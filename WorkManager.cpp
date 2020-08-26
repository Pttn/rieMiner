// (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)

#include "WorkManager.hpp"
#include "GBTClient.hpp"
#include "StratumClient.hpp"

void WorkManager::init() {
	_options.loadConf();
	std::cout << "-----------------------------------------------------------" << std::endl;
	if (_options.mode() == "Solo")
		_client = std::unique_ptr<Client>(new GBTClient(shared_from_this()));
	else if (_options.mode() == "Pool")
		_client = std::unique_ptr<Client>(new StratumClient(shared_from_this()));
	else _client = std::unique_ptr<Client>(new BMClient(shared_from_this()));
	
	_miner = std::unique_ptr<Miner>(new Miner(shared_from_this()));
	_miner->init();
	_inited = true;
}

bool WorkManager::getWork(WorkData &wd) {
	_clientMutex.lock();
	wd = _client->workData();
	_clientMutex.unlock();
	return wd.height != 0;
}

void WorkManager::submitWork(const WorkData &wd) {
	_clientMutex.lock();
	_client->addSubmission(wd);
	_clientMutex.unlock();
}

void WorkManager::manage() {
	if (!_inited) ERRORMSG("Manager was not inited!");
	else {
		_running = true;
		std::chrono::time_point<std::chrono::steady_clock> timer;
		while (_running) {
			if (_options.mode() == "Benchmark" && _miner->running()) {
				if (timeSince(_stats.miningStartTp()) > _options.benchmarkTimeLimit() && _options.benchmarkTimeLimit() != 0) {
					std::cout << timeSince(_stats.miningStartTp()) << " s elapsed, test finished. " << versionString << ", difficulty " << _options.benchmarkDifficulty() << ", PTL " << _options.primeTableLimit() << std::endl;
					_stats.printTuplesStats();
					_exit(0);
				}
				if (_stats.tuplesCount()[2] >= _options.benchmark2tupleCountLimit() && _options.benchmark2tupleCountLimit() != 0) {
					std::cout << _stats.tuplesCount()[2] << " 2-tuples found, test finished. " << versionString << ", difficulty " << _options.benchmarkDifficulty() << ", PTL " << _options.primeTableLimit() << std::endl;
					_stats.printBenchmarkResults();
					if (_options.benchmarkDifficulty() == 1600 && _options.primeTableLimit() == 2147483648 && _options.benchmark2tupleCountLimit() >= 50000 && _options.benchmarkTimeLimit() == 0)
						std::cout << "VALID parameters for Standard Benchmark" << std::endl;
					_stats.printTuplesStats();
					_exit(0);
				}
			}
			
			if (_client->connected()) {
				if (_options.refreshInterval() != 0) {
					if (timeSince(timer) > _options.refreshInterval() && _miner->inited() && _miner->running()) {
						_stats.printStats();
						_stats.printEstimatedTimeToBlock();
						timer = std::chrono::steady_clock::now();
					}
				}
				
				_clientMutex.lock();
				_client->process();
				if (!_client->connected()) {
					std::cout << "Connection lost :|, reconnecting in " << _waitReconnect << " s..." << std::endl;
					_miner->stopThreads();
					_stats.printTuplesStats();
					_stats = Stats(offsets().size());
					_clientMutex.unlock();
					usleep(1000000*_waitReconnect);
				}
				else {
					if (!_miner->inited()) {
						ERRORMSG("Miner is not inited!");
						exit(-1);
					}
					if (!_miner->running() && _client->workData().height != 0) {
						_miner->startThreads();
						_stats.setMiningType(_options.mode());
						_stats.startTimer();
						timer = std::chrono::steady_clock::now();
						std::cout << "-----------------------------------------------------------" << std::endl;
						const WorkData workData(_client->workData());
						_stats.printTime();
						std::cout << " Started mining at block " << workData.height << ", difficulty " << workData.difficulty << std::endl;
					}
					_currentHeight = _client->workData().height;
					_clientMutex.unlock();
					usleep(10000);
				}
			}
			else {
				std::cout << "Connecting to Riecoin server..." << std::endl;
				_clientMutex.lock();
				if (!_client->connect()) {
					_clientMutex.unlock();
					std::cout << "Failure :| ! Check your connection, configuration or credentials. Retry in " << _waitReconnect << " s..." << std::endl;
					usleep(1000000*_waitReconnect);
				}
				else {
					_clientMutex.unlock();
					_stats = Stats(offsets().size());
					std::cout << "Success!" << std::endl;
					usleep(10000);
				}
			}
		}
	}
}

void WorkManager::stop() {
	printTuplesStats();
	_currentHeight = 0;
	if (_miner->inited()) _miner->stop();
	else exit(0);
	_running = false;
}
