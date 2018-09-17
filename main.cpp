// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#include "main.h"
#include "client.h"
#include "miner.h"
#include "gbtclient.h"
#include "stratumclient.h"
#include "tools.h"
#include <iomanip>
#include <fstream>
#include <unistd.h>
#ifndef _WIN32
	#include <signal.h>
#endif

std::shared_ptr<WorkManager> manager;

WorkManager::WorkManager() {
	_options           = Options();
	_client            = NULL;
	_miner             = NULL;
	_inited            = false;
	_miningStarted     = false;
	_waitReconnect     = 10;
	_workRefresh       = 500;
	_constellationType = {0, 4, 2, 4, 2, 4};
	_stats             = Stats(_constellationType.size());
	/* Some possible constellations types
	You will need to change the Primorial Offset in the MinerParameters constructor in miner.h
	The Primorial Number may sometimes need to be lowered too
	The sixoff[...] size should also be changed in miner.cpp
	Format
		(type) -> {copyable offsets} ; 3 first constellations (n + 0) which can be used as offsets
	5-tuples
		(0, 2, 6,  8, 12) -> {0, 2, 4, 2, 4} ; 5, 11, 101,...
		(0, 4, 6, 10, 12) -> {0, 4, 2, 4, 2} ; 7, 97, 1867,...
	6-tuples
		(0, 4, 6, 10, 12, 16) -> {0, 4, 2, 4, 2, 4} (Riecoin) ; 7, 97, 16057,...
	7-tuples
		(0, 2, 6,  8, 12, 18, 20) -> {0, 2, 4, 2, 4, 6, 2} ; 11, 165701, 1068701,...
		(0, 2, 8, 12, 14, 18, 20) -> {0, 2, 6, 4, 2, 4, 2} ; 5639, 88799, 284729,...
	8-tuples
		(0, 2, 6,  8, 12, 18, 20, 26) -> {0, 2, 4, 2, 4, 6, 2, 6} ; 11, 15760091, 25658441,...
		(0, 2, 6, 12, 14, 20, 24, 26) -> {0, 2, 4, 6, 2, 6, 4, 2} ; 17, 1277, 113147,...
		(0, 6, 8, 14, 18, 20, 24, 26) -> {0, 6, 2, 6, 4, 2, 4, 2} ; 88793, 284723, 855713,...
	Also see the constellationsGen tool in my rieTools repository (https://github.com/Pttn/rieTools) */
}

void WorkManager::init() {
	_options.loadConf();
	std::cout << "-----------------------------------------------------------" << std::endl;
	if (_options.protocol() == "GetBlockTemplate")
		_client = std::unique_ptr<Client>(new GBTClient(shared_from_this()));
	else if (_options.protocol() == "Stratum")
		_client = std::unique_ptr<Client>(new StratumClient(shared_from_this()));
	else _client = std::unique_ptr<Client>(new BMClient(shared_from_this()));
	
	_miner = std::unique_ptr<Miner>(new Miner(shared_from_this()));
	
	std::cout << "Starting " << _options.threads() << " + 1 threads" << std::endl;
	for (uint16_t i(0) ; i < _options.threads() + 1 ; i++) {
		_threads.push_back(std::thread(&WorkManager::minerThread, shared_from_this()));
		_threads[i].detach();
	}
	
	_inited = true;
}

void WorkManager::submitWork(WorkData wd, uint32_t* nOffset, uint8_t length) {
	_clientMutex.lock();
	// Fill the nOffset and submit
	memcpy(wd.bh.nOffset, nOffset, 32); 
	_client->addSubmission(wd, length);
	_clientMutex.unlock();
}

void WorkManager::minerThread() {
	WorkData wd;
	while (true) {
		bool hasValidWork(false);
		_clientMutex.lock();
		wd = _client->workData(); // Get generated work data from client
		_clientMutex.unlock();
		if (wd.height > 0) hasValidWork = true;
		if (!hasValidWork) usleep(1000*_workRefresh/2);
		else _miner->process(wd);
	}
}

void WorkManager::manage() {
	if (!_inited) std::cerr << "Manager was not inited!" << std::endl;
	else {
		std::chrono::time_point<std::chrono::system_clock> timer;
		while (true) {
			if (_options.protocol() == "Benchmark" && _miningStarted) {
				if (timeSince(_stats.miningStartTp()) > _options.testTime() && _options.testTime() != 0) {
					std::cout << _options.testTime() << " s elapsed, test finished. " << minerVersionString << ", diff " << _options.testDiff() << ", sieve " << _options.sieve() << std::endl;
					_stats.printTuplesStats();
					_exit(0);
				}
				if (_stats.tuplesCount()[3] >= _options.test3t() && _options.test3t() != 0) {
					std::cout << _options.test3t() << " 3-tuples found, test finished. Version: " << minerVersionString << ", difficulty " << _options.testDiff() << ", sieve " << _options.sieve() << std::endl;
					_stats.printTuplesStats();
					_exit(0);
				}
			}
			
			if (_client->connected()) {
				if (_options.refresh() != 0) {
					double dt(timeSince(timer));
					if (dt > _options.refresh() && _miner->inited() && _miningStarted) {
						_stats.printStats();
						_stats.printEstimatedTimeToBlock();
						timer = std::chrono::system_clock::now();
					}
				}
				
				_clientMutex.lock();
				_client->process();
				if (!_client->connected()) {
					_miner->updateHeight(0); // Mark work as invalid
					std::cout << "Connection lost :|, reconnecting in 10 seconds..." << std::endl;
					_stats.printTuplesStats();
					_miningStarted = false;
					_clientMutex.unlock();
					usleep(1000000*_waitReconnect);
				}
				else {
					if (!_miner->inited()) _miner->init();
					if (!_miningStarted && _client->workData().height != 0) {
						_stats.startTimer();
						_stats.updateHeight(_client->workData().height - 1);
						std::cout << "-----------------------------------------------------------" << std::endl;
						uint32_t startHeight(_client->workData().height);
						std::cout << "[0000:00:00] Started mining at block " << startHeight << std::endl;
						_stats.initHeight(startHeight);
						_miningStarted = true;
					}
					
					_miner->updateHeight(_client->workData().height);
					__sync_synchronize();
					_clientMutex.unlock();
					usleep(1000*_workRefresh);
				}
			}
			else {
				std::cout << "Connecting to Riecoin server..." << std::endl;
				if (!_client->connect()) {
					std::cout << "Failure :| ! Retry in 10 seconds..." << std::endl;
					usleep(1000000*_waitReconnect);
				}
				else {
					std::cout << "Connected!" << std::endl;
					_stats = Stats(_constellationType.size());
					_stats.setMiningType(_options.protocol());
				}
				usleep(10000);
			}
		}
	}
}

void Options::parseLine(std::string line, std::string& key, std::string& value) const {
	for (uint16_t i(0) ; i < line.size() ; i++) { // Delete spaces
		if (line[i] == ' ' || line[i] == '\t') {
			line.erase (i, 1);
			i--;
		}
	}
	
	auto pos(line.find('='));
	if (pos != std::string::npos) {
		key   = line.substr(0, pos);
		value = line.substr(pos + 1, line.size() - pos - 1);
	}
	else {
		std::cerr << "Ill formed configuration line: " << line << std::endl;
		key   = "Error";
		value = "Ill formed configuration line";
	}
}

void Options::askConf() {
	std::string value;
	std::ofstream file("rieMiner.conf");
	if (file) {
		std::cout << "Solo mining (solo), pooled mining (pool), or benchmarking (benchmark)? ";
		std::cin >> value;
		if (value == "solo") {
			file << "Protocol = GetBlockTemplate" << std::endl;
			_protocol = "GetBlockTemplate";
		}
		else if (value == "pool") {
			file << "Protocol = Stratum" << std::endl;
			_protocol = "Stratum";
		}
		else if (value == "benchmark") {
			file << "Protocol = Benchmark" << std::endl;
			_protocol = "Benchmark";
		}
		else {
			std::cerr << "Invalid choice! Please answer solo, pool, or benchmark." << std::endl;
			std::remove("rieMiner.conf");
			exit(0);
		}
		
		if (_protocol != "Benchmark") {
			if (_protocol == "GetBlockTemplate") {
				std::cout << "Riecoin Core (wallet) IP: ";
				std::cin >> value;
#ifndef _WIN32
				struct sockaddr_in sa;
				if (inet_pton(AF_INET, value.c_str(), &(sa.sin_addr)) != 1) {
					std::cerr << "Invalid IP address!" << std::endl;
					std::remove("rieMiner.conf");
					exit(0);
				}
				else {
					file << "Host = " << value << std::endl;
					_host = value;
				}
#else
				file << "Host = " << value << std::endl;
				_host = value;
#endif
				std::cout << "RPC port: ";
			}
			else {
				std::cout << "Current pools " << std::endl;
				std::cout << "     XPoolX: mining.xpoolx.com:5000" << std::endl;
				std::cout << "    riePool: riepool.ovh:8000" << std::endl;
				std::cout << "  uBlock.it: mine.ublock.it:5000" << std::endl;
				std::cout << "Pool address (without port): ";
				std::cin >> value;
				file << "Host = " << value << std::endl;
				_host = value;
				std::cout << "Pool port (example: 5000): ";
			}
			
			std::cin >> value;
			try {
				_port = std::stoi(value);
				file << "Port = " << value << std::endl;
			}
			catch (...) {
				std::cerr << "Invalid port !" << std::endl;
				std::remove("rieMiner.conf");
				exit(0);
			}
			
			if (_protocol == "GetBlockTemplate") std::cout << "RPC username: ";
			else std::cout << "Pool username.worker: ";
			
			std::cin >> value;
			file << "User = " << value << std::endl;
			_user = value;
			
			if (_protocol == "GetBlockTemplate") std::cout << "RPC password: ";
			else std::cout << "Worker password: ";
			
			std::cin >> value;
			file << "Pass = " << value << std::endl;
			_pass = value;
			
			if (_protocol == "GetBlockTemplate") {
				uint8_t scriptPubKeyTest[20];
				std::cout << "Payout address: ";
				std::cin >> value;
				if (!addrToScriptPubKey(value, scriptPubKeyTest)) {
					std::cerr << "Invalid payout address!" << std::endl;
					std::remove("rieMiner.conf");
					exit(0);
				}
				else {
					file << "Address = " << value << std::endl;
					_address = value;
				}
			}
		}
		else std::cout << "Standard Benchmark values loaded. Edit the rieMiner.conf file if needed." << std::endl;
		
		std::cout << "Number of threads: ";
		std::cin >> value;
		try {
			_threads = std::stoi(value);
			file << "Threads = " << value << std::endl;
		}
		catch (...) {
			std::cerr << "Invalid thread number!" << std::endl;
			std::remove("rieMiner.conf");
			exit(0);
		}
		
		if (_protocol != "Benchmark") std::cout << "Thank you, happy mining :D !" << std::endl;
		else std::cout << "Thank you :D !" << std::endl;
		std::cout << "-----------------------------------------------------------" << std::endl;
		file.close();
	}
	else std::cerr << "Unable to create rieMiner.conf :|, values for standard benchmark loaded." << std::endl;
}

void Options::loadConf() {
	std::ifstream file("rieMiner.conf", std::ios::in);
	std::cout << "Opening rieMiner.conf..." << std::endl;
	if (file) {
		std::string line, key, value;
		while (std::getline(file, line)) {
			if (line.size() != 0) {
				parseLine(line, key, value);
				if (key == "Host") _host = value;
				else if (key == "Port") {
					try {_port = std::stoi(value);}
					catch (...) {_port = 28332;}
				}
				else if (key == "User") _user = value;
				else if (key == "Pass") _pass = value;
				else if (key == "Threads") {
					try {_threads = std::stoi(value);}
					catch (...) {_threads = 8;}
				}
				else if (key == "Sieve") {
					try {_sieve = std::stoll(value);}
					catch (...) {_sieve = 1073741824;}
					if (_sieve < 100000) _sieve = 100000;
				}
				else if (key == "Tuples") {
					try {_tuples = std::stoi(value);}
					catch (...) {_tuples = 6;}
					if (_tuples < 2 || _tuples > 6)
						_tuples = 6;
				}
				else if (key == "Refresh") {
					try {_refresh = std::stoi(value);}
					catch (...) {_refresh = 10;}
				}
				else if (key == "Protocol") {
					if (value == "GetBlockTemplate" || value == "Stratum" || value == "Benchmark") {
						_protocol = value;
					}
					else std::cout << "Invalid Protocol" << std::endl;
				}
				else if (key == "Address") {
					_address = value;
				}
				else if (key == "TestDiff") {
					try {_testDiff = std::stoll(value);}
					catch (...) {_testDiff = 304;}
					if (_testDiff < 265) _testDiff = 265;
					else if (_testDiff > 32767) _testDiff = 32767;
				}
				else if (key == "TestTime") {
					try {_testTime = std::stoll(value);}
					catch (...) {_testTime = 0;}
				}
				else if (key == "Test3t") {
					try {_test3t = std::stoll(value);}
					catch (...) {_test3t = 1000;}
				}
				else if (key == "Error")
					std::cout << "Ignoring invalid line" << std::endl;
				else
					std::cout << "Ignoring line with unused key " << key << std::endl;
			}
		}
		file.close();
	}
	else {
		std::cerr << "rieMiner.conf not found or unreadable, please configure rieMiner now." << std::endl;
		askConf();
	}
	
	std::cout << "Host = " << _host << std::endl;
	std::cout << "Port = " << _port << std::endl;
	if (_protocol != "Stratum")
		std::cout << "User = " << _user << std::endl;
	else std::cout << "User.worker = " << _user << std::endl;
	std::cout << "Pass = ..." << std::endl;
	std::cout << "Protocol = " << _protocol << std::endl;
	if (_protocol == "GetBlockTemplate")
		std::cout << "Payout address = " << _address << std::endl;
	else if (_protocol == "Benchmark") {
		std::cout << "Test difficulty = " << _testDiff << std::endl;
		if (_testTime != 0) std::cout << "Will stop after " << _testTime << " s" << std::endl;
		if (_test3t   != 0) std::cout << "Will stop after finding " << _test3t << " 3-tuples" << std::endl;
	}
	std::cout << "Threads = " << _threads << std::endl;
	std::cout << "Sieve max = " << _sieve << std::endl;
	if (_protocol == "Benchmark")
		std::cout << "Will notify tuples of at least length = " << (uint16_t) _tuples << std::endl;
	else if (_protocol != "Stratum")
		std::cout << "Will submit tuples of at least length = " << (uint16_t) _tuples << std::endl;
	else std::cout << "Will submit 4-shares" << std::endl;
	std::cout << "Stats refresh rate = " << _refresh << " s" << std::endl;
}

void signalHandler(int signum) {
	std::cout << std::endl << "Signal " << signum << " received, terminating rieMiner." << std::endl;
	manager->printTuplesStats();
	_exit(0);
}

int main() {
#ifndef _WIN32
	struct sigaction SIGINTHandler;
	SIGINTHandler.sa_handler = signalHandler;
	sigemptyset(&SIGINTHandler.sa_mask);
	SIGINTHandler.sa_flags = 0;
	sigaction(SIGINT, &SIGINTHandler, NULL);
#endif
	
	std::cout << minerVersionString << ", Riecoin miner by Pttn" << std::endl;
	std::cout << "Project page: https://github.com/Pttn/rieMiner" << std::endl;
	std::cout << "Go to project page or open README.md for usage information." << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	
	manager = std::shared_ptr<WorkManager>(new WorkManager);
	manager->init();
	manager->manage();
	
	return 0;
}
