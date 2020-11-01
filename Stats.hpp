// (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Stats_hpp
#define HEADER_Stats_hpp

#include "tools.hpp"

// "Raw" and immutable stats, and tools to analyze them
class Stats {
	std::vector<uint64_t> _counts;
	double _duration;
public:
	Stats(const std::vector<uint64_t> &counts, const double &duration) : _counts(counts), _duration(duration) {};
	std::vector<uint64_t> counts() const {return _counts;}
	uint64_t count(const uint64_t i) const {return i < _counts.size() ? _counts[i] : 0;}
	double duration() const {return _duration;}
	double cps() const {return _duration > 0. ? static_cast<double>(_counts[0])/_duration : 0.;}
	double r() const {return _counts[1] > 0 ? static_cast<double>(_counts[0])/static_cast<double>(_counts[1]) : 0.;}
	double estimatedAverageTimeToFindBlock(const uint64_t primeCountTarget) const {return cps() != 0. ? std::pow(r(), primeCountTarget)/cps() : 0.;}
	std::string formattedCounts(const uint64_t = 0) const;
	std::string formattedRates(const uint64_t = 0) const;
	std::string formattedRatios() const;
	static std::string formattedTime(const double &time);
	static std::string formattedClockTimeNow();
	static std::string formattedDuration(const double &duration);
};

// Allows the miner to update and get stats
constexpr uint32_t countsRecentEntries(5);
class StatManager {
	struct Counts {
		std::vector<uint64_t> counts;
		std::chrono::time_point<std::chrono::steady_clock> startTp;
		Counts() : counts(std::vector<uint64_t>()) {};
		Counts(const uint64_t tupleSize) : counts(tupleSize + 1, 0), startTp(std::chrono::steady_clock::now()) {}
	};
	uint64_t _tupleSize, _nBlocks, _countsRecentEntryPos;
	Counts _countsSinceStart;
	std::vector<Counts> _countsRecent; // Stores separately the counts for the last countsRecentEntries blocks
	std::mutex _countsLock;
public:
	StatManager() {}
	void start(const uint64_t);
	void newBlock();
	void addCounts(const std::vector<uint64_t>&);
	double timeSinceStart() const {return timeSince(_countsSinceStart.startTp);}
	double averageBlockTime() const {return _nBlocks > 0 ? timeSinceStart()/static_cast<double>(_nBlocks) : 0;}
	Stats stats(const bool) const;
};

#endif
