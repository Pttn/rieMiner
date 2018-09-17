/* Adapted from latest known optimized Riecoin miner, fastrie from dave-andersen (https://github.com/dave-andersen/fastrie).
(c) 2014-2017 dave-andersen (http://www.cs.cmu.edu/~dga/)
(c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner) */

#include "miner.h"

thread_local bool isMaster(false);
thread_local uint64_t *offset_stack(NULL);

typedef uint64_t sixoff[6];

thread_local uint8_t* riecoin_sieve(NULL);
sixoff *offsets(NULL);

#define	zeroesBeforeHashInPrime	8

void Miner::init() {
	_parameters.threads = _manager->options().threads();
	_parameters.sieveWorkers = std::max(1, _manager->options().threads()/4);
	_parameters.sieveWorkers = std::min(_parameters.sieveWorkers, 8);
	_parameters.solo = !(_manager->options().protocol() == "Stratum");
	_parameters.tuples = _manager->options().tuples();
	_parameters.sieve = _manager->options().sieve();
	_parameters.primeTupleOffset = _manager->offsets();
	
	mpz_init(z_verifyTarget);
	mpz_init(z_verifyRemainderPrimorial);
	
	std::cout << "Generating prime table using sieve of Eratosthenes...";
	std::vector<uint8_t> vfComposite;
	vfComposite.resize((_parameters.sieve + 7)/8, 0);
	for (uint64_t nFactor(2) ; nFactor*nFactor < _parameters.sieve ; nFactor++) {
		if (vfComposite[nFactor >> 3] & (1 << (nFactor & 7))) continue;
		for (uint64_t nComposite(nFactor*nFactor) ; nComposite < _parameters.sieve ; nComposite += nFactor)
			vfComposite[nComposite >> 3] |= 1 << (nComposite & 7);
	}
	for (uint64_t n(2) ; n < _parameters.sieve ; n++) {
		if (!(vfComposite[n >> 3] & (1 << (n & 7))))
			_parameters.primes.push_back(n);
	}
	_nPrimes = _parameters.primes.size();
	std::cout << " Done!" << std::endl << "Table with all " << _nPrimes << " first primes generated." << std::endl;
	
	mpz_init_set_ui(_primorial, _parameters.primes[0]);
	for (uint64_t i(1) ; i < _parameters.primorialNumber ; i++)
		mpz_mul_ui(_primorial, _primorial, _parameters.primes[i]);
	
	_parameters.inverts.resize(_nPrimes);
	
	mpz_t z_tmp, z_p;
	mpz_init(z_tmp);
	mpz_init(z_p);
	for (uint64_t i(5) ; i < _nPrimes ; i++) {
		mpz_set_ui(z_p, _parameters.primes[i]);
		mpz_invert(z_tmp, _primorial, z_p);
		_parameters.inverts[i] = mpz_get_ui(z_tmp);
	}
	mpz_clear(z_p);
	mpz_clear(z_tmp);
	
	uint64_t high_segment_entries(0);
	double high_floats(0.);
	_primeTestStoreOffsetsSize = 0;
	for (uint64_t i(5) ; i < _nPrimes ; i++) {
		uint64_t p(_parameters.primes[i]);
		if (p < _parameters.maxIncrements) _primeTestStoreOffsetsSize++;
		else high_floats += ((6.*_parameters.maxIncrements)/(double) p);
	}
	
	high_segment_entries = ceil(high_floats);
	if (high_segment_entries == 0) _entriesPerSegment = 1;
	else {
		_entriesPerSegment = high_segment_entries/_parameters.maxIter + 4; // Rounding up a bit
		_entriesPerSegment = (_entriesPerSegment + (_entriesPerSegment >> 3));
	}
	
	_segmentCounts.resize(_parameters.maxIter);
	for (uint64_t i(_parameters.primorialNumber) ; i < _nPrimes ; i++) {
		uint64_t p(_parameters.primes[i]);
		if (p < _parameters.denseLimit) _nDense++;
		else if (p < _parameters.maxIncrements) _nSparse++;
	}
	
	_inited = true;
}

void Miner::_putOffsetsInSegments(uint64_t *offsets, int n_offsets) {
	_bucketLock.lock();
	for (int i(0); i < n_offsets; i++) {
		uint64_t index(offsets[i]),
		         segment(index >> _parameters.sieveBits),
		         sc(_segmentCounts[segment]);
		if (sc >= _entriesPerSegment) {
			std::cerr << "Segment " << segment << " " << sc << " with index " << index << " is > " << _entriesPerSegment << std::endl;
			exit(-1);
		}
		_segmentHits[segment][sc] = index - (_parameters.sieveSize*segment);
		_segmentCounts[segment]++;
	}
	_bucketLock.unlock();
}

void Miner::_updateRemainders(uint64_t start_i, uint64_t end_i) {
	mpz_t tar;
	mpz_init(tar);
	mpz_set(tar, z_verifyTarget);
	mpz_add(tar, tar, z_verifyRemainderPrimorial);
	int n_offsets(0);
	static const int OFFSET_STACK_SIZE(16384);
	if (offset_stack == NULL)
		offset_stack = new uint64_t[OFFSET_STACK_SIZE];

	for (uint64_t i(start_i) ; i < end_i ; i++) {
		uint64_t p(_parameters.primes[i]),
		         remainder(mpz_tdiv_ui(tar, p));
		bool onceOnly(false);

		/* Also update the offsets unless once only */
		if (p >= _parameters.maxIncrements)
			onceOnly = true;
		 
		uint64_t invert(_parameters.inverts[i]);
		for (std::vector<uint64_t>::size_type f(0) ; f < _parameters.primeTupleOffset.size() ; f++) {
			remainder += _parameters.primeTupleOffset[f];
			if (remainder > p)
				remainder -= p;
			uint64_t pa(p - remainder), index(pa*invert);
			index %= p;
			if (!onceOnly)
				offsets[i][f] = index;
			else {
				if (index < _parameters.maxIncrements) {
					offset_stack[n_offsets++] = index;
					if (n_offsets >= OFFSET_STACK_SIZE) {
						_putOffsetsInSegments(offset_stack, n_offsets);
						n_offsets = 0;
					}
				}
			}
		}
	}
	if (n_offsets > 0) {
		_putOffsetsInSegments(offset_stack, n_offsets);
		n_offsets = 0;
	}
	mpz_clear(tar);
}

void Miner::_processSieve(uint8_t *sieve, uint64_t start_i, uint64_t end_i) {
	uint64_t pending[PENDING_SIZE], pending_pos(0);
	_initPending(pending);
	
	for (uint64_t i(start_i) ; i < end_i ; i++) {
		uint64_t pno(i + _startingPrimeIndex),
		         p(_parameters.primes[pno]);
		for (uint64_t f(0) ; f < 6; f++) {
			while (offsets[pno][f] < _parameters.sieveSize) {
				_addToPending(sieve, pending, pending_pos, offsets[pno][f]);
				offsets[pno][f] += p;
			}
			offsets[pno][f] -= _parameters.sieveSize;
		}
	}

	for (uint64_t i(0) ; i < PENDING_SIZE ; i++) {
		uint64_t old(pending[i]);
		if (old != 0) {
			assert(old < _parameters.sieveSize);
			sieve[old >> 3] |= (1 << (old & 7));
		}
	}
}

void Miner::_verifyThread() {
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
		auto job(_verifyWorkQueue.pop_front());
		
		if (job.type == TYPE_MOD) {
			_updateRemainders(job.modWork.start, job.modWork.end);
			_workerDoneQueue.push_back(1);
			continue;
		}
		
		if (job.type == TYPE_SIEVE) {
			_processSieve(_sieves[job.sieveWork.sieveId], job.sieveWork.start, job.sieveWork.end);
			_workerDoneQueue.push_back(1);
			continue;
		}
		// fallthrough:	job.type == TYPE_CHECK
		if (job.type == TYPE_CHECK) {
			for (uint64_t idx(0) ; idx < job.testWork.n_indexes ; idx++) {
				uint8_t tupleSize(0);
				mpz_set(z_temp, _primorial);
				mpz_mul_ui(z_temp, z_temp, job.testWork.loop*_parameters.sieveSize);
				mpz_set(z_temp2, _primorial);
				mpz_mul_ui(z_temp2, z_temp2, job.testWork.indexes[idx]);
				mpz_add(z_temp, z_temp, z_temp2);
				mpz_add(z_temp, z_temp, z_verifyRemainderPrimorial);
				mpz_add(z_temp, z_temp, z_verifyTarget);
				
				mpz_sub(z_temp2, z_temp, z_verifyTarget); // offset = tested - target
				
				mpz_sub_ui(z_ft_n, z_temp, 1);
				mpz_powm(z_ft_r, z_ft_b, z_ft_n, z_temp);
				
				if (mpz_cmp_ui(z_ft_r, 1) != 0)
					continue;
				
				tupleSize++;
				// Note start at 1 - we've already tested bias 0
				for (std::vector<uint64_t>::size_type i(1) ; i < _parameters.primeTupleOffset.size() ; i++) {
					mpz_add_ui(z_temp, z_temp, _parameters.primeTupleOffset[i]);
					mpz_sub_ui(z_ft_n, z_temp, 1);
					mpz_powm(z_ft_r, z_ft_b, z_ft_n, z_temp);
					if (mpz_cmp_ui(z_ft_r, 1) == 0) {
						tupleSize++;
						_manager->incTupleCount(tupleSize);
					}
					else if (!_parameters.solo) {
						int candidatesRemaining(5 - i);
						if ((tupleSize + candidatesRemaining) < 4) continue;
					}
					else break;
				}
				
				if (_parameters.solo) {
					if (tupleSize < _parameters.tuples) continue;
				}
				else if (tupleSize < 4) continue;
	
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
				
				_manager->submitWork(_verifyBlock, (uint32_t*) nOffset, tupleSize);
			}
			
			_testDoneQueue.push_back(1);
		}
	}
}

void Miner::_getTargetFromBlock(mpz_t z_target, const WorkData& block) {
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
	
	uint64_t difficulty(mpz_sizeinbase(z_target, 2));
	if (_manager->difficulty() != difficulty)
		_manager->updateDifficulty(difficulty, block.height);
}

void Miner::process(WorkData block) {
	if (!_masterExists) {
		_masterLock.lock();
		if (!_masterExists) {
			_masterExists = true;
			isMaster = true;
		}
		_masterLock.unlock();
	}
	
	if (!isMaster) {
		_verifyThread(); // Runs forever
		return;
	}
	
	if (riecoin_sieve == NULL) {
		try {
			// std::cout << "Allocating " << _parameters.sieveSize/8 << " bytes for riecoin_sieve..." << std::endl;
			riecoin_sieve = new uint8_t[_parameters.sieveSize/8];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for riecoin_sieve :|..." << std::endl;
			exit(-1);
		}
		
		try {
			// std::cout << "Allocating " << _parameters.sieveWorkers << " bytes for the sieves..." << std::endl;
			_sieves = new uint8_t*[_parameters.sieveWorkers];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the sieves :|..." << std::endl;
			exit(-1);
		}
		
		try {
			// std::cout << "Allocating " << _parameters.sieveSize/8*_parameters.sieveWorkers << " bytes for the sieves..." << std::endl;
			for (int i(0) ; i < _parameters.sieveWorkers; i++)
				_sieves[i] = new uint8_t[_parameters.sieveSize/8];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the miner.sieves :|..." << std::endl;
			exit(-1);
		}
		
		try {
			// std::cout << "Allocating " << 6*4*(_primeTestStoreOffsetsSize + 1024) << " bytes for the offsets..." << std::endl;
			offsets = new sixoff[_primeTestStoreOffsetsSize + 1024];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the offsets :|..." << std::endl;
			exit(-1);
		}
		
		memset(offsets, 0, sizeof(sixoff)*(_primeTestStoreOffsetsSize + 1024));
		
		try {
			// std::cout << "Allocating " << 4*_parameters.maxIter*_entriesPerSegment<< " bytes for the _segmentHits..." << std::endl;
			_segmentHits = new uint32_t*[_parameters.maxIter];
			for (uint64_t i(0); i < _parameters.maxIter; i++)
				_segmentHits[i] = new uint32_t[_entriesPerSegment];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the _segmentHits :|..." << std::endl;
			exit(-1);
		}
	}
	uint8_t* sieve(riecoin_sieve);
	
	mpz_t z_target, z_temp, z_remainderPrimorial;
	
	mpz_init(z_temp);
	mpz_init(z_remainderPrimorial);
	
	_getTargetFromBlock(z_target, block);
	// find first offset where target%primorial = _parameters.primorialOffset
	mpz_tdiv_r(z_remainderPrimorial, z_target, _primorial);
	mpz_abs(z_remainderPrimorial, z_remainderPrimorial);
	mpz_sub(z_remainderPrimorial, _primorial, z_remainderPrimorial);
	mpz_tdiv_r(z_remainderPrimorial, z_remainderPrimorial, _primorial);
	mpz_abs(z_remainderPrimorial, z_remainderPrimorial);
	mpz_add_ui(z_remainderPrimorial, z_remainderPrimorial, _parameters.primorialOffset);
	mpz_add(z_temp, z_target, z_remainderPrimorial);
	const uint64_t primeIndex = _parameters.primorialNumber;
	
	_startingPrimeIndex = primeIndex;
	mpz_set(z_verifyTarget, z_target);
	mpz_set(z_verifyRemainderPrimorial, z_remainderPrimorial);
	_verifyBlock = block;
	
	for (uint64_t i(0) ; i < _parameters.maxIter; i++) _segmentCounts[i] = 0;
	
	uint64_t incr(_nPrimes/128);
	primeTestWork wi;
	wi.type = TYPE_MOD;
	int n_workers(0);
	for (auto base(primeIndex) ; base < _nPrimes ; base += incr) {
		uint64_t lim(std::min(_nPrimes, base+incr));
		wi.modWork.start = base;
		wi.modWork.end = lim;
		_verifyWorkQueue.push_back(wi);
		n_workers++;
	}
	for (int i(0) ; i < n_workers ; i++) _workerDoneQueue.pop_front();
	
	/* Main processing loop:
	 * 1)	Sieve "dense" primes;
	 * 2)	Sieve "sparse" primes;
	 * 3)	Sieve "so sparse they happen at most once" primes;
	 * 4)	Scan sieve for candidates, test, report
	 */

	uint64_t countCandidates = 0;
	uint64_t outstandingTests = 0;
	for (uint64_t loop(0); loop < _parameters.maxIter; loop++) {
		__sync_synchronize(); // gcc specific - memory barrier for checking height
		if (block.height != _currentHeight)
			break;
		
		for (int i(0) ; i < _parameters.sieveWorkers ; i++)
			memset(_sieves[i], 0, _parameters.sieveSize/8);
		
		wi.type = TYPE_SIEVE;
		n_workers = 0;
		incr = ((_nSparse)/_parameters.sieveWorkers) + 1;
		int which_sieve(0);
		for (uint64_t base(_nDense) ; base < (_nDense + _nSparse) ; base += incr) {
			uint64_t lim(std::min(_nDense + _nSparse,
			                      base + incr));
			if (lim + 1000 > _nDense + _nSparse)
				lim = (_nDense+_nSparse);
			wi.sieveWork.start = base;
			wi.sieveWork.end = lim;
			wi.sieveWork.sieveId = which_sieve;
			// Need to do something for thread to sieve affinity
			_verifyWorkQueue.push_front(wi);
			which_sieve++;
			which_sieve %= _parameters.sieveWorkers;
			n_workers++;
			if (lim + 1000 > _nDense + _nSparse)
				break;
		}

		memset(sieve, 0, _parameters.sieveSize/8);
		
		for (uint64_t i(0) ; i < _nDense ; i++) {
			uint64_t pno(i + _startingPrimeIndex);
			_sortIndexes(offsets[pno]);
			uint64_t p(_parameters.primes[pno]);
			for (uint64_t f(0) ; f < 6 ; f++) {
				while (offsets[pno][f] < _parameters.sieveSize) {
					assert(offsets[pno][f] < _parameters.sieveSize);
					sieve[offsets[pno][f] >> 3] |= (1 << ((offsets[pno][f] & 7)));
					offsets[pno][f] += p;
				}
				offsets[pno][f] -= _parameters.sieveSize;
			}
		}
		
		outstandingTests -= _testDoneQueue.clear();
		for (int32_t i(0) ; i < n_workers; i++)
			_workerDoneQueue.pop_front();
		
		for (uint64_t i(0) ; i < _parameters.sieveWords ; i++) {
			for (int j(0) ; j < _parameters.sieveWorkers; j++) {
				((uint64_t*) sieve)[i] |= ((uint64_t*) (_sieves[j]))[i];
			}
		}
		
		uint64_t pending[PENDING_SIZE];
		_initPending(pending);
		uint64_t pending_pos = 0;
		for (uint64_t i(0) ; i < _segmentCounts[loop] ; i++)
			_addToPending(sieve, pending, pending_pos, _segmentHits[loop][i]);

		for (uint64_t i = 0; i < PENDING_SIZE; i++) {
			uint64_t old = pending[i];
			if (old != 0) {
				assert(old < _parameters.sieveSize);
				sieve[old >> 3] |= (1 << (old & 7));
			}
		}
		
		primeTestWork w;
		w.testWork.n_indexes = 0;
		w.testWork.loop = loop;
		w.type = TYPE_CHECK;

		bool reset(false);
		uint64_t *sieve64 = (uint64_t*) sieve;
		for(uint64_t b(0) ; !reset && b < _parameters.sieveWords ; b++) {
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
				outstandingTests -= _testDoneQueue.clear();
				
				if (w.testWork.n_indexes == WORK_INDEXES) {
					_verifyWorkQueue.push_back(w);
					w.testWork.n_indexes = 0;
					outstandingTests++;
				}
				outstandingTests -= _testDoneQueue.clear();
				// Low overhead but still often enough
				if (block.height != _currentHeight) {
					outstandingTests -= _verifyWorkQueue.clear();
					reset = true;
					break;
				}
			}
		}

		if (w.testWork.n_indexes > 0) {
			_verifyWorkQueue.push_back(w);
			outstandingTests++;
			w.testWork.n_indexes = 0;
		}
	}
	
	outstandingTests -= _testDoneQueue.clear();
	
	while (outstandingTests > 0) {
		_testDoneQueue.pop_front();
		outstandingTests--;
		if (block.height != _currentHeight)
			outstandingTests -= _verifyWorkQueue.clear();
	}
	
	mpz_clears(z_target, z_temp, z_remainderPrimorial, NULL);
}
