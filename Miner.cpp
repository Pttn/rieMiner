/* (c) 2014-2017 dave-andersen (base code) (http://www.cs.cmu.edu/~dga/)
(c) 2017-2018 Pttn (refactoring and porting to modern C++) (https://ric.pttn.me/)
(c) 2018 Michael Bell/Rockhawk (assembly optimizations, improvements of work management between threads, and some more) (https://github.com/MichaelBell/) */

#include "Miner.hpp"

thread_local bool isMaster(false);
thread_local uint64_t** offsetStack(NULL);
thread_local uint64_t** offsetCount(NULL);

#define MAX_SIEVE_WORKERS 16
#define	zeroesBeforeHashInPrime	8

void Miner::init() {
	_parameters.threads = _manager->options().threads();
	_parameters.primorialOffsets = _manager->options().primorialOffsets();
	_parameters.sieveWorkers = _manager->options().sieveWorkers();
	if (_parameters.sieveWorkers == 0) {
		_parameters.sieveWorkers = std::max(_manager->options().threads()/5, 1);
		_parameters.sieveWorkers += (_manager->options().primeTableLimit() + 0x80000000ull) >> 33;
	}
	_parameters.sieveWorkers = std::min(_parameters.sieveWorkers, MAX_SIEVE_WORKERS);
	_parameters.sieveWorkers = std::min(_parameters.sieveWorkers, int(_parameters.primorialOffsets.size()));
	std::cout << "Sieve Workers = " << _parameters.sieveWorkers << std::endl;
	_parameters.sieveBits = _manager->options().sieveBits();
	_parameters.sieveSize = 1 << _parameters.sieveBits;
	_parameters.sieveWords = _parameters.sieveSize/64;
	_parameters.maxIter = _parameters.maxIncrements/_parameters.sieveSize;
	_parameters.solo = !(_manager->options().mode() == "Pool");
	_parameters.tupleLengthMin = _manager->options().tupleLengthMin();
	_parameters.sieve = _manager->options().primeTableLimit();
	_parameters.primorialNumber  = _manager->options().primorialNumber();
	_parameters.primeTupleOffset = _manager->options().constellationType();
	
	for (uint32_t i(0) ; i < WORK_DATAS ; i++) {
		mpz_init(_workData[i].z_verifyTarget);
		mpz_init(_workData[i].z_verifyRemainderPrimorial);
	}

	// For larger ranges of offsets, need to add more inverts in _updateRemainders().
	std::transform(_parameters.primeTupleOffset.begin(),
	               _parameters.primeTupleOffset.end(),
	               std::back_inserter(_halfPrimeTupleOffset),
	               [](uint64_t n) {/*assert(n <= 6); */return n >> 1;});
	_primorialOffsetDiff.resize(_parameters.sieveWorkers - 1);
	_primorialOffsetDiffToFirst.resize(_parameters.sieveWorkers);
	_primorialOffsetDiffToFirst[0] = 0;
	const uint64_t tupleSpan(std::accumulate(_parameters.primeTupleOffset.begin(), _parameters.primeTupleOffset.end(), 0));
	for (int j(1) ; j < _parameters.sieveWorkers ; j++) {
		_primorialOffsetDiff[j - 1] = _parameters.primorialOffsets[j] - _parameters.primorialOffsets[j - 1] - tupleSpan;
		_primorialOffsetDiffToFirst[j] = _parameters.primorialOffsets[j] - _parameters.primorialOffsets[0];
	}
	
	{
		std::cout << "Generating prime table using sieve of Eratosthenes..." << std::endl;
		std::vector<uint8_t> vfComposite;
		vfComposite.resize((_parameters.sieve + 15)/16, 0);
		for (uint64_t nFactor(3) ; nFactor*nFactor < _parameters.sieve ; nFactor += 2) {
			if (vfComposite[nFactor >> 4] & (1 << ((nFactor >> 1) & 7))) continue;
			for (uint64_t nComposite((nFactor*nFactor) >> 1) ; nComposite < (_parameters.sieve >> 1) ; nComposite += nFactor)
				vfComposite[nComposite >> 3] |= 1 << (nComposite & 7);
		}
		_parameters.primes.push_back(2);
		for (uint64_t n(1) ; (n << 1) + 1 < _parameters.sieve ; n++) {
			if (!(vfComposite[n >> 3] & (1 << (n & 7))))
				_parameters.primes.push_back((n << 1) + 1);
		}
		_nPrimes = _parameters.primes.size();
		std::cout << "Table with all " << _nPrimes << " first primes generated." << std::endl;
	}
	
	mpz_init_set_ui(_primorial, _parameters.primes[0]);
	for (uint64_t i(1) ; i < _parameters.primorialNumber ; i++)
		mpz_mul_ui(_primorial, _primorial, _parameters.primes[i]);
	
	// Estimate memory usage
	const uint64_t primeMult(16 + 8*_parameters.sieveWorkers),
	               memUsage(128ULL*1048576ULL + 650ULL*1048576ULL*_parameters.sieveWorkers + _nPrimes*primeMult);
	
	std::cout << "Estimated memory usage: ";
	if (memUsage < 1073741824) std::cout << "< 1024 MiB" << std::endl;
	else std::cout << ((float) memUsage)/1048576. << " MiB" << std::endl;
	std::cout << "Reduce prime table limit to lower this, if needed." << std::endl;
	_parameters.inverts.resize(_nPrimes);
	
	_startingPrimeIndex = _parameters.primorialNumber;
	const uint64_t blockSize((_nPrimes - _startingPrimeIndex + _parameters.threads - 1)/_parameters.threads);
	std::thread threads[_parameters.threads];
	for (int16_t j(0) ; j < _parameters.threads ; j++) {
		threads[j] = std::thread([&, j]() {
			mpz_t z_tmp, z_p;
			mpz_init(z_tmp);
			mpz_init(z_p);
			const uint64_t endIndex(std::min(_startingPrimeIndex + (j + 1)*blockSize, _nPrimes));
			for (uint64_t i(_startingPrimeIndex + j*blockSize) ; i < endIndex ; i++) {
				mpz_set_ui(z_p, _parameters.primes[i]);
				mpz_invert(z_tmp, _primorial, z_p);
				_parameters.inverts[i] = mpz_get_ui(z_tmp);
			}
			mpz_clear(z_p);
			mpz_clear(z_tmp);
		});
	}
	for (int16_t j(0) ; j < _parameters.threads ; j++) threads[j].join();
	
	uint64_t highSegmentEntries(0);
	double highFloats(0.), tupleSizeAsDouble(_parameters.primeTupleOffset.size());
	_primeTestStoreOffsetsSize = 0;
	_sparseLimit = 0;
	for (uint64_t i(5) ; i < _nPrimes ; i++) {
		const uint64_t p(_parameters.primes[i]);
		if (p < _parameters.maxIncrements) _primeTestStoreOffsetsSize++;
		else {
			if (_sparseLimit == 0) _sparseLimit = i & (~1ull);
			highFloats += ((tupleSizeAsDouble*_parameters.maxIncrements)/(double) p);
		}
	}
	if (_sparseLimit == 0) {
		_nPrimes &= (~1ull);
		_sparseLimit = _nPrimes;
	}
	
	highSegmentEntries = ceil(highFloats);
	if (highSegmentEntries == 0) _entriesPerSegment = 1;
	else {
		_entriesPerSegment = highSegmentEntries/_parameters.maxIter + 4; // Rounding up a bit
		_entriesPerSegment = (_entriesPerSegment + (_entriesPerSegment >> 3));
	}
	
	try {
		_sieves = new SieveInstance[_parameters.sieveWorkers];
		for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
			_sieves[i].id = i;
			_sieves[i].segmentCounts = new std::atomic<uint64_t>[_parameters.maxIter];
		}

		DBG(std::cout << "Allocating " << _parameters.sieveSize/8*_parameters.sieveWorkers << " bytes for the sieves..." << std::endl;);
		for (int i(0) ; i < _parameters.sieveWorkers ; i++)
			_sieves[i].sieve = new uint8_t[_parameters.sieveSize/8];
	}
	catch (std::bad_alloc& ba) {
		std::cerr << __func__ << ": unable to allocate memory for the miner.sieves :|..." << std::endl;
		exit(-1);
	}

	try {
		DBG(std::cout << "Allocating " << _parameters.primeTupleOffset.size()*4*(_primeTestStoreOffsetsSize + 1024) << " bytes for the offsets..." << std::endl;);
		for (int i(0) ; i < _parameters.sieveWorkers ; i++)
			_sieves[i].offsets = new uint32_t[(_primeTestStoreOffsetsSize + 1024)*_parameters.primeTupleOffset.size()];
	}
	catch (std::bad_alloc& ba) {
		std::cerr << __func__ << ": unable to allocate memory for the offsets :|..." << std::endl;
		exit(-1);
	}

	for (int i(0) ; i < _parameters.sieveWorkers ; i++)
		memset(_sieves[i].offsets, 0, sizeof(uint32_t)*_parameters.primeTupleOffset.size()*(_primeTestStoreOffsetsSize + 1024));

	try {
		DBG(std::cout << "Allocating " << 4*_parameters.maxIter*_entriesPerSegment << " bytes for the segment hits..." << std::endl;);
		for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
			_sieves[i].segmentHits = new uint32_t*[_parameters.maxIter];
			for (uint64_t j(0); j < _parameters.maxIter; j++)
				_sieves[i].segmentHits[j] = new uint32_t[_entriesPerSegment];
		}
	}
	catch (std::bad_alloc& ba) {
		std::cerr << __func__ << ": unable to allocate memory for the segment hits :|..." << std::endl;
		exit(-1);
	}

	// Initial guess at a value for maxWorkOut
	_maxWorkOut = std::min(_parameters.threads*32u*_parameters.sieveWorkers, _workDoneQueue.size() - 256);
	
	_inited = true;
}

void Miner::_putOffsetsInSegments(SieveInstance& sieve, uint64_t *offsets, uint64_t* counts, int n_offsets) {
	for (uint64_t segment(0) ; segment < _parameters.maxIter ; segment++) {
		const uint64_t curSegmentCount(sieve.segmentCounts[segment].fetch_add(counts[segment])),
		               sc(curSegmentCount + counts[segment]);
		if (sc >= _entriesPerSegment) {
			std::cerr << __func__ << ": segment " << segment << " " << sc << " count is > " << _entriesPerSegment << std::endl;
			abort();
		}
		counts[segment] = curSegmentCount;
	}
	for (int i(0) ; i < n_offsets ; i++) {
		const uint64_t index(offsets[i]),
		               segment(index >> _parameters.sieveBits),
		               sc(counts[segment]);
		sieve.segmentHits[segment][sc] = index & (_parameters.sieveSize - 1);
		counts[segment]++;
	}
	for (uint64_t segment(0); segment < _parameters.maxIter; segment++)
		counts[segment] = 0;
}

void Miner::_updateRemainders(uint32_t workDataIndex, uint64_t start_i, uint64_t end_i) {
	mpz_t tar;
	mpz_init(tar);
	mpz_set(tar, _workData[workDataIndex].z_verifyTarget);
	mpz_add(tar, tar, _workData[workDataIndex].z_verifyRemainderPrimorial);
	int n_offsets[MAX_SIEVE_WORKERS] = {0};
	static const int OFFSET_STACK_SIZE(16384);
	const uint64_t tupleSize(_parameters.primeTupleOffset.size());
	if (offsetStack == NULL) {
		offsetStack = new uint64_t*[MAX_SIEVE_WORKERS];
		offsetCount = new uint64_t*[MAX_SIEVE_WORKERS];
		for (int i(0) ; i < _parameters.sieveWorkers ; ++i) {
			offsetStack[i] = new uint64_t[OFFSET_STACK_SIZE];
			offsetCount[i] = new uint64_t[_parameters.maxIter];
			for (uint64_t segment(0) ; segment < _parameters.maxIter ; segment++)
				offsetCount[i][segment] = 0;
		}
	}

	// On Windows, caching these thread_local pointers on the stack makes a noticeable perf difference.
	uint64_t **offsets(offsetStack), **counts(offsetCount);
	for (uint64_t i(start_i) ; i < end_i ; i++) {
		const uint64_t p(_parameters.primes[i]);

		// Also update the offsets unless once only
		const bool onceOnly(i >= _sparseLimit);

		uint64_t invert[4];
		invert[0] = _parameters.inverts[i];
		
		const uint64_t remainder(mpz_tdiv_ui(tar, p)), pa(p - remainder);
		uint64_t index(pa*invert[0]);
		index %= p;

		invert[1] = (invert[0] << 1);
		if (invert[1] >= p) invert[1] -= p;
		invert[2] = invert[1] << 1;
		if (invert[2] >= p) invert[2] -= p;
		invert[3] = invert[1] + invert[2];
		if (invert[3] >= p) invert[3] -= p;

		// We use a macro here to ensure the compiler inlines the code, and also make it easier to early
		// out of the function completely if the current height has changed.
#define addToOffsets(j) { \
			if (!onceOnly) { \
				uint32_t* offsets = &_sieves[j].offsets[tupleSize*i]; \
				offsets[0] = index; \
				for (std::vector<uint64_t>::size_type f(1) ; f < _halfPrimeTupleOffset.size() ; f++) { \
					if (index < invert[_halfPrimeTupleOffset[f]]) index += p; \
					index -= invert[_halfPrimeTupleOffset[f]]; \
					offsets[f] = index; \
				} \
			} \
			else { \
				if (n_offsets[j] + _halfPrimeTupleOffset.size() >= OFFSET_STACK_SIZE) { \
					if (_workData[workDataIndex].verifyBlock.height != _currentHeight) { \
						mpz_clear(tar); \
						return; \
					} \
					_putOffsetsInSegments(_sieves[j], offsets[j], counts[j], n_offsets[j]); \
					n_offsets[j] = 0; \
				} \
				if (index < _parameters.maxIncrements) { \
					offsets[j][n_offsets[j]++] = index; \
					counts[j][index >> _parameters.sieveBits]++; \
				} \
				for (std::vector<uint64_t>::size_type f(1) ; f < _halfPrimeTupleOffset.size() ; f++) { \
					if (index < invert[_halfPrimeTupleOffset[f]]) index += p; \
					index -= invert[_halfPrimeTupleOffset[f]]; \
					if (index < _parameters.maxIncrements) { \
						offsets[j][n_offsets[j]++] = index; \
						counts[j][index >> _parameters.sieveBits]++; \
					} \
				} \
			} \
		};
		addToOffsets(0);
		if (_parameters.sieveWorkers == 1) continue;

		uint64_t r;
#define recomputeRemainder(j) {r = (_primorialOffsetDiff[j - 1]*invert[0]) % p;}
		recomputeRemainder(1);
		if (index < r) index += p;
		index -= r;
		addToOffsets(1);

		for (int j(2) ; j < _parameters.sieveWorkers ; j++) {
			if (_primorialOffsetDiff[j - 1] != _primorialOffsetDiff[j - 2]) {
				recomputeRemainder(j);
			}
			if (index < r) index += p;
			index -= r;
			addToOffsets(j);
		}
	}

	if (end_i > _sparseLimit)
	{
		for (int j(0) ; j < _parameters.sieveWorkers ; j++) {
			if (n_offsets[j] > 0) {
				_putOffsetsInSegments(_sieves[j], offsets[j], counts[j], n_offsets[j]);
				n_offsets[j] = 0;
			}
		}
	}

	mpz_clear(tar);
}

void Miner::_processSieve(uint8_t *sieve, uint32_t* offsets, uint64_t start_i, uint64_t end_i) {
	const uint64_t tupleSize(_parameters.primeTupleOffset.size());
	uint32_t pending[PENDING_SIZE];
	uint64_t pending_pos(0);
	_initPending(pending);

	for (uint64_t i(start_i) ; i < end_i ; i++) {
		const uint32_t p(_parameters.primes[i]);
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

void Miner::_runSieve(SieveInstance& sieve, uint32_t workDataIndex) {
	std::unique_lock<std::mutex> modLock(sieve.modLock, std::defer_lock);
	for (uint64_t loop(0) ; loop < _parameters.maxIter ; loop++) {
		if (_workData[workDataIndex].verifyBlock.height != _currentHeight)
			break;

		memset(sieve.sieve, 0, _parameters.sieveSize/8);

		// Align
		const uint64_t tupleSize(_parameters.primeTupleOffset.size());
		uint64_t start_i(_startingPrimeIndex);
		for ( ; (start_i & 1) != 0 ; start_i++) {
			const uint64_t pno(start_i);
			const uint32_t p(_parameters.primes[pno]);
			for (uint64_t f(0) ; f < tupleSize ; f++) {
				while (sieve.offsets[pno*tupleSize + f] < _parameters.sieveSize) {
					sieve.sieve[sieve.offsets[pno*tupleSize + f] >> 3] |= (1 << ((sieve.offsets[pno*tupleSize + f] & 7)));
					sieve.offsets[pno*tupleSize + f] += p;
				}
				sieve.offsets[pno*tupleSize + f] -= _parameters.sieveSize;
			}
		}

		// Main sieve
		_processSieve(sieve.sieve, sieve.offsets, start_i, _sparseLimit);

		// Must now have all segments populated.
		if (loop == 0) modLock.lock();

		uint32_t pending[PENDING_SIZE];
		_initPending(pending);
		uint64_t pending_pos(0);
		for (uint64_t i(0) ; i < sieve.segmentCounts[loop] ; i++)
			_addToPending(sieve.sieve, pending, pending_pos, sieve.segmentHits[loop][i]);

		_termPending(sieve.sieve, pending);

		if (_workData[workDataIndex].verifyBlock.height != _currentHeight)
			break;

		primeTestWork w;
		w.testWork.n_indexes = 0;
		w.testWork.offsetId = sieve.id;
		w.testWork.loop = loop;
		w.type = TYPE_CHECK;
		w.workDataIndex = workDataIndex;
		
		bool stop(false);
		uint64_t *sieve64((uint64_t*) sieve.sieve);
		for (uint32_t b(0) ; !stop && b < _parameters.sieveWords ; b++) {
			uint64_t sb(~sieve64[b]);

			while (sb != 0) {
				const uint32_t lowsb(__builtin_ctzll(sb)), i((b*64) + lowsb);
				sb &= sb - 1;

				w.testWork.indexes[w.testWork.n_indexes] = i;
				w.testWork.n_indexes++;

				if (w.testWork.n_indexes == WORK_INDEXES) {
					// Low overhead but still often enough
					if (_workData[workDataIndex].verifyBlock.height != _currentHeight) {
						stop = true;
						break;
					}

					_verifyWorkQueue.push_back(w);
					w.testWork.n_indexes = 0;
					_workData[workDataIndex].outstandingTests++;
				}
			}
		}

		if (_workData[workDataIndex].verifyBlock.height != _currentHeight) break;

		if (w.testWork.n_indexes > 0) {
			_verifyWorkQueue.push_back(w);
			_workData[workDataIndex].outstandingTests++;
		}
	}
}

void Miner::_verifyThread() {
/* Check for a prime cluster. Uses the fermat test - jh's code noted that it is
slightly faster. Could do an MR test as a follow-up, but the server can do this
too for the one-in-a-whatever case that Fermat is wrong. */
	mpz_t z_ft_r, z_ft_b, z_ft_n, z_tmp, z_tmp2, z_ploop;
	mpz_init(z_ft_r);
	mpz_init_set_ui(z_ft_b, 2);
	mpz_init(z_ft_n);
	mpz_init(z_tmp);
	mpz_init(z_tmp2);
	mpz_init(z_ploop);

	while (_running) {
		primeTestWork job;
		if (!_modWorkQueue.pop_front_if_not_empty(job)) {
			job = _verifyWorkQueue.pop_front();
		}
		const auto startTime(std::chrono::high_resolution_clock::now());
		
		if (job.type == TYPE_MOD) {
			_updateRemainders(job.workDataIndex, job.modWork.start, job.modWork.end);
			_workDoneQueue.push_back(-int64_t(job.modWork.start));
			_modTime += std::chrono::duration_cast<decltype(_modTime)>(std::chrono::high_resolution_clock::now() - startTime);
			continue;
		}
		
		if (job.type == TYPE_SIEVE) {
			_runSieve(_sieves[job.sieveWork.sieveId], job.workDataIndex);
			_workDoneQueue.push_back(-1);
			const auto dt(std::chrono::duration_cast<decltype(_sieveTime)>(std::chrono::high_resolution_clock::now() - startTime));
			_sieveTime += dt;
			continue;
		}
		
		if (job.type == TYPE_CHECK) { // fallthrough: job.type == TYPE_CHECK
			mpz_mul_ui(z_ploop, _primorial, job.testWork.loop*_parameters.sieveSize);
			mpz_add(z_ploop, z_ploop, _workData[job.workDataIndex].z_verifyRemainderPrimorial);
			mpz_add(z_ploop, z_ploop, _workData[job.workDataIndex].z_verifyTarget);
			mpz_add_ui(z_ploop, z_ploop, _primorialOffsetDiffToFirst[job.testWork.offsetId]);

			bool firstTestDone(false);

			for (uint32_t idx(0) ; idx < job.testWork.n_indexes ; idx++) {
				if (_currentHeight != _workData[job.workDataIndex].verifyBlock.height) break;

				uint8_t tupleLength(0);
				mpz_mul_ui(z_tmp, _primorial, job.testWork.indexes[idx]);
				mpz_add(z_tmp, z_tmp, z_ploop);
				
				if (!firstTestDone) {
					mpz_sub_ui(z_ft_n, z_tmp, 1);
					mpz_powm(z_ft_r, z_ft_b, z_ft_n, z_tmp);
					if (mpz_cmp_ui(z_ft_r, 1) != 0) continue;
				}

				mpz_sub(z_tmp2, z_tmp, _workData[job.workDataIndex].z_verifyTarget); // offset = tested - target
				
				tupleLength++;
				_manager->incTupleCount(tupleLength);
				// Note start at 1 - we've already tested bias 0
				for (std::vector<uint64_t>::size_type i(1) ; i < _parameters.primeTupleOffset.size() ; i++) {
					mpz_add_ui(z_tmp, z_tmp, _parameters.primeTupleOffset[i]);
					mpz_sub_ui(z_ft_n, z_tmp, 1);
					mpz_powm(z_ft_r, z_ft_b, z_ft_n, z_tmp);
					if (mpz_cmp_ui(z_ft_r, 1) == 0) {
						tupleLength++;
						_manager->incTupleCount(tupleLength);
					}
					else if (!_parameters.solo) {
						int candidatesRemaining(5 - i);
						if ((tupleLength + candidatesRemaining) < 4) continue;
					}
					else break;
				}
				
				if (_parameters.solo) {
					if (tupleLength < _parameters.tupleLengthMin) continue;
				}
				else if (tupleLength < 4) continue;
	
				// Generate nOffset and submit
				for (uint32_t d(0) ; d < (uint32_t) std::min(32/(uint32_t)sizeof(mp_limb_t), (uint32_t)z_tmp2->_mp_size) ; d++)
					*(mp_limb_t*) (_workData[job.workDataIndex].verifyBlock.bh.nOffset + d*sizeof(mp_limb_t)) = z_tmp2->_mp_d[d];

				_workData[job.workDataIndex].verifyBlock.primes = tupleLength;
				_manager->submitWork(_workData[job.workDataIndex].verifyBlock);
			}
			
			_workDoneQueue.push_back(job.workDataIndex);
			_verifyTime += std::chrono::duration_cast<decltype(_verifyTime)>(std::chrono::high_resolution_clock::now() - startTime);
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
	
	const uint64_t searchBits(block.targetCompact);
	const uint64_t trailingZeros(searchBits - 1 - zeroesBeforeHashInPrime - 256);
	mpz_mul_2exp(z_target, z_target, trailingZeros);
	
	const uint64_t difficulty(mpz_sizeinbase(z_target, 2));
	if (_manager->difficulty() != difficulty) {
		if (_manager->difficulty() == 1)
			std::cout << ", difficulty " << difficulty << std::endl;
		_manager->updateDifficulty(difficulty, block.height);
	}
}

void Miner::_processOneBlock(uint32_t workDataIndex, bool isNewHeight) {
	mpz_t z_target, z_tmp, z_remainderPrimorial;
	mpz_init(z_tmp);
	mpz_init(z_remainderPrimorial);
	
	_getTargetFromBlock(z_target, _workData[workDataIndex].verifyBlock);
	if (_running) {
		// find first offset where target%primorial = _parameters.primorialOffset
		mpz_tdiv_r(z_remainderPrimorial, z_target, _primorial);
		mpz_abs(z_remainderPrimorial, z_remainderPrimorial);
		mpz_sub(z_remainderPrimorial, _primorial, z_remainderPrimorial);
		mpz_tdiv_r(z_remainderPrimorial, z_remainderPrimorial, _primorial);
		mpz_abs(z_remainderPrimorial, z_remainderPrimorial);
		mpz_add_ui(z_remainderPrimorial, z_remainderPrimorial, _parameters.primorialOffsets[0]);
		mpz_add(z_tmp, z_target, z_remainderPrimorial);
		
		mpz_set(_workData[workDataIndex].z_verifyTarget, z_target);
		mpz_set(_workData[workDataIndex].z_verifyRemainderPrimorial, z_remainderPrimorial);
		
		for (int i(0) ; i < _parameters.sieveWorkers ; i++)
			for (uint64_t j(0) ; j < _parameters.maxIter; j++) _sieves[i].segmentCounts[j] = 0;
		
		primeTestWork wi;
		wi.type = TYPE_MOD;
		wi.workDataIndex = workDataIndex;
		primeTestWork wd;
		wd.type = TYPE_DUMMY;
		int32_t nModWorkers(0), nLowModWorkers(0);
		
		const uint32_t curWorkOut(_verifyWorkQueue.size());
		const uint64_t incr(_nPrimes/(_parameters.threads*8));
		for (auto base(_startingPrimeIndex) ; base < _nPrimes ; base += incr) {
			uint64_t lim(std::min(_nPrimes, base + incr));
			wi.modWork.start = base;
			wi.modWork.end = lim;
			_modWorkQueue.push_back(wi);
			_verifyWorkQueue.push_front(wd);  // To ensure a thread wakes up to grab the mod work.
			if (wi.modWork.start < _sparseLimit) nLowModWorkers++;
			else nModWorkers++;
		}
		while (nLowModWorkers > 0) {
			const int64_t i(_workDoneQueue.pop_front());
			if (i >= 0) _workData[i].outstandingTests--;
			else {
				if (uint64_t(-i) < _sparseLimit) nLowModWorkers--;
				else nModWorkers--;
			}
		}

		assert(_workData[workDataIndex].outstandingTests == 0);

		wi.type = TYPE_SIEVE;
		for (int i(0); i < _parameters.sieveWorkers; ++i) {
			wi.sieveWork.sieveId = i;
			_sieves[i].modLock.lock();
			_verifyWorkQueue.push_front(wi);
		}
		int nSieveWorkers(_parameters.sieveWorkers);
		
		while (nModWorkers > 0) {
			const int64_t i(_workDoneQueue.pop_front());
			if (i >= 0) _workData[i].outstandingTests--;
			else if (i == -1) nSieveWorkers--;
			else nModWorkers--;
		}
		for (int i(0) ; i < _parameters.sieveWorkers; ++i) _sieves[i].modLock.unlock();

		uint32_t minWorkOut(std::min(curWorkOut, _verifyWorkQueue.size()));
		while (nSieveWorkers > 0) {
			const int workId(_workDoneQueue.pop_front());
			if (workId == -1) nSieveWorkers--;
			else _workData[workId].outstandingTests--;
			minWorkOut = std::min(minWorkOut, _verifyWorkQueue.size());
		}

		if (_currentHeight == _workData[workDataIndex].verifyBlock.height && !isNewHeight) {
			DBG(std::cout << "Min work outstanding during sieving: " << minWorkOut << std::endl;);
			if (curWorkOut > _maxWorkOut - _parameters.threads*2) {
				// If we are acheiving our work target, then adjust it towards the amount
				// required to maintain a healthy minimum work queue length.
				if (minWorkOut == 0) {
					// Need more, but don't know how much, try adding some.
					_maxWorkOut += 4*_parameters.threads*_parameters.sieveWorkers;
				}
				else {
					// Adjust towards target of min work = 4*threads
					const uint32_t targetMaxWork((_maxWorkOut - minWorkOut) + 8*_parameters.threads);
					_maxWorkOut = (_maxWorkOut + targetMaxWork)/2;
				}
			}
			else if (minWorkOut > 4u*_parameters.threads) {
				// Didn't make the target, but also didn't run out of work.  Can still adjust target.
				const uint32_t targetMaxWork((curWorkOut - minWorkOut) + 10*_parameters.threads);
				_maxWorkOut = (_maxWorkOut + targetMaxWork)/2;
			}
			else if (minWorkOut == 0 && curWorkOut > 0) {
				// Warn possible CPU Underuse
				static int allowedFails(5);
				if (--allowedFails == 0) {
					allowedFails = 5;
					DBG(std::cout << "Unable to generate enough verification work to keep threads busy." << std::endl;
					    std::cout << "Sieve = " << _parameters.sieve << ", SieveWorkers = " << _parameters.sieveWorkers << std::endl;);
				}
			}
			_maxWorkOut = std::min(_maxWorkOut, _workDoneQueue.size() - 9*_parameters.threads);
			DBG(std::cout << "Work target before starting next block now: " << _maxWorkOut << std::endl;);
		}

		mpz_clears(z_target, z_tmp, z_remainderPrimorial, NULL);
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
		_verifyThread();
		usleep(1000000);
		return;
	}
	
	uint32_t workDataIndex(0), oldHeight(0);
	_workData[workDataIndex].verifyBlock = block;
	
	do {
		_modTime = _modTime.zero();
		_sieveTime = _sieveTime.zero();
		_verifyTime = _verifyTime.zero();
		
		_processOneBlock(workDataIndex, oldHeight != _workData[workDataIndex].verifyBlock.height);
		oldHeight = _workData[workDataIndex].verifyBlock.height;

		while (_workData[workDataIndex].outstandingTests > _maxWorkOut)
			_workData[_workDoneQueue.pop_front()].outstandingTests--;

		workDataIndex = (workDataIndex + 1) % WORK_DATAS;
		while (_workData[workDataIndex].outstandingTests > 0)
			_workData[_workDoneQueue.pop_front()].outstandingTests--;

		DBG(std::cout << "Block timing: " << _modTime.count() << ", " << _sieveTime.count() << ", " << _verifyTime.count() << "  Tests out: " << _workData[0].outstandingTests << ", " << _workData[1].outstandingTests << std::endl;);

	} while (_manager->getWork(_workData[workDataIndex].verifyBlock));

	for (workDataIndex = 0 ; workDataIndex < WORK_DATAS ; workDataIndex++) {
		while (_workData[workDataIndex].outstandingTests > 0)
			_workData[_workDoneQueue.pop_front()].outstandingTests--;
	}
}
