// (c) 2017-2020 Pttn and contributors (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Miner_hpp
#define HEADER_Miner_hpp

#include <atomic>
#include <cassert>
#include "WorkManager.hpp"

class WorkManager;
struct WorkData;

union xmmreg_t {
	uint32_t v[4];
	uint64_t v64[2];
	__m128i m128;
};

constexpr uint32_t sieveCacheSize(16);
constexpr uint32_t nWorks(2);

inline std::vector<mpz_class> v64ToVMpz(const std::vector<uint64_t> &v64) {
	std::vector<mpz_class> vMpz;
	for (const auto & n : v64) {
		mpz_class mpz;
		mpz_import(mpz.get_mpz_t(), 1, 1, 8, 0, 0, &n);
		vMpz.push_back(mpz);
	}
	return vMpz;
}

struct MinerParameters {
	uint16_t threads;
	uint8_t tupleLengthMin;
	uint64_t primorialNumber, primeTableLimit;
	bool solo, useAvx2;
	int sieveWorkers;
	uint64_t sieveBits, sieveSize, sieveWords, maxIncrements, maxIterations;
	std::vector<uint64_t> primeTupleOffset;
	std::vector<mpz_class> primorialOffsets;
	
	MinerParameters() :
		threads(8),
		tupleLengthMin(6),
		primorialNumber(40), primeTableLimit(2147483648),
		solo(true), useAvx2(false),
		sieveWorkers(2),
		sieveBits(25), sieveSize(1UL << sieveBits), sieveWords(sieveSize/64), maxIncrements(1ULL << 29), maxIterations(maxIncrements/sieveSize),
		primeTupleOffset(defaultConstellationData[0].first),
		primorialOffsets(v64ToVMpz(defaultConstellationData[0].second)) {}
};

constexpr uint32_t maxCandidatesPerCheckJob(64);
struct Job {
	enum Type {Dummy, Presieve, Sieve, Check};
	Type type;
	uint64_t workIndex;
	union {
		struct {} dummy;
		struct {
			uint64_t loop;
			uint32_t offsetId;
			uint32_t nCandidates;
			uint32_t candidateIndexes[maxCandidatesPerCheckJob];
		} check;
		struct {
			uint64_t start;
			uint64_t end;
		} presieve;
		struct {
			uint32_t sieveId;
			uint64_t iteration;
		} sieve;
	};
};

struct JobDoneInfo {
	Job::Type type;
	union {
		struct {} empty;
		uint64_t workIndex;
		uint64_t firstPrimeIndex;
	};
};

struct MinerWork {
	mpz_class target, remainderPrimorial;
	WorkData verifyBlock;
	std::atomic<uint64_t> nRemainingCheckJobs{0};
	void clear() {
		target = 0;
		remainderPrimorial = 0;
		nRemainingCheckJobs = 0;
	}
};

struct SieveInstance {
	uint32_t id;
	std::mutex presieveLock;
	uint64_t *sieve = NULL;
	uint32_t **segmentHits = NULL;
	std::atomic<uint64_t> *segmentCounts = NULL;
	uint32_t *offsets = NULL;
};

class Miner {
	std::shared_ptr<WorkManager> _manager;
	std::thread _masterThread;
	std::vector<std::thread> _workerThreads;
	MinerParameters _parameters;
	CpuID _cpuInfo;
	// Miner data (generated in init)
	mpz_class _primorial;
	uint64_t _nPrimes, _entriesPerSegment, _primeTestStoreOffsetsSize, _sparseLimit;
	std::vector<uint64_t> _primes, _modularInverses, _modPrecompute;
	std::vector<uint64_t> _halfPrimeTupleOffset, _primorialOffsetDiff, _primorialOffsetDiffToFirst;
	// Miner state variables
	bool _inited, _running;
	TsQueue<Job> _presieveJobs, _jobs;
	TsQueue<JobDoneInfo> _jobsDoneInfos;
	SieveInstance* _sieveInstances;
	std::array<MinerWork, nWorks> _works;
	uint32_t _nRemainingCheckJobsThreshold;
	std::mutex _tupleFileLock;
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
	
	void _putOffsetsInSegments(SieveInstance& sieveInstance, uint64_t *offsets, uint64_t* counts, int nOffsets);
	void _doPresieveJob(const Job&);
	void _processSieve(uint64_t *sieve, uint32_t* offsets, const uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex);
	void _processSieve6(uint64_t *sieve, uint32_t* offsets, const uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex);
	void _doSieveJob(Job);
	bool _testPrimesIspc(uint32_t candidateIndexes[maxCandidatesPerCheckJob], uint32_t is_prime[maxCandidatesPerCheckJob], const mpz_class &ploop, mpz_class &candidate);
	void _doCheckJob(Job);
	void _doJobs(uint16_t);
	void _manageJobs();
	mpz_class _getTargetFromBlock(const WorkData& block);
	
	public:
	Miner(const std::shared_ptr<WorkManager> &manager) :
		_manager(manager) {
		_inited  = false;
		_running = false;
		_parameters = MinerParameters();
		_nPrimes = 0;
		_entriesPerSegment = 0;
		_primeTestStoreOffsetsSize = 0;
		_sparseLimit = 0;
	}
	
	void start() {
		init();
		startThreads();
	}
	void init();
	void startThreads();
	void stop() {
		if (_running) stopThreads();
		if (_inited) clear();
	}
	void stopThreads();
	void clear();
	bool inited() {return _inited;}
	bool running() {return _running;}
};

#endif
