// (c) 2017-present Pttn and contributors (https://riecoin.dev/en/rieMiner)

#ifndef HEADER_Miner_hpp
#define HEADER_Miner_hpp

#include <atomic>
#include <cassert>
#include "Client.hpp"

struct Job;

#ifdef __SSE2__
#include <immintrin.h>
union xmmreg_t {
	uint32_t v[4];
	uint64_t v64[2];
	__m128i m128;
};
#ifdef __AVX2__
#include "ispc/fermat.h"
union ymmreg_t {
	uint32_t v[8];
	uint64_t v64[4];
	__m256i m256;
};
#endif
#endif

constexpr uint32_t sieveCacheSize(32);
constexpr uint32_t nWorks(2);

inline mpz_class u64ToMpz(const uint64_t u64) {
	mpz_class mpz;
	mpz_import(mpz.get_mpz_t(), 1, 1, 8, 0, 0, &u64);
	return mpz;
}

inline std::vector<mpz_class> v64ToVMpz(const std::vector<uint64_t> &v64) {
	std::vector<mpz_class> vMpz;
	for (const auto & n : v64)
		vMpz.push_back(u64ToMpz(n));
	return vMpz;
}

constexpr uint32_t maxCandidatesPerCheckTask(64);
struct Task {
	enum Type {Dummy, Presieve, Sieve, Check};
	Type type;
	uint64_t workIndex;
	union {
		struct {} dummy;
		struct {
			uint64_t start;
			uint64_t end;
		} presieve;
		struct {
			uint32_t id;
			uint64_t iteration;
		} sieve;
		struct {
			uint32_t offsetId;
			uint32_t nCandidates;
			uint32_t factorStart; // The form of a candidate is firstCandidate + primorial*f, with f = factorStart + factorOffset
			std::array<uint32_t, maxCandidatesPerCheckTask> factorOffsets;
		} check;
	};

	static Task PresieveTask(uint64_t workIndex, uint64_t start, uint64_t end) {
		Task task;
		task.type = Presieve;
		task.workIndex = workIndex;
		task.presieve.start = start;
		task.presieve.end = end;
		return task;
	}
	static Task SieveTask(uint64_t workIndex, uint32_t id, uint64_t iteration) {
		Task task;
		task.type = Sieve;
		task.workIndex = workIndex;
		task.sieve.id = id;
		task.sieve.iteration = iteration;
		return task;
	}
};

struct TaskDoneInfo {
	Task::Type type;
	union {
		uint64_t workIndex;
		uint64_t firstPrimeIndex;
	};
};

struct MinerWork {
	Job job; // Fetched from the Client, to be completed with the solution once it is found.
	mpz_class primorialMultipleStart; // First multiple of the primorial after the target.
	std::atomic<uint64_t> nRemainingCheckTasks{0};
	void clear() {
		primorialMultipleStart = 0;
		nRemainingCheckTasks = 0;
	}
};

struct Sieve {
	uint32_t id;
	std::mutex presieveLock;
	uint64_t *factorsTable = nullptr; // Booleans corresponding to whether a primorial factor is eliminated
	uint32_t *factorsToEliminate = nullptr; // One entry for each constellation offset, for each prime number p < factorMax (the factors are in the form of indexes of the factorsTable)
	uint32_t **additionalFactorsToEliminate = nullptr; // Factors for p >= factorMax (they are eliminated only once and treated separately), arranged by Sieve Iteration (also in the form of indexes of the factorsTable)
	std::atomic<uint64_t> *additionalFactorsToEliminateCounts = nullptr; // Counts for each Sieve Iteration
};

class Miner {
	const std::string _mode;
	MinerParameters _parameters;
	std::shared_ptr<Client> _client;
	std::thread _masterThread;
	std::vector<std::thread> _workerThreads;
	// Miner data (generated in init)
	mpz_class _primorial;
	uint64_t _primorialNumber, _nPrimes, _nPrimes32, _factorMax, _primesIndexThreshold;
	std::vector<uint32_t> _primes32, _modularInverses32;
	std::vector<uint64_t> _primes64, _modularInverses64;
#ifdef __SSE2__
	std::vector<uint64_t> _modPrecompute;
#endif
	std::vector<mpz_class> _primorialOffsets;
	std::vector<uint64_t> _halfPattern, _primorialOffsetDiff;
	// Miner state variables
	bool _inited, _running, _shouldRestart, _keepStats, _tupleFound;
	double _difficultyAtInit; // Restart the miner if the Difficulty changed a lot to retune
	TsQueue<Task> _presieveTasks, _tasks;
	TsQueue<TaskDoneInfo> _tasksDoneInfos;
	std::vector<Sieve> _sieves;
	std::array<MinerWork, nWorks> _works; // Alternating work for better efficiency when there is a new block
	uint32_t _nRemainingCheckTasksThreshold, _currentWorkIndex;
	std::chrono::microseconds _presieveTime, _sieveTime, _verifyTime;
	
	void _addToSieveCache(uint64_t *sieve, std::array<uint32_t, sieveCacheSize> &sieveCache, uint64_t &pos, uint32_t ent) {
		__builtin_prefetch(&(sieve[ent >> 6U]));
		uint32_t old(sieveCache[pos]);
		if (old != 0)
			sieve[old >> 6U] |= (1ULL << (old & 63U));
		sieveCache[pos] = ent;
		pos++;
		pos &= sieveCacheSize - 1;
	}
	void _endSieveCache(uint64_t *sieve, std::array<uint32_t, sieveCacheSize> &sieveCache) {
		for (uint64_t i(0) ; i < sieveCacheSize ; i++) {
			const uint32_t old(sieveCache[i]);
			if (old != 0)
				sieve[old >> 6U] |= (1ULL << (old & 63U));
		}
	}
	
	void _addCachedAdditionalFactorsToEliminate(Sieve&, uint64_t*, uint64_t*, const int);
	void _doPresieveTask(const Task&);
	void _processSieve(uint64_t*, uint32_t*, const uint64_t, const uint64_t);
#ifdef __SSE2__
	void _processSieve6(uint64_t*, uint32_t*, uint64_t, const uint64_t);
	void _processSieve7(uint64_t*, uint32_t*, uint64_t, const uint64_t);
	void _processSieve8(uint64_t*, uint32_t*, uint64_t, const uint64_t);
#ifdef __AVX2__
	void _processSieve7_avx2(uint64_t*, uint32_t*, uint64_t, const uint64_t);
	void _processSieve8_avx2(uint64_t*, uint32_t*, uint64_t, const uint64_t);
	bool _testPrimesIspc(const std::array<uint32_t, maxCandidatesPerCheckTask>&, uint32_t[maxCandidatesPerCheckTask], const mpz_class&, mpz_class&);
#endif
#endif
	void _doSieveTask(Task);
	void _doCheckTask(Task);
	void _doTasks(uint16_t);
	void _manageTasks();
	void _suggestLessMemoryIntensiveOptions(const uint64_t, const uint16_t)  const;

	uint64_t _getPrime(uint64_t i) const { 
		if (i < _nPrimes32) return _primes32[i];
		else return _primes64[i - _nPrimes32];
	}
	uint64_t _getModularInverse(uint64_t i) const {
		if (i < _nPrimes32) return _modularInverses32[i];
		else return _modularInverses64[i - _nPrimes32];
	}
public:
	Miner(const Options &options) :
		_mode(options.mode), _parameters(MinerParameters()),
		_client(nullptr),
		_inited(false), _running(false), _shouldRestart(false), _keepStats(false) {
		_nPrimes = 0;
		_primesIndexThreshold = 0;
	}
	
	void setClient(const std::shared_ptr<Client> &client) {_client = client;}
	bool hasAcceptedPatterns(const std::vector<std::vector<uint64_t>>&) const;
	void start(const MinerParameters &minerParameters) {
		init(minerParameters);
		startThreads();
	}
	void init(const MinerParameters&);
	void startThreads();
	void stop() {
		if (_running) stopThreads();
		if (_inited) clear();
	}
	void stopThreads();
	void clear();
	bool inited() {return _inited;}
	bool running() {return _running;}
	bool shouldRestart() {return _shouldRestart;}
	
	void printStats() const;
	bool benchmarkFinishedTimeOut(const double) const;
	bool benchmarkFinishedEnoughPrimes(const uint64_t) const;
	void printBenchmarkResults() const;
	void printTupleStats() const;
	bool tupleFound() {
		return _tupleFound;
	}
};

#endif
