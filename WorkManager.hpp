// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_WorkManager_hpp
#define HEADER_WorkManager_hpp

#include "main.hpp"
#include "Stats.hpp"
#include "Client.hpp"
#include "Miner.hpp"

class Client;
class Miner;

class WorkManager : public std::enable_shared_from_this<WorkManager> {
	Options _options;
	Stats _stats;
	std::unique_ptr<Client> _client;
	std::unique_ptr<Miner> _miner;
	std::mutex _clientMutex;
	std::vector<std::thread> _threads;
	bool _inited;
	uint16_t _waitReconnect, // Time in s to wait before reconnecting after disconnect
	         _workRefresh;   // Time in ms for each fetch work cycle
	
	void minerThread();
	
	public:
	WorkManager();
	
	void init();
	void submitWork(const WorkData&);
	bool getWork(WorkData&);
	void manage();
	Options options() const {return _options;}
	uint32_t height() const {return _stats.height();}
	uint32_t difficulty() const {return _stats.difficulty();}
	std::vector<uint64_t> offsets() const {return _options.constellationType();}
	void printTime() const {_stats.printTime();}
	void printTuplesStats() const {_stats.printTuplesStats();}
	void incTupleCount(const uint8_t i) {_stats.incTupleCount(i);}
	void incRejectedShares() {_stats.incRejectedShares();}
	void updateDifficulty(const uint32_t newDifficulty, const uint32_t height) {_stats.updateDifficulty(newDifficulty, height);}
	void updateHeight(const uint32_t height) {_stats.updateHeight(height);}
	void saveTuplesCounts() {_stats.saveTuplesCounts(_options.tupleCountsFile());}
};

#endif
