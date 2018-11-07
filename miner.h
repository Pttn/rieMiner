// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_MINER_H
#define HEADER_MINER_H

#include <assert.h>
#include <math.h>
#include <immintrin.h>
#include <chrono>
#include "main.h"
#include "client.h"
#include "tools.h"
#include "tsqueue.hpp"

union xmmreg_t {
	uint32_t v[4];
	__m128i m128;
};

#define PENDING_SIZE 16

struct MinerParameters {
	uint64_t primorialNumber;
	int16_t threads;
	uint8_t tuples;
	uint64_t sieve;
	bool solo;
	int sieveWorkers;
	uint64_t sieveBits, sieveSize, sieveWords, maxIncrements, maxIter, primorialOffset, denseLimit;
	std::vector<uint64_t> primes, inverts, modPrecompute, primeTupleOffset;
	
	MinerParameters() {
		primorialNumber = 40;
		threads         = 8;
		tuples          = 6;
		sieve           = 2147483648;
		sieveWorkers    = 2;
		solo            = true;
		sieveBits       = 24;
		sieveSize       = 1UL << sieveBits;
		sieveWords      = sieveSize/64;
		maxIncrements   = (1ULL << 29),
		maxIter         = maxIncrements/sieveSize;
		primorialOffset = 16057;
		denseLimit      = 16384;
		primeTupleOffset = {0, 4, 2, 4, 2, 4};
	}
};

struct primeTestWork {
	JobType type;
	union {
		struct {
			uint64_t loop;
			uint64_t n_indexes;
			uint32_t indexes[WORK_INDEXES];
		} testWork;
		struct {
			uint64_t start;
			uint64_t end;
		} modWork;
		struct {
			uint64_t start;
			uint64_t end;
			uint64_t sieveId;
		} sieveWork;
	};
};

class Miner {
	std::shared_ptr<WorkManager> _manager;
	bool _inited;
	volatile uint32_t _currentHeight;
	MinerParameters _parameters;
	
	ts_queue<primeTestWork, 1024> _verifyWorkQueue;
	ts_queue<int, 3096> _workerDoneQueue;
	ts_queue<int, 3096> _testDoneQueue;
	mpz_t _primorial;
	uint64_t _nPrimes, _entriesPerSegment, _primeTestStoreOffsetsSize, _startingPrimeIndex, _nDense, _nSparse;
	uint8_t  **_sieves;
	uint32_t **_segmentHits;
	std::vector<uint64_t> _segmentCounts;
	std::vector<uint64_t> _halfPrimeTupleOffset;

	std::chrono::microseconds _modTime, _sieveTime, _verifyTime;
	
	bool _masterExists;
	std::mutex _masterLock, _bucketLock;

	mpz_t z_verifyTarget, z_verifyRemainderPrimorial;
	WorkData _verifyBlock;
	
	void _initPending(uint32_t pending[PENDING_SIZE]) {
		for (int i(0) ; i < PENDING_SIZE; i++) pending[i] = 0;
	}

	void _addToPending(uint8_t *sieve, uint32_t pending[PENDING_SIZE], uint64_t &pos, uint32_t ent) {
		__builtin_prefetch(&(sieve[ent >> 3]));
		uint32_t old = pending[pos];
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
			uint32_t old(pending[i]);
			if (old != 0) {
				assert(old < _parameters.sieveSize);
				sieve[old >> 3] |= (1 << (old & 7));
			}
		}
	}
	
	void _putOffsetsInSegments(uint64_t *offsets, int n_offsets);
	void _updateRemainders(uint64_t start_i, uint64_t end_i, bool usePrecomp);
	void _processSieve(uint8_t *sieve, uint64_t start_i, uint64_t end_i);
	void _processSieve6(uint8_t *sieve, uint64_t start_i, uint64_t end_i);
	void _verifyThread();
	void _getTargetFromBlock(mpz_t z_target, const WorkData& block);
	
	public:
	Miner(const std::shared_ptr<WorkManager> &manager) {
		_manager = manager;
		_inited = false;
		_currentHeight = 0;
		_parameters = MinerParameters();
		_sieves = NULL;
		_segmentHits = NULL;
		_nPrimes = 0;
		_entriesPerSegment = 0;
		_segmentCounts = std::vector<uint64_t>();
		_primeTestStoreOffsetsSize = 0;
		_startingPrimeIndex = 0;
		_nDense  = 0;
		_nSparse = 0;
		_masterExists = false;
	}
	
	void init();
	void process(WorkData block);
	bool inited() {return _inited;}
	void updateHeight(uint32_t height) {_currentHeight = height;}
};

#endif
