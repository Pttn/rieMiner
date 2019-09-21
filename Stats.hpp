// (c) 2017-2019 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Stats_hpp
#define HEADER_Stats_hpp

#include "tools.hpp"

// Contains stats data like: tuple counts, time elapsed since mining or latest difficulty change
// Provides useful stats displaying features
class Stats {
	std::vector<uint64_t> _tuples, _tuplesSinceLastDiff;
	uint32_t _difficulty, _heightAtDiffChange, _rejectedShares;
	std::chrono::time_point<std::chrono::system_clock> _miningStartTp, _lastDiffChangeTp;
	bool _solo;
	
	bool _inited() const {return _difficulty != 1;}
	
	public:
	Stats(uint8_t tupleLength = 6) :
		_tuples(tupleLength + 1, 0), _tuplesSinceLastDiff(tupleLength + 1, 0),
		_difficulty(1), _heightAtDiffChange(0), _rejectedShares(0),
		_lastDiffChangeTp(std::chrono::system_clock::now()),
		_solo(true) {}
	
	void startTimer();
	void setMiningType(const std::string &protocol) {_solo = !(protocol == "Pool");}
	
	void incTupleCount(const uint8_t i) {_tuples[i]++; _tuplesSinceLastDiff[i]++;}
	void incRejectedShares() {_rejectedShares++;}
	
	void newHeightMessage(const uint32_t);
	
	uint32_t difficulty() const {return _difficulty;}
	void updateDifficulty(const uint32_t, const uint32_t);
	uint32_t heightAtDiffChange() const {return _heightAtDiffChange;}
	
	std::chrono::time_point<std::chrono::system_clock> miningStartTp() const {return _miningStartTp;}
	std::vector<uint64_t> tuplesCount() const {return _tuples;}
	
	void printTime() const;
	void printStats() const;
	void printTuplesStats() const;
	void printEstimatedTimeToBlock() const;
	void printBenchmarkResults() const;
};

#endif
