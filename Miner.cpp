/* (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)
(c) 2018 Michael Bell/Rockhawk (assembly optimizations, improvements of work management between threads, and some more) (https://github.com/MichaelBell/) */

#include <gmpxx.h> // With Uint64_Ts, we still need to use the Mpz_ functions, otherwise there are "ambiguous overload" errors on Windows...

#include "external/gmp_util.h"
#include "ispc/fermat.h"
#include "Miner.hpp"

extern "C" {
	void rie_mod_1s_4p_cps(uint64_t *cps, uint64_t p);
	mp_limb_t rie_mod_1s_4p(mp_srcptr ap, mp_size_t n, uint64_t ps, uint64_t cnt, uint64_t* cps);
	mp_limb_t rie_mod_1s_2p_4times(mp_srcptr ap, mp_size_t n, uint32_t* ps, uint32_t cnt, uint64_t* cps, uint64_t* remainders);
	mp_limb_t rie_mod_1s_2p_8times(mp_srcptr ap, mp_size_t n, uint32_t* ps, uint32_t cnt, uint64_t* cps, uint64_t* remainders);
}

constexpr uint64_t nPrimesTo2p32(203280222);
constexpr int offsetStackSize(16384);
constexpr int maxSieveWorkers(16); // There is a noticeable performance penalty using Vector so we are using Arrays.
thread_local std::array<uint64_t*, maxSieveWorkers> threadOffsetStack{nullptr};
thread_local std::array<uint64_t*, maxSieveWorkers> threadOffsetCount{nullptr};
thread_local uint16_t threadId(65535);

void Miner::init(const MinerParameters &minerParameters) {
	if (_inited) {
		ERRORMSG("The miner is already inited!");
		return;
	}
	std::cout << "Initializing miner..." << std::endl;
	std::cout << "Processor: " << _cpuInfo.getBrand() << std::endl;
	_parameters = minerParameters;
	// Get settings from Configuration File.
	std::cout << "Best SIMD instructions supported:";
	if (_cpuInfo.hasAVX512()) std::cout << " AVX-512";
	else if (_cpuInfo.hasAVX2()) {
		std::cout << " AVX2";
		if (!_parameters.useAvx2) std::cout << " (disabled -> AVX)";
	}
	else if (_cpuInfo.hasAVX()) std::cout << " AVX";
	else std::cout << " AVX not suppported";
	std::cout << std::endl;
	std::cout << "Threads: " << _parameters.threads << std::endl;
	std::vector<uint64_t> cumulativeOffsets(_parameters.pattern.size(), 0);
	std::partial_sum(_parameters.pattern.begin(), _parameters.pattern.end(), cumulativeOffsets.begin(), std::plus<uint64_t>());
	std::cout << "Constellation pattern: n + (" << formatContainer(cumulativeOffsets) << "), length " << _parameters.pattern.size() << std::endl;
	if (_mode == "Search") {
		if (_parameters.tupleLengthMin < 1 || _parameters.tupleLengthMin > _parameters.pattern.size())
			_parameters.tupleLengthMin = std::max(1, static_cast<int>(_parameters.pattern.size()) - 1);
		std::cout << "Will show tuples of at least length " << _parameters.tupleLengthMin << std::endl;
	}
	std::cout << "Primorial number: " << _parameters.primorialNumber << std::endl;
	std::cout << "Primorial offsets: ";
	if (_parameters.primorialOffsets.size() == 0) { // Set the default Primorial Offsets if not chosen (must be chosen if the chosen pattern is not hardcoded)
		auto defaultPrimorialOffsetsIterator(std::find_if(defaultConstellationData.begin(), defaultConstellationData.end(), [this](const auto& constellationData) {return constellationData.first == _parameters.pattern;}));
		if (defaultPrimorialOffsetsIterator == defaultConstellationData.end()) {
			std::cout << "None" << std::endl << "Not hardcoded Constellation Offsets chosen and no Primorial Offset set." << std::endl;
			return;
		}
		else
			_parameters.primorialOffsets = defaultPrimorialOffsetsIterator->second;
	}
	_primorialOffsets = v64ToVMpz(_parameters.primorialOffsets);
	std::cout << formatContainer(_primorialOffsets) << std::endl;
	if (_parameters.sieveWorkers == 0) {
		_parameters.sieveWorkers = std::max(_parameters.threads/5, 1);
		_parameters.sieveWorkers += (_parameters.primeTableLimit + 0x80000000ull) >> 33;
	}
	_parameters.sieveWorkers = std::min(_parameters.sieveWorkers, maxSieveWorkers);
	_parameters.sieveWorkers = std::min(_parameters.sieveWorkers, int(_primorialOffsets.size()));
	std::cout << "Sieve Workers: " << _parameters.sieveWorkers << std::endl;
	_parameters.sieveSize = 1 << _parameters.sieveBits;
	_parameters.sieveWords = _parameters.sieveSize/64;
	std::cout << "Sieve Size: " << "2^" << _parameters.sieveBits << " = " << _parameters.sieveSize << " (" << _parameters.sieveWords << " words)" << std::endl;
	_parameters.maxIterations = _parameters.maxIncrements/_parameters.sieveSize;
	std::cout << "Max Increments: " << _parameters.maxIncrements << std::endl;
	std::cout << "Max Iterations: " << _parameters.maxIterations << std::endl;
	std::cout << "Prime table limit: " << _parameters.primeTableLimit << std::endl;
	std::transform(_parameters.pattern.begin(), _parameters.pattern.end(), std::back_inserter(_halfPattern), [](uint64_t n) {return n >> 1;});
	_primorialOffsetDiff.resize(_parameters.sieveWorkers - 1);
	_primorialOffsetDiffToFirst.resize(_parameters.sieveWorkers);
	_primorialOffsetDiffToFirst[0] = 0;
	const uint64_t constellationDiameter(cumulativeOffsets.back());
	for (int j(1) ; j < _parameters.sieveWorkers ; j++) {
		_primorialOffsetDiff[j - 1] = _parameters.primorialOffsets[j] - _parameters.primorialOffsets[j - 1] - constellationDiameter;
		_primorialOffsetDiffToFirst[j] = _parameters.primorialOffsets[j] - _parameters.primorialOffsets[0];
	}
	
	{
		std::chrono::time_point<std::chrono::steady_clock> t0(std::chrono::steady_clock::now());
		std::cout << "Generating prime table using sieve of Eratosthenes..." << std::endl;
		std::vector<uint64_t> compositeTable((_parameters.primeTableLimit + 127ULL)/128ULL, 0ULL); // Booleans indicating whether an odd number is composite: 0000100100101100...
		for (uint64_t f(3ULL) ; f*f < _parameters.primeTableLimit ; f += 2ULL) { // Eliminate f and its multiples m for odd f from 3 to square root of the PrimeTableLimit
			if (compositeTable[f >> 7ULL] & (1ULL << ((f >> 1ULL) & 63ULL))) continue; // Skip if f is composite (f and its multiples were already eliminated)
			for (uint64_t m((f*f) >> 1ULL) ; m < (_parameters.primeTableLimit >> 1ULL) ; m += f) // Start eliminating at f^2 (multiples of f below were already eliminated)
				compositeTable[m >> 6ULL] |= 1ULL << (m & 63ULL);
		}
		_primes.push_back(2ULL);
		for (uint64_t i(1ULL) ; (i << 1ULL) + 1ULL < _parameters.primeTableLimit ; i++) { // Fill the prime table using the composite table
			if (!(compositeTable[i >> 6ULL] & (1ULL << (i & 63ULL))))
				_primes.push_back((i << 1ULL) + 1ULL); // Add prime number 2i + 1
		}
		std::cout << "Table with all " << _primes.size() << " first primes generated in " << timeSince(t0) << " s." << std::endl;
		if (_primes.size() % 2 == 1 && _parameters.pattern.size() == 6) // Needs to be even to use optimizations for 6-tuples
			_primes.pop_back();
		_nPrimes = _primes.size();
	}
	
	if (_primes.size() < _parameters.primorialNumber) {
		std::cout << "The Prime Table is too small, the number of primes must be at least the Primorial Number " << _parameters.primorialNumber << "." << std::endl;
		return;
	}
	mpz_set_ui(_primorial.get_mpz_t(), _primes[0]);
	for (uint64_t i(1) ; i < _parameters.primorialNumber ; i++)
		mpz_mul_ui(_primorial.get_mpz_t(), _primorial.get_mpz_t(), _primes[i]);
	std::cout << "Primorial: p" << _parameters.primorialNumber << "# = " << _primes[_parameters.primorialNumber - 1] << "# = ";
	if (mpz_sizeinbase(_primorial.get_mpz_t(), 10) < 18)
		std::cout << _primorial;
	else
		std::cout << "~" << _primorial.get_str()[0] << "." << _primorial.get_str().substr(1, 12) << "*10^" << _primorial.get_str().size() - 1;
	std::cout << " (" << mpz_sizeinbase(_primorial.get_mpz_t(), 2) << " bits)" << std::endl;
	
	uint64_t highSegmentEntries(0); // highSegmentEntries: sum of tupleSize*maxIncrements/p for p in the prime table greater or equal than maxIncrements
	double highFloats(0.), tupleSizeAsDouble(_parameters.pattern.size());
	_primeTestStoreOffsetsSize = 0; // primeTestStoreOffsetsSize: (number of prime numbers in the table smaller than maxIncrements) - 5
	_sparseLimit = 0; // sparseLimit: number of prime numbers smaller than maxIncrements in the table
	for (uint64_t i(5) ; i < _nPrimes ; i++) {
		const uint64_t p(_primes[i]);
		if (p < _parameters.maxIncrements) _primeTestStoreOffsetsSize++;
		else {
			if (_sparseLimit == 0) {
				_sparseLimit = i;
				if (_sparseLimit % 2 == 1 && _parameters.pattern.size() == 6) // Needs to be even to use optimizations for 6-tuples
					_sparseLimit--;
			}
			highFloats += ((tupleSizeAsDouble*_parameters.maxIncrements)/static_cast<double>(p));
		}
	}
	if (_sparseLimit == 0)
		_sparseLimit = _nPrimes;
	std::cout << "Sparse Limit: " << _sparseLimit << std::endl;
	
	highSegmentEntries = ceil(highFloats);
	if (highSegmentEntries == 0) _entriesPerSegment = 1;
	else {
		_entriesPerSegment = highSegmentEntries/_parameters.maxIterations + 4; // Rounding up a bit
		_entriesPerSegment = (_entriesPerSegment + (_entriesPerSegment >> 3));
	}
	std::cout << "Entries per segment: " << _entriesPerSegment << std::endl; // entriesPerSegment = (9/8)(highSegmentEntries/_parameters.maxIterations + 4)
	{
		std::cout << "Precomputing modular inverses and division data..." << std::endl; // The precomputed data is used to speed up computations in _doPresieveTask.
		std::chrono::time_point<std::chrono::steady_clock> t0(std::chrono::steady_clock::now());
		const uint64_t precompPrimes(std::min(_nPrimes, 5586502348UL)); // Precomputation only works up to p = 2^37
		_modularInverses.resize(_nPrimes); // Table of inverses of the primorial modulo a prime number in the table with index >= primorialNumber.
		_modPrecompute.resize(precompPrimes);
		const uint64_t blockSize((_nPrimes - _parameters.primorialNumber + _parameters.threads - 1)/_parameters.threads);
		std::thread threads[_parameters.threads];
		for (uint16_t j(0) ; j < _parameters.threads ; j++) {
			threads[j] = std::thread([&, j]() {
				mpz_class modularInverse, prime;
				const uint64_t endIndex(std::min(_parameters.primorialNumber + (j + 1)*blockSize, _nPrimes));
				for (uint64_t i(_parameters.primorialNumber + j*blockSize) ; i < endIndex ; i++) {
					mpz_set_ui(prime.get_mpz_t(), _primes[i]);
					mpz_invert(modularInverse.get_mpz_t(), _primorial.get_mpz_t(), prime.get_mpz_t()); // modularInverse*primorial ≡ 1 (mod prime)
					_modularInverses[i] = mpz_get_ui(modularInverse.get_mpz_t());
					if (i < precompPrimes)
						rie_mod_1s_4p_cps(&_modPrecompute[i], _primes[i]);
				}
			});
		}
		for (uint16_t j(0) ; j < _parameters.threads ; j++) threads[j].join();
		std::cout << "Tables of " << _modularInverses.size() - _parameters.primorialNumber << " modular inverses and " << precompPrimes - _parameters.primorialNumber << " division entries generated in " << timeSince(t0) << " s." << std::endl;
	}
	
	try {
		_sieveInstances = new SieveInstance[_parameters.sieveWorkers];
		for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
			_sieveInstances[i].id = i;
			_sieveInstances[i].segmentCounts = new std::atomic<uint64_t>[_parameters.maxIterations];
		}
		std::cout << "Allocating " << sizeof(uint64_t)*_parameters.sieveWords*_parameters.sieveWorkers << " bytes for the sieves..." << std::endl;
		for (int i(0) ; i < _parameters.sieveWorkers ; i++)
			_sieveInstances[i].sieve = new uint64_t[_parameters.sieveWords];
	}
	catch (std::bad_alloc& ba) {
		ERRORMSG("Unable to allocate memory for the sieves");
		return;
	}
	
	try {
		std::cout << "Allocating " << sizeof(uint32_t)*_parameters.sieveWorkers*_parameters.pattern.size()*(_primeTestStoreOffsetsSize + 1024) << " bytes for the offsets..." << std::endl;
		for (int i(0) ; i < _parameters.sieveWorkers ; i++)
			_sieveInstances[i].offsets = new uint32_t[(_primeTestStoreOffsetsSize + 1024)*_parameters.pattern.size()];
	}
	catch (std::bad_alloc& ba) {
		ERRORMSG("Unable to allocate memory for the offsets");
		return;
	}
	for (int i(0) ; i < _parameters.sieveWorkers ; i++)
		memset(_sieveInstances[i].offsets, 0, sizeof(uint32_t)*_parameters.pattern.size()*(_primeTestStoreOffsetsSize + 1024));
	
	try {
		std::cout << "Allocating " << sizeof(uint32_t)*_parameters.sieveWorkers*_parameters.maxIterations*_entriesPerSegment << " bytes for the segment hits..." << std::endl;
		for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
			_sieveInstances[i].segmentHits = new uint32_t*[_parameters.maxIterations];
			for (uint64_t j(0) ; j < _parameters.maxIterations ; j++)
				_sieveInstances[i].segmentHits[j] = new uint32_t[_entriesPerSegment];
		}
	}
	catch (std::bad_alloc& ba) {
		ERRORMSG("Unable to allocate memory for the segment hits");
		return;
	}
	// Initial guess at a value for the threshold
	_nRemainingCheckTasksThreshold = 32U*_parameters.threads*_parameters.sieveWorkers;
	_inited = true;
	std::cout << "Done initializing miner." << std::endl;
}

void Miner::startThreads() {
	if (!_inited)
		ERRORMSG("The miner is not inited");
	else if (_client == nullptr)
		ERRORMSG("The miner cannot start mining without a client");
	else if (_running)
		ERRORMSG("The miner is already running");
	else {
		_running = true;
		_statManager.start(_parameters.pattern.size());
		std::cout << "Starting the miner's master thread..." << std::endl;
		_masterThread = std::thread(&Miner::_manageTasks, this);
		std::cout << "Starting " << _parameters.threads << " miner's worker threads..." << std::endl;
		for (uint16_t i(0) ; i < _parameters.threads ; i++)
			_workerThreads.push_back(std::thread(&Miner::_doTasks, this, i));
		std::cout << "-----------------------------------------------------------" << std::endl;
		std::cout << Stats::formattedTime(_statManager.timeSinceStart()) << " Started mining at block " << _client->currentHeight() << ", difficulty " << FIXED(3) << _client->currentDifficulty() << std::endl;
	}
}

void Miner::stopThreads() {
	if (!_running)
		ERRORMSG("The miner is already not running");
	else {
		_running = false;
		if (_mode == "Benchmark" || _mode == "Search")
			printTupleStats();
		std::cout << "Waiting for the miner's master thread to finish..." << std::endl;
		_tasksDoneInfos.push_front(TaskDoneInfo{Task::Type::Dummy, .empty = {}}); // Unblock if master thread stuck in blocking_pop_front().
		_masterThread.join();
		std::cout << "Waiting for the miner's worker threads to finish..." << std::endl;
		for (uint16_t i(0) ; i < _parameters.threads ; i++)
			_tasks.push_front(Task{Task::Type::Dummy, 0, {}}); // Unblock worker threads stuck in blocking_pop_front().
		for (auto &workerThread : _workerThreads)
			workerThread.join();
		_workerThreads.clear();
		std::cout << "Miner threads stopped." << std::endl;
		_presieveTasks.clear();
		_tasks.clear();
		_tasksDoneInfos.clear();
		for (auto &work : _works) work.clear();
	}
}

void Miner::clear() {
	if (_running)
		ERRORMSG("Cannot clear the miner while it is running");
	else if (!_inited)
		ERRORMSG("Cannot clear the miner if it is not inited");
	else {
		std::cout << "Clearing miner's data..." << std::endl;
		_inited = false;
		for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
			delete _sieveInstances[i].segmentCounts;
			delete _sieveInstances[i].sieve;
			delete _sieveInstances[i].offsets;
			for (uint64_t j(0) ; j < _parameters.maxIterations ; j++)
				delete _sieveInstances[i].segmentHits[j];
			delete _sieveInstances[i].segmentHits;
		}
		delete _sieveInstances;
		_primes.clear();
		_modularInverses.clear();
		_modPrecompute.clear();
		_halfPattern.clear();
		_primorialOffsetDiff.clear();
		_primorialOffsetDiffToFirst.clear();
		_parameters = MinerParameters();
		std::cout << "Miner's data cleared." << std::endl;
	}
}

void Miner::_putOffsetsInSegments(SieveInstance& sieveInstance, uint64_t *offsets, uint64_t* counts, int nOffsets) {
	for (uint64_t segment(0) ; segment < _parameters.maxIterations ; segment++) // Update the number of offsets of each segment
		counts[segment] = sieveInstance.segmentCounts[segment].fetch_add(counts[segment]);
	for (int i(0) ; i < nOffsets ; i++) {
		const uint64_t index(offsets[i]),
		               segment(index >> _parameters.sieveBits),
		               posInSegment(counts[segment]);
		sieveInstance.segmentHits[segment][posInSegment] = index & (_parameters.sieveSize - 1); // index % sieveSize
		counts[segment]++;
	}
	for (uint64_t segment(0) ; segment < _parameters.maxIterations ; segment++)
		counts[segment] = 0;
}

void Miner::_doPresieveTask(const Task &task) {
	const uint64_t workIndex(task.workIndex), firstPrimeIndex(task.presieve.start), lastPrimeIndex(task.presieve.end);
	const mpz_class firstCandidate(_works[workIndex].job.target  + _works[workIndex].remainderPrimorial);
	std::array<int, maxSieveWorkers> nOffsets{0}; // Number of offsets
	std::array<uint64_t*, maxSieveWorkers> &offsets(threadOffsetStack), &counts(threadOffsetCount); // On Windows, caching these thread_local pointers on the stack makes a noticeable perf difference.
	const uint64_t precompLimit(_modPrecompute.size()), tupleSize(_parameters.pattern.size());

	uint64_t avxLimit(0);
	const uint64_t avxWidth(_parameters.useAvx2 ? 8 : 4);
	if (_cpuInfo.hasAVX()) {
		avxLimit = nPrimesTo2p32 - avxWidth;
		avxLimit -= (avxLimit - firstPrimeIndex) & (avxWidth - 1);  // Must be enough primes in range to use AVX
	}

	uint64_t nextRemainder[8];
	uint64_t nextRemainderIndex(8);
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i++) {
		const uint64_t p(_primes[i]);
		uint64_t mi[4];
		mi[0] = _modularInverses[i]; // Modular inverse of the primorial: mi[0]*primorial ≡ 1 (mod p). The modularInverses were precomputed in init().
		mi[1] = (mi[0] << 1); // mi[i] = (2*i*mi[0]) % p for i > 0.
		if (mi[1] >= p) mi[1] -= p;
		mi[2] = mi[1] << 1;
		if (mi[2] >= p) mi[2] -= p;
		mi[3] = mi[1] + mi[2];
		if (mi[3] >= p) mi[3] -= p;
		// Compute the index, using precomputation speed up if available.
		// The index is the solution of firstCandidate + i*primorial ≡ 0 (mod p) for 0 <= i < p: index = (p - (firstCandidate % p))*mi[0] % p.
		// It is used as a starting point for sieving later, where numbers of the form firstCandidate + (index + m*p)*primorial for 0 <= m < maxIncrements are eliminated as they are divisible by p.
		// This is for the first number of the constellation. Later, the mi[1-3] will be used to adjust the index for the other elements of the constellation.
		uint64_t index, cnt(0ULL), ps(0ULL);
		if (i < precompLimit) { // Assembly optimized computation of the index by Michael Bell
			bool haveRemainder(false);
			if (nextRemainderIndex < avxWidth) {
				index = nextRemainder[nextRemainderIndex++];
				cnt = __builtin_clzll(p);
				ps = p << cnt;
				haveRemainder = true;
			}
			else if (i < avxLimit) {
				cnt = __builtin_clz(static_cast<uint32_t>(p));
				if (__builtin_clz(static_cast<uint32_t>(_primes[i + avxWidth - 1])) == cnt) {
					uint32_t ps32[8];
					for (uint64_t j(0) ; j < avxWidth; j++) {
						ps32[j] = static_cast<uint32_t>(_primes[i + j]) << cnt;
						nextRemainder[j] = _modularInverses[i + j];
					}
					if (_parameters.useAvx2) rie_mod_1s_2p_8times(firstCandidate.get_mpz_t()->_mp_d, firstCandidate.get_mpz_t()->_mp_size, &ps32[0], cnt, &_modPrecompute[i], &nextRemainder[0]);
					else rie_mod_1s_2p_4times(firstCandidate.get_mpz_t()->_mp_d, firstCandidate.get_mpz_t()->_mp_size, &ps32[0], cnt, &_modPrecompute[i], &nextRemainder[0]);
					haveRemainder = true;
					index = nextRemainder[0];
					nextRemainderIndex = 1;
					cnt += 32ULL;
					ps = static_cast<uint64_t>(ps32[0]) << 32ULL;
				}
			}
			
			if (!haveRemainder) {
				cnt = __builtin_clzll(p);
				ps = p << cnt;
				const uint64_t remainder(rie_mod_1s_4p(firstCandidate.get_mpz_t()->_mp_d, firstCandidate.get_mpz_t()->_mp_size, ps, cnt, &_modPrecompute[i]));
				const uint64_t pa(ps - remainder);
				uint64_t r, n[2];
				umul_ppmm(n[1], n[0], pa, mi[0]);
				udiv_rnnd_preinv(r, n[1], n[0], ps, _modPrecompute[i]);
				index = r >> cnt;
			}
		}
		else { // Basic computation of the index
			const uint64_t remainder(mpz_tdiv_ui(firstCandidate.get_mpz_t(), p)), pa(p - remainder);
			uint64_t q, n[2];
			umul_ppmm(n[1], n[0], pa, mi[0]);
			udiv_qrnnd(q, index, n[1], n[0], p);
		}
		
		// We use a macro here to ensure the compiler inlines the code, and also make it easier to early
		// out of the function completely if the current height has changed.
#define addToOffsets(sieveWorkerIndex) {                                                           \
			if (i < _sparseLimit) {                                                                \
				_sieveInstances[sieveWorkerIndex].offsets[tupleSize*i] = index;                    \
				for (std::vector<uint64_t>::size_type f(1) ; f < _halfPattern.size() ; f++) { \
					if (index < mi[_halfPattern[f]]) index += p;                          \
					index -= mi[_halfPattern[f]];                                         \
					_sieveInstances[sieveWorkerIndex].offsets[tupleSize*i + f] = index;            \
				}                                                                                  \
			}                                                                                      \
			else {                                                                                 \
				if (nOffsets[sieveWorkerIndex] + _halfPattern.size() >= offsetStackSize) { \
					if (_works[workIndex].job.height != _client->currentHeight()) \
						return;                                                                    \
					_putOffsetsInSegments(_sieveInstances[sieveWorkerIndex], offsets[sieveWorkerIndex], counts[sieveWorkerIndex], nOffsets[sieveWorkerIndex]); \
					nOffsets[sieveWorkerIndex] = 0;                                                \
				}                                                                                  \
				if (index < _parameters.maxIncrements) {                                           \
					offsets[sieveWorkerIndex][nOffsets[sieveWorkerIndex]++] = index;               \
					counts[sieveWorkerIndex][index >> _parameters.sieveBits]++;                    \
				}                                                                                  \
				for (std::vector<uint64_t>::size_type f(1) ; f < _halfPattern.size() ; f++) { \
					if (index < mi[_halfPattern[f]]) index += p;                          \
					index -= mi[_halfPattern[f]];                                         \
					if (index < _parameters.maxIncrements) {                                       \
						offsets[sieveWorkerIndex][nOffsets[sieveWorkerIndex]++] = index;           \
						counts[sieveWorkerIndex][index >> _parameters.sieveBits]++;                \
					}                                                                              \
				}                                                                                  \
			}                                                                                      \
		};
		addToOffsets(0);
		if (_parameters.sieveWorkers == 1) continue;
		
		// Recompute the index to adjust to the PrimorialOffsets of other Sieve Workers.
		uint64_t r;
#define recomputeRemainder(sieveWorkerIndex) { \
			if (i < precompLimit && _primorialOffsetDiff[sieveWorkerIndex - 1] < p) {              \
				uint64_t n[2];                                                                     \
				uint64_t os(_primorialOffsetDiff[sieveWorkerIndex - 1] << cnt);                    \
				umul_ppmm(n[1], n[0], os, mi[0]);                                                  \
				udiv_rnnd_preinv(r, n[1], n[0], ps, _modPrecompute[i]);                            \
				r >>= cnt;                                                                         \
			}                                                                                      \
			else {                                                                                 \
				uint64_t q, n[2];                                                                  \
				umul_ppmm(n[1], n[0], _primorialOffsetDiff[sieveWorkerIndex - 1], mi[0]);          \
				udiv_qrnnd(q, r, n[1], n[0], p);                                                   \
			}                                                                                      \
		}
		recomputeRemainder(1);
		if (index < r) index += p;
		index -= r;
		addToOffsets(1);
		
		for (int j(2) ; j < _parameters.sieveWorkers ; j++) {
			if (_primorialOffsetDiff[j - 1] != _primorialOffsetDiff[j - 2])
				recomputeRemainder(j);
			if (index < r) index += p;
			index -= r;
			addToOffsets(j);
		}
	}
	
	if (lastPrimeIndex > _sparseLimit) {
		for (int j(0) ; j < _parameters.sieveWorkers ; j++) {
			if (nOffsets[j] > 0) {
				_putOffsetsInSegments(_sieveInstances[j], offsets[j], counts[j], nOffsets[j]);
				nOffsets[j] = 0;
			}
		}
	}
}

void Miner::_processSieve(uint64_t *sieve, uint32_t* offsets, const uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex) {
	const uint64_t tupleSize(_parameters.pattern.size());
	std::array<uint32_t, sieveCacheSize> sieveCache{0};
	uint64_t sieveCachePos(0);
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i++) {
		const uint32_t p(_primes[i]);
		for (uint64_t f(0) ; f < tupleSize; f++) {
			while (offsets[i*tupleSize + f] < _parameters.sieveSize) { // Eliminate numbers of the form firstCandidate + (index + m*p)*primorial for the m*p in the current sieve.
				_addToSieveCache(sieve, sieveCache, sieveCachePos, offsets[i*tupleSize + f]);
				offsets[i*tupleSize + f] += p;
			}
			offsets[i*tupleSize + f] -= _parameters.sieveSize;
		}
	}
	_endSieveCache(sieve, sieveCache);
}

void Miner::_processSieve6(uint64_t *sieve, uint32_t* offsets, const uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex) { // Assembly optimized sieving for 6-tuples by Michael Bell
	assert(_parameters.pattern.size() == 6);
	assert((firstPrimeIndex & 1) == 0);
	assert((lastPrimeIndex  & 1) == 0);
	xmmreg_t offsetmax;
	offsetmax.m128 = _mm_set1_epi32(_parameters.sieveSize);
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i += 2) {
		xmmreg_t p1, p2, p3;
		xmmreg_t offset1, offset2, offset3, nextIncr1, nextIncr2, nextIncr3;
		xmmreg_t cmpres1, cmpres2, cmpres3;
		p1.m128 = _mm_set1_epi32(_primes[i]);
		p3.m128 = _mm_set1_epi32(_primes[i+1]);
		p2.m128 = _mm_castps_si128(_mm_shuffle_ps(_mm_castsi128_ps(p1.m128), _mm_castsi128_ps(p3.m128), _MM_SHUFFLE(0, 0, 0, 0)));
		offset1.m128 = _mm_load_si128((__m128i const*) &offsets[i*6 + 0]);
		offset2.m128 = _mm_load_si128((__m128i const*) &offsets[i*6 + 4]);
		offset3.m128 = _mm_load_si128((__m128i const*) &offsets[i*6 + 8]);
		while (true) {
			cmpres1.m128 = _mm_cmpgt_epi32(offsetmax.m128, offset1.m128);
			cmpres2.m128 = _mm_cmpgt_epi32(offsetmax.m128, offset2.m128);
			cmpres3.m128 = _mm_cmpgt_epi32(offsetmax.m128, offset3.m128);
			const int mask1 = _mm_movemask_epi8(cmpres1.m128);
			const int mask2 = _mm_movemask_epi8(cmpres2.m128);
			const int mask3 = _mm_movemask_epi8(cmpres3.m128);
			if ((mask1 == 0) && (mask2 == 0) && (mask3 == 0)) break;
			if (mask1 & 0x0008) sieve[offset1.v[0] >> 6] |= (1ULL << (offset1.v[0] & 63ULL));
			if (mask1 & 0x0080) sieve[offset1.v[1] >> 6] |= (1ULL << (offset1.v[1] & 63ULL));
			if (mask1 & 0x0800) sieve[offset1.v[2] >> 6] |= (1ULL << (offset1.v[2] & 63ULL));
			if (mask1 & 0x8000) sieve[offset1.v[3] >> 6] |= (1ULL << (offset1.v[3] & 63ULL));
			if (mask2 & 0x0008) sieve[offset2.v[0] >> 6] |= (1ULL << (offset2.v[0] & 63ULL));
			if (mask2 & 0x0080) sieve[offset2.v[1] >> 6] |= (1ULL << (offset2.v[1] & 63ULL));
			if (mask2 & 0x0800) sieve[offset2.v[2] >> 6] |= (1ULL << (offset2.v[2] & 63ULL));
			if (mask2 & 0x8000) sieve[offset2.v[3] >> 6] |= (1ULL << (offset2.v[3] & 63ULL));
			if (mask3 & 0x0008) sieve[offset3.v[0] >> 6] |= (1ULL << (offset3.v[0] & 63ULL));
			if (mask3 & 0x0080) sieve[offset3.v[1] >> 6] |= (1ULL << (offset3.v[1] & 63ULL));
			if (mask3 & 0x0800) sieve[offset3.v[2] >> 6] |= (1ULL << (offset3.v[2] & 63ULL));
			if (mask3 & 0x8000) sieve[offset3.v[3] >> 6] |= (1ULL << (offset3.v[3] & 63ULL));
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
}

void Miner::_doSieveTask(Task task) {
	SieveInstance& sieveInstance(_sieveInstances[task.sieve.sieveId]);
	std::unique_lock<std::mutex> presieveLock(sieveInstance.presieveLock, std::defer_lock);
	const uint64_t workIndex(task.workIndex),
	               iteration(task.sieve.iteration),
	               tupleSize(_parameters.pattern.size());
	uint64_t firstPrimeIndex(_parameters.primorialNumber);
	
	Task checkTask{Task::Type::Check, workIndex, .check = {}};
	std::array<uint32_t, sieveCacheSize> sieveCache{0};
	uint64_t sieveCachePos(0);
	
	if (_works[workIndex].job.height != _client->currentHeight()) // Abort Sieve Task if new block (but count as Task done)
		goto sieveEnd;
	
	memset(sieveInstance.sieve, 0, sizeof(uint64_t)*_parameters.sieveWords);
	// Already eliminate for the first prime to sieve if it is odd to align for the 6-tuples optimizations
	if ((firstPrimeIndex & 1) != 0) {
		for (uint64_t f(0) ; f < tupleSize ; f++) {
			while (sieveInstance.offsets[firstPrimeIndex*tupleSize + f] < _parameters.sieveSize) {
				sieveInstance.sieve[sieveInstance.offsets[firstPrimeIndex*tupleSize + f] >> 6U] |= (1ULL << ((sieveInstance.offsets[firstPrimeIndex*tupleSize + f] & 63U)));
				sieveInstance.offsets[firstPrimeIndex*tupleSize + f] += _primes[firstPrimeIndex];
			}
			sieveInstance.offsets[firstPrimeIndex*tupleSize + f] -= _parameters.sieveSize;
		}
		firstPrimeIndex++;
	}
	
	// Main sieve
	if (tupleSize == 6)
		_processSieve6(sieveInstance.sieve, sieveInstance.offsets, firstPrimeIndex, _sparseLimit);
	else
		_processSieve(sieveInstance.sieve, sieveInstance.offsets, firstPrimeIndex, _sparseLimit);
	
	// Must now have all segments populated.
	if (iteration == 0) presieveLock.lock();
	
	for (uint64_t i(0) ; i < sieveInstance.segmentCounts[iteration] ; i++)
		_addToSieveCache(sieveInstance.sieve, sieveCache, sieveCachePos, sieveInstance.segmentHits[iteration][i]);
	_endSieveCache(sieveInstance.sieve, sieveCache);
	
	if (_works[workIndex].job.height != _client->currentHeight())
		goto sieveEnd;
	
	checkTask.check.nCandidates = 0;
	checkTask.check.offsetId = sieveInstance.id;
	checkTask.check.loop = iteration;
	// Extract candidates from the sieve and create verify tasks of up to maxCandidatesPerCheckTask candidates.
	for (uint32_t b(0) ; b < _parameters.sieveWords ; b++) {
		uint64_t sieveWord(~sieveInstance.sieve[b]); // ~ is the Bitwise Not: ones then indicate the candidates and zeros the previously eliminated numbers.
		while (sieveWord != 0) {
			const uint32_t nEliminatedUntilNext(__builtin_ctzll(sieveWord)), candidateIndex((b*64) + nEliminatedUntilNext); // __builtin_ctzll returns the number of leading 0s.
			checkTask.check.candidateIndexes[checkTask.check.nCandidates] = candidateIndex;
			checkTask.check.nCandidates++;
			if (checkTask.check.nCandidates == maxCandidatesPerCheckTask) {
				if (_works[workIndex].job.height != _client->currentHeight()) // Low overhead but still often enough
					goto sieveEnd;
				_tasks.push_back(checkTask);
				checkTask.check.nCandidates = 0;
				_works[workIndex].nRemainingCheckTasks++;
			}
			sieveWord &= sieveWord - 1; // Change the candidate's bit from 1 to 0.
		}
	}
	if (_works[workIndex].job.height != _client->currentHeight())
		goto sieveEnd;
	if (checkTask.check.nCandidates > 0) {
		_tasks.push_back(checkTask);
		_works[workIndex].nRemainingCheckTasks++;
	}
	if (iteration + 1 < _parameters.maxIterations) {
		if (_parameters.threads > 1)
			_tasks.push_front(Task{Task::Type::Sieve, workIndex, .sieve = {sieveInstance.id, iteration + 1}});
		else // Allow mining with 1 Thread without having to wait for all the iterations.
			_tasks.push_back(Task{Task::Type::Sieve, workIndex, .sieve = {sieveInstance.id, iteration + 1}});
		return; // Sieving still not finished, do not go to sieveEnd.
	}
sieveEnd:
	_tasksDoneInfos.push_back(TaskDoneInfo{Task::Type::Sieve, .empty = {}});
}

// Riecoin uses the Miller-Rabin Test for the PoW, but the Fermat Test is significantly faster and more suitable for the miner.
// n is probably prime if a^(n - 1) ≡ 1 (mod n) for one 0 < a < p or more.
static const mpz_class mpz2(2); // Here, we test with one a = 2.
bool isPrimeFermat(const mpz_class& n) {
	mpz_class r, nm1(n - 1);
	mpz_powm(r.get_mpz_t(), mpz2.get_mpz_t(), nm1.get_mpz_t(), n.get_mpz_t()); // r = 2^(n - 1) % n
	return r == 1;
}

bool Miner::_testPrimesIspc(uint32_t candidateIndexes[maxCandidatesPerCheckTask], uint32_t is_prime[maxCandidatesPerCheckTask], const mpz_class &ploop, mpz_class &candidate) { // Assembly optimized prime testing by Michael Bell
	uint32_t M[maxCandidatesPerCheckTask*MAX_N_SIZE], bits(0), N_Size;
	uint32_t *mp(&M[0]);
	for (uint32_t i(0) ; i < maxCandidatesPerCheckTask ; i++) {
		candidate = _primorial*candidateIndexes[i];
		candidate += ploop;
		if (bits == 0) {
			bits = mpz_sizeinbase(candidate.get_mpz_t(), 2);
			N_Size = (bits >> 5) + ((bits & 0x1f) > 0);
			if (N_Size > MAX_N_SIZE) return false;
		}
		else assert(bits == mpz_sizeinbase(candidate.get_mpz_t(), 2));
		memcpy(mp, candidate.get_mpz_t()->_mp_d, N_Size*4);
		mp += N_Size;
	}
	fermatTest(N_Size, maxCandidatesPerCheckTask, M, is_prime, _cpuInfo.hasAVX512());
	return true;
}

void Miner::_doCheckTask(Task task) {
	std::vector<uint64_t> tupleCounts(_parameters.pattern.size() + 1, 0);
	const uint16_t workIndex(task.workIndex);
	mpz_class candidate, ploop;
	mpz_mul_ui(ploop.get_mpz_t(), _primorial.get_mpz_t(), task.check.loop*_parameters.sieveSize);
	ploop += _works[workIndex].job.target;
	ploop += _works[workIndex].remainderPrimorial;
	mpz_add_ui(ploop.get_mpz_t(), ploop.get_mpz_t(), _primorialOffsetDiffToFirst[task.check.offsetId]);
	bool firstTestDone(false);
	if (_parameters.useAvx2 && task.check.nCandidates == maxCandidatesPerCheckTask) { // Test candidates + 0 primality with assembly optimizations if possible.
		uint32_t isPrime[maxCandidatesPerCheckTask];
		firstTestDone = _testPrimesIspc(task.check.candidateIndexes, isPrime, ploop, candidate);
		if (firstTestDone) {
			task.check.nCandidates = 0;
			for (uint32_t i(0) ; i < maxCandidatesPerCheckTask ; i++) {
				tupleCounts[0]++;
				if (isPrime[i])
					task.check.candidateIndexes[task.check.nCandidates++] = task.check.candidateIndexes[i];
			}
		}
	}
	
	for (uint32_t i(0) ; i < task.check.nCandidates ; i++) {
		if (_works[workIndex].job.height != _client->currentHeight()) break;
		
		uint32_t tupleLength(0);
		candidate = _primorial*task.check.candidateIndexes[i];
		candidate += ploop;
		
		if (!firstTestDone) { // Test candidate + 0 primality without optimizations if not done before.
			tupleCounts[tupleLength]++;
			if (!isPrimeFermat(candidate)) continue;
		}
		
		tupleLength++;
		tupleCounts[tupleLength]++;
		uint32_t offsetSum(0);
		// Test primality of the other elements of the tuple if candidate + 0 is prime.
		for (std::vector<uint64_t>::size_type i(1) ; i < _parameters.pattern.size() ; i++) {
			offsetSum += _parameters.pattern[i];
			mpz_add_ui(candidate.get_mpz_t(), candidate.get_mpz_t(), _parameters.pattern[i]);
			if (isPrimeFermat(mpz_class(candidate))) {
				tupleLength++;
				tupleCounts[tupleLength]++;
			}
			else if (_mode == "Pool" && tupleLength > 1) {
				int candidatesRemaining(_works[workIndex].job.primeCountTarget - 1 - i);
				if ((tupleLength + candidatesRemaining) < _works[workIndex].job.primeCountMin) break; // No chance to be a share anymore
			}
			else break;
		}
		// If tuple long enough or share, submit
		if (tupleLength >= _works[workIndex].job.primeCountMin || (_mode == "Search" && tupleLength >= _parameters.tupleLengthMin)) {
			const mpz_class basePrime(candidate - offsetSum);
			std::cout << Stats::formattedTime(_statManager.timeSinceStart()) << " " << tupleLength;
			if (_mode == "Pool")
				std::cout << "-share found by worker thread " << threadId << std::endl;
			else {
				std::cout << "-tuple found by worker thread " << threadId << std::endl;
				std::cout << "Base prime: " << basePrime << std::endl;
			}
			_works[workIndex].job.result = basePrime;
			_works[workIndex].job.resultPrimeCount = tupleLength;
			_works[workIndex].job.primorialNumber = _parameters.primorialNumber;
			_works[workIndex].job.primorialFactor = task.check.loop*_parameters.sieveSize + task.check.candidateIndexes[i];
			_works[workIndex].job.primorialOffset = _parameters.primorialOffsets[task.check.offsetId];
			_client->handleResult(_works[workIndex].job);
		}
	}
	_statManager.addCounts(tupleCounts);
}

void Miner::_doTasks(const uint16_t id) { // Worker Threads run here until the miner is stopped
	// Thread initialization.
	threadId = id;
	for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
		threadOffsetStack[i] = new uint64_t[offsetStackSize];
		threadOffsetCount[i] = new uint64_t[_parameters.maxIterations];
		for (uint64_t segment(0) ; segment < _parameters.maxIterations ; segment++)
			threadOffsetCount[i][segment] = 0;
	}
	// Threads are fetching tasks from the queues. The first part of the constellation search is sieving to generate candidates, which is done by the Presieve and Sieve tasks.
	// Once the candidates were generated, they are tested whether they are indeed base primes of constellations using the Fermat Test.
	while (_running) {
		Task task;
		if (!_presieveTasks.try_pop_front(task)) // Presieve Tasks have priority
			task = _tasks.blocking_pop_front();
		
		const auto startTime(std::chrono::steady_clock::now());
		if (task.type == Task::Type::Presieve) {
			_doPresieveTask(task);
			_presieveTime += std::chrono::duration_cast<decltype(_presieveTime)>(std::chrono::steady_clock::now() - startTime);
			_tasksDoneInfos.push_back(TaskDoneInfo{Task::Type::Presieve, .firstPrimeIndex = task.presieve.start});
		}
		if (task.type == Task::Type::Sieve) {
			_doSieveTask(task);
			_sieveTime += std::chrono::duration_cast<decltype(_sieveTime)>(std::chrono::steady_clock::now() - startTime);
			// The Sieve's Task Done Info is created in _doSieveTask
		}
		if (task.type == Task::Type::Check) {
			_doCheckTask(task);
			_verifyTime += std::chrono::duration_cast<decltype(_verifyTime)>(std::chrono::steady_clock::now() - startTime);
			_tasksDoneInfos.push_back(TaskDoneInfo{Task::Type::Check, .workIndex = task.workIndex});
		}
	}
	// Thread clean up.
	for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
		delete threadOffsetCount[i];
		delete threadOffsetStack[i];
	}
}

void Miner::_manageTasks() {
	Job job; // Block's data (target, blockheader if applicable, ...) from the Client
	_currentWorkIndex = 0;
	uint32_t oldHeight(0);
	while (_running && _client->getJob(job)) {
		_presieveTime = _presieveTime.zero();
		_sieveTime = _sieveTime.zero();
		_verifyTime = _verifyTime.zero();
		
		_works[_currentWorkIndex].job = job;
		const bool isNewHeight(oldHeight != _works[_currentWorkIndex].job.height);
		// Notify when the network found a block
		if (isNewHeight && oldHeight != 0) {
			_statManager.newBlock();
			std::cout << Stats::formattedTime(_statManager.timeSinceStart()) << " Block " << job.height << ", average " << FIXED(1) << _statManager.averageBlockTime() << " s, difficulty " << FIXED(3) << job.difficulty << std::endl;
		}
		// Candidates are in the form a*primorial + primorialOffset. target + remainderPrimorial is the first such number starting from the target.
		_works[_currentWorkIndex].remainderPrimorial = _primorial - (_works[_currentWorkIndex].job.target % _primorial) + _primorialOffsets[0];
		// Reset Segment Counts and create Presieve Tasks
		for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
			for (uint64_t j(0) ; j < _parameters.maxIterations; j++)
				_sieveInstances[i].segmentCounts[j] = 0;
		}
		uint64_t nPresieveTasks(_parameters.threads*8ULL);
		int32_t nRemainingHighPresieveTasks(0), nRemainingLowPresieveTasks(0);
		const uint32_t remainingTasks(_tasks.size());
		const uint64_t primesPerPresieveTask((_nPrimes - _parameters.primorialNumber)/nPresieveTasks + 1ULL);
		for (uint64_t start(_parameters.primorialNumber) ; start < _nPrimes ; start += primesPerPresieveTask) {
			const uint64_t end(std::min(_nPrimes, start + primesPerPresieveTask));
			_presieveTasks.push_back(Task{Task::Type::Presieve, _currentWorkIndex, .presieve = {start, end}});
			_tasks.push_front(Task{Task::Type::Dummy, _currentWorkIndex, {}}); // To ensure a thread wakes up to grab the mod work.
			if (start < _sparseLimit) nRemainingLowPresieveTasks++;
			else nRemainingHighPresieveTasks++;
		}
		
		while (nRemainingLowPresieveTasks > 0) {
			const TaskDoneInfo taskDoneInfo(_tasksDoneInfos.blocking_pop_front());
			if (!_running) return; // Can happen if stopThreads is called while this Thread is stuck in this blocking_pop_front().
			if (taskDoneInfo.type == Task::Type::Presieve) {
				if (taskDoneInfo.firstPrimeIndex < _sparseLimit) nRemainingLowPresieveTasks--;
				else nRemainingHighPresieveTasks--;
			}
			else if (taskDoneInfo.type == Task::Type::Check) _works[taskDoneInfo.workIndex].nRemainingCheckTasks--;
			else ERRORMSG("Unexpected Sieve Task done during Presieving");
		}
		assert(_works[_currentWorkIndex].nRemainingCheckTasks == 0);
		
		// Create Sieve Tasks
		for (uint32_t i(0) ; i < static_cast<uint32_t>(_parameters.sieveWorkers) ; i++) {
			_sieveInstances[i].presieveLock.lock();
			_tasks.push_front(Task{Task::Type::Sieve, _currentWorkIndex, .sieve = {i, 0}});
		}
		
		int nRemainingSieves(_parameters.sieveWorkers);
		while (nRemainingHighPresieveTasks > 0) {
			const TaskDoneInfo taskDoneInfo(_tasksDoneInfos.blocking_pop_front());
			if (!_running) return;
			if (taskDoneInfo.type == Task::Type::Presieve)  nRemainingHighPresieveTasks--;
			else if (taskDoneInfo.type == Task::Type::Sieve) nRemainingSieves--;
			else _works[taskDoneInfo.workIndex].nRemainingCheckTasks--;
		}
		for (int i(0) ; i < _parameters.sieveWorkers ; i++) _sieveInstances[i].presieveLock.unlock();
		
		uint32_t nRemainingTasksMin(std::min(remainingTasks, _tasks.size()));
		while (nRemainingSieves > 0) {
			const TaskDoneInfo taskDoneInfo(_tasksDoneInfos.blocking_pop_front());
			if (!_running) return;
			if (taskDoneInfo.type == Task::Type::Sieve) nRemainingSieves--;
			else if (taskDoneInfo.type == Task::Type::Check) _works[taskDoneInfo.workIndex].nRemainingCheckTasks--;
			else ERRORMSG("Unexpected Presieve Task done during Sieving");
			nRemainingTasksMin = std::min(nRemainingTasksMin, _tasks.size());
		}
		
		// Adjust the Remaining Tasks Threshold
		if (_works[_currentWorkIndex].job.height == _client->currentHeight() && !isNewHeight) {
			DBG(std::cout << "Min work outstanding during sieving: " << nRemainingTasksMin << std::endl;);
			if (remainingTasks > _nRemainingCheckTasksThreshold - _parameters.threads*2) {
				// If we are acheiving our work target, then adjust it towards the amount
				// required to maintain a healthy minimum work queue length.
				if (nRemainingTasksMin == 0) // Need more, but don't know how much, try adding some.
					_nRemainingCheckTasksThreshold += 4*_parameters.threads*_parameters.sieveWorkers;
				else { // Adjust towards target of min work = 4*threads.
					const uint32_t targetMaxWork((_nRemainingCheckTasksThreshold - nRemainingTasksMin) + 8*_parameters.threads);
					_nRemainingCheckTasksThreshold = (_nRemainingCheckTasksThreshold + targetMaxWork)/2;
				}
			}
			else if (nRemainingTasksMin > 4u*_parameters.threads) { // Didn't make the target, but also didn't run out of work. Can still adjust target.
				const uint32_t targetMaxWork((remainingTasks - nRemainingTasksMin) + 10*_parameters.threads);
				_nRemainingCheckTasksThreshold = (_nRemainingCheckTasksThreshold + targetMaxWork)/2;
			}
			else if (nRemainingTasksMin == 0 && remainingTasks > 0) {
				static int allowedFails(5);
				if (--allowedFails == 0) { // Warn possible CPU Underuse
					allowedFails = 5;
					DBG(std::cout << "Unable to generate enough verification work to keep threads busy." << std::endl;
					std::cout << "PTL = " << _parameters.primeTableLimit << ", sieve workers = " << _parameters.sieveWorkers << std::endl;);
				}
			}
			_nRemainingCheckTasksThreshold = std::min(_nRemainingCheckTasksThreshold, _tasksDoneInfos.size() - 9*_parameters.threads);
			DBG(std::cout << "Work target before starting next block now: " << _nRemainingCheckTasksThreshold << std::endl;);
		}
		
		oldHeight = _works[_currentWorkIndex].job.height;
		
		while (_works[_currentWorkIndex].nRemainingCheckTasks > _nRemainingCheckTasksThreshold) {
			const TaskDoneInfo taskDoneInfo(_tasksDoneInfos.blocking_pop_front());
			if (!_running) return;
			if (taskDoneInfo.type == Task::Type::Check) _works[taskDoneInfo.workIndex].nRemainingCheckTasks--;
			else ERRORMSG("Expected Check Task done");
		}
		_currentWorkIndex = (_currentWorkIndex + 1) % nWorks;
		while (_works[_currentWorkIndex].nRemainingCheckTasks > 0) {
			const TaskDoneInfo taskDoneInfo(_tasksDoneInfos.blocking_pop_front());
			if (!_running) return;
			if (taskDoneInfo.type == Task::Type::Check) _works[taskDoneInfo.workIndex].nRemainingCheckTasks--;
			else ERRORMSG("Expected Check Task done 2");
		}
		
		DBG(std::cout << "Job Timing: " << _presieveTime.count() << "/" << _sieveTime.count() << "/" << _verifyTime.count() << ", tasks: " << _works[0].nRemainingCheckTasks << ", " << _works[1].nRemainingCheckTasks << std::endl;);
	}
}

bool Miner::hasAcceptedPatterns(const std::vector<std::vector<uint64_t>> &acceptedConstellationsOffsets) const {
	for (const auto &acceptedPatterns : acceptedConstellationsOffsets) {
		bool compatible(true);
		for (uint16_t i(0) ; i < acceptedPatterns.size() ; i++) {
			if (i >= _parameters.pattern.size() ? true : acceptedPatterns[i] != _parameters.pattern[i]) {
				compatible = false;
				break;
			}
		}
		if (compatible)
			return true;
	}
	return false;
}

void Miner::printStats() const {
	Stats statsRecent(_statManager.stats(false)), statsSinceStart(_statManager.stats(true));
	if (_mode == "Benchmark" || _mode == "Search")
		statsRecent = statsSinceStart;
	std::cout << Stats::formattedTime(_statManager.timeSinceStart()) << " " << FIXED(2) << statsRecent.cps() << " c/s, r " << statsRecent.r();
	if (_mode != "Pool") {
		std::cout << " ; (1-" << _parameters.pattern.size() << "t) = " << statsSinceStart.formattedCounts(1);
		if (statsRecent.count(1) >= 10)
			std::cout << " | " << Stats::formattedDuration(statsRecent.estimatedAverageTimeToFindBlock(_works[_currentWorkIndex].job.primeCountTarget));
	}
	else {
		std::dynamic_pointer_cast<StratumClient>(_client)->printSharesStats();
		if (statsRecent.count(1) >= 10)
			std::cout << " | " << 86400.*(50./static_cast<double>(1 << _client->currentHeight()/840000))/statsRecent.estimatedAverageTimeToFindBlock(_works[_currentWorkIndex].job.primeCountTarget) << " RIC/d";
	}
	std::cout << std::endl;
}
bool Miner::benchmarkFinishedTimeOut(const double benchmarkTimeLimit) const {
	const Stats stats(_statManager.stats(true));
	return benchmarkTimeLimit > 0. && stats.duration() >= benchmarkTimeLimit;
}
bool Miner::benchmarkFinished2Tuples(const uint64_t benchmark2tupleCountLimit) const {
	const Stats stats(_statManager.stats(true));
	return benchmark2tupleCountLimit > 0 && stats.count(2) >= benchmark2tupleCountLimit;
}
void Miner::printBenchmarkResults() const {
	Stats stats(_statManager.stats(true));
	std::cout << "Benchmark finished after " << stats.duration() << " s." << std::endl;
	std::cout << "RESULTS: " << FIXED(6) << stats.cps() << " candidates/s, ratio " << stats.r() << " -> " << stats.estimatedAverageTimeToFindBlock(_works[_currentWorkIndex].job.primeCountTarget)/86400. << " block(s)/day" << std::endl;
}
void Miner::printTupleStats() const {
	Stats stats(_statManager.stats(true));
	std::cout << "Tuples found: " << stats.formattedCounts() << " in " << FIXED(6) << stats.duration() << " s" << std::endl;
	std::cout << "Tuple rates : " << stats.formattedRates() << std::endl;
	std::cout << "Tuple ratios: " << stats.formattedRatios() << std::endl;
}
