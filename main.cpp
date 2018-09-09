// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#include "global.h"
#include "client.h"
#include "gwclient.h"
#include "gbtclient.h"
#include "stratumclient.h"
#include "tools.h"
#include <iomanip>
#include <fstream>

std::string minerVersionString("rieMiner 0.9-alpha3");

Client *client;
std::mutex clientMutex;
volatile uint32_t currentBlockHeight; // used to notify worker threads of new block data

Stats stats = Stats();

Arguments arguments;

void submitWork(WorkData wd, uint32_t* nOffset, uint8_t length) {
	clientMutex.lock();
	// Fill the nOffset and submit
	memcpy(wd.bh.nOffset, nOffset, 32); 
	client->addSubmission(wd, length);
	clientMutex.unlock();
}

bool algorithmInited(false);

void minerThread() {
	WorkData wd;
	while (true) {
		bool hasValidWork(false);
		clientMutex.lock();
		if (client->workData().height > 0) {
			// Get RieCoin work data
			wd = WorkData();
			wd.bh = client->workData().bh;
			wd.targetCompact = client->workData().targetCompact;
			wd.height = client->workData().height;
			if (arguments.protocol() == "GetBlockTemplate") {
				wd.transactions = client->workData().transactions;
				wd.txCount = client->workData().txCount;
			}
			else if (arguments.protocol() == "Stratum") {
				wd.extraNonce2 = client->workData().extraNonce2;
				wd.jobId = client->workData().jobId;
			}
			hasValidWork = true;
		}
		clientMutex.unlock();
		if (!hasValidWork) usleep(10000);
		else miningProcess(wd);
	}
}

bool miningStarted(false);

void getWorkFromClient(Client *client) {
	if (!algorithmInited) {
		miningInit(arguments.sieve(), arguments.threads() + 1, !(arguments.protocol() == "Stratum"));
		algorithmInited = true;
	}
	
	if (!miningStarted && client->workData().height != 0) {
		stats.startMining = std::chrono::system_clock::now();
		stats.lastDifficultyChange = std::chrono::system_clock::now();
		stats.blockHeightAtDifficultyChange = client->workData().height - 1;
		std::cout << "[0000:00:00] Started mining at block " << client->workData().height << std::endl;
		miningStarted = true;
	}
	
	currentBlockHeight = client->workData().height;
	__sync_synchronize(); // memory barrier needed if this isn't done in crit
}

void workManagement() {
	std::chrono::time_point<std::chrono::system_clock> timer;
	while (true) {
		if (client->connected()) {
			if (arguments.refresh() != 0) {
				double dt(timeSince(timer));
				if (dt > arguments.refresh() && algorithmInited && miningStarted) {
					stats.printStats();
					stats.printEstimatedTimeToBlock();
					timer = std::chrono::system_clock::now();
				}
			}
			
			clientMutex.lock();
			client->process();
			if (!client->connected()) {
				// Mark work as invalid
				currentBlockHeight = 0;
				printf("Connection lost :|, reconnecting in 10 seconds...\n");
				stats.printTuplesStats();
				miningStarted = false;
				clientMutex.unlock();
				usleep(10000000);
			}
			else {
				// Update work
				getWorkFromClient(client);
				clientMutex.unlock();
				usleep(100000);
			}
		}
		else {
			std::cout << "Connecting to Riecoin server..." << std::endl;
			if (!client->connect(arguments)) {
				std::cout << "Failure :| ! Retry in 10 seconds..." << std::endl;
				usleep(10000000);
			}
			else {
				std::cout << "Connected!" << std::endl;
				stats = Stats();
				stats.solo = !(arguments.protocol() == "Stratum");
			}
			usleep(10000);
		}
	}
}

void Arguments::parseLine(std::string line, std::string& key, std::string& value) const {
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

void Arguments::loadConf() {
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
					if (value == "GetWork" || value == "GetBlockTemplate" || value == "Stratum") {
						_protocol = value;
					}
					else std::cout << "Invalid Protocol" << std::endl;
				}
				else if (key == "Address") {
					_address = value;
				}
				else if (key == "Error")
					std::cout << "Ignoring invalid line" << std::endl;
				else
					std::cout << "Ignoring line with unused key " << key << std::endl;
			}
		}
	}
	else
		std::cerr << "rieMiner.conf not found or unreadable, no value loaded." << std::endl;
}

int main() {
	std::cout << minerVersionString << ", Riecoin miner by Pttn" << std::endl;
	std::cout << "Project page: https://github.com/Pttn/rieMiner" << std::endl;
	std::cout << "Go to project page or open README.md for usage information." << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	arguments.loadConf();
	std::cout << "Host = " << arguments.host() << std::endl;
	std::cout << "Port = " << arguments.port() << std::endl;
	if (arguments.protocol() != "Stratum")
		std::cout << "User = " << arguments.user() << std::endl;
	else std::cout << "User.worker = " << arguments.user() << std::endl;
	std::cout << "Pass = ..." << std::endl;
	std::cout << "Protocol = " << arguments.protocol() << std::endl;
	if (arguments.protocol() == "GetBlockTemplate")
		std::cout << "Payout address = " << arguments.address() << std::endl;
	std::cout << "Threads = " << arguments.threads() << std::endl;
	std::cout << "Sieve max = " << arguments.sieve() << std::endl;
	if (arguments.protocol() != "Stratum")
		std::cout << "Will submit tuples of at least length = " << (uint16_t) arguments.tuples() << std::endl;
	else std::cout << "Will submit 4-shares" << std::endl;
	std::cout << "Stats refresh rate = " << arguments.refresh() << " s" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	
	if (arguments.protocol() == "GetWork") client = new GWClient();
	else if (arguments.protocol() == "Stratum")
		client = new StratumClient();
	else client = new GBTClient();
	
	std::thread threads[arguments.threads() + 1];
	std::cout << "Starting " << arguments.threads() << " + 1 threads" << std::endl;
	for (uint16_t i(0) ; i < arguments.threads() + 1 ; i++) {
		threads[i] = std::thread(minerThread);
		threads[i].detach();
	}
	workManagement();
	return 0;
}
