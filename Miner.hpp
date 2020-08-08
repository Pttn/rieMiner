// (c) 2017-2020 Pttn and contributors (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Miner_hpp
#define HEADER_Miner_hpp

#include <atomic>
#include <cassert>
#include "tsQueue.hpp"
#include "WorkManager.hpp"

class WorkManager;
struct WorkData;

union xmmreg_t {
	uint32_t v[4];
	uint64_t v64[2];
	__m128i m128;
};

constexpr uint32_t PENDING_SIZE(16);
constexpr uint32_t WORK_DATAS(2);

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
	bool solo;
	int sieveWorkers;
	uint64_t sieveBits, sieveSize, sieveWords, maxIncrements, maxIterations;
	std::vector<uint64_t> primeTupleOffset;
	std::vector<mpz_class> primorialOffsets;
	
	MinerParameters() :
		threads(8),
		tupleLengthMin(6),
		primorialNumber(40), primeTableLimit(2147483648),
		solo(true),
		sieveWorkers(2),
		sieveBits(25), sieveSize(1UL << sieveBits), sieveWords(sieveSize/64), maxIncrements(1ULL << 29), maxIterations(maxIncrements/sieveSize),
		primeTupleOffset(defaultConstellationData[0].first),
		primorialOffsets(v64ToVMpz(defaultConstellationData[0].second)) {}
};

constexpr uint32_t maxCandidatesPerCheckJob(64);
enum JobType {TYPE_CHECK, TYPE_MOD, TYPE_SIEVE, TYPE_DUMMY};
struct primeTestWork {
	JobType type;
	uint32_t workDataIndex;
	union {
		struct {} dummy;
		struct {
			uint64_t loop;
			uint32_t offsetId;
			uint32_t nCandidates;
			uint32_t candidateIndexes[maxCandidatesPerCheckJob];
		} testWork;
		struct {
			uint64_t start;
			uint64_t end;
		} modWork;
		struct {
			uint32_t sieveId;
		} sieveWork;
	};
};

struct MinerWorkData {
	mpz_class target, remainderPrimorial;
	WorkData verifyBlock;
	std::atomic<uint64_t> outstandingTests{0};
};

struct SieveInstance {
	uint32_t id;
	std::mutex modLock;
	uint64_t *sieve = NULL;
	uint32_t **segmentHits = NULL;
	std::atomic<uint64_t> *segmentCounts = NULL;
	uint32_t *offsets = NULL;
};

class Miner {
	std::shared_ptr<WorkManager> _manager;
	MinerParameters _parameters;
	CpuID _cpuInfo;
	// Miner data (generated in init)
	mpz_class _primorial;
	uint64_t _nPrimes, _entriesPerSegment, _primeTestStoreOffsetsSize, _sparseLimit;
	std::vector<uint64_t> _primes, _modularInverses, _modPrecompute;
	std::vector<uint64_t> _halfPrimeTupleOffset, _primorialOffsetDiff, _primorialOffsetDiffToFirst;
	// Miner state variables
	bool _inited, _running;
	volatile uint32_t _currentHeight;
	tsQueue<primeTestWork, 1024> _modWorkQueue;
	tsQueue<primeTestWork, 4096> _verifyWorkQueue;
	tsQueue<int64_t, 9216> _workDoneQueue;
	SieveInstance* _sieveInstances;
	bool _masterExists;
	std::mutex _masterLock, _tupleFileLock;
	uint64_t _curWorkDataIndex;
	MinerWorkData _workData[WORK_DATAS];
	uint32_t _maxWorkOut;
	
	std::chrono::microseconds _modTime, _sieveTime, _verifyTime;
	
	void _addToPending(uint64_t *sieve, std::array<uint32_t, PENDING_SIZE> &pending, uint64_t &pos, uint32_t ent) {
		__builtin_prefetch(&(sieve[ent >> 6U]));
		uint32_t old(pending[pos]);
		if (old != 0)
			sieve[old >> 6U] |= (1ULL << (old & 63U));
		pending[pos] = ent;
		pos++;
		pos &= PENDING_SIZE - 1;
	}
	void _termPending(uint64_t *sieve, std::array<uint32_t, PENDING_SIZE> &pending) {
		for (uint64_t i(0) ; i < PENDING_SIZE ; i++) {
			const uint32_t old(pending[i]);
			if (old != 0)
				sieve[old >> 6U] |= (1ULL << (old & 63U));
		}
	}
	
	void _putOffsetsInSegments(SieveInstance& sieveInstance, uint64_t *offsets, uint64_t* counts, int nOffsets);
	void _updateRemainders(uint32_t workDataIndex, const uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex);
	void _processSieve(uint64_t *sieve, uint32_t* offsets, const uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex);
	void _processSieve6(uint64_t *sieve, uint32_t* offsets, const uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex);
	void _runSieve(SieveInstance& sieveInstance, uint32_t workDataIndex);
	bool _testPrimesIspc(uint32_t candidateIndexes[maxCandidatesPerCheckJob], uint32_t is_prime[maxCandidatesPerCheckJob], const mpz_class &ploop, mpz_class &candidate);
	void _verifyThread();
	mpz_class _getTargetFromBlock(const WorkData& block);
	void _processOneBlock(uint32_t workDataIndex, bool isNewHeight);
	
	public:
	Miner(const std::shared_ptr<WorkManager> &manager) :
		_manager(manager) {
		_inited  = false;
		_running = false;
		_currentHeight = 0;
		_parameters = MinerParameters();
		_nPrimes = 0;
		_entriesPerSegment = 0;
		_primeTestStoreOffsetsSize = 0;
		_sparseLimit = 0;
		_masterExists = false;
	}
	
	void init();
	void process(WorkData block);
	bool inited() {return _inited;}
	void pause() {
		_running = false;
		_currentHeight = 0;
	}
	void start() {
		_running = true;
	}
	bool running() {return _running;}
	void updateHeight(uint32_t height) {_currentHeight = height;}
};

#endif
