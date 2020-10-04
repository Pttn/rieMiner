// (c) 2017-2020 Pttn and contributors (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Miner_hpp
#define HEADER_Miner_hpp

#include <atomic>
#include <cassert>
#include "Stats.hpp"
#include "Client.hpp"
#include "StratumClient.hpp"

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
	mpz_class remainderPrimorial;
	WorkData data;
	std::atomic<uint64_t> nRemainingCheckJobs{0};
	void clear() {
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
	std::shared_ptr<Options> _options;
	std::shared_ptr<Client> _client;
	StatManager _statManager;
	std::thread _masterThread;
	std::vector<std::thread> _workerThreads;
	MinerParameters _parameters;
	CpuID _cpuInfo;
	// Miner data (generated in init)
	mpz_class _primorial;
	uint64_t _nPrimes, _entriesPerSegment, _primeTestStoreOffsetsSize, _sparseLimit;
	std::vector<uint64_t> _primes, _modularInverses, _modPrecompute;
	std::vector<mpz_class> _primorialOffsets;
	std::vector<uint64_t> _halfConstellationOffsets, _primorialOffsetDiff, _primorialOffsetDiffToFirst;
	// Miner state variables
	bool _inited, _running;
	TsQueue<Job> _presieveJobs, _jobs;
	TsQueue<JobDoneInfo> _jobsDoneInfos;
	SieveInstance* _sieveInstances;
	std::array<MinerWork, nWorks> _works;
	uint32_t _nRemainingCheckJobsThreshold, _currentWorkIndex;
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
	
	public:
	Miner(const std::shared_ptr<Options> &options) :
		_options(options),
		_client(nullptr) {
		_inited  = false;
		_running = false;
		_parameters = MinerParameters();
		_nPrimes = 0;
		_entriesPerSegment = 0;
		_primeTestStoreOffsetsSize = 0;
		_sparseLimit = 0;
	}
	
	void setClient(const std::shared_ptr<Client> &client) {_client = client;}
	bool hasAcceptedConstellationOffsets(const std::vector<std::vector<uint64_t>> &acceptedConstellationsOffsets) const {
		for (const auto &acceptedConstellationOffsets : acceptedConstellationsOffsets) {
			bool compatible(true);
			for (uint16_t i(0) ; i < acceptedConstellationOffsets.size() ; i++) {
				if (i >= _parameters.constellationOffsets.size() ? true : acceptedConstellationOffsets[i] != _parameters.constellationOffsets[i]) {
					compatible = false;
					break;
				}
			}
			if (compatible)
				return true;
		}
		return false;
	}
	void start(const MinerParameters &minerParameters) {
		init(minerParameters);
		startThreads();
	}
	void init(const MinerParameters&);
	void startThreads();
	void stop() {
		if (_running) stopThreads();
		if (_inited) clear();
	}
	void stopThreads();
	void clear();
	bool inited() {return _inited;}
	bool running() {return _running;}
	
	void printStats() const {
		Stats statsRecent(_statManager.stats(false)), statsSinceStart(_statManager.stats(true));
		if (_options->mode() == "Benchmark" || _options->mode() == "Search")
			statsRecent = statsSinceStart;
		std::cout << Stats::formattedTime(_statManager.timeSinceStart()) << " " << FIXED(2) << statsRecent.cps() << " c/s, r " << statsRecent.r();
		if (_options->mode() != "Pool") {
			std::cout << " ; (1-" << _parameters.constellationOffsets.size() << "t) = " << statsSinceStart.formattedCounts(1);
			if (statsRecent.count(1) >= 10)
				std::cout << " | " << Stats::formattedDuration(statsRecent.estimatedAverageTimeToFindBlock(_works[_currentWorkIndex].data.primeCountTarget));
		}
		else {
			std::dynamic_pointer_cast<StratumClient>(_client)->printSharesStats();
			if (statsRecent.count(1) >= 10)
				std::cout << " | " << 86400.*(50./static_cast<double>(1 << _client->currentHeight()/840000))/statsRecent.estimatedAverageTimeToFindBlock(_works[_currentWorkIndex].data.primeCountTarget) << " RIC/d";
		}
		std::cout << std::endl;
	}
	bool benchmarkFinishedTimeOut() const {
		const Stats stats(_statManager.stats(true));
		return _options->benchmarkTimeLimit() != 0 && stats.duration() >= _options->benchmarkTimeLimit();
	}
	bool benchmarkFinished2Tuples() const {
		const Stats stats(_statManager.stats(true));
		return _options->benchmark2tupleCountLimit() != 0 && stats.count(2) >= _options->benchmark2tupleCountLimit();
	}
	void printBenchmarkResults() const {
		Stats stats(_statManager.stats(true));
		std::cout << stats.duration() << " s elapsed, test finished. " << versionString << ", difficulty " << _options->difficulty() << ", PTL " << _parameters.primeTableLimit << std::endl;
		std::cout << "BENCHMARK RESULTS: " << FIXED(6) << stats.cps() << " candidates/s, ratio " << stats.r() << " -> " << stats.estimatedAverageTimeToFindBlock(_works[_currentWorkIndex].data.primeCountTarget)/86400. << " block(s)/day" << std::endl;
	}
	void printTupleStats() const {
		Stats stats(_statManager.stats(true));
		std::cout << "Tuples found: " << stats.formattedCounts() << " in " << FIXED(6) << stats.duration() << " s" << std::endl;
		std::cout << "Tuple rates : " << stats.formattedRates() << std::endl;
		std::cout << "Tuple ratios: " << stats.formattedRatios() << std::endl;
	}
};

#endif
