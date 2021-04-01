// (c) 2017-2021 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Client_hpp
#define HEADER_Client_hpp

#include <mutex>
#include <vector>
#include <jansson.h>
#include "main.hpp"

// Decodes the nBits field from a Block Header
double decodeBits(const uint32_t, const int32_t);

// Riecoin Block Header structure, total 896 bits/112 bytes (224 hex chars)
struct BlockHeader { // The fields are named according to the GetBlockTemplate labels
	uint32_t version;
	std::array<uint8_t, 32> previousblockhash;
	std::array<uint8_t, 32> merkleRoot;
	uint64_t curtime;
	uint32_t bits;
	std::array<uint8_t, 32> nOffset;
	
	BlockHeader() : version(0), previousblockhash{0}, merkleRoot{0}, curtime(0), bits(0), nOffset{0} {}
	std::vector<uint8_t> toV8() const;
	mpz_class target(const int32_t) const;
};

// Stores all the information needed for the miner and submissions
struct Job {
	// General data
	uint32_t primeCountTarget, primeCountMin; // The prime count can be interpreted either as tuple length or share prime count depending on the mining mode
	mpz_class target;
	// General Riecoin data
	BlockHeader bh;
	uint32_t height;
	double difficulty;
	int32_t powVersion;
	// GetBlockTemplate data
	std::string transactions; // Store the concatenation in hex format
	uint16_t txCount;
	// Stratum data
	std::vector<uint8_t> extraNonce1, extraNonce2;
	std::string jobId;
	
	// The miner writes the result (base prime) here
	mpz_class result;
	uint32_t resultPrimeCount;
	// For PoW version 1
	uint16_t primorialNumber;
	uint64_t primorialFactor, primorialOffset; // Currently, only make use of 64 bits (out of respectively 128 and 96)
	
	Job() : height(0), txCount(0) {}
	std::array<uint8_t, 32> encodedOffset() const; // Encodes result - target in the appropriate format for the block header
};

// Abstract class with protocol independent member variables and functions
// Communicates with the server to get, parse, and submit mining work (or takes the role of the server for non networked clients)
class Client {
protected:
	std::mutex _workMutex; // Prevents process() (called from main())/getJob() (called from the miner) concurrency problems
public:
	virtual bool isNetworked() {return false;}
	virtual void process() {} // Processes submissions and updates work, polled in the main thread
	virtual bool getJob(Job&, const bool = false) = 0;
	virtual void handleResult(const Job&) {} // Handles a miner's result
	virtual uint32_t currentHeight() const = 0;
	virtual double currentDifficulty() const = 0;
	
	// Tools for constellation pattern autodetection/selection
	static std::vector<std::vector<uint64_t>> extractAcceptedPatterns(const json_t*);
	static std::vector<uint64_t> choosePatterns(const std::vector<std::vector<uint64_t>>&, const std::vector<uint64_t>&);
};

// Used to provide network information like the current accepted constellation patterns.
// Currently, it is used to select a pattern if not provided and to handle the 0.20 fork, though it may also be used later for things like autotuning during mining.
struct NetworkInfo {
	int32_t powVersion;
	std::vector<std::vector<uint64_t>> acceptedPatterns;
};

class NetworkedClient : public Client {
protected:
	bool _connected;
public:
	NetworkedClient() : _connected(false) {}
	bool isNetworked() {return true;}
	virtual void connect() = 0;
	bool connected() const {return _connected;}
	virtual NetworkInfo info() = 0;
};

// For BenchMarking, emulates a client to allow similar conditions to actual mining by providing
// dummy and (mostly) deterministic work at the desired difficulty.
class BMClient : public Client {
	// Options
	const std::vector<uint64_t> _pattern;
	const double _difficulty, _blockInterval;
	// Client State Variables
	uint32_t _height, _requests;
	std::chrono::time_point<std::chrono::steady_clock> _timer;
public:
	BMClient(const Options &options) : _pattern(options.minerParameters().pattern), _difficulty(options.difficulty()), _blockInterval(options.benchmarkBlockInterval()), _height(0), _requests(0) {} // The timer is initialized at the first getJob call.
	void process();
	bool getJob(Job&, const bool = false); // Dummy boolean to avoid prevent the block timer of Benchmark and Test Clients from starting when the miner initializes.
	uint32_t currentHeight() const {return _height;}
	double currentDifficulty() const {return _difficulty;}
};

// Client to use in order to break records, or to benchmark without blocks and with randomized work.
class SearchClient : public Client {
	// Options
	const std::vector<uint64_t> _pattern;
	const double _difficulty;
	const std::string _tuplesFilename;
	// Client State Variables
	std::mutex _tupleFileMutex;
public:
	SearchClient(const Options &options) : _pattern(options.minerParameters().pattern), _difficulty(options.difficulty()), _tuplesFilename(options.tuplesFile()) {
		std::cout << "Tuples will be written to file " << _tuplesFilename << std::endl;
	}
	bool getJob(Job&, const bool = false); // Work is generated here
	void handleResult(const Job&); // Save tuple to file
	uint32_t currentHeight() const {return 1;};
	double currentDifficulty() const {return _difficulty;}
};

// Simulates various network situations to test/debug code.
class TestClient : public NetworkedClient { // Actually not networked, but behaves like one
	BlockHeader _bh;
	uint32_t _height, _difficulty, _requests, _timeBeforeNextBlock;
	std::vector<uint64_t> _currentPattern;
	bool _starting; // Used to set the timer so the time taken to initialize the miner the first time not counted
	std::chrono::time_point<std::chrono::steady_clock> _timer;
	
	bool _fetchWork();
public:
	TestClient() : _height(1), _difficulty(1600), _requests(0), _timeBeforeNextBlock(10), _currentPattern{0, 2, 4, 2, 4} {}
	void connect();
	NetworkInfo info() {return {1, {_currentPattern}};}
	void process();
	bool getJob(Job&, const bool = false);
	uint32_t currentHeight() const {return _connected ? _height : 0;};
	double currentDifficulty() const {return _difficulty;};
};

#endif
