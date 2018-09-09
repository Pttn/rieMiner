/* Adapted from latest known optimized Riecoin miner, fastrie from dave-andersen (https://github.com/dave-andersen/fastrie).
(c) 2014-2017 dave-andersen (http://www.cs.cmu.edu/~dga/)
(c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner) */

#include <assert.h>
#include <math.h>
#include "global.h"
#include "client.h"
#include "gwclient.h"
#include "tools.h"
#include "tsqueue.hpp"

struct MinerParameters {
	uint64_t primorialNumber;
	int16_t threads;
	int sieveWorkers;
	std::vector<uint64_t> primes, inverts;
	bool solo;
	
	MinerParameters() {
		primorialNumber = 40;
		threads      = 4;
		sieveWorkers = 2;
		solo = true;
	}
};

enum JobType {TYPE_CHECK, TYPE_MOD, TYPE_SIEVE};
#define WORK_INDEXES 64

struct riecoinPrimeTestWork {
	JobType type;
	union {
		struct {
			uint64_t loop;
			uint64_t n_indexes;
			uint64_t indexes[WORK_INDEXES];
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

struct Miner {
	MinerParameters parameters;
	ts_queue<riecoinPrimeTestWork, 1024> verifyWorkQueue;
	ts_queue<int, 3096> workerDoneQueue;
	ts_queue<int, 3096> testDoneQueue;
	mpz_t primorial;
	
	uint8_t **sieves;
	
	Miner() {
		parameters = MinerParameters();
	}
};

Miner miner;

static const uint64_t riecoin_sieveBits = 24;
static const uint64_t riecoin_sieveSize = (1UL << riecoin_sieveBits);
static const uint64_t riecoin_sieveWords = riecoin_sieveSize/64;

uint64_t entriesPerSegment(0);

static const uint64_t maxIncrements = (1ULL << 29),
                      maxiter = (maxIncrements/riecoin_sieveSize);

static const uint64_t primorialOffset = 16057;
static const std::array<uint64_t, 6> primeTupleOffset = {0, 4, 2, 4, 2, 4};

static const uint64_t denseLimit(16384);
std::vector<uint64_t> segmentCounts;
uint64_t nPrimes,
         primeTestStoreOffsetsSize,
         startingPrimeIndex,
         n_dense(0), n_sparse(0);

thread_local bool isMaster(false);
bool masterExists = false;
std::mutex masterLock, bucketLock;

mpz_t z_verifyTarget, z_verifyRemainderPrimorial;
WorkData verifyBlock;

void miningInit(uint64_t sieveMax, int16_t threads, bool solo) {
	miner.parameters.threads = threads;
	miner.parameters.sieveWorkers = std::max(1, threads/4);
	miner.parameters.sieveWorkers = std::min(miner.parameters.sieveWorkers, 8);
	miner.parameters.solo = solo;
	
	mpz_init(z_verifyTarget);
	mpz_init(z_verifyRemainderPrimorial);
	
	std::cout << "Generating prime table using sieve of Eratosthenes...";
	std::vector<uint8_t> vfComposite;
	vfComposite.resize((sieveMax + 7)/8, 0);
	for (uint64_t nFactor(2) ; nFactor*nFactor < sieveMax ; nFactor++) {
		if (vfComposite[nFactor >> 3] & (1 << (nFactor & 7)))
			continue;
		for (uint64_t nComposite(nFactor*nFactor) ; nComposite < sieveMax ; nComposite += nFactor)
			vfComposite[nComposite >> 3] |= 1 << (nComposite & 7);
	}
	for (uint64_t n(2) ; n < sieveMax ; n++) {
		if (!(vfComposite[n >> 3] & (1 << (n & 7))))
			miner.parameters.primes.push_back(n);
	}
	nPrimes = miner.parameters.primes.size();
	std::cout << " Done!" << std::endl << "Table with all " << nPrimes << " first primes generated." << std::endl;
	
	mpz_init_set_ui(miner.primorial, miner.parameters.primes[0]);
	for (uint64_t i(1) ; i < miner.parameters.primorialNumber ; i++)
		mpz_mul_ui(miner.primorial, miner.primorial, miner.parameters.primes[i]);
	
	miner.parameters.inverts.resize(nPrimes);
	
	mpz_t z_tmp, z_p;
	mpz_init(z_tmp);
	mpz_init(z_p);
	for (uint64_t i(5) ; i < nPrimes ; i++) {
		mpz_set_ui(z_p, miner.parameters.primes[i]);
		mpz_invert(z_tmp, miner.primorial, z_p);
		miner.parameters.inverts[i] = mpz_get_ui(z_tmp);
	}
	mpz_clear(z_p);
	mpz_clear(z_tmp);
	
	uint64_t high_segment_entries(0);
	double high_floats(0.);
	primeTestStoreOffsetsSize = 0;
	for (uint64_t i(5) ; i < nPrimes ; i++) {
		uint64_t p(miner.parameters.primes[i]);
		if (p < maxIncrements)
			primeTestStoreOffsetsSize++;
		else high_floats += ((6.*maxIncrements)/(double) p);
	}
	
	high_segment_entries = ceil(high_floats);
	if (high_segment_entries == 0)
		entriesPerSegment = 1;
	else {
		entriesPerSegment = high_segment_entries/maxiter + 4; // Rounding up a bit
		entriesPerSegment = (entriesPerSegment + (entriesPerSegment >> 3));
	}
	
	segmentCounts.resize(maxiter);
	for (uint64_t i(miner.parameters.primorialNumber) ; i < nPrimes ; i++) {
		uint64_t p = miner.parameters.primes[i];
		if (p < denseLimit)
			n_dense++;
		else if (p < maxIncrements)
			n_sparse++;
	}
}

typedef uint64_t sixoff[6];

thread_local uint8_t* riecoin_sieve = NULL;
sixoff *offsets = NULL;
uint32_t *segment_hits[maxiter];

inline void silly_sort_indexes(uint64_t indexes[6]) {
	for (int i(0) ; i < 5; i++) {
		for (int j(i + 1) ; j < 6; j++) {
			if (indexes[j] < indexes[i])
				std::swap(indexes[i], indexes[j]);
		}
	}
}

#define PENDING_SIZE 16

inline void init_pending(uint64_t pending[PENDING_SIZE]) {
	for (int i(0) ; i < PENDING_SIZE; i++)
		pending[i] = 0;
}

inline void addToPending(uint8_t *sieve, uint64_t pending[PENDING_SIZE], uint64_t &pos, uint64_t ent) {
	__builtin_prefetch(&(sieve[ent >> 3]));
	uint64_t old = pending[pos];
	if (old != 0) {
		assert(old < riecoin_sieveSize);
		sieve[old >> 3] |= (1 << (old & 7));
	}
	pending[pos] = ent;
	pos++;
	pos &= 0xf;
}

void putOffsetsInSegments(uint64_t *offsets, int n_offsets) {
	bucketLock.lock();
	for (int i = 0; i < n_offsets; i++) {
		uint64_t index = offsets[i];
		uint64_t segment = index>>riecoin_sieveBits;
		uint64_t sc = segmentCounts[segment];
		if (sc >= entriesPerSegment) {
			std::cerr << "Segment " << segment << " " << sc << " with index " << index << " is > " << entriesPerSegment << std::endl;
			exit(-1);
		}
		segment_hits[segment][sc] = index - (riecoin_sieveSize*segment);
		segmentCounts[segment]++;
	}
	bucketLock.unlock();
}

thread_local uint64_t *offset_stack = NULL;

void update_remainders(uint64_t start_i, uint64_t end_i) {
	mpz_t tar;
	mpz_init(tar);
	mpz_set(tar, z_verifyTarget);
	mpz_add(tar, tar, z_verifyRemainderPrimorial);
	int n_offsets(0);
	static const int OFFSET_STACK_SIZE(16384);
	if (offset_stack == NULL)
		offset_stack = new uint64_t[OFFSET_STACK_SIZE];

	for (uint64_t i(start_i) ; i < end_i ; i++) {
		uint64_t p = miner.parameters.primes[i];
		uint64_t remainder = mpz_tdiv_ui(tar, p);
		bool is_once_only = false;

		/* Also update the offsets unless once only */
		if (p >= maxIncrements)
			is_once_only = true;
		 
		uint64_t invert(miner.parameters.inverts[i]);
		for (uint64_t f(0) ; f < 6 ; f++) {
			remainder += primeTupleOffset[f];
			if (remainder > p)
				remainder -= p;
			uint64_t pa(p - remainder);
			uint64_t index(pa*invert);
			index %= p;
			if (!is_once_only)
				offsets[i][f] = index;
			else {
				if (index < maxIncrements) {
					offset_stack[n_offsets++] = index;
					if (n_offsets >= OFFSET_STACK_SIZE) {
						putOffsetsInSegments(offset_stack, n_offsets);
						n_offsets = 0;
					}
				}
			}
		}
	}
	if (n_offsets > 0) {
		putOffsetsInSegments(offset_stack, n_offsets);
		n_offsets = 0;
	}
	mpz_clear(tar);
}

void process_sieve(uint8_t *sieve, uint64_t start_i, uint64_t end_i) {
	uint64_t pending[PENDING_SIZE];
	uint64_t pending_pos = 0;
	init_pending(pending);
	
	for (uint64_t i(start_i) ; i < end_i ; i++) {
		uint64_t pno(i + startingPrimeIndex);
		uint64_t p(miner.parameters.primes[pno]);
		for (uint64_t f(0) ; f < 6; f++) {
			while (offsets[pno][f] < riecoin_sieveSize) {
				addToPending(sieve, pending, pending_pos, offsets[pno][f]);
				offsets[pno][f] += p;
			}
			offsets[pno][f] -= riecoin_sieveSize;
		}
	}

	for (uint64_t i(0) ; i < PENDING_SIZE ; i++) {
		uint64_t old = pending[i];
		if (old != 0) {
			assert(old < riecoin_sieveSize);
			sieve[old >> 3] |= (1 << (old & 7));
		}
	}
}

void verifyThread() {
	/* Check for a prime cluster.
	 * Uses the fermat test - jh's code noted that it is slightly faster.
	 * Could do an MR test as a follow-up, but the server can do this too
	 * for the one-in-a-whatever case that Fermat is wrong.
	 */
	mpz_t z_ft_r, z_ft_b, z_ft_n;
	mpz_t z_temp, z_temp2;
	
	mpz_init(z_ft_r);
	mpz_init_set_ui(z_ft_b, 2);
	mpz_init(z_ft_n);
	mpz_init(z_temp);
	mpz_init(z_temp2);

	while (true) {
		auto job = miner.verifyWorkQueue.pop_front();
		
		if (job.type == TYPE_MOD) {
			update_remainders(job.modWork.start, job.modWork.end);
			miner.workerDoneQueue.push_back(1);
			continue;
		}
		
		if (job.type == TYPE_SIEVE) {
			process_sieve(miner.sieves[job.sieveWork.sieveId], job.sieveWork.start, job.sieveWork.end);
			miner.workerDoneQueue.push_back(1);
			continue;
		}
		// fallthrough:	job.type == TYPE_CHECK
		if (job.type == TYPE_CHECK) {
			for (uint64_t idx(0) ; idx < job.testWork.n_indexes ; idx++) {
				uint8_t nPrimes(0);
				mpz_set(z_temp, miner.primorial);
				mpz_mul_ui(z_temp, z_temp, job.testWork.loop*riecoin_sieveSize);
				mpz_set(z_temp2, miner.primorial);
				mpz_mul_ui(z_temp2, z_temp2, job.testWork.indexes[idx]);
				mpz_add(z_temp, z_temp, z_temp2);
				mpz_add(z_temp, z_temp, z_verifyRemainderPrimorial);
				mpz_add(z_temp, z_temp, z_verifyTarget);
				
				mpz_sub(z_temp2, z_temp, z_verifyTarget); // offset = tested - target
				
				mpz_sub_ui(z_ft_n, z_temp, 1);
				mpz_powm(z_ft_r, z_ft_b, z_ft_n, z_temp);
				
				if (mpz_cmp_ui(z_ft_r, 1) != 0)
					continue;
				
				nPrimes++;
				// Note start at 1 - we've already tested bias 0
				for (int i(1) ; i < 6 ; i++) {
					mpz_add_ui(z_temp, z_temp, primeTupleOffset[i]);
					mpz_sub_ui(z_ft_n, z_temp, 1);
					mpz_powm(z_ft_r, z_ft_b, z_ft_n, z_temp);
					if (mpz_cmp_ui(z_ft_r, 1) == 0) {
						nPrimes++;
						stats.foundTuples[nPrimes]++;
						stats.foundTuplesSinceLastDifficulty[nPrimes]++;
					}
					else if (!miner.parameters.solo) {
						int candidatesRemaining(5 - i);
						if ((nPrimes + candidatesRemaining) < 4) continue;
					}
					else break;
				}
				
				if (miner.parameters.solo) {
					if (nPrimes < arguments.tuples()) continue;
				}
				else if (nPrimes < 4) continue;
	
				// Generate nOffset and submit
				uint8_t nOffset[32];
				memset(nOffset, 0x00, 32);
#if BITS == 32
				for(uint32_t d(0) ; d < (uint32_t) std::min(32/4, z_temp2->_mp_size) ; d++)
					*(uint32_t*) (nOffset + d*4) = z_temp2->_mp_d[d];
#else
				for(uint32_t d(0) ; d < (uint32_t) std::min(32/8, z_temp2->_mp_size) ; d++)
					*(uint64_t*) (nOffset + d*8) = z_temp2->_mp_d[d];
#endif
				
				submitWork(verifyBlock, (uint32_t*) nOffset, nPrimes);
			}
			
			miner.testDoneQueue.push_back(1);
		}
	}
}

#define zeroesBeforeHashInPrime	8

void getTargetFromBlock(mpz_t z_target, const WorkData& block) {
	uint64_t searchBits = block.targetCompact;
	std::ostringstream oss, oss2;
	
	uint8_t powHash[32];
	sha256((uint8_t*) &block, powHash, 80);
	sha256(powHash, powHash, 32);
	
	mpz_init_set_ui(z_target, 1);
	mpz_mul_2exp(z_target, z_target, zeroesBeforeHashInPrime);
	for (uint64_t i(0) ; i < 256 ; i++) {
		mpz_mul_2exp(z_target, z_target, 1);
		if ((powHash[i/8] >> (i % 8)) & 1)
			z_target->_mp_d[0]++;
	}
	
	uint64_t trailingZeros(searchBits - 1 - zeroesBeforeHashInPrime - 256);
	mpz_mul_2exp(z_target, z_target, trailingZeros);
	
	uint64_t difficulty = mpz_sizeinbase(z_target, 2);
	if (stats.difficulty != difficulty && stats.difficulty != 1) {
		stats.printTuplesStats();
		stats.lastDifficultyChange = std::chrono::system_clock::now();
		stats.blockHeightAtDifficultyChange = block.height;
		for (uint8_t i(0) ; i < 7 ; i++)
			stats.foundTuplesSinceLastDifficulty[i] = 0;
	}
	stats.difficulty = difficulty;
}

void miningProcess(WorkData block) {
	if (!masterExists) {
		masterLock.lock();
		if (!masterExists) {
			masterExists = true;
			isMaster = true;
		}
		masterLock.unlock();
	}
	
	if (!isMaster) {
		verifyThread(); // Runs forever
		return;
	}
	
	if (riecoin_sieve == NULL) {
		try {
			// std::cout << "Allocating " << riecoin_sieveSize/8 << " bytes for riecoin_sieve..." << std::endl;
			riecoin_sieve = new uint8_t[riecoin_sieveSize/8];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for riecoin_sieve :|..." << std::endl;
			exit(-1);
		}
		
		try {
			// std::cout << "Allocating " << miner.parameters.sieveWorkers << " bytes for the miner.sieves..." << std::endl;
			miner.sieves = new uint8_t*[miner.parameters.sieveWorkers];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the miner.sieves :|..." << std::endl;
			exit(-1);
		}
		
		try {
			// std::cout << "Allocating " << riecoin_sieveSize/8*miner.parameters.sieveWorkers << " bytes for the miner.sieves..." << std::endl;
			for (int i(0) ; i < miner.parameters.sieveWorkers; i++)
				miner.sieves[i] = new uint8_t[riecoin_sieveSize/8];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the miner.sieves :|..." << std::endl;
			exit(-1);
		}
		
		try {
			// std::cout << "Allocating " << 6*4*(primeTestStoreOffsetsSize + 1024) << " bytes for the offsets..." << std::endl;
			offsets = new sixoff[primeTestStoreOffsetsSize + 1024];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the offsets :|..." << std::endl;
			exit(-1);
		}
		
		memset(offsets, 0, sizeof(sixoff)*(primeTestStoreOffsetsSize + 1024));
		
		try {
			// std::cout << "Allocating " << 4*maxiter*entriesPerSegment<< " bytes for the segment_hits..." << std::endl;
			for (uint64_t i(0); i < maxiter; i++)
				segment_hits[i] = new uint32_t[entriesPerSegment];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the segment_hits :|..." << std::endl;
			exit(-1);
		}
	}
	uint8_t* sieve(riecoin_sieve);
	
	mpz_t z_target, z_temp, z_remainderPrimorial;
	
	mpz_init(z_temp);
	mpz_init(z_remainderPrimorial);
	
	getTargetFromBlock(z_target, block);
	// find first offset where target%primorial = primorialOffset
	mpz_tdiv_r(z_remainderPrimorial, z_target, miner.primorial);
	mpz_abs(z_remainderPrimorial, z_remainderPrimorial);
	mpz_sub(z_remainderPrimorial, miner.primorial, z_remainderPrimorial);
	mpz_tdiv_r(z_remainderPrimorial, z_remainderPrimorial, miner.primorial);
	mpz_abs(z_remainderPrimorial, z_remainderPrimorial);
	mpz_add_ui(z_remainderPrimorial, z_remainderPrimorial, primorialOffset);
	mpz_add(z_temp, z_target, z_remainderPrimorial);
	const uint64_t primeIndex = miner.parameters.primorialNumber;
	
	startingPrimeIndex = primeIndex;
	mpz_set(z_verifyTarget, z_target);
	mpz_set(z_verifyRemainderPrimorial, z_remainderPrimorial);
	verifyBlock = block;
	
	for (uint64_t i(0) ; i < maxiter; i++)
		segmentCounts[i] = 0;
	
	uint64_t incr(nPrimes/128);
	riecoinPrimeTestWork wi;
	wi.type = TYPE_MOD;
	int n_workers = 0;
	for (auto base(primeIndex) ; base < nPrimes ; base += incr) {
		uint64_t lim(std::min(nPrimes, base+incr));
		wi.modWork.start = base;
		wi.modWork.end = lim;
		miner.verifyWorkQueue.push_back(wi);
		n_workers++;
	}
	for (int i(0) ; i < n_workers ; i++)
		miner.workerDoneQueue.pop_front();
	
	/* Main processing loop:
	 * 1)	Sieve "dense" primes;
	 * 2)	Sieve "sparse" primes;
	 * 3)	Sieve "so sparse they happen at most once" primes;
	 * 4)	Scan sieve for candidates, test, report
	 */

	uint64_t countCandidates = 0;
	uint64_t outstandingTests = 0;
	for (uint64_t loop(0); loop < maxiter; loop++) {
		__sync_synchronize(); // gcc specific - memory barrier for checking height
		if (block.height != currentBlockHeight)
			break;
		
		for (int i(0) ; i < miner.parameters.sieveWorkers ; i++)
			memset(miner.sieves[i], 0, riecoin_sieveSize/8);
		
		wi.type = TYPE_SIEVE;
		n_workers = 0;
		incr = ((n_sparse)/miner.parameters.sieveWorkers) + 1;
		int which_sieve(0);
		for (uint64_t base(n_dense) ; base < (n_dense + n_sparse) ; base += incr) {
			uint64_t lim(std::min(n_dense + n_sparse,
			                      base + incr));
			if (lim + 1000 > n_dense + n_sparse)
				lim = (n_dense+n_sparse);
			wi.sieveWork.start = base;
			wi.sieveWork.end = lim;
			wi.sieveWork.sieveId = which_sieve;
			// Need to do something for thread to sieve affinity
			miner.verifyWorkQueue.push_front(wi);
			which_sieve++;
			which_sieve %= miner.parameters.sieveWorkers;
			n_workers++;
			if (lim + 1000 > n_dense + n_sparse)
				break;
		}

		memset(sieve, 0, riecoin_sieveSize/8);
		
		for (uint64_t i(0) ; i < n_dense ; i++) {
			uint64_t pno(i + startingPrimeIndex);
			silly_sort_indexes(offsets[pno]);
			uint64_t p(miner.parameters.primes[pno]);
			for (uint64_t f(0) ; f < 6 ; f++) {
				while (offsets[pno][f] < riecoin_sieveSize) {
					assert(offsets[pno][f] < riecoin_sieveSize);
					sieve[offsets[pno][f]>>3] |= (1 << ((offsets[pno][f] & 7)));
					offsets[pno][f] += p;
				}
				offsets[pno][f] -= riecoin_sieveSize;
			}
		}
		
		outstandingTests -= miner.testDoneQueue.clear();
		for (int32_t i(0) ; i < n_workers; i++)
			miner.workerDoneQueue.pop_front();
		
		for (uint64_t i(0) ; i < riecoin_sieveWords ; i++) {
			for (int j(0) ; j < miner.parameters.sieveWorkers; j++) {
				((uint64_t*) sieve)[i] |= ((uint64_t*) (miner.sieves[j]))[i];
			}
		}
		
		uint64_t pending[PENDING_SIZE];
		init_pending(pending);
		uint64_t pending_pos = 0;
		for (uint64_t i(0) ; i < segmentCounts[loop] ; i++)
			addToPending(sieve, pending, pending_pos, segment_hits[loop][i]);

		for (uint64_t i = 0; i < PENDING_SIZE; i++) {
			uint64_t old = pending[i];
			if (old != 0) {
				assert(old < riecoin_sieveSize);
				sieve[old >> 3] |= (1 << (old & 7));
			}
		}
		
		riecoinPrimeTestWork w;
		w.testWork.n_indexes = 0;
		w.testWork.loop = loop;
		w.type = TYPE_CHECK;

		bool do_reset(false);
		uint64_t *sieve64 = (uint64_t*) sieve;
		for(uint64_t b(0) ; !do_reset && b < riecoin_sieveWords ; b++) {
			uint64_t sb(~sieve64[b]);
			
			int sb_process_count(0);
			while (sb != 0) {
				sb_process_count++;
				if (sb_process_count > 65) {
					std::cerr << "Impossible: process count too high :|" << std::endl;
					exit(-1);
				}
				uint64_t highsb(__builtin_clzll(sb));
				uint64_t i((b*64) + (63 - highsb));
				sb &= ~(1ULL<<(63 - highsb));
				
				countCandidates++;
				
				w.testWork.indexes[w.testWork.n_indexes] = i;
				w.testWork.n_indexes++;
				outstandingTests -= miner.testDoneQueue.clear();
				
				if (w.testWork.n_indexes == WORK_INDEXES) {
					miner.verifyWorkQueue.push_back(w);
					w.testWork.n_indexes = 0;
					outstandingTests++;
				}
				outstandingTests -= miner.testDoneQueue.clear();
	
				// Low overhead but still often enough
				if (block.height != currentBlockHeight) {
					outstandingTests -= miner.verifyWorkQueue.clear();
					do_reset = true;
					break;
				}
			}
		}

		if (w.testWork.n_indexes > 0) {
			miner.verifyWorkQueue.push_back(w);
			outstandingTests++;
			w.testWork.n_indexes = 0;
		}
	}
	
	outstandingTests -= miner.testDoneQueue.clear();
	
	while (outstandingTests > 0) {
		miner.testDoneQueue.pop_front();
		outstandingTests--;
		if (block.height != currentBlockHeight) {
			outstandingTests -= miner.verifyWorkQueue.clear();
		}
	}
	
	mpz_clears(z_target, z_temp, z_remainderPrimorial, NULL);
}
