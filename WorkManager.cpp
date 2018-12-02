// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#include "WorkManager.hpp"
#include "GBTClient.hpp"
#include "StratumClient.hpp"

WorkManager::WorkManager() {
	_options           = Options();
	_client            = NULL;
	_miner             = NULL;
	_inited            = false;
	_waitReconnect     = 10;
	_workRefresh       = 500;
	_stats             = Stats(offsets().size());
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
	_miner->init();
	
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

bool WorkManager::getWork(WorkData& wd) {
	_clientMutex.lock();
	wd = _client->workData();
	_clientMutex.unlock();
	return wd.height != 0;
}

void WorkManager::minerThread() {
	WorkData wd;
	while (true) {
		if (!getWork(wd)) usleep(1000*_workRefresh/2);
		else _miner->process(wd);
	}
}

void WorkManager::manage() {
	if (!_inited) std::cerr << "Manager was not inited!" << std::endl;
	else {
		std::chrono::time_point<std::chrono::system_clock> timer;
		while (true) {
			if (_options.protocol() == "Benchmark" && _miner->running()) {
				if (timeSince(_stats.miningStartTp()) > _options.testTime() && _options.testTime() != 0) {
					std::cout << _options.testTime() << " s elapsed, test finished. " << versionString << ", diff " << _options.testDiff() << ", sieve " << _options.sieve() << std::endl;
					_stats.printTuplesStats();
					_stats.saveTuplesCounts(_options.tcFile());
					_exit(0);
				}
				if (_stats.tuplesCount()[2] >= _options.test2t() && _options.test2t() != 0) {
					std::cout << _options.test2t() << " 2-tuples found, test finished. " << versionString << ", difficulty " << _options.testDiff() << ", sieve " << _options.sieve() << std::endl;
					_stats.printBenchmarkResults();
					if (_options.testDiff() == 1600 && _options.sieve() == 2147483648 && _options.test2t() >= 50000 && _options.testTime() == 0)
						std::cout << "VALID parameters for Standard Benchmark" << std::endl;
					_stats.printTuplesStats();
					_stats.saveTuplesCounts(_options.tcFile());
					_exit(0);
				}
			}
			
			if (_client->connected()) {
				if (_options.refresh() != 0) {
					const double dt(timeSince(timer));
					if (dt > _options.refresh() && _miner->inited() && _miner->running()) {
						_stats.printStats();
						_stats.printEstimatedTimeToBlock();
						timer = std::chrono::system_clock::now();
					}
				}
				
				_clientMutex.lock();
				_client->process();
				if (!_client->connected()) {
					std::cout << "Connection lost :|, reconnecting in 10 seconds..." << std::endl;
					_miner->pause();
					_stats.printTuplesStats();
					_stats.saveTuplesCounts(_options.tcFile());
					_clientMutex.unlock();
					usleep(1000000*_waitReconnect);
				}
				else {
					assert(_miner->inited());
					if (!_miner->running() && _client->workData().height != 0) {
						_stats = Stats(offsets().size());
						_stats.setMiningType(_options.protocol());
						_stats.loadTuplesCounts(_options.tcFile());
						_stats.startTimer();
						_stats.updateHeight(_client->workData().height - 1);
						std::cout << "-----------------------------------------------------------" << std::endl;
						const uint32_t startHeight(_client->workData().height);
						std::cout << "[0000:00:00] Started mining at block " << startHeight;
						_stats.initHeight(startHeight);
						_miner->start();
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
				else
					std::cout << "Connected!" << std::endl;
				usleep(10000);
			}
		}
	}
}
