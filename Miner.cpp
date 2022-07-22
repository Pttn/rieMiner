/* (c) 2017-2022 Pttn (https://riecoin.dev/en/rieMiner)
(c) 2018-2020 Michael Bell/Rockhawk (assembly optimizations, improvements of work management between threads, and some more) (https://github.com/MichaelBell/) */

#include <gmpxx.h> // With Uint64_Ts, we still need to use the Mpz_ functions, otherwise there are "ambiguous overload" errors on Windows...
#include "Miner.hpp"

#ifdef __SSE2__
#include "external/gmp_util.h"
extern "C" {
	void rie_mod_1s_4p_cps(uint64_t *cps, uint64_t p);
	mp_limb_t rie_mod_1s_4p(mp_srcptr ap, mp_size_t n, uint64_t ps, uint64_t cnt, uint64_t* cps);
	mp_limb_t rie_mod_1s_2p_4times(mp_srcptr ap, mp_size_t n, uint32_t* ps, uint32_t cnt, uint64_t* cps, uint64_t* remainders);
#ifdef __AVX2__
	mp_limb_t rie_mod_1s_2p_8times(mp_srcptr ap, mp_size_t n, uint32_t* ps, uint32_t cnt, uint64_t* cps, uint64_t* remainders);
#endif
}
#else
uint64_t mulMod(const uint64_t a, const uint64_t b, const uint64_t c) { // (ab) % c without assembly optimizations
#ifdef __SIZEOF_INT128__
	return (static_cast<__uint128_t>(a)*b) % c;
#else
	mpz_class tmp;
	mpz_set_ui(tmp.get_mpz_t(), a);
	mpz_mul_ui(tmp.get_mpz_t(), tmp.get_mpz_t(), b);
	return mpz_tdiv_ui(tmp.get_mpz_t(), c);
#endif
}
#endif

constexpr uint64_t nPrimesTo2p32(203280221);
constexpr int factorsCacheSize(16384);
constexpr uint16_t maxSieveWorkers(64); // There is a noticeable performance penalty using Std Vector or Arrays so we are using Raw Arrays.
thread_local uint64_t** factorsCache{nullptr};
thread_local uint64_t** factorsCacheCounts{nullptr};
thread_local uint16_t threadId(65535);

void Miner::init(const MinerParameters &minerParameters) {
	_shouldRestart = false;
	if (_inited) {
		ERRORMSG("The miner is already inited");
		return;
	}
	if (_client == nullptr) {
		ERRORMSG("The miner cannot be initialized without a client");
		return;
	}
	Job job(_client->getJob(true));
	if (job.powVersion == 0) { // Using this check rather than Height = 0 to make Benchmark Mode work
		std::cout << "Could not get data from Client :|" << std::endl;
		return;
	}
	_difficultyAtInit = job.difficulty;
	
	std::cout << "Initializing miner..." << std::endl;
	// Get settings from Configuration File.
	_parameters = minerParameters;
	if (_parameters.threads == 0) {
		_parameters.threads = std::thread::hardware_concurrency();
		if (_parameters.threads == 0) {
			std::cout << "Could not detect number of Threads, setting to 1." << std::endl;
			_parameters.threads = 1;
		}
	}
	std::cout << "Threads: " << _parameters.threads;
	if (_parameters.primorialOffsets.size() == 0) { // Set the default Primorial Offsets if not chosen (must be chosen if the chosen pattern is not hardcoded)
		auto defaultPrimorialOffsetsIterator(std::find_if(defaultConstellationData.begin(), defaultConstellationData.end(), [this](const auto& constellationData) {return constellationData.first == _parameters.pattern;}));
		if (defaultPrimorialOffsetsIterator == defaultConstellationData.end()) {
			std::cout << std::endl << "Not hardcoded Constellation Offsets chosen and no Primorial Offset set." << std::endl;
			return;
		}
		else
			_parameters.primorialOffsets = defaultPrimorialOffsetsIterator->second;
	}
	_primorialOffsets = v64ToVMpz(_parameters.primorialOffsets);
	if (_parameters.sieveWorkers == 0) {
		double proportion;
		if (_parameters.pattern.size() >= 7) proportion = 0.85 - _difficultyAtInit/1920.;
		else if (_parameters.pattern.size() == 6) proportion = 0.75 - _difficultyAtInit/1792.;
		else if (_parameters.pattern.size() == 5) proportion = 0.7 - _difficultyAtInit/1280.;
		else if (_parameters.pattern.size() == 4) proportion = 0.5 - _difficultyAtInit/1280.;
		else proportion = 0.;
		if (proportion < 0.) proportion = 0.;
		if (proportion > 1.) proportion = 1.;
		_parameters.sieveWorkers = std::ceil(proportion*static_cast<double>(_parameters.threads));
	}
	_parameters.sieveWorkers = std::min(static_cast<int>(_parameters.sieveWorkers), static_cast<int>(_parameters.threads) - 1);
	_parameters.sieveWorkers = std::max(static_cast<int>(_parameters.sieveWorkers), 1);
	_parameters.sieveWorkers = std::min(_parameters.sieveWorkers, maxSieveWorkers);
	_parameters.sieveWorkers = std::min(static_cast<int>(_parameters.sieveWorkers), static_cast<int>(_primorialOffsets.size()));
	std::cout << " (" << _parameters.sieveWorkers << " Sieve Worker(s))" << std::endl;
	std::vector<uint64_t> cumulativeOffsets(_parameters.pattern.size(), 0);
	std::partial_sum(_parameters.pattern.begin(), _parameters.pattern.end(), cumulativeOffsets.begin(), std::plus<uint64_t>());
	std::cout << "Constellation pattern: n + (" << formatContainer(cumulativeOffsets) << "), length " << _parameters.pattern.size() << std::endl;
	if (_mode == "Search") {
		if (_parameters.tupleLengthMin < 1 || _parameters.tupleLengthMin > _parameters.pattern.size())
			_parameters.tupleLengthMin = std::max(1, static_cast<int>(_parameters.pattern.size()) - 1);
		std::cout << "Will show tuples of at least length " << _parameters.tupleLengthMin << std::endl;
	}
	
	if (_parameters.primeTableLimit == 0) {
		uint64_t primeTableLimitMax(2147483648ULL);
		if (sysInfo.getPhysicalMemory() < 1073741824ULL)
			primeTableLimitMax = 268435456ULL;
		else if (sysInfo.getPhysicalMemory() < 8589934592ULL)
			primeTableLimitMax = sysInfo.getPhysicalMemory()/4ULL;
		_parameters.primeTableLimit = std::pow(_difficultyAtInit, 6.)/std::pow(2., 3.*static_cast<double>(_parameters.pattern.size()) + 7.);
		if (_parameters.threads > 16) {
			_parameters.primeTableLimit *= 16;
			_parameters.primeTableLimit /= static_cast<double>(_parameters.threads);
		}
		_parameters.primeTableLimit = std::min(_parameters.primeTableLimit, primeTableLimitMax);
	}
	std::cout << "Prime Table Limit: " << _parameters.primeTableLimit << std::endl;
	std::transform(_parameters.pattern.begin(), _parameters.pattern.end(), std::back_inserter(_halfPattern), [](uint64_t n) {return n >> 1;});
	
	std::vector<uint64_t> primes;
	uint64_t primeTableFileBytes, savedPrimes(0), largestSavedPrime;
	std::fstream file(primeTableFile);
	if (file) {
		file.seekg(0, std::ios::end);
		primeTableFileBytes = file.tellg();
		savedPrimes = primeTableFileBytes/sizeof(decltype(primes)::value_type);
		if (savedPrimes > 0) {
			file.seekg(-static_cast<int64_t>(sizeof(decltype(primes)::value_type)), std::ios::end);
			file.read(reinterpret_cast<char*>(&largestSavedPrime), sizeof(decltype(primes)::value_type));
		}
	}
	std::chrono::time_point<std::chrono::steady_clock> t0(std::chrono::steady_clock::now());
	if (savedPrimes > 0 && _parameters.primeTableLimit >= 1048576 && _parameters.primeTableLimit <= largestSavedPrime) {
		std::cout << "Extracting prime numbers from " << primeTableFile << " (" << primeTableFileBytes << " bytes, " << savedPrimes << " primes, largest " << largestSavedPrime << ")..." << std::endl;
		uint64_t nPrimesUpperBound(std::min(1.085*static_cast<double>(_parameters.primeTableLimit)/std::log(static_cast<double>(_parameters.primeTableLimit)), static_cast<double>(savedPrimes))); // 1.085 = max(π(p)log(p)/p) for p >= 2^20
		try {
			primes = std::vector<uint64_t>(nPrimesUpperBound);
		}
		catch (std::bad_alloc& ba) {
			ERRORMSG("Unable to allocate memory for the prime table");
			_suggestLessMemoryIntensiveOptions(_parameters.primeTableLimit/8, _parameters.sieveWorkers);
			return;
		}
		file.seekg(0, std::ios::beg);
		file.read(reinterpret_cast<char*>(primes.data()), nPrimesUpperBound*sizeof(decltype(primes)::value_type));
		file.close();
		for (auto i(primes.size() - 1) ; i > 0 ; i--) {
			if (primes[i] <= _parameters.primeTableLimit) {
				primes.resize(i + 1);
				break;
			}
		}
		std::cout << primes.size() << " first primes extracted in " << timeSince(t0) << " s (" << primes.size()*sizeof(decltype(primes)::value_type) << " bytes)." << std::endl;
	}
	else {
		std::cout << "Generating prime table using sieve of Eratosthenes..." << std::endl;
		try {
			primes = generatePrimeTable(_parameters.primeTableLimit);
		}
		catch (std::bad_alloc& ba) {
			ERRORMSG("Unable to allocate memory for the prime table");
			_suggestLessMemoryIntensiveOptions(_parameters.primeTableLimit/8, _parameters.sieveWorkers);
			return;
		}
		std::cout << "Table with all " << primes.size() << " first primes generated in " << timeSince(t0) << " s (" << primes.size()*sizeof(decltype(primes)::value_type) << " bytes)." << std::endl;
	}

	if (primes.size() % 2 == 1) // Needs to be even to use SIMD sieving optimizations
		primes.pop_back();
	
	try {
		_primes32.reserve(std::min(static_cast<decltype(_primes32)::value_type>(nPrimesTo2p32), static_cast<decltype(_primes32)::value_type>(primes.size())));
		if (primes.size() > nPrimesTo2p32) _primes64.reserve(primes.size() - nPrimesTo2p32);
	}
	catch (std::bad_alloc& ba) {
		ERRORMSG("Unable to allocate memory for the prime table");
		_suggestLessMemoryIntensiveOptions(_parameters.primeTableLimit/8, _parameters.sieveWorkers);
		return;
	}

	for (size_t i = 0; i < primes.size(); ++i) {
		if (primes[i] < (1ULL << 32)) _primes32.push_back(primes[i]);
		else _primes64.push_back(primes[i]);
	}

	_nPrimes = primes.size();
	_nPrimes32 = _primes32.size();
	primes.clear();

	if (_parameters.sieveBits == 0) {
		if (sysInfo.getCpuArchitecture() == "x64")
			_parameters.sieveBits = _parameters.sieveWorkers <= 4 ? 25 : 24;
		else
			_parameters.sieveBits = _parameters.sieveWorkers <= 4 ? 23 : 22;
	}
	_parameters.sieveSize = 1 << _parameters.sieveBits;
	_parameters.sieveWords = _parameters.sieveSize/64;
	std::cout << "Sieve Size: " << "2^" << _parameters.sieveBits << " = " << _parameters.sieveSize << " (" << _parameters.sieveWords << " words)" << std::endl;
	if (_parameters.sieveIterations == 0)
		_parameters.sieveIterations = 16;
	std::cout << "Sieve Iterations: " << _parameters.sieveIterations << std::endl;
	_factorMax = _parameters.sieveIterations*_parameters.sieveSize;
	std::cout << "Primorial Factor Max: " << _factorMax << std::endl;
	
	uint32_t bitsForOffset;
	// The primorial times the maximum factor should be smaller than the allowed limit for the target offset.
	if (_mode == "Solo" || _mode == "Pool")
		bitsForOffset = std::floor(static_cast<double>(_difficultyAtInit)/_parameters.restartDifficultyFactor - 265.); // 1 . leading 8 bits . hash (256 bits) . remaining bits for the offset, and some margin to take in account the Difficulty fluctuations
	else if (_mode == "Search")
		bitsForOffset = std::floor(_difficultyAtInit - 97.); // 1 . leading 16 bits . random 80 bits . remaining bits for the offset
	else
		bitsForOffset = std::floor(_difficultyAtInit - 81.); // 1 . leading 16 bits . constructed 64 bits . remaining bits for the offset
	mpz_class primorialLimit(1);
	primorialLimit <<= bitsForOffset;
	primorialLimit /= u64ToMpz(_factorMax);
	if (primorialLimit == 0) {
		std::cout << "The Difficulty is too low. Try to increase it or decrease the Sieve Size/Iterations." << std::endl;
		std::cout << "Available digits for the offsets: " << bitsForOffset << std::endl;
		return;
	}
	mpz_set_ui(_primorial.get_mpz_t(), 1);
	for (uint64_t i(0) ; i < _primes32.size() ; i++) {
		if (i == _parameters.primorialNumber && _parameters.primorialNumber != 0)
			break;
		else {
			if (_primorial*_primes32[i] >= primorialLimit) {
				if (_parameters.primorialNumber != 0)
					std::cout << "The provided Primorial Number " <<_parameters.primorialNumber  << " is too large and will be reduced." << std::endl;
				_parameters.primorialNumber = i;
				break;
			}
		}
		_primorial *= _primes32[i];
		if (i + 1 == _primes32.size())
			_parameters.primorialNumber = i + 1;
	}
	std::cout << "Primorial Number: " << _parameters.primorialNumber << std::endl;
	std::cout << "Primorial: p" << _parameters.primorialNumber << "# = " << _primes32[_parameters.primorialNumber - 1] << "# = ";
	if (mpz_sizeinbase(_primorial.get_mpz_t(), 10) < 18)
		std::cout << _primorial;
	else
		std::cout << "~" << _primorial.get_str()[0] << "." << _primorial.get_str().substr(1, 12) << "*10^" << _primorial.get_str().size() - 1;
	std::cout << " (" << mpz_sizeinbase(_primorial.get_mpz_t(), 2) << " bits)" << std::endl;
	std::cout << "Primorial Offsets: " << _primorialOffsets.size() << std::endl;
	_primorialOffsetDiff.resize(_parameters.sieveWorkers - 1);
	const uint64_t constellationDiameter(cumulativeOffsets.back());
	for (int j(1) ; j < _parameters.sieveWorkers ; j++)
		_primorialOffsetDiff[j - 1] = _parameters.primorialOffsets[j] - _parameters.primorialOffsets[j - 1] - constellationDiameter;
	
	uint64_t additionalFactorsCountEstimation(0); // tupleSize*factorMax*(sum of 1/p, for p in the prime table >= factorMax); it is the estimation of how many such p will eliminate a factor (factorMax/p being the probability of the modulo p being < factorMax)
	double sumInversesOfPrimes(0.);
	_primesIndexThreshold = 0; // Number of prime numbers smaller than factorMax in the table
	for (uint64_t i(0) ; i < _nPrimes ; i++) {
		const uint64_t p(_getPrime(i));
		if (p >= _factorMax) {
			if (_primesIndexThreshold == 0) {
				_primesIndexThreshold = i;
				if (_primesIndexThreshold % 2 == 1) // Needs to be even to use SIMD sieving optimizations
					_primesIndexThreshold--;
			}
			sumInversesOfPrimes += 1./static_cast<double>(p);
		}
	}
	if (_primesIndexThreshold == 0)
		_primesIndexThreshold = _nPrimes;
	std::cout << "Prime index threshold: " << _primesIndexThreshold << std::endl;
	const uint64_t factorsToEliminateEntries(_parameters.pattern.size()*_primesIndexThreshold); // PatternLength entries for every prime < factorMax
	additionalFactorsCountEstimation = _parameters.pattern.size()*ceil(static_cast<double>(_factorMax)*sumInversesOfPrimes);
	const uint64_t additionalFactorsEntriesPerIteration(17ULL*(additionalFactorsCountEstimation/_parameters.sieveIterations)/16ULL + 64ULL); // Have some margin
	std::cout << "Estimated additional factors: " << additionalFactorsCountEstimation << " (allocated per iteration: " << additionalFactorsEntriesPerIteration << ")" << std::endl;
	{
#ifdef __SSE2__
		std::cout << "Precomputing modular inverses and division data..." << std::endl; // The precomputed data is used to speed up computations in _doPresieveTask.
#else
		std::cout << "Precomputing modular inverses..." << std::endl;
#endif
		t0 = std::chrono::steady_clock::now();
#ifdef __SSE2__
		const uint64_t precompPrimes(std::min(_nPrimes, 5586502348UL)); // Precomputation only works up to p = 2^37
#endif
		try {
			_modularInverses32.resize(_primes32.size());
			_modularInverses64.resize(_primes64.size()); // Table of inverses of the primorial modulo a prime number in the table with index >= primorialNumber.
#ifdef __SSE2__
			_modPrecompute.resize(precompPrimes);
#endif
		}
		catch (std::bad_alloc& ba) {
			ERRORMSG("Unable to allocate memory for the precomputed data");
			_suggestLessMemoryIntensiveOptions(_parameters.primeTableLimit/4, _parameters.sieveWorkers);
			return;
		}
		const uint64_t blockSize((_nPrimes - _parameters.primorialNumber + _parameters.threads - 1)/_parameters.threads);
		std::thread threads[_parameters.threads];
		for (uint16_t j(0) ; j < _parameters.threads ; j++) {
			threads[j] = std::thread([&, j]() {
				mpz_class modularInverse, prime;
				const uint64_t endIndex(std::min(_parameters.primorialNumber + (j + 1)*blockSize, _nPrimes));
				for (uint64_t i(_parameters.primorialNumber + j*blockSize) ; i < endIndex ; i++) {
					uint64_t p(_getPrime(i));
					mpz_set_ui(prime.get_mpz_t(), p);
					mpz_invert(modularInverse.get_mpz_t(), _primorial.get_mpz_t(), prime.get_mpz_t()); // modularInverse*primorial ≡ 1 (mod prime)
					if (i < nPrimesTo2p32) _modularInverses32[i] = static_cast<uint32_t>(mpz_get_ui(modularInverse.get_mpz_t()));
					else _modularInverses64[i - nPrimesTo2p32] = mpz_get_ui(modularInverse.get_mpz_t());
#ifdef __SSE2__
					if (i < precompPrimes)
						rie_mod_1s_4p_cps(&_modPrecompute[i], p);
#endif
				}
			});
		}
		for (uint16_t j(0) ; j < _parameters.threads ; j++) threads[j].join();
#ifdef __SSE2__
		std::cout << "Tables of " << _modularInverses32.size() + _modularInverses64.size() - _parameters.primorialNumber << " modular inverses and " << precompPrimes - _parameters.primorialNumber << " division entries generated in " << timeSince(t0) << " s (" << (_modularInverses64.size() + precompPrimes)*sizeof(decltype(_modularInverses64)::value_type) + _modularInverses32.size()*sizeof(decltype(_modularInverses32)::value_type) << " bytes)." << std::endl;
#else
		std::cout << "Tables of " << _modularInverses32.size() + _modularInverses64.size() - _parameters.primorialNumber << " modular inverses generated in " << timeSince(t0) << " s (" << _modularInverses64.size()*sizeof(decltype(_modularInverses64)::value_type) + _modularInverses32.size()*sizeof(decltype(_modularInverses32)::value_type) << " bytes)." << std::endl;
#endif
	}
	
	try {
		std::vector<Sieve> sieves(_parameters.sieveWorkers);
		_sieves.swap(sieves);
		for (std::vector<Sieve>::size_type i(0) ; i < _sieves.size() ; i++) {
			_sieves[i].id = i;
			_sieves[i].additionalFactorsToEliminateCounts = new std::atomic<uint64_t>[_parameters.sieveIterations];
		}
		std::cout << "Allocating " << sizeof(uint64_t)*_parameters.sieveWorkers*_parameters.sieveWords << " bytes for the primorial factors tables..." << std::endl;
		for (auto &sieve : _sieves)
			sieve.factorsTable = new uint64_t[_parameters.sieveWords];
	}
	catch (std::bad_alloc& ba) {
		ERRORMSG("Unable to allocate memory for the primorial factors tables");
		_suggestLessMemoryIntensiveOptions(_parameters.primeTableLimit/3, _parameters.sieveWorkers);
		return;
	}
	
	try {
		std::cout << "Allocating " << sizeof(uint32_t)*_parameters.sieveWorkers*factorsToEliminateEntries << " bytes for the primorial factors..." << std::endl;
		for (auto &sieve : _sieves) {
#ifdef __SSE2__
			sieve.factorsToEliminate = reinterpret_cast<uint32_t*>(new __m256i[(factorsToEliminateEntries + 7) / 8]);
#else
			sieve.factorsToEliminate = new uint32_t[factorsToEliminateEntries];
#endif
			memset(sieve.factorsToEliminate, 0, sizeof(uint32_t)*factorsToEliminateEntries);
		}
	}
	catch (std::bad_alloc& ba) {
		ERRORMSG("Unable to allocate memory for the primorial factors");
		_suggestLessMemoryIntensiveOptions(_parameters.primeTableLimit/2, std::max(static_cast<int>(_parameters.sieveWorkers) - 1, 1));
		return;
	}
	
	try {
		std::cout << "Allocating " << sizeof(uint32_t)*_parameters.sieveWorkers*_parameters.sieveIterations*additionalFactorsEntriesPerIteration << " bytes for the additional primorial factors..." << std::endl;
		for (auto &sieve : _sieves) {
			sieve.additionalFactorsToEliminate = new uint32_t*[_parameters.sieveIterations];
			for (uint64_t j(0) ; j < _parameters.sieveIterations ; j++)
				sieve.additionalFactorsToEliminate[j] = new uint32_t[additionalFactorsEntriesPerIteration];
		}
	}
	catch (std::bad_alloc& ba) {
		ERRORMSG("Unable to allocate memory for the additional primorial factors");
		_suggestLessMemoryIntensiveOptions(2*_parameters.primeTableLimit/3, std::max(static_cast<int>(_parameters.sieveWorkers) - 1, 1));
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
		if (!_keepStats)
			_statManager.start(_parameters.pattern.size());
		_keepStats = false;
		std::cout << "Starting the miner's master thread..." << std::endl;
		_masterThread = std::thread(&Miner::_manageTasks, this);
		std::cout << "Starting " << _parameters.threads << " miner's worker threads..." << std::endl;
		for (uint16_t i(0) ; i < _parameters.threads ; i++)
			_workerThreads.push_back(std::thread(&Miner::_doTasks, this, i));
		std::cout << "-----------------------------------------------------------" << std::endl;
		if (_mode == "Benchmark" || _mode == "Search")
			std::cout << Stats::formattedTime(_statManager.timeSinceStart()) << " Started " << _mode << ", difficulty " << FIXED(3) << _client->currentDifficulty() << std::endl;
		else
			std::cout << Stats::formattedClockTimeNow() << " Started mining at block " << _client->currentHeight() << ", difficulty " << FIXED(3) << _client->currentDifficulty() << std::endl;
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
		_tasksDoneInfos.push_front(TaskDoneInfo{Task::Type::Dummy, {}}); // Unblock if master thread stuck in blocking_pop_front().
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
		for (auto &sieve : _sieves) {
			delete[] sieve.factorsTable;
#ifdef __SSE2__
			delete[] reinterpret_cast<__m256i*>(sieve.factorsToEliminate);
#else
			delete[] sieve.factorsToEliminate;
#endif
			for (uint64_t j(0) ; j < _parameters.sieveIterations ; j++)
				delete[] sieve.additionalFactorsToEliminate[j];
			delete[] sieve.additionalFactorsToEliminate;
			delete[] sieve.additionalFactorsToEliminateCounts;
		}
		_sieves.clear();
		_primes32.clear();
		_primes64.clear();
		_modularInverses32.clear();
		_modularInverses64.clear();
#ifdef __SSE2__
		_modPrecompute.clear();
#endif
		_primorialOffsets.clear();
		_halfPattern.clear();
		_primorialOffsetDiff.clear();
		_parameters = MinerParameters();
		std::cout << "Miner's data cleared." << std::endl;
	}
}

void Miner::_addCachedAdditionalFactorsToEliminate(Sieve& sieve, uint64_t *factorsCache, uint64_t *factorsCacheCounts, const int factorsCacheTotalCount) {
	for (uint64_t i(0) ; i < _parameters.sieveIterations ; i++) // Initialize the counts for use as index and update the sieve's one
		factorsCacheCounts[i] = sieve.additionalFactorsToEliminateCounts[i].fetch_add(factorsCacheCounts[i]);
	for (int i(0) ; i < factorsCacheTotalCount ; i++) {
		const uint64_t factor(factorsCache[i]),
		               sieveIteration(factor >> _parameters.sieveBits),
		               indexInFactorsTable(factorsCacheCounts[sieveIteration]);
		sieve.additionalFactorsToEliminate[sieveIteration][indexInFactorsTable] = factor & (_parameters.sieveSize - 1); // factor % sieveSize
		factorsCacheCounts[sieveIteration]++;
	}
	for (uint64_t i(0) ; i < _parameters.sieveIterations ; i++)
		factorsCacheCounts[i] = 0;
}

void Miner::_doPresieveTask(const Task &task) {
	const uint64_t workIndex(task.workIndex), firstPrimeIndex(task.presieve.start), lastPrimeIndex(task.presieve.end);
	const mpz_class firstCandidate(_works[workIndex].primorialMultipleStart + _primorialOffsets[0]);
	std::array<int, maxSieveWorkers> factorsCacheTotalCounts{0};
	uint64_t** factorsCacheRef(factorsCache); // On Windows, caching these thread_local pointers on the stack makes a noticeable perf difference.
	uint64_t** factorsCacheCountsRef(factorsCacheCounts);
#ifdef __SSE2__
	const uint64_t precompLimit(_modPrecompute.size()), tupleSize(_parameters.pattern.size());
	uint64_t avxLimit(0);
#ifdef __AVX2__
	const uint64_t avxWidth(8);
#else
	const uint64_t avxWidth(4);
#endif
	if (sysInfo.hasAVX()) {
		avxLimit = nPrimesTo2p32 - avxWidth;
		avxLimit -= (avxLimit - firstPrimeIndex) & (avxWidth - 1);  // Must be enough primes in range to use AVX
	}
	uint64_t nextRemainder[8];
	uint64_t nextRemainderIndex(8);
#else
	const uint64_t tupleSize(_parameters.pattern.size());
#endif
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i++) {
		const uint64_t p(_getPrime(i));
		uint64_t mi[4];
		mi[0] = _getModularInverse(i); // Modular inverse of the primorial: mi[0]*primorial ≡ 1 (mod p). The modularInverses were precomputed in init().
		mi[1] = (mi[0] << 1); // mi[i] = (2*i*mi[0]) % p for i > 0.
		if (mi[1] >= p) mi[1] -= p;
		mi[2] = mi[1] << 1;
		if (mi[2] >= p) mi[2] -= p;
		mi[3] = mi[1] + mi[2];
		if (mi[3] >= p) mi[3] -= p;
		// Compute the first eliminated primorial factor for p fp, using precomputation speed up if available.
		// fp is the solution of firstCandidate + primorial*f ≡ 0 (mod p) for 0 <= f < p: fp = (p - (firstCandidate % p))*mi[0] % p.
		// In the sieving phase, numbers of the form firstCandidate + (p*i + fp)*primorial for 0 <= i < factorMax are eliminated as they are divisible by p.
		// This is for the first number of the constellation. Later, the mi[1-3] will be used to adjust fp for the other elements of the constellation.
#ifdef __SSE2__
		uint64_t fp, cnt(0ULL), ps(0ULL);
		if (i < precompLimit) { // Assembly optimized computation of fp by Michael Bell
			bool haveRemainder(false);
			if (nextRemainderIndex < avxWidth) {
				fp = nextRemainder[nextRemainderIndex++];
				cnt = __builtin_clzll(p);
				ps = p << cnt;
				haveRemainder = true;
			}
			else if (i < avxLimit) {
				cnt = __builtin_clz(static_cast<uint32_t>(p));
				if (__builtin_clz(static_cast<uint32_t>(_primes32[i + avxWidth - 1])) == cnt) {
					uint32_t ps32[8];
					for (uint64_t j(0) ; j < avxWidth; j++) {
						ps32[j] = static_cast<uint32_t>(_primes32[i + j]) << cnt;
						nextRemainder[j] = _modularInverses32[i + j];
					}
#ifdef __AVX2__
					rie_mod_1s_2p_8times(firstCandidate.get_mpz_t()->_mp_d, firstCandidate.get_mpz_t()->_mp_size, &ps32[0], cnt, &_modPrecompute[i], &nextRemainder[0]);
#else
					rie_mod_1s_2p_4times(firstCandidate.get_mpz_t()->_mp_d, firstCandidate.get_mpz_t()->_mp_size, &ps32[0], cnt, &_modPrecompute[i], &nextRemainder[0]);
#endif
					haveRemainder = true;
					fp = nextRemainder[0];
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
				fp = r >> cnt;
			}
		}
		else { // Basic computation of fp
			const uint64_t remainder(mpz_tdiv_ui(firstCandidate.get_mpz_t(), p)), pa(p - remainder);
			uint64_t q, n[2];
			umul_ppmm(n[1], n[0], pa, mi[0]);
			udiv_qrnnd(q, fp, n[1], n[0], p);
		}
#else
		const uint64_t remainder(mpz_tdiv_ui(firstCandidate.get_mpz_t(), p)), pa(p - remainder);
		uint64_t fp(mulMod(pa, mi[0], p)); // (pa*mi[0]) % p
#endif

		// We use a macro here to ensure the compiler inlines the code, and also make it easier to early
		// out of the function completely if the current height has changed.
#define addFactorsToEliminateForP(sieveWorkerIndex) {						                                                   \
			if (i < _primesIndexThreshold) {			                                                                       \
				_sieves[sieveWorkerIndex].factorsToEliminate[tupleSize*i] = fp;		                                           \
				for (std::vector<uint64_t>::size_type f(1) ; f < _halfPattern.size() ; f++) {		                           \
					if (fp < mi[_halfPattern[f]]) fp += p;	                                                                   \
					fp -= mi[_halfPattern[f]];	                                                                               \
					_sieves[sieveWorkerIndex].factorsToEliminate[tupleSize*i + f] = fp;	                                       \
				}		                                                                                                       \
			}			                                                                                                       \
			else {			                                                                                                   \
				if (factorsCacheTotalCounts[sieveWorkerIndex] + _halfPattern.size() >= factorsCacheSize) {		           \
					if (_works[workIndex].job.height != _client->currentHeight())	                                           \
						return;                                                                                                \
					_addCachedAdditionalFactorsToEliminate(_sieves[sieveWorkerIndex], factorsCacheRef[sieveWorkerIndex], factorsCacheCountsRef[sieveWorkerIndex], factorsCacheTotalCounts[sieveWorkerIndex]); \
					factorsCacheTotalCounts[sieveWorkerIndex] = 0;	                                                   \
				}		                                                                                                       \
				if (fp < _factorMax) {		                                                                                   \
					factorsCacheRef[sieveWorkerIndex][factorsCacheTotalCounts[sieveWorkerIndex]++] = fp;	   \
					factorsCacheCountsRef[sieveWorkerIndex][fp >> _parameters.sieveBits]++;	                       \
				}		                                                                                                       \
				for (std::vector<uint64_t>::size_type f(1) ; f < _halfPattern.size() ; f++) {		                           \
					if (fp < mi[_halfPattern[f]]) fp += p;	                                                                   \
					fp -= mi[_halfPattern[f]];	                                                                               \
					if (fp < _factorMax) {	                                                                                   \
						factorsCacheRef[sieveWorkerIndex][factorsCacheTotalCounts[sieveWorkerIndex]++] = fp; \
						factorsCacheCountsRef[sieveWorkerIndex][fp >> _parameters.sieveBits]++;                    \
					}	                                                                                                       \
				}		                                                                                                       \
			}		                                                                                                           \
		};
		addFactorsToEliminateForP(0);
		if (_parameters.sieveWorkers == 1) continue;
		
		// Recompute fp to adjust to the PrimorialOffsets of other Sieve Workers.
#ifdef __SSE2__
		uint64_t r;
#define recomputeFp(sieveWorkerIndex) {				                                      \
			if (i < precompLimit && _primorialOffsetDiff[sieveWorkerIndex - 1] < p) {	  \
				uint64_t n[2];                                                            \
				uint64_t os(_primorialOffsetDiff[sieveWorkerIndex - 1] << cnt);           \
				umul_ppmm(n[1], n[0], os, mi[0]);                                         \
				udiv_rnnd_preinv(r, n[1], n[0], ps, _modPrecompute[i]);                   \
				r >>= cnt;                                                                \
			}	                                                                          \
			else {	                                                                      \
				uint64_t q, n[2];                                                         \
				umul_ppmm(n[1], n[0], _primorialOffsetDiff[sieveWorkerIndex - 1], mi[0]); \
				udiv_qrnnd(q, r, n[1], n[0], p);                                          \
			}                                                                             \
		}
		recomputeFp(1);
#else
		uint64_t r(mulMod(_primorialOffsetDiff[0], mi[0], p));
#endif
		if (fp < r) fp += p;
		fp -= r;
		addFactorsToEliminateForP(1);
		
		for (int j(2) ; j < _parameters.sieveWorkers ; j++) {
			if (_primorialOffsetDiff[j - 1] != _primorialOffsetDiff[j - 2])
#ifdef __SSE2__
				recomputeFp(j);
#else
				r = mulMod(_primorialOffsetDiff[j - 1], mi[0], p);
#endif
			if (fp < r) fp += p;
			fp -= r;
			addFactorsToEliminateForP(j);
		}
	}
	
	if (lastPrimeIndex > _primesIndexThreshold) {
		for (int j(0) ; j < _parameters.sieveWorkers ; j++) {
			if (factorsCacheTotalCounts[j] > 0) {
				_addCachedAdditionalFactorsToEliminate(_sieves[j], factorsCacheRef[j], factorsCacheCountsRef[j], factorsCacheTotalCounts[j]);
				factorsCacheTotalCounts[j] = 0;
			}
		}
	}
}

void Miner::_processSieve(uint64_t *factorsTable, uint32_t* factorsToEliminate, const uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex) {
	const uint64_t tupleSize(_parameters.pattern.size());
	std::array<uint32_t, sieveCacheSize> sieveCache{0};
	uint64_t sieveCachePos(0);
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i++) {
		const uint32_t p(_primes32[i]);
		for (uint64_t f(0) ; f < tupleSize; f++) {
			while (factorsToEliminate[i*tupleSize + f] < _parameters.sieveSize) { // Eliminate primorial factors of the form p*m + fp for every m*p in the current table.
				_addToSieveCache(factorsTable, sieveCache, sieveCachePos, factorsToEliminate[i*tupleSize + f]);
				factorsToEliminate[i*tupleSize + f] += p; // Increment the m
			}
			factorsToEliminate[i*tupleSize + f] -= _parameters.sieveSize; // Prepare for the next iteration
		}
	}
	_endSieveCache(factorsTable, sieveCache);
}

#ifdef __SSE2__
void Miner::_processSieve6(uint64_t *factorsTable, uint32_t* factorsToEliminate, uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex) { // Assembly optimized sieving for 6-tuples by Michael Bell
	assert(_parameters.pattern.size() == 6);
	assert((lastPrimeIndex & 1) == 0);
	// Already eliminate for the first prime to sieve if it is odd to align for the optimizations
	if ((firstPrimeIndex & 1) != 0) {
		for (uint64_t f(0) ; f < 6 ; f++) {
			while (factorsToEliminate[firstPrimeIndex*6 + f] < _parameters.sieveSize) {
				factorsTable[factorsToEliminate[firstPrimeIndex*6 + f] >> 6U] |= (1ULL << ((factorsToEliminate[firstPrimeIndex*6 + f] & 63U)));
				factorsToEliminate[firstPrimeIndex*6 + f] += _primes32[firstPrimeIndex];
			}
			factorsToEliminate[firstPrimeIndex*6 + f] -= _parameters.sieveSize;
		}
		firstPrimeIndex++;
	}
	xmmreg_t offsetmax;
	offsetmax.m128 = _mm_set1_epi32(_parameters.sieveSize);
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i += 2) {
		xmmreg_t p1, p2, p3;
		xmmreg_t factor1, factor2, factor3, nextIncr1, nextIncr2, nextIncr3;
		xmmreg_t cmpres1, cmpres2, cmpres3;
		p1.m128 = _mm_set1_epi32(_primes32[i]);
		p3.m128 = _mm_set1_epi32(_primes32[i + 1]);
		p2.m128 = _mm_castps_si128(_mm_shuffle_ps(_mm_castsi128_ps(p1.m128), _mm_castsi128_ps(p3.m128), _MM_SHUFFLE(0, 0, 0, 0)));
		factor1.m128 = _mm_load_si128(reinterpret_cast<__m128i const*>(&factorsToEliminate[i*6 + 0]));
		factor2.m128 = _mm_load_si128(reinterpret_cast<__m128i const*>(&factorsToEliminate[i*6 + 4]));
		factor3.m128 = _mm_load_si128(reinterpret_cast<__m128i const*>(&factorsToEliminate[i*6 + 8]));
		while (true) {
			cmpres1.m128 = _mm_cmpgt_epi32(offsetmax.m128, factor1.m128);
			cmpres2.m128 = _mm_cmpgt_epi32(offsetmax.m128, factor2.m128);
			cmpres3.m128 = _mm_cmpgt_epi32(offsetmax.m128, factor3.m128);
			const int mask1(_mm_movemask_epi8(cmpres1.m128));
			const int mask2(_mm_movemask_epi8(cmpres2.m128));
			const int mask3(_mm_movemask_epi8(cmpres3.m128));
			if ((mask1 == 0) && (mask2 == 0) && (mask3 == 0)) break;
			if (mask1 & 0x0008) factorsTable[factor1.v[0] >> 6] |= (1ULL << (factor1.v[0] & 63ULL));
			if (mask1 & 0x0080) factorsTable[factor1.v[1] >> 6] |= (1ULL << (factor1.v[1] & 63ULL));
			if (mask1 & 0x0800) factorsTable[factor1.v[2] >> 6] |= (1ULL << (factor1.v[2] & 63ULL));
			if (mask1 & 0x8000) factorsTable[factor1.v[3] >> 6] |= (1ULL << (factor1.v[3] & 63ULL));
			if (mask2 & 0x0008) factorsTable[factor2.v[0] >> 6] |= (1ULL << (factor2.v[0] & 63ULL));
			if (mask2 & 0x0080) factorsTable[factor2.v[1] >> 6] |= (1ULL << (factor2.v[1] & 63ULL));
			if (mask2 & 0x0800) factorsTable[factor2.v[2] >> 6] |= (1ULL << (factor2.v[2] & 63ULL));
			if (mask2 & 0x8000) factorsTable[factor2.v[3] >> 6] |= (1ULL << (factor2.v[3] & 63ULL));
			if (mask3 & 0x0008) factorsTable[factor3.v[0] >> 6] |= (1ULL << (factor3.v[0] & 63ULL));
			if (mask3 & 0x0080) factorsTable[factor3.v[1] >> 6] |= (1ULL << (factor3.v[1] & 63ULL));
			if (mask3 & 0x0800) factorsTable[factor3.v[2] >> 6] |= (1ULL << (factor3.v[2] & 63ULL));
			if (mask3 & 0x8000) factorsTable[factor3.v[3] >> 6] |= (1ULL << (factor3.v[3] & 63ULL));
			nextIncr1.m128 = _mm_and_si128(cmpres1.m128, p1.m128);
			nextIncr2.m128 = _mm_and_si128(cmpres2.m128, p2.m128);
			nextIncr3.m128 = _mm_and_si128(cmpres3.m128, p3.m128);
			factor1.m128 = _mm_add_epi32(factor1.m128, nextIncr1.m128);
			factor2.m128 = _mm_add_epi32(factor2.m128, nextIncr2.m128);
			factor3.m128 = _mm_add_epi32(factor3.m128, nextIncr3.m128);
		}
		factor1.m128 = _mm_sub_epi32(factor1.m128, offsetmax.m128);
		factor2.m128 = _mm_sub_epi32(factor2.m128, offsetmax.m128);
		factor3.m128 = _mm_sub_epi32(factor3.m128, offsetmax.m128);
		_mm_store_si128(reinterpret_cast<__m128i*>(&factorsToEliminate[i*6 + 0]), factor1.m128);
		_mm_store_si128(reinterpret_cast<__m128i*>(&factorsToEliminate[i*6 + 4]), factor2.m128);
		_mm_store_si128(reinterpret_cast<__m128i*>(&factorsToEliminate[i*6 + 8]), factor3.m128);
	}
}

void Miner::_processSieve7(uint64_t *factorsTable, uint32_t* factorsToEliminate, uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex) { // Assembly optimized sieving for 7-tuples by Michael Bell
	assert(_parameters.pattern.size() == 7);
	std::array<uint32_t, sieveCacheSize> sieveCache{0};
	uint64_t sieveCachePos(0);
	xmmreg_t offsetmax;
	offsetmax.m128 = _mm_set1_epi32(_parameters.sieveSize);
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i += 1) {
		xmmreg_t p1;
		xmmreg_t factor1, factor2, nextIncr1, nextIncr2;
		xmmreg_t cmpres1, cmpres2;
		p1.m128 = _mm_set1_epi32(_primes32[i]);
		factor1.m128 = _mm_loadu_si128(reinterpret_cast<__m128i const*>(&factorsToEliminate[i*7 + 0]));
		factor2.m128 = _mm_loadu_si128(reinterpret_cast<__m128i const*>(&factorsToEliminate[i*7 + 3]));
		while (true) {
			cmpres1.m128 = _mm_cmpgt_epi32(offsetmax.m128, factor1.m128);
			cmpres2.m128 = _mm_cmpgt_epi32(offsetmax.m128, factor2.m128);
			const int mask1(_mm_movemask_epi8(cmpres1.m128));
			const int mask2(_mm_movemask_epi8(cmpres2.m128));
			if ((mask1 == 0) && (mask2 == 0)) break;
			if (mask1 & 0x0008) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[0]);
			if (mask1 & 0x0080) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[1]);
			if (mask1 & 0x0800) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[2]);
			if (mask1 & 0x8000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[3]);
			if (mask2 & 0x0080) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[1]);
			if (mask2 & 0x0800) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[2]);
			if (mask2 & 0x8000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[3]);
			nextIncr1.m128 = _mm_and_si128(cmpres1.m128, p1.m128);
			nextIncr2.m128 = _mm_and_si128(cmpres2.m128, p1.m128);
			factor1.m128 = _mm_add_epi32(factor1.m128, nextIncr1.m128);
			factor2.m128 = _mm_add_epi32(factor2.m128, nextIncr2.m128);
		}
		factor1.m128 = _mm_sub_epi32(factor1.m128, offsetmax.m128);
		factor2.m128 = _mm_sub_epi32(factor2.m128, offsetmax.m128);
		_mm_storeu_si128(reinterpret_cast<__m128i*>(&factorsToEliminate[i*7 + 0]), factor1.m128);
		_mm_storeu_si128(reinterpret_cast<__m128i*>(&factorsToEliminate[i*7 + 3]), factor2.m128);
	}
	_endSieveCache(factorsTable, sieveCache);
}

void Miner::_processSieve8(uint64_t *factorsTable, uint32_t* factorsToEliminate, uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex) { // Assembly optimized sieving for 8-tuples by Michael Bell
	assert(_parameters.pattern.size() == 8);
	std::array<uint32_t, sieveCacheSize> sieveCache{0};
	uint64_t sieveCachePos(0);
	xmmreg_t offsetmax;
	offsetmax.m128 = _mm_set1_epi32(_parameters.sieveSize);
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i += 1) {
		xmmreg_t p1;
		xmmreg_t factor1, factor2, nextIncr1, nextIncr2;
		xmmreg_t cmpres1, cmpres2;
		p1.m128 = _mm_set1_epi32(_primes32[i]);
		factor1.m128 = _mm_load_si128(reinterpret_cast<__m128i const*>(&factorsToEliminate[i*8 + 0]));
		factor2.m128 = _mm_load_si128(reinterpret_cast<__m128i const*>(&factorsToEliminate[i*8 + 4]));
		while (true) {
			cmpres1.m128 = _mm_cmpgt_epi32(offsetmax.m128, factor1.m128);
			cmpres2.m128 = _mm_cmpgt_epi32(offsetmax.m128, factor2.m128);
			const int mask1(_mm_movemask_epi8(cmpres1.m128));
			const int mask2(_mm_movemask_epi8(cmpres2.m128));
			if ((mask1 == 0) && (mask2 == 0)) break;
			if (mask1 & 0x0008) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[0]);
			if (mask1 & 0x0080) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[1]);
			if (mask1 & 0x0800) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[2]);
			if (mask1 & 0x8000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[3]);
			if (mask2 & 0x0008) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[0]);
			if (mask2 & 0x0080) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[1]);
			if (mask2 & 0x0800) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[2]);
			if (mask2 & 0x8000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[3]);
			nextIncr1.m128 = _mm_and_si128(cmpres1.m128, p1.m128);
			nextIncr2.m128 = _mm_and_si128(cmpres2.m128, p1.m128);
			factor1.m128 = _mm_add_epi32(factor1.m128, nextIncr1.m128);
			factor2.m128 = _mm_add_epi32(factor2.m128, nextIncr2.m128);
		}
		factor1.m128 = _mm_sub_epi32(factor1.m128, offsetmax.m128);
		factor2.m128 = _mm_sub_epi32(factor2.m128, offsetmax.m128);
		_mm_store_si128(reinterpret_cast<__m128i*>(&factorsToEliminate[i*8 + 0]), factor1.m128);
		_mm_store_si128(reinterpret_cast<__m128i*>(&factorsToEliminate[i*8 + 4]), factor2.m128);
	}
	_endSieveCache(factorsTable, sieveCache);
}

#ifdef __AVX2__
void Miner::_processSieve7_avx2(uint64_t *factorsTable, uint32_t* factorsToEliminate, uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex) { // Assembly optimized sieving for 7-tuples by Michael Bell
	assert(_parameters.pattern.size() == 7);
	std::array<uint32_t, sieveCacheSize> sieveCache{0};
	uint64_t sieveCachePos(0);
	assert((lastPrimeIndex & 1) == 0);
	// Already eliminate for the first prime to sieve if it is odd to align for the optimizations
	if ((firstPrimeIndex & 1) != 0) {
		for (uint64_t f(0) ; f < 7 ; f++) {
			while (factorsToEliminate[firstPrimeIndex*7 + f] < _parameters.sieveSize) {
				_addToSieveCache(factorsTable, sieveCache, sieveCachePos, factorsToEliminate[firstPrimeIndex*7 + f]);
				factorsToEliminate[firstPrimeIndex*7 + f] += _primes32[firstPrimeIndex];
			}
			factorsToEliminate[firstPrimeIndex*7 + f] -= _parameters.sieveSize;
		}
		firstPrimeIndex++;
	}
	
	ymmreg_t offsetmax;
	offsetmax.m256 = _mm256_set1_epi32(_parameters.sieveSize);
	ymmreg_t storemask;
	storemask.m256 = _mm256_set1_epi32(0xffffffff);
	storemask.v[0] = 0;
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i += 2) {
		ymmreg_t p1, p2;
		ymmreg_t factor1, factor2, nextIncr1, nextIncr2;
		ymmreg_t cmpres1, cmpres2;
		p1.m256 = _mm256_set1_epi32(_primes32[i]);
		p2.m256 = _mm256_set1_epi32(_primes32[i + 1]);
		factor1.m256 = _mm256_loadu_si256(reinterpret_cast<__m256i const*>(&factorsToEliminate[i*7 + 0]));
		factor2.m256 = _mm256_loadu_si256(reinterpret_cast<__m256i const*>(&factorsToEliminate[i*7 + 6]));
		while (true) {
			cmpres1.m256 = _mm256_cmpgt_epi32(offsetmax.m256, factor1.m256);
			cmpres2.m256 = _mm256_cmpgt_epi32(offsetmax.m256, factor2.m256);
			const int mask1(_mm256_movemask_epi8(cmpres1.m256));
			const int mask2(_mm256_movemask_epi8(cmpres2.m256));
			if ((mask1 == 0) && (mask2 == 0)) break;
			if (mask1 & 0x00000008) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[0]);
			if (mask1 & 0x00000080) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[1]);
			if (mask1 & 0x00000800) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[2]);
			if (mask1 & 0x00008000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[3]);
			if (mask1 & 0x00080000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[4]);
			if (mask1 & 0x00800000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[5]);
			if (mask1 & 0x08000000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[6]);
			if (mask2 & 0x00000080) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[1]);
			if (mask2 & 0x00000800) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[2]);
			if (mask2 & 0x00008000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[3]);
			if (mask2 & 0x00080000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[4]);
			if (mask2 & 0x00800000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[5]);
			if (mask2 & 0x08000000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[6]);
			if (mask2 & 0x80000000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[7]);
			nextIncr1.m256 = _mm256_and_si256(cmpres1.m256, p1.m256);
			nextIncr2.m256 = _mm256_and_si256(cmpres2.m256, p2.m256);
			factor1.m256 = _mm256_add_epi32(factor1.m256, nextIncr1.m256);
			factor2.m256 = _mm256_add_epi32(factor2.m256, nextIncr2.m256);
		}
		factor1.m256 = _mm256_sub_epi32(factor1.m256, offsetmax.m256);
		factor2.m256 = _mm256_sub_epi32(factor2.m256, offsetmax.m256);
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(&factorsToEliminate[i*7 + 0]), factor1.m256);
		_mm256_maskstore_epi32(reinterpret_cast<int*>(&factorsToEliminate[i*7 + 6]), storemask.m256, factor2.m256);
	}
	_endSieveCache(factorsTable, sieveCache);
}

void Miner::_processSieve8_avx2(uint64_t *factorsTable, uint32_t* factorsToEliminate, uint64_t firstPrimeIndex, const uint64_t lastPrimeIndex) { // Assembly optimized sieving for 8-tuples by Michael Bell
	assert(_parameters.pattern.size() == 8);
	std::array<uint32_t, sieveCacheSize> sieveCache{0};
	uint64_t sieveCachePos(0);

	assert((lastPrimeIndex & 1) == 0);
	// Already eliminate for the first prime to sieve if it is odd to align for the optimizations
	if ((firstPrimeIndex & 1) != 0) {
		for (uint64_t f(0) ; f < 8 ; f++) {
			while (factorsToEliminate[firstPrimeIndex*8 + f] < _parameters.sieveSize) {
				_addToSieveCache(factorsTable, sieveCache, sieveCachePos, factorsToEliminate[firstPrimeIndex*8 + f]);
				factorsToEliminate[firstPrimeIndex*8 + f] += _primes32[firstPrimeIndex];
			}
			factorsToEliminate[firstPrimeIndex*8 + f] -= _parameters.sieveSize;
		}
		firstPrimeIndex++;
	}

	ymmreg_t offsetmax;
	offsetmax.m256 = _mm256_set1_epi32(_parameters.sieveSize);
	for (uint64_t i(firstPrimeIndex) ; i < lastPrimeIndex ; i += 2) {
		ymmreg_t p1, p2;
		ymmreg_t factor1, factor2, nextIncr1, nextIncr2;
		ymmreg_t cmpres1, cmpres2;
		p1.m256 = _mm256_set1_epi32(_primes32[i]);
		p2.m256 = _mm256_set1_epi32(_primes32[i + 1]);
		factor1.m256 = _mm256_load_si256(reinterpret_cast<__m256i const*>(&factorsToEliminate[i*8 + 0]));
		factor2.m256 = _mm256_load_si256(reinterpret_cast<__m256i const*>(&factorsToEliminate[i*8 + 8]));
		while (true) {
			cmpres1.m256 = _mm256_cmpgt_epi32(offsetmax.m256, factor1.m256);
			cmpres2.m256 = _mm256_cmpgt_epi32(offsetmax.m256, factor2.m256);
			const int mask1(_mm256_movemask_epi8(cmpres1.m256));
			const int mask2(_mm256_movemask_epi8(cmpres2.m256));
			if ((mask1 == 0) && (mask2 == 0)) break;
			if (mask1 & 0x00000008) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[0]);
			if (mask1 & 0x00000080) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[1]);
			if (mask1 & 0x00000800) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[2]);
			if (mask1 & 0x00008000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[3]);
			if (mask1 & 0x00080000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[4]);
			if (mask1 & 0x00800000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[5]);
			if (mask1 & 0x08000000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[6]);
			if (mask1 & 0x80000000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor1.v[7]);
			if (mask2 & 0x00000008) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[0]);
			if (mask2 & 0x00000080) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[1]);
			if (mask2 & 0x00000800) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[2]);
			if (mask2 & 0x00008000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[3]);
			if (mask2 & 0x00080000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[4]);
			if (mask2 & 0x00800000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[5]);
			if (mask2 & 0x08000000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[6]);
			if (mask2 & 0x80000000) _addToSieveCache(factorsTable, sieveCache, sieveCachePos, factor2.v[7]);
			nextIncr1.m256 = _mm256_and_si256(cmpres1.m256, p1.m256);
			nextIncr2.m256 = _mm256_and_si256(cmpres2.m256, p2.m256);
			factor1.m256 = _mm256_add_epi32(factor1.m256, nextIncr1.m256);
			factor2.m256 = _mm256_add_epi32(factor2.m256, nextIncr2.m256);
		}
		factor1.m256 = _mm256_sub_epi32(factor1.m256, offsetmax.m256);
		factor2.m256 = _mm256_sub_epi32(factor2.m256, offsetmax.m256);
		_mm256_store_si256(reinterpret_cast<__m256i*>(&factorsToEliminate[i*8 + 0]), factor1.m256);
		_mm256_store_si256(reinterpret_cast<__m256i*>(&factorsToEliminate[i*8 + 8]), factor2.m256);
	}
	_endSieveCache(factorsTable, sieveCache);
}
#endif
#endif

void Miner::_doSieveTask(Task task) {
	Sieve& sieve(_sieves[task.sieve.id]);
	std::unique_lock<std::mutex> presieveLock(sieve.presieveLock, std::defer_lock);
	const uint64_t workIndex(task.workIndex), sieveIteration(task.sieve.iteration), firstPrimeIndex(_parameters.primorialNumber);
	std::array<uint32_t, sieveCacheSize> sieveCache{0};
	uint64_t sieveCachePos(0);
	Task checkTask{Task::Type::Check, workIndex, {}};
	
	if (_works[workIndex].job.height != _client->currentHeight()) // Abort Sieve Task if new block (but count as Task done)
		goto sieveEnd;
	
	memset(sieve.factorsTable, 0, sizeof(uint64_t)*_parameters.sieveWords);
	
	// Eliminate the p*i + fp factors (p < factorMax).
#ifdef __SSE2__
	if (_parameters.pattern.size() == 6)
		_processSieve6(sieve.factorsTable, sieve.factorsToEliminate, firstPrimeIndex, _primesIndexThreshold);
	else if (_parameters.pattern.size() == 7)
#ifdef __AVX2__
		_processSieve7_avx2(sieve.factorsTable, sieve.factorsToEliminate, firstPrimeIndex, _primesIndexThreshold);
#else
		_processSieve7(sieve.factorsTable, sieve.factorsToEliminate, firstPrimeIndex, _primesIndexThreshold);
#endif
	else if (_parameters.pattern.size() == 8)
#ifdef __AVX2__
		_processSieve8_avx2(sieve.factorsTable, sieve.factorsToEliminate, firstPrimeIndex, _primesIndexThreshold);
#else
		_processSieve8(sieve.factorsTable, sieve.factorsToEliminate, firstPrimeIndex, _primesIndexThreshold);
#endif
	else
		_processSieve(sieve.factorsTable, sieve.factorsToEliminate, firstPrimeIndex, _primesIndexThreshold);
#else
	_processSieve(sieve.factorsTable, sieve.factorsToEliminate, firstPrimeIndex, _primesIndexThreshold);
#endif
	
	if (_works[workIndex].job.height != _client->currentHeight())
		goto sieveEnd;
	
	// Wait for the presieve tasks that generate the additional factors to finish.
	if (sieveIteration == 0) presieveLock.lock();
	
	// Eliminate these factors.
	for (uint64_t i(0), count(sieve.additionalFactorsToEliminateCounts[sieveIteration]); i < count ; i++)
		_addToSieveCache(sieve.factorsTable, sieveCache, sieveCachePos, sieve.additionalFactorsToEliminate[sieveIteration][i]);
	_endSieveCache(sieve.factorsTable, sieveCache);
	
	if (_works[workIndex].job.height != _client->currentHeight())
		goto sieveEnd;
	
	checkTask.check.nCandidates = 0;
	checkTask.check.offsetId = sieve.id;
	checkTask.check.factorStart = sieveIteration*_parameters.sieveSize;
	// Extract candidates from the sieve and create verify tasks of up to maxCandidatesPerCheckTask candidates.
	for (uint32_t b(0) ; b < _parameters.sieveWords ; b++) {
		uint64_t sieveWord(~sieve.factorsTable[b]); // ~ is the Bitwise Not: ones then indicate the candidates and zeros the previously eliminated numbers.
		while (sieveWord != 0) {
			const uint32_t nEliminatedUntilNext(__builtin_ctzll(sieveWord)), candidateIndex((b*64) + nEliminatedUntilNext); // __builtin_ctzll returns the number of leading 0s.
			checkTask.check.factorOffsets[checkTask.check.nCandidates] = candidateIndex;
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
	if (sieveIteration + 1 < _parameters.sieveIterations) {
		if (_parameters.threads > 1)
			_tasks.push_front(Task::SieveTask(workIndex, sieve.id, sieveIteration + 1));
		else // Allow mining with 1 Thread without having to wait for all the blocks to be processed.
			_tasks.push_back(Task::SieveTask(workIndex, sieve.id, sieveIteration + 1));
		return; // Sieving still not finished, do not go to sieveEnd.
	}
sieveEnd:
	_tasksDoneInfos.push_back(TaskDoneInfo{Task::Type::Sieve, {}});
}

// Riecoin uses the Miller-Rabin Test for the PoW, but the Fermat Test is significantly faster and more suitable for the miner.
// n is probably prime if a^(n - 1) ≡ 1 (mod n) for one 0 < a < p or more.
static const mpz_class mpz2(2); // Here, we test with one a = 2.
bool isPrimeFermat(const mpz_class& n) {
	mpz_class r, nm1(n - 1);
	mpz_powm(r.get_mpz_t(), mpz2.get_mpz_t(), nm1.get_mpz_t(), n.get_mpz_t()); // r = 2^(n - 1) % n
	return r == 1;
}

#if defined(__SSE2__) && defined(__AVX2__)
bool Miner::_testPrimesIspc(const std::array<uint32_t, maxCandidatesPerCheckTask> &factorOffsets, uint32_t is_prime[maxCandidatesPerCheckTask], const mpz_class &candidateStart, mpz_class &candidate) { // Assembly optimized prime testing by Michael Bell
	uint32_t M[maxCandidatesPerCheckTask*MAX_N_SIZE], bits(0), N_Size;
	uint32_t *mp(&M[0]);
	for (uint32_t i(0) ; i < maxCandidatesPerCheckTask ; i++) {
		candidate = candidateStart + _primorial*factorOffsets[i];
		if (bits == 0) {
			bits = mpz_sizeinbase(candidate.get_mpz_t(), 2);
			N_Size = (bits >> 5) + ((bits & 0x1f) > 0);
			if (N_Size > MAX_N_SIZE) return false;
		}
		else assert(bits == mpz_sizeinbase(candidate.get_mpz_t(), 2));
		memcpy(mp, candidate.get_mpz_t()->_mp_d, N_Size*4);
		mp += N_Size;
	}
	fermatTest(N_Size, maxCandidatesPerCheckTask, M, is_prime, sysInfo.hasAVX512());
	return true;
}
#endif

void Miner::_doCheckTask(Task task) {
	const uint16_t workIndex(task.workIndex);
	if (_works[workIndex].job.height != _client->currentHeight()) return;
	std::vector<uint64_t> tupleCounts(_parameters.pattern.size() + 1, 0);
	mpz_class candidateStart, candidate;
	mpz_mul_ui(candidateStart.get_mpz_t(), _primorial.get_mpz_t(), task.check.factorStart);
	candidateStart += _works[workIndex].primorialMultipleStart;
	candidateStart += _primorialOffsets[task.check.offsetId];
	
#if defined(__SSE2__) && defined(__AVX2__)
	bool firstTestDone(false);
	if (task.check.nCandidates == maxCandidatesPerCheckTask) { // Test candidates + 0 primality with assembly optimizations if possible.
		uint32_t isPrime[maxCandidatesPerCheckTask];
		firstTestDone = _testPrimesIspc(task.check.factorOffsets, isPrime, candidateStart, candidate);
		if (firstTestDone) {
			tupleCounts[0] += maxCandidatesPerCheckTask;
			task.check.nCandidates = 0;
			for (uint32_t i(0) ; i < maxCandidatesPerCheckTask ; i++) {
				if (isPrime[i]) {
					task.check.factorOffsets[task.check.nCandidates++] = task.check.factorOffsets[i];
					tupleCounts[1]++;
				}
			}
		}
	}
#endif
	
	for (uint32_t i(0) ; i < task.check.nCandidates ; i++) {
		if (_works[workIndex].job.height != _client->currentHeight()) break;
		candidate = candidateStart + _primorial*task.check.factorOffsets[i];
		
#if defined(__SSE2__) && defined(__AVX2__)
		if (!firstTestDone) { // Test candidate + 0 primality without optimizations if not done before.
			tupleCounts[0]++;
			if (!isPrimeFermat(candidate)) continue;
			tupleCounts[1]++;
		}
#else
		tupleCounts[0]++;
		if (!isPrimeFermat(candidate)) continue;
		tupleCounts[1]++;
#endif
		
		uint32_t primeCount(1), offsetSum(0);
		// Test primality of the other elements of the tuple if candidate + 0 is prime.
		for (std::vector<uint64_t>::size_type i(1) ; i < _parameters.pattern.size() ; i++) {
			offsetSum += _parameters.pattern[i];
			mpz_add_ui(candidate.get_mpz_t(), candidate.get_mpz_t(), _parameters.pattern[i]);
			if (isPrimeFermat(mpz_class(candidate))) {
				primeCount++;
				tupleCounts[primeCount]++;
			}
			else if (_mode == "Pool" && primeCount > 1) {
				int candidatesRemaining(_works[workIndex].job.primeCountTarget - 1 - i);
				if ((primeCount + candidatesRemaining) < _works[workIndex].job.primeCountMin) break; // No chance to be a share anymore
			}
			else break;
		}
		// If tuple long enough or share, submit
		if (primeCount >= _works[workIndex].job.primeCountMin || (_mode == "Search" && primeCount >= _parameters.tupleLengthMin)) {
			const mpz_class basePrime(candidate - offsetSum);
			if (_mode == "Benchmark" || _mode == "Search")
				std::cout << Stats::formattedTime(_statManager.timeSinceStart()) << " " << primeCount;
			else
				std::cout << Stats::formattedClockTimeNow() << " " << primeCount;
			if (_mode == "Pool")
				std::cout << "-share found by worker thread " << threadId << std::endl;
			else {
				std::cout << "-tuple found by worker thread " << threadId << std::endl;
				std::cout << "Base prime: " << basePrime << std::endl;
			}
			Job filledJob(_works[workIndex].job);
			filledJob.result = basePrime;
			filledJob.resultPrimeCount = primeCount;
			filledJob.primorialNumber = _parameters.primorialNumber;
			filledJob.primorialFactor = task.check.factorStart + task.check.factorOffsets[i];
			filledJob.primorialOffset = _parameters.primorialOffsets[task.check.offsetId];
			_client->handleResult(filledJob);
		}
	}
	_statManager.addCounts(tupleCounts);
}

void Miner::_doTasks(const uint16_t id) { // Worker Threads run here until the miner is stopped
	// Thread initialization.
	threadId = id;
	factorsCache = new uint64_t*[_parameters.sieveWorkers];
	factorsCacheCounts = new uint64_t*[_parameters.sieveWorkers];
	for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
		factorsCache[i] = new uint64_t[factorsCacheSize];
		factorsCacheCounts[i] = new uint64_t[_parameters.sieveIterations];
		for (uint64_t j(0) ; j < _parameters.sieveIterations ; j++)
			factorsCacheCounts[i][j] = 0;
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
			_tasksDoneInfos.push_back(TaskDoneInfo{Task::Type::Presieve, {task.presieve.start}});
		}
		if (task.type == Task::Type::Sieve) {
			_doSieveTask(task);
			_sieveTime += std::chrono::duration_cast<decltype(_sieveTime)>(std::chrono::steady_clock::now() - startTime);
			// The Sieve's Task Done Info is created in _doSieveTask
		}
		if (task.type == Task::Type::Check) {
			_doCheckTask(task);
			_verifyTime += std::chrono::duration_cast<decltype(_verifyTime)>(std::chrono::steady_clock::now() - startTime);
			_tasksDoneInfos.push_back(TaskDoneInfo{Task::Type::Check, {task.workIndex}});
		}
	}
	// Thread clean up.
	for (int i(0) ; i < _parameters.sieveWorkers ; i++) {
		delete[] factorsCacheCounts[i];
		delete[] factorsCache[i];
	}
	delete[] factorsCacheCounts;
	delete[] factorsCache;
}

void Miner::_manageTasks() {
	Job job; // Block's data (target, blockheader if applicable, ...) from the Client
	_currentWorkIndex = 0;
	uint32_t oldHeight(0);
	while (_running) {
		job = _client->getJob();
		if (job.height == 0)
			return;
		if (job.difficulty < _difficultyAtInit/_parameters.restartDifficultyFactor || job.difficulty > _difficultyAtInit*_parameters.restartDifficultyFactor) { // Restart to retune parameters.
			_keepStats = true;
			_shouldRestart = true;
		}
		if (std::dynamic_pointer_cast<NetworkedClient>(_client) != nullptr) {
			if (!hasAcceptedPatterns(job.acceptedPatterns)) { // Restart if the pattern changed and is no longer compatible with the current one
				_keepStats = false;
				_shouldRestart = true;
			}
		}
		_presieveTime = _presieveTime.zero();
		_sieveTime = _sieveTime.zero();
		_verifyTime = _verifyTime.zero();
		
		_works[_currentWorkIndex].job = job;
		const bool isNewHeight(oldHeight != _works[_currentWorkIndex].job.height);
		// Notify when the network found a block
		if (isNewHeight && oldHeight != 0) {
			_statManager.newBlock();
			if (_mode == "Benchmark" || _mode == "Search")
				std::cout << Stats::formattedTime(_statManager.timeSinceStart());
			else
				std::cout << Stats::formattedClockTimeNow();
			std::cout << " Block " << job.height << ", average " << FIXED(1) << _statManager.averageBlockTime() << " s, difficulty " << FIXED(3) << job.difficulty << std::endl;
		}
		_works[_currentWorkIndex].primorialMultipleStart = _works[_currentWorkIndex].job.target + _primorial - (_works[_currentWorkIndex].job.target % _primorial);
		// Reset Counts and create Presieve Tasks
		for (auto &sieve : _sieves) {
			for (uint64_t j(0) ; j < _parameters.sieveIterations ; j++)
				sieve.additionalFactorsToEliminateCounts[j] = 0;
		}
		uint64_t nPresieveTasks(_parameters.threads*8ULL);
		int32_t nRemainingNormalPresieveTasks(0), nRemainingAdditionalPresieveTasks(0);
		const uint32_t remainingTasks(_tasks.size());
		const uint64_t primesPerPresieveTask((_nPrimes - _parameters.primorialNumber)/nPresieveTasks + 1ULL);
		for (uint64_t start(_parameters.primorialNumber) ; start < _nPrimes ; start += primesPerPresieveTask) {
			const uint64_t end(std::min(_nPrimes, start + primesPerPresieveTask));
			_presieveTasks.push_back(Task::PresieveTask(_currentWorkIndex, start, end));
			_tasks.push_front(Task{Task::Type::Dummy, _currentWorkIndex, {}}); // To ensure a thread wakes up to grab the mod work.
			if (start < _primesIndexThreshold) nRemainingNormalPresieveTasks++;
			else nRemainingAdditionalPresieveTasks++;
		}
		
		while (nRemainingNormalPresieveTasks > 0) {
			const TaskDoneInfo taskDoneInfo(_tasksDoneInfos.blocking_pop_front());
			if (!_running) return; // Can happen if stopThreads is called while this Thread is stuck in this blocking_pop_front().
			if (taskDoneInfo.type == Task::Type::Presieve) {
				if (taskDoneInfo.firstPrimeIndex < _primesIndexThreshold) nRemainingNormalPresieveTasks--;
				else nRemainingAdditionalPresieveTasks--;
			}
			else if (taskDoneInfo.type == Task::Type::Check) _works[taskDoneInfo.workIndex].nRemainingCheckTasks--;
			else ERRORMSG("Unexpected Sieve Task done during Presieving");
		}
		assert(_works[_currentWorkIndex].nRemainingCheckTasks == 0);
		
		// Create Sieve Tasks
		for (std::vector<Sieve>::size_type i(0) ; i < _sieves.size() ; i++) {
			_sieves[i].presieveLock.lock();
			_tasks.push_front(Task::SieveTask(_currentWorkIndex, i, 0));
		}
		
		int nRemainingSieves(_parameters.sieveWorkers);
		while (nRemainingAdditionalPresieveTasks > 0) {
			const TaskDoneInfo taskDoneInfo(_tasksDoneInfos.blocking_pop_front());
			if (!_running) {
				for (auto &sieve : _sieves) sieve.presieveLock.unlock();
				return;
			}
			if (taskDoneInfo.type == Task::Type::Presieve) nRemainingAdditionalPresieveTasks--;
			else if (taskDoneInfo.type == Task::Type::Sieve) nRemainingSieves--;
			else _works[taskDoneInfo.workIndex].nRemainingCheckTasks--;
		}
		for (auto &sieve : _sieves) sieve.presieveLock.unlock();
		
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
					DBG(std::cout << "Unable to generate enough verification work to keep threads busy." << std::endl;);
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

void Miner::_suggestLessMemoryIntensiveOptions(const uint64_t suggestedPrimeTableLimit, const uint16_t suggestedSieveWorkers) const {
	std::cout << "You don't have enough available memory to run rieMiner with the current options." << std::endl;
	std::cout << "Try to use the following options in the " << confPath << " configuration file and retry:" << std::endl;
	std::cout << "PrimeTableLimit = " << suggestedPrimeTableLimit << std::endl;
	std::cout << "SieveWorkers = " << suggestedSieveWorkers << std::endl;
	waitForUser();
}

bool Miner::hasAcceptedPatterns(const std::vector<std::vector<uint64_t>> &acceptedPatterns) const {
	for (const auto &acceptedPattern : acceptedPatterns) {
		bool compatible(true);
		for (uint16_t i(0) ; i < acceptedPattern.size() ; i++) {
			if (i >= _parameters.pattern.size() ? true : acceptedPattern[i] != _parameters.pattern[i]) {
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
	if (_mode == "Benchmark" || _mode == "Search") {
		statsRecent = statsSinceStart;
		std::cout << Stats::formattedTime(_statManager.timeSinceStart());
	}
	else
		std::cout << Stats::formattedClockTimeNow();
	std::cout << " " << FIXED(2) << statsRecent.cps() << " c/s, r " << statsRecent.r();
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
bool Miner::benchmarkFinishedEnoughPrimes(const uint64_t benchmarkPrimeCountLimit) const {
	const Stats stats(_statManager.stats(true));
	return benchmarkPrimeCountLimit > 0 && stats.count(1) >= benchmarkPrimeCountLimit;
}
void Miner::printBenchmarkResults() const {
	Stats stats(_statManager.stats(true));
	std::cout << "Benchmark finished after " << stats.duration() << " s." << std::endl;
	std::cout << FIXED(6) << stats.cps() << " candidates/s, ratio " << stats.r() << " -> " << 86400./stats.estimatedAverageTimeToFindBlock(_works[_currentWorkIndex].job.primeCountTarget) << " block(s)/day" << std::endl;
}
void Miner::printTupleStats() const {
	Stats stats(_statManager.stats(true));
	std::cout << "Tuples found: " << stats.formattedCounts() << " in " << FIXED(6) << stats.duration() << " s" << std::endl;
	std::cout << "Tuple rates : " << stats.formattedRates() << std::endl;
	std::cout << "Tuple ratios: " << stats.formattedRatios() << std::endl;
}
