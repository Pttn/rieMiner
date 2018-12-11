// (c) 2017-2018 Pttn and contributors (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Miner_hpp
#define HEADER_Miner_hpp

#include <cassert>
#include <atomic>
#include "WorkManager.hpp"
#include "tsQueue.hpp"

class WorkManager;
struct WorkData;

union xmmreg_t {
	uint32_t v[4];
	uint64_t v64[2];
	__m128i m128;
};

#define PENDING_SIZE 16

#define WORK_DATAS 2
#define WORK_INDEXES 64
enum JobType {TYPE_CHECK, TYPE_MOD, TYPE_SIEVE, TYPE_DUMMY};

struct MinerParameters {
	int16_t threads;
	uint8_t tupleLengthMin;
	uint64_t primorialNumber, sieve;
	bool solo;
	int sieveWorkers;
	uint64_t sieveBits, sieveSize, sieveWords, maxIncrements, maxIter, denseLimit;
	std::vector<uint64_t> primes, inverts, primeTupleOffset, primorialOffsets;
	
	MinerParameters() {
		primorialNumber  = 40;
		threads          = 8;
		tupleLengthMin   = 6;
		sieve            = 2147483648;
		sieveWorkers     = 2;
		solo             = true;
		sieveBits        = 25;
		sieveSize        = 1UL << sieveBits;
		sieveWords       = sieveSize/64;
		maxIncrements    = (1ULL << 29),
		maxIter          = maxIncrements/sieveSize;
		primorialOffsets =  {4209995887ull, 4209999247ull, 4210002607ull, 4210005967ull,
		                     7452755407ull, 7452758767ull, 7452762127ull, 7452765487ull,
		                     8145217177ull, 8145220537ull, 8145223897ull, 8145227257ull};
		primeTupleOffset = {0, 4, 2, 4, 2, 4};
	}
};

struct primeTestWork {
	JobType type;
	uint32_t workDataIndex;
	union {
		struct {
			uint64_t loop;
			uint32_t offsetId;
			uint32_t n_indexes;
			uint32_t indexes[WORK_INDEXES];
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
	mpz_t z_verifyTarget, z_verifyRemainderPrimorial;
	WorkData verifyBlock;
	std::atomic<uint64_t> outstandingTests{0};
};

struct SieveInstance {
	uint32_t id;
	std::mutex modLock;
	uint8_t *sieve = NULL;
	uint32_t **segmentHits = NULL;
	std::atomic<uint64_t> *segmentCounts = NULL;
	uint32_t *offsets = NULL;
};

class Miner {
	std::shared_ptr<WorkManager> _manager;
	bool _inited, _running;
	volatile uint32_t _currentHeight;
	MinerParameters _parameters;
	CpuID _cpuInfo;
	
	tsQueue<primeTestWork, 1024> _modWorkQueue;
	tsQueue<primeTestWork, 4096> _verifyWorkQueue;
	tsQueue<int64_t, 9216> _workDoneQueue;
	mpz_t _primorial;
	uint64_t _nPrimes, _entriesPerSegment, _primeTestStoreOffsetsSize, _startingPrimeIndex, _sparseLimit;
	std::vector<uint64_t> _halfPrimeTupleOffset, _primorialOffsetDiff, _primorialOffsetDiffToFirst;
	SieveInstance* _sieves;

	std::chrono::microseconds _modTime, _sieveTime, _verifyTime;
	
	bool _masterExists;
	std::mutex _masterLock;

	uint64_t _curWorkDataIndex;
	MinerWorkData _workData[WORK_DATAS];
	uint32_t _maxWorkOut;

	void _initPending(uint32_t pending[PENDING_SIZE]) {
		for (int i(0) ; i < PENDING_SIZE; i++) pending[i] = 0;
	}

	void _addToPending(uint8_t *sieve, uint32_t pending[PENDING_SIZE], uint64_t &pos, uint32_t ent) {
		__builtin_prefetch(&(sieve[ent >> 3]));
		const uint32_t old(pending[pos]);
		if (old != 0) {
			assert(old < _parameters.sieveSize);
			sieve[old >> 3] |= (1 << (old & 7));
		}
		pending[pos] = ent;
		pos++;
		pos &= PENDING_SIZE - 1;
	}

	void _addRegToPending(uint8_t *sieve, uint32_t pending[PENDING_SIZE], uint64_t &pos, xmmreg_t reg, int mask) {
		if (mask & 0x0008) _addToPending(sieve, pending, pos, reg.v[0]);
		if (mask & 0x0080) _addToPending(sieve, pending, pos, reg.v[1]);
		if (mask & 0x0800) _addToPending(sieve, pending, pos, reg.v[2]);
		if (mask & 0x8000) _addToPending(sieve, pending, pos, reg.v[3]);
	}

	void _termPending(uint8_t *sieve, uint32_t pending[PENDING_SIZE]) {
		for (uint64_t i(0) ; i < PENDING_SIZE ; i++) {
			const uint32_t old(pending[i]);
			if (old != 0) {
				assert(old < _parameters.sieveSize);
				sieve[old >> 3] |= (1 << (old & 7));
			}
		}
	}
	
	void _putOffsetsInSegments(SieveInstance& sieve, uint64_t *offsets, uint64_t* counts, int n_offsets);
	void _updateRemainders(uint32_t workDataIndex, uint64_t start_i, uint64_t end_i);
	void _processSieve(uint8_t *sieve, uint32_t* offsets, uint64_t start_i, uint64_t end_i);
	void _processSieve6(uint8_t *sieve, uint32_t* offsets, uint64_t start_i, uint64_t end_i);
	void _runSieve(SieveInstance& sieve, uint32_t workDataIndex);
	void _verifyThread();
	void _getTargetFromBlock(mpz_t z_target, const WorkData& block);
	void _processOneBlock(uint32_t workDataIndex, bool isNewHeight);
	
	public:
	Miner(const std::shared_ptr<WorkManager> &manager) {
		_manager = manager;
		_inited  = false;
		_running = false;
		_currentHeight = 0;
		_parameters = MinerParameters();
		_nPrimes = 0;
		_entriesPerSegment = 0;
		_primeTestStoreOffsetsSize = 0;
		_startingPrimeIndex = 0;
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
