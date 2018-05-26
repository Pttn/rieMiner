/* Parts taken from dave-andersen's fastrie (https://github.com/dave-andersen/fastrie) (based on xptMiner). jh00 is the original author of xptMiner.
(c) 2014 jh00 (https://github.com/jh000/xptMiner)
(c) 2014-2017 dave-andersen (http://www.cs.cmu.edu/~dga/)
(c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner) */

#include "global.h"
#include <iomanip>

std::string minerVersionString("rieMiner 0.1121");

Client client;
pthread_mutex_t clientMutex;
volatile uint32_t monitorCurrentBlockHeight; // used to notify worker threads of new block data

Stats stats = Stats();

Arguments arguments;

struct WorkDataSource {
	// block data
	WorkInfo wi;
	pthread_mutex_t mutex;
	WorkDataSource() {
		wi = WorkInfo();
	}
};

WorkDataSource workDataSource;

void submitWork(GetWorkData gwd, uint32_t* nOffset, uint8_t length) {
	pthread_mutex_lock(&clientMutex);
	// Fill the nOffset and submit
	memcpy(gwd.nOffset, nOffset, 32); 
	client.addSubmission(gwd, length);
	pthread_mutex_unlock(&clientMutex);
}

bool algorithmInited(false);

void* minerThread(void*) {
	WorkInfo wi;
	while (true) {
		bool hasValidWork(false);
		pthread_mutex_lock(&workDataSource.mutex);
		if (workDataSource.wi.height > 0) {
			// Get RieCoin work data
			memset(&wi, 0x00, sizeof(wi));
			wi.gwd = workDataSource.wi.gwd;
			wi.targetCompact = workDataSource.wi.targetCompact;
			wi.height = workDataSource.wi.height;
			hasValidWork = true;
		}
		
		pthread_mutex_unlock(&workDataSource.mutex);
		
		if (!hasValidWork) usleep(10000);
		else miningProcess(wi);
	}
	return 0;
}

void getWorkFromClient(Client& client) {
	pthread_mutex_lock(&workDataSource.mutex);
	if (!algorithmInited) {
		miningInit(arguments.sieveMax, arguments.threads);
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
	pthread_mutex_unlock(&workDataSource.mutex);
	monitorCurrentBlockHeight = workDataSource.wi.height;
	__sync_synchronize(); /* memory barrier needed if this isn't done in crit */
}

void workManagement() {
	client = Client();
	std::chrono::time_point<std::chrono::system_clock> timer;
	while (true) {
		if (client.connected()) {
			if (arguments.refreshRate != 0) {
				double dt(timeSince(timer));
				if (dt > arguments.refreshRate && algorithmInited) {
					stats.printStats();
					stats.printEstimatedTimeToBlock();
					timer = std::chrono::system_clock::now();
				}
			}
			
			pthread_mutex_lock(&clientMutex);
			client.process();
			if (!client.connected()) {
				// Mark work as invalid
				pthread_mutex_lock(&workDataSource.mutex);
				workDataSource.wi.height = 0;
				monitorCurrentBlockHeight = 0;
				pthread_mutex_unlock(&workDataSource.mutex);
				printf("Connection lost :|, reconnecting in 5 seconds...\n");
				pthread_mutex_unlock(&clientMutex);
				usleep(5000000);
			}
			else {
				// Update work
				if (client.workInfo.height != workDataSource.wi.height
				 || memcmp(client.workInfo.gwd.merkleRoot, workDataSource.wi.gwd.merkleRoot, 32) != 0) {
					getWorkFromClient(client);
					pthread_mutex_unlock(&clientMutex);
				}
				else
					pthread_mutex_unlock(&clientMutex);
				usleep(10000);
			}
		}
		else {
			std::cout << "Connecting to Riecoin server using JSON-RPC..." << std::endl;
			pthread_mutex_lock(&clientMutex);
			client = Client();
			pthread_mutex_unlock(&clientMutex);
			if (!client.connect(arguments.user, arguments.pass, arguments.host, arguments.port)) {
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

void printUsage() {
	std::cout << "Usage: ./rieMiner [options]" << std::endl;
	std::cout << "Options:" << std::endl;
	std::cout << "  -o : The miner will connect to this IP. You can specify a port after the url using -o IP:port" << std::endl;
	std::cout << "  -u : User/workername used for login" << std::endl;
	std::cout << "  -p : Password used for login" << std::endl;
	std::cout << "  -t : Number of threads for mining (default 1)" << std::endl;
	std::cout << "  -s : Prime sieve max (default: 1073741824)" << std::endl;
	std::cout << "  -k : k-tuples of at least this length will be submitted" << std::endl;
	std::cout << "  -r : seconds between each stats refresh (default 10, integer). 0 for showing only when a tuple of enough length is found." << std::endl;
	std::cout << "Example: ./rieMiner -o example.com:12345 -u user.worker1 -p password -t 4" << std::endl;
}

void getArguments(int argc, char **argv) {
	int32_t cIdx(1);
	arguments.sieveMax = 1073741824;
	
	while (cIdx < argc) {
		char* argument = argv[cIdx];
		cIdx++;
		if (memcmp(argument, "-s", 3) == 0 || memcmp(argument, "-s", 3) == 0) {
			if (cIdx > argc) {
				std::cerr << "Missing sieve size after -s" << std::endl;
				exit(0);
			}
			arguments.sieveMax = strtoull(argv[cIdx], NULL, 10);
			if (arguments.sieveMax < 100000) {
				std::cerr << "Sieve size must be between 100000 and 2^32 - 1" << std::endl;
				exit(0);
			}
			cIdx++;
		}
		else if (memcmp(argument, "-o", 3) == 0 || memcmp(argument, "-O", 3) == 0) {
			if (cIdx >= argc) {
				printf("Missing URL after -o option\n");
				exit(0);
			}
			if (strstr(argv[cIdx], "http://"))
				arguments.host = strstr(argv[cIdx], "http://") + 7;
			else
				arguments.host = argv[cIdx];
			
			const char* portStr = strstr(arguments.host.c_str(), ":");
			if (portStr != NULL)
				arguments.port = atoi(portStr + 1);
			cIdx++;
			
			std::istringstream iss(arguments.host);
			std::getline(iss, arguments.host, ':');
		}
		else if (memcmp(argument, "-u", 3) == 0) {
			if (cIdx >= argc) {
				printf("Missing username after -u option\n");
				exit(0);
			}
			arguments.user = argv[cIdx];
			cIdx++;
		}
		else if (memcmp(argument, "-p", 3) == 0) {
			if (cIdx >= argc) {
				printf("Missing password after -p option\n");
				exit(0);
			}
			arguments.pass = argv[cIdx];
			cIdx++;
		}
		else if (memcmp(argument, "-t", 3) == 0) {
			if (cIdx >= argc) {
				printf("Missing thread number after -t option\n");
				exit(0);
			}
			arguments.threads = atoi(argv[cIdx]);
			if (arguments.threads < 1)
				arguments.threads = 1;
			cIdx++;
		}
		else if (memcmp(argument, "-k", 3) == 0) {
			if (cIdx >= argc) {
				printf("Missing length (2-6) after -k option\n");
				exit(0);
			}
			arguments.tuples = atoi(argv[cIdx]);
			if (arguments.tuples < 2 || arguments.tuples > 6)
				arguments.tuples = 6;
			cIdx++;
		}
		else if (memcmp(argument, "-r", 3) == 0) {
			if (cIdx >= argc) {
				printf("Missing duration after -r option\n");
				exit(0);
			}
			arguments.refreshRate = atoi(argv[cIdx]);
			cIdx++;
		}
		else if (memcmp(argument, "-help", 6) == 0 || memcmp(argument, "--help", 7) == 0) {
			printUsage();
			exit(0);
		}
		else {
			printf("'%s' is an unknown option.\nUse the --help parameter for more info\n", argument); 
			exit(-1);
		}
	}
	if (argc <= 1) {
		printUsage();
		exit(0);
	}
}

int main(int argc, char** argv) {
	//curl_global_init(CURL_GLOBAL_DEFAULT);
	std::cout << "Starting Riecoin miner: " << minerVersionString << ", by Pttn (https://github.com/Pttn/rieMiner)" << std::endl;
	getArguments(argc, argv);
	std::cout << "Host = " << arguments.host << std::endl;
	std::cout << "Port = " << arguments.port << std::endl;
	std::cout << "User = " << arguments.user << std::endl;
	std::cout << "Pass = " << arguments.pass << std::endl;
	std::cout << "Threads = " << arguments.threads << std::endl;
	std::cout << "Sieve max = " << arguments.sieveMax << std::endl;
	std::cout << "Will submit tuples of at least length = " << (uint16_t) arguments.tuples << std::endl;
	std::cout << "Stats refresh rate = " << arguments.refreshRate << " s" << std::endl;
	std::cout << "----------------------------------------" << std::endl;
	arguments.threads += 1;
	// Init work source
	pthread_mutex_init(&workDataSource.mutex, NULL);
	pthread_mutex_init(&clientMutex, NULL);
	// start miner threads
	pthread_t threads[arguments.threads];
	pthread_attr_t threadAttr;
	pthread_attr_init(&threadAttr);
	// Set the stack size of the thread
	pthread_attr_setstacksize(&threadAttr, 120*1024);
	// Free resources of thread upon return
	pthread_attr_setdetachstate(&threadAttr, PTHREAD_CREATE_DETACHED);
	
	printf("Starting %d + 1 threads\n", arguments.threads - 1);
	for (uint16_t i(0) ; i < arguments.threads ; i++)
		pthread_create(&threads[i], &threadAttr, minerThread, (void*) (uint64_t) i);
	workManagement();
	return 0;
}
