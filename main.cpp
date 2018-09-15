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
	_options       = Options();
	_stats         = Stats();
	_client        = NULL;
	_miner         = NULL;
	_inited        = false;
	_miningStarted = false;
	_waitReconnect = 10;
	_workRefresh   = 500;
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
						std::cout << "[0000:00:00] Started mining at block " << _client->workData().height << std::endl;
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
					_stats = Stats();
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
	else
		std::cerr << "rieMiner.conf not found or unreadable, values for standard benchmark loaded." << std::endl;
	
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
