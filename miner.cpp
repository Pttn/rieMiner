/* (c) 2014-2017 dave-andersen (base code) (http://www.cs.cmu.edu/~dga/)
(c) 2017-2018 Pttn (refactoring and porting to modern C++) (https://ric.pttn.me/)
(c) 2018 Michael Bell/Rockhawk (assembly optimizations and some more) (https://github.com/MichaelBell/) */

#include "miner.h"

thread_local bool isMaster(false);
thread_local uint64_t *offset_stack(NULL);

thread_local uint8_t* riecoin_sieve(NULL);
uint32_t *offsets(NULL);

#define	zeroesBeforeHashInPrime	8

void Miner::init() {
	_parameters.threads = _manager->options().threads();
	_parameters.sieveWorkers = std::max(1, _manager->options().threads()/4);
	_parameters.sieveWorkers = std::min(_parameters.sieveWorkers, 8);
	_parameters.solo = !(_manager->options().protocol() == "Stratum");
	_parameters.tuples = _manager->options().tuples();
	_parameters.sieve = _manager->options().sieve();
	_parameters.primorialNumber  = _manager->options().pn();
	_parameters.primorialOffset  = _manager->options().pOff();
	_parameters.primeTupleOffset = _manager->options().consType();
	
	mpz_init(z_verifyTarget);
	mpz_init(z_verifyRemainderPrimorial);

	// For larger ranges of offsets, need to add more inverts in _updateRemainders().
	std::transform(_parameters.primeTupleOffset.begin(), _parameters.primeTupleOffset.end(), std::back_inserter(_halfPrimeTupleOffset),
	               [](uint64_t n) { assert(n <= 6); return n >> 1; });
	
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
	
	uint64_t highSegmentEntries(0);
	double highFloats(0.);
	double tupleSizeAsDouble(_parameters.primeTupleOffset.size());
	_primeTestStoreOffsetsSize = 0;
	for (uint64_t i(5) ; i < _nPrimes ; i++) {
		uint64_t p(_parameters.primes[i]);
		if (p < _parameters.maxIncrements) _primeTestStoreOffsetsSize++;
		else highFloats += ((tupleSizeAsDouble*_parameters.maxIncrements)/(double) p);
	}
	
	highSegmentEntries = ceil(highFloats);
	if (highSegmentEntries == 0) _entriesPerSegment = 1;
	else {
		_entriesPerSegment = highSegmentEntries/_parameters.maxIter + 4; // Rounding up a bit
		_entriesPerSegment = (_entriesPerSegment + (_entriesPerSegment >> 3));
	}
	
	_segmentCounts.resize(_parameters.maxIter);
	for (uint64_t i(_parameters.primorialNumber) ; i < _nPrimes ; i++) {
		uint64_t p(_parameters.primes[i]);
		if (p < _parameters.denseLimit) _nDense++;
		else if (p < _parameters.maxIncrements) _nSparse++;
		else break;
	}

	uint64_t round(8 - ((_nDense + _parameters.primorialNumber) & 0x7));
	_nDense += round;
	_nSparse -= round;
	if ((_nSparse - _nDense) & 1) {
		if (_nSparse + _nDense + _parameters.primorialNumber < _nPrimes) _nSparse += 1;
		else _nSparse -= 1;
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
		_segmentHits[segment][sc] = index & (_parameters.sieveSize - 1);
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
	const uint64_t tupleSize(_parameters.primeTupleOffset.size());
	if (offset_stack == NULL)
		offset_stack = new uint64_t[OFFSET_STACK_SIZE];

	for (uint64_t i(start_i) ; i < end_i ; i++) {
		uint64_t p(_parameters.primes[i]),
		         remainder(mpz_tdiv_ui(tar, p));
		bool onceOnly(false);

		/* Also update the offsets unless once only */
		if (p >= _parameters.maxIncrements)
			onceOnly = true;
		 
		// Note the multiplication will overflow for p > 2^32 - relatively easy to fix on x64.
		assert(p < 0x100000000ULL);
		uint64_t invert[4];
		invert[0] = _parameters.inverts[i];
		uint64_t pa(p - remainder),
		         index(pa*invert[0]);
		index %= p;
		invert[1] = (invert[0] << 1);
		if (invert[1] > p) invert[1] -= p;
		invert[2] = invert[1] << 1;
		if (invert[2] > p) invert[2] -= p;
		invert[3] = invert[1] + invert[2];
		if (invert[3] > p) invert[3] -= p;

		if (!onceOnly) {
			offsets[tupleSize*i + 0] = index;
			for (std::vector<uint64_t>::size_type f(1) ; f < _halfPrimeTupleOffset.size() ; f++) {
				if (index < invert[_halfPrimeTupleOffset[f]]) index += p;
				index -= invert[_halfPrimeTupleOffset[f]];
				offsets[tupleSize*i + f] = index;
			}
		}
		else {
			if (n_offsets + _halfPrimeTupleOffset.size() >= OFFSET_STACK_SIZE) {
				_putOffsetsInSegments(offset_stack, n_offsets);
				n_offsets = 0;
			}
			if (index < _parameters.maxIncrements) offset_stack[n_offsets++] = index;
			for (std::vector<uint64_t>::size_type f(1) ; f < _halfPrimeTupleOffset.size() ; f++) {
				if (index < invert[_halfPrimeTupleOffset[f]]) index += p;
				index -= invert[_halfPrimeTupleOffset[f]];
				if (index < _parameters.maxIncrements) offset_stack[n_offsets++] = index;
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
	const uint64_t tupleSize(_parameters.primeTupleOffset.size());
	uint32_t pending[PENDING_SIZE];
	uint64_t pending_pos(0);
	_initPending(pending);

	for (uint64_t i(start_i) ; i < end_i ; i++) {
		uint32_t p(_parameters.primes[i]);
		for (uint64_t f(0) ; f < tupleSize; f++) {
			while (offsets[i*tupleSize + f] < _parameters.sieveSize) {
				_addToPending(sieve, pending, pending_pos, offsets[i*tupleSize + f]);
				offsets[i*tupleSize + f] += p;
			}
			offsets[i*tupleSize + f] -= _parameters.sieveSize;
		}
	}

	_termPending(sieve, pending);
}

void Miner::_processSieve6(uint8_t *sieve, uint64_t start_i, uint64_t end_i) {
	assert(_parameters.primeTupleOffset.size() == 6);
	uint32_t pending[PENDING_SIZE];
	uint64_t pending_pos(0);
	_initPending(pending);

	xmmreg_t offsetmax;
	offsetmax.m128 = _mm_set1_epi32(_parameters.sieveSize);
	
	assert((start_i & 1) == 0);
	assert((end_i & 1) == 0);

	for (uint64_t i(start_i) ; i < end_i ; i += 2) {
		xmmreg_t p1, p2, p3;
		xmmreg_t offset1, offset2, offset3, nextIncr1, nextIncr2, nextIncr3;
		xmmreg_t cmpres1, cmpres2, cmpres3;
		p1.m128 = _mm_set1_epi32(_parameters.primes[i]);
		p3.m128 = _mm_set1_epi32(_parameters.primes[i+1]);
		p2.m128 = _mm_castps_si128(_mm_shuffle_ps(_mm_castsi128_ps(p1.m128), _mm_castsi128_ps(p3.m128), _MM_SHUFFLE(0, 0, 0, 0)));
		offset1.m128 = _mm_load_si128((__m128i const*) &offsets[i*6 + 0]);
		offset2.m128 = _mm_load_si128((__m128i const*) &offsets[i*6 + 4]);
		offset3.m128 = _mm_load_si128((__m128i const*) &offsets[i*6 + 8]);
		while (true) {
			cmpres1.m128 = _mm_cmpgt_epi32(offsetmax.m128, offset1.m128);
			cmpres2.m128 = _mm_cmpgt_epi32(offsetmax.m128, offset2.m128);
			cmpres3.m128 = _mm_cmpgt_epi32(offsetmax.m128, offset3.m128);
			int mask1 = _mm_movemask_epi8(cmpres1.m128);
			int mask2 = _mm_movemask_epi8(cmpres2.m128);
			int mask3 = _mm_movemask_epi8(cmpres3.m128);
			if ((mask1 == 0) && (mask2 == 0) && (mask3 == 0)) break;
			_addRegToPending(sieve, pending, pending_pos, offset1, mask1);
			_addRegToPending(sieve, pending, pending_pos, offset2, mask2);
			_addRegToPending(sieve, pending, pending_pos, offset3, mask3);
			nextIncr1.m128 = _mm_and_si128(cmpres1.m128, p1.m128);
			nextIncr2.m128 = _mm_and_si128(cmpres2.m128, p2.m128);
			nextIncr3.m128 = _mm_and_si128(cmpres3.m128, p3.m128);
			offset1.m128 = _mm_add_epi32(offset1.m128, nextIncr1.m128);
			offset2.m128 = _mm_add_epi32(offset2.m128, nextIncr2.m128);
			offset3.m128 = _mm_add_epi32(offset3.m128, nextIncr3.m128);
		}
		offset1.m128 = _mm_sub_epi32(offset1.m128, offsetmax.m128);
		offset2.m128 = _mm_sub_epi32(offset2.m128, offsetmax.m128);
		offset3.m128 = _mm_sub_epi32(offset3.m128, offsetmax.m128);
		_mm_store_si128((__m128i*)&offsets[i*6 + 0], offset1.m128);
		_mm_store_si128((__m128i*)&offsets[i*6 + 4], offset2.m128);
		_mm_store_si128((__m128i*)&offsets[i*6 + 8], offset3.m128);
	}

	_termPending(sieve, pending);
}

void Miner::_verifyThread() {
	/* Check for a prime cluster.
	 * Uses the fermat test - jh's code noted that it is slightly faster.
	 * Could do an MR test as a follow-up, but the server can do this too
	 * for the one-in-a-whatever case that Fermat is wrong.
	 */
	mpz_t z_ft_r, z_ft_b, z_ft_n;
	mpz_t z_temp, z_temp2;
	mpz_t z_ploop;
	
	mpz_init(z_ft_r);
	mpz_init_set_ui(z_ft_b, 2);
	mpz_init(z_ft_n);
	mpz_init(z_temp);
	mpz_init(z_temp2);
	mpz_init(z_ploop);

	while (true) {
		auto job(_verifyWorkQueue.pop_front());
		
		if (job.type == TYPE_MOD) {
			_updateRemainders(job.modWork.start, job.modWork.end);
			_workerDoneQueue.push_back(1);
			continue;
		}
		
		if (job.type == TYPE_SIEVE) {
			if (_parameters.primeTupleOffset.size() == 6)
				_processSieve6(_sieves[job.sieveWork.sieveId], job.sieveWork.start, job.sieveWork.end);
			else
				_processSieve(_sieves[job.sieveWork.sieveId], job.sieveWork.start, job.sieveWork.end);
			_workerDoneQueue.push_back(1);
			continue;
		}
		// fallthrough:	job.type == TYPE_CHECK
		if (job.type == TYPE_CHECK) {
			mpz_mul_ui(z_ploop, _primorial, job.testWork.loop*_parameters.sieveSize);
			mpz_add(z_ploop, z_ploop, z_verifyRemainderPrimorial);
			mpz_add(z_ploop, z_ploop, z_verifyTarget);

			for (uint64_t idx(0) ; idx < job.testWork.n_indexes ; idx++) {
				uint8_t tupleSize(0);
				mpz_mul_ui(z_temp, _primorial, job.testWork.indexes[idx]);
				mpz_add(z_temp, z_temp, z_ploop);
				
				mpz_sub_ui(z_ft_n, z_temp, 1);
				mpz_powm(z_ft_r, z_ft_b, z_ft_n, z_temp);
				
				if (mpz_cmp_ui(z_ft_r, 1) != 0) continue;

				mpz_sub(z_temp2, z_temp, z_verifyTarget); // offset = tested - target
				
				tupleSize++;
				_manager->incTupleCount(tupleSize);
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

void Miner::_getTargetFromBlock(mpz_t z_target, const WorkData &block) {
	std::vector<uint8_t> powHash(sha256sha256((uint8_t*) &block, 80));
	
	mpz_init_set_ui(z_target, 1);
	mpz_mul_2exp(z_target, z_target, zeroesBeforeHashInPrime);
	for (uint64_t i(0) ; i < 256 ; i++) {
		mpz_mul_2exp(z_target, z_target, 1);
		if ((powHash[i/8] >> (i % 8)) & 1)
			z_target->_mp_d[0]++;
	}
	
	uint64_t searchBits(block.targetCompact);
	uint64_t trailingZeros(searchBits - 1 - zeroesBeforeHashInPrime - 256);
	mpz_mul_2exp(z_target, z_target, trailingZeros);
	
	uint64_t difficulty(mpz_sizeinbase(z_target, 2));
	if (_manager->difficulty() != difficulty) {
		bool save(true);
		if (_manager->difficulty() == 1) save = false;
		_manager->updateDifficulty(difficulty, block.height);
		if (save) _manager->saveTuplesCounts();
	}
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
			offsets = new uint32_t[(_primeTestStoreOffsetsSize + 1024)*_parameters.primeTupleOffset.size()];
		}
		catch (std::bad_alloc& ba) {
			std::cerr << "Unable to allocate memory for the offsets :|..." << std::endl;
			exit(-1);
		}
		
		memset(offsets, 0, sizeof(uint32_t)*_parameters.primeTupleOffset.size()*(_primeTestStoreOffsetsSize + 1024));
		
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
	uint8_t *sieve(riecoin_sieve);
	
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

	uint64_t outstandingTests = 0;
	for (uint64_t loop(0); loop < _parameters.maxIter; loop++) {
		__sync_synchronize(); // gcc specific - memory barrier for checking height
		if (block.height != _currentHeight)
			break;
		
		for (int i(0) ; i < _parameters.sieveWorkers ; i++)
			memset(_sieves[i], 0, _parameters.sieveSize/8);
		
		wi.type = TYPE_SIEVE;
		n_workers = 0;
		incr = (_nSparse/_parameters.sieveWorkers);
		uint64_t round(8 - (incr & 0x7));
		incr += round;
		int which_sieve(0);
		for (uint64_t base(_nDense) ; base < (_nDense + _nSparse) ; base += incr) {
			uint64_t lim(std::min(_nDense + _nSparse,
			                      base + incr));
			if (lim + 1000 > _nDense + _nSparse)
				lim = (_nDense+_nSparse);
			wi.sieveWork.start = base + _startingPrimeIndex;
			wi.sieveWork.end = lim + _startingPrimeIndex;
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
		
		const uint64_t tupleSize(_parameters.primeTupleOffset.size());
		for (uint64_t i(0) ; i < _nDense ; i++) {
			uint64_t pno(i + _startingPrimeIndex);
			uint32_t p(_parameters.primes[pno]);
			for (uint64_t f(0) ; f < tupleSize ; f++) {
				while (offsets[pno*tupleSize + f] < _parameters.sieveSize) {
					sieve[offsets[pno*tupleSize + f] >> 3] |= (1 << ((offsets[pno*tupleSize + f] & 7)));
					offsets[pno*tupleSize + f] += p;
				}
				offsets[pno*tupleSize + f] -= _parameters.sieveSize;
			}
		}
		
		outstandingTests -= _testDoneQueue.clear();
		for (int32_t i(0) ; i < n_workers; i++)
			_workerDoneQueue.pop_front();
		
		__m128i *sp128 = (__m128i*) sieve;
		for (uint64_t i(0) ; i < _parameters.sieveWords/2 ; i++) {
			__m128i s128;
			s128 = _mm_load_si128(&sp128[i]);
			for (int j(0) ; j < _parameters.sieveWorkers; j++) {
				__m128i ws128;
				ws128 = _mm_load_si128(&((__m128i*) (_sieves[j]))[i]);
				s128 = _mm_or_si128(s128, ws128);
			}
			_mm_store_si128(&sp128[i], s128);
		}
		
		uint32_t pending[PENDING_SIZE];
		_initPending(pending);
		uint64_t pending_pos(0);
		for (uint64_t i(0) ; i < _segmentCounts[loop] ; i++)
			_addToPending(sieve, pending, pending_pos, _segmentHits[loop][i]);

		_termPending(sieve, pending);
		
		primeTestWork w;
		w.testWork.n_indexes = 0;
		w.testWork.loop = loop;
		w.type = TYPE_CHECK;

		bool reset(false);
		uint64_t *sieve64 = (uint64_t*) sieve;
		for(uint32_t b(0) ; !reset && b < _parameters.sieveWords ; b++) {
			uint64_t sb(~sieve64[b]);
			
			while (sb != 0) {
				uint32_t lowsb(__builtin_ctzll(sb));
				uint32_t i((b*64) + lowsb);
				sb &= sb - 1;
				
				w.testWork.indexes[w.testWork.n_indexes] = i;
				w.testWork.n_indexes++;
				outstandingTests -= _testDoneQueue.clear();
				
				if (w.testWork.n_indexes == WORK_INDEXES) {
					// Low overhead but still often enough
					if (block.height != _currentHeight) {
						outstandingTests -= _verifyWorkQueue.clear();
						reset = true;
						break;
					}

					_verifyWorkQueue.push_back(w);
					w.testWork.n_indexes = 0;
					outstandingTests++;
					outstandingTests -= _testDoneQueue.clear();
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
