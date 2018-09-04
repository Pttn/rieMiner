/* Parts taken from dave-andersen's fastrie (https://github.com/dave-andersen/fastrie) (based on xptMiner). jh00 is the original author of xptMiner.
(c) 2014 jh00 (https://github.com/jh000/xptMiner)
(c) 2014-2017 dave-andersen (http://www.cs.cmu.edu/~dga/)
(c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner) */

#include "global.h"
#include "client.h"
#include <iomanip>
#include <fstream>

std::string minerVersionString("rieMiner 0.9-alpha1");

Client client;
std::mutex clientMutex;
volatile uint32_t monitorCurrentBlockHeight; // used to notify worker threads of new block data

Stats stats = Stats();

Arguments arguments;

struct WorkDataSource {
	// block data
	WorkInfo wi;
	std::mutex mutex;
	WorkDataSource() {
		wi = WorkInfo();
	}
};

WorkDataSource workDataSource;

void submitWork(GetWorkData gwd, uint32_t* nOffset, uint8_t length) {
	clientMutex.lock();
	// Fill the nOffset and submit
	memcpy(gwd.nOffset, nOffset, 32); 
	client.addSubmission(gwd, length);
	clientMutex.unlock();
}

bool algorithmInited(false);

void minerThread() {
	WorkInfo wi;
	while (true) {
		bool hasValidWork(false);
		workDataSource.mutex.lock();
		if (workDataSource.wi.height > 0) {
			// Get RieCoin work data
			memset(&wi, 0x00, sizeof(wi));
			wi.gwd = workDataSource.wi.gwd;
			wi.targetCompact = workDataSource.wi.targetCompact;
			wi.height = workDataSource.wi.height;
			hasValidWork = true;
		}
		
		workDataSource.mutex.unlock();
		if (!hasValidWork) usleep(10000);
		else miningProcess(wi);
	}
}

void getWorkFromClient(Client& client) {
	workDataSource.mutex.lock();
	if (!algorithmInited) {
		miningInit(arguments.sieve(), arguments.threads() + 1);
		algorithmInited = true;
	}
	
	workDataSource.wi.gwd = client.workInfo.gwd;
	
	memcpy(workDataSource.wi.target, client.workInfo.target, 32);
	workDataSource.wi.targetCompact = client.workInfo.targetCompact;
	if (workDataSource.wi.height == 0 && client.workInfo.height != 0) {
		stats.startMining = std::chrono::system_clock::now();
		stats.lastDifficultyChange = std::chrono::system_clock::now();
		std::cout << "[0000:00:00] Started mining at block " << client.getBlockheight() << std::endl;
	}
	
	workDataSource.wi.height = client.workInfo.height;
	workDataSource.mutex.unlock();
	monitorCurrentBlockHeight = workDataSource.wi.height;
	__sync_synchronize(); /* memory barrier needed if this isn't done in crit */
}

void workManagement() {
	std::chrono::time_point<std::chrono::system_clock> timer;
	while (true) {
		if (client.connected()) {
			if (arguments.refresh() != 0) {
				double dt(timeSince(timer));
				if (dt > arguments.refresh() && algorithmInited) {
					stats.printStats();
					stats.printEstimatedTimeToBlock();
					timer = std::chrono::system_clock::now();
				}
			}
			
			clientMutex.lock();
			client.process();
			if (!client.connected()) {
				// Mark work as invalid
				workDataSource.mutex.lock();
				workDataSource.wi.height = 0;
				monitorCurrentBlockHeight = 0;
				workDataSource.mutex.unlock();
				printf("Connection lost :|, reconnecting in 5 seconds...\n");
				clientMutex.unlock();
				usleep(5000000);
			}
			else {
				// Update work
				if (client.workInfo.height != workDataSource.wi.height
				 || memcmp(client.workInfo.gwd.merkleRoot, workDataSource.wi.gwd.merkleRoot, 32) != 0) {
					getWorkFromClient(client);
					clientMutex.unlock();
				}
				else
					clientMutex.unlock();
				usleep(10000);
			}
		}
		else {
			std::cout << "Connecting to Riecoin server using JSON-RPC..." << std::endl;
			if (!client.connect(arguments)) {
				std::cout << "Failure :| ! Retry in 5 seconds..." << std::endl;
				usleep(5000000);
			}
			else {
				std::cout << "Connected!" << std::endl;
				stats = Stats();
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
					try {_sieve = std::stoi(value);}
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
	std::cout << "User = " << arguments.user() << std::endl;
	std::cout << "Pass = ..." << std::endl;
	std::cout << "Threads = " << arguments.threads() << std::endl;
	std::cout << "Sieve max = " << arguments.sieve() << std::endl;
	std::cout << "Will submit tuples of at least length = " << (uint16_t) arguments.tuples() << std::endl;
	std::cout << "Stats refresh rate = " << arguments.refresh() << " s" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	
	std::thread threads[arguments.threads() + 1];
	std::cout << "Starting " << arguments.threads() << " + 1 threads" << std::endl;
	for (uint16_t i(0) ; i < arguments.threads() + 1 ; i++) {
		threads[i] = std::thread(minerThread);
		threads[i].detach();
	}
	workManagement();
	return 0;
}
