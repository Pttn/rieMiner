// (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)

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
	bool _inited, _running;
	uint16_t _waitReconnect; // Time in s to wait before reconnecting after disconnect
	uint32_t _currentHeight;
	
	public:
	WorkManager() : _stats(offsets().size()), _client(nullptr), _miner(nullptr), _inited(false), _waitReconnect(10), _currentHeight(0) {}
	void init();
	
	// The Miner will use these to get ready work from Client, and to submit solutions to it
	bool getWork(WorkData&);
	void submitWork(const WorkData&);
	
	void manage();
	void stop();
	Options options() const {return _options;}
	uint32_t difficulty() const {return _stats.difficulty();}
	std::vector<uint64_t> offsets() const {return _options.constellationType();}
	void printTime() const {_stats.printTime();}
	void printTuplesStats() const {_stats.printTuplesStats();}
	void incTupleCount(const uint8_t i) {_stats.incTupleCount(i);}
	void incRejectedShares() {_stats.incRejectedShares();}
	void newHeightMessage(const uint32_t height) {_stats.newHeightMessage(height);}
	void updateDifficulty(const uint32_t newDifficulty, const uint32_t height) {_stats.updateDifficulty(newDifficulty, height);}
	uint32_t getCurrentHeight() const {return _currentHeight;}
};

#endif
