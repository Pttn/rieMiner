// (c) 2017-2022 Pttn (https://riecoin.dev/en/rieMiner)

#ifndef HEADER_Client_hpp
#define HEADER_Client_hpp

#include <curl/curl.h>
#include <mutex>
#include <nlohmann/json.hpp>
#include <vector>
#include "main.hpp"
#include "tools.hpp"

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

// Used by GBT and Stratum Clients to store required information for Block/Share submissions, that are unused by the miner
struct ClientData {
	BlockHeader bh;
	// GetBlockTemplate exclusive data
	std::string transactionsHex;
	uint16_t txCount;
	// Stratum exclusive data
	std::string jobId;
	std::vector<uint8_t> extraNonce2;
};

// Stores all the information needed for the miner and submissions
struct Job {
	uint32_t height;
	mpz_class target;
	int32_t powVersion;
	std::vector<std::vector<uint64_t>> acceptedPatterns;
	uint32_t primeCountTarget, primeCountMin; // The prime count can be interpreted either as tuple length or share prime count depending on the mining mode
	double difficulty;
	ClientData clientData;
	// The miner writes the result (base prime) here
	mpz_class result;
	uint32_t resultPrimeCount;
	// For PoW version 1
	uint16_t primorialNumber;
	uint64_t primorialFactor, primorialOffset; // Currently, only make use of 64 bits (out of respectively 128 and 96)
	
	Job() : height(0) {}
	std::array<uint8_t, 32> encodedOffset() const; // Encodes result - target in the appropriate format for the block header
};

// Abstract class with protocol independent member variables and functions
// Communicates with the server to get, parse, and submit mining work (or takes the role of the server for non networked clients)
class Client {
protected:
	std::mutex _jobMutex; // Prevents process() (called from main())/getJob() (called from the miner) concurrency problems
public:
	virtual bool isNetworked() {return false;}
	virtual void process() {} // Processes submissions and updates work, polled in the main thread
	virtual Job getJob(const bool = false) = 0;
	virtual void handleResult(const Job&) {} // Handles a miner's result
	virtual uint32_t currentHeight() const = 0;
	virtual double currentDifficulty() const = 0;
	// Tools for constellation pattern autodetection/selection
	static std::vector<uint64_t> choosePatterns(const std::vector<std::vector<uint64_t>>&, const std::vector<uint64_t>&);
};

class NetworkedClient : public Client {
protected:
	bool _connected;
public:
	NetworkedClient() : _connected(false) {}
	bool isNetworked() {return true;}
	virtual void connect() = 0;
	bool connected() const {return _connected;}
};

// Client for the GetBlockTemplate protocol (solo mining)
class GBTClient : public NetworkedClient {
	// Options
	const std::vector<std::string> _rules;
	const std::string _host, _url, _credentials;
	const std::vector<uint8_t> _scriptPubKey;
	// Client State Variables
	CURL *_curl;
	std::mutex _submitMutex; // Send results from the main thread rather than a miner one
	std::vector<Job> _pendingSubmissions;
	struct JobTemplate {
		std::string default_witness_commitment;
		std::vector<std::array<uint8_t, 32>> txHashes;
		uint64_t coinbasevalue;
		std::vector<uint8_t> coinbase;
		Job job;
	} _currentJobTemplate;
	
	nlohmann::json _sendRequestToWallet(const std::string&, const nlohmann::json&) const; // Sends a RPC call to the Riecoin server and returns the response
	bool _fetchJob(); // Via getblocktemplate
	void _submit(const Job& job); // Sends a pending result via submitblock
public:
	GBTClient(const Options &options) :
		_rules(options.rules),
		_host(options.host),
		_url("http://" + options.host + ":" + std::to_string(options.port) + "/"),
		_credentials(options.username + ":" + options.password),
		_scriptPubKey(bech32ToScriptPubKey(options.payoutAddress)),
		_curl(curl_easy_init()) {}
	void connect();
	void process();
	Job getJob(const bool = false);
	void handleResult(const Job& job) { // Called by a miner thread, adds result to pending submissions, which will be processed in process() called by the main thread
		std::lock_guard<std::mutex> lock(_submitMutex);
		_pendingSubmissions.push_back(job);
	}
	uint32_t currentHeight() const {return _currentJobTemplate.job.height;}
	double currentDifficulty() const {return _currentJobTemplate.job.difficulty;}
};

// Client for the Stratum protocol (pooled mining), working for the current Riecoin pools
class StratumClient : public NetworkedClient {
	// Options
	const std::string _username, _password, _host;
	const uint16_t _port;
	// Client State Variables
	std::mutex _submitMutex;
	std::vector<Job> _pendingSubmissions; // Send results from the main thread rather than a miner one
	std::vector<std::pair<std::string, std::string>> _sids; // Subscription Ids, not really used for now
	std::vector<uint8_t> _extraNonce1;
	uint16_t _extraNonce2Len;
	struct JobTemplate {
		std::vector<uint8_t> coinbase1, coinbase2;
		std::vector<std::array<uint8_t, 32>> merkleBranches;
		Job job;
	} _currentJobTemplate;
	int _socket;
	std::chrono::time_point<std::chrono::steady_clock> _lastPoolMessageTp; // Used to disconnect if the server sent nothing since a long time
	uint32_t _shares, _rejectedShares;
	enum State {UNSUBSCRIBED, SUBSCRIBED, AUTHORIZED} _state;
	uint32_t _jsonId; // Counter for the Id field when sending requests to the pool
	
	void _processMessage(const std::string&); // Processes a message received from the pool
	void _submit(const Job&); // Submit share to pool with Mining.Submit
public:
	StratumClient(const Options &options) : _username(options.username), _password(options.password), _host(options.host), _port(options.port) {}
	void connect(); // Also sends mining.subscribe
	void process(); // Get messages from the server and calls _processMessage to handle them
	Job getJob(const bool = false);
	virtual void handleResult(const Job& job) { // Add result to pending submissions
		std::lock_guard<std::mutex> lock(_submitMutex);
		_pendingSubmissions.push_back(job);
	}
	uint32_t currentHeight() const {return _currentJobTemplate.job.height;}
	double currentDifficulty() const {return _currentJobTemplate.job.difficulty;}
	void printSharesStats() const { // Must be after a Stats::printStats()
		std::cout << " ; Sh: " << _shares - _rejectedShares << "/" << _shares;
		if (_shares > 0) std::cout << " (" << FIXED(1) << 100.*(static_cast<double>(_shares - _rejectedShares)/static_cast<double>(_shares)) << "%)";
	}
	uint32_t shares() const {return _shares;}
	uint32_t sharesRejected() const {return _rejectedShares;}
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
	BMClient(const Options &options) : _pattern(options.minerParameters.pattern), _difficulty(options.difficulty), _blockInterval(options.benchmarkBlockInterval), _height(0), _requests(0) {} // The timer is initialized at the first getJob call.
	void process();
	Job getJob(const bool = false); // Dummy boolean to prevent the block timer of the Benchmark Client from starting when the miner initializes.
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
	SearchClient(const Options &options) : _pattern(options.minerParameters.pattern), _difficulty(options.difficulty), _tuplesFilename(options.tuplesFile) {
		std::cout << "Tuples will be written to file " << _tuplesFilename << std::endl;
	}
	Job getJob(const bool = false); // Work is generated here
	void handleResult(const Job&); // Save tuple to file
	uint32_t currentHeight() const {return 1;};
	double currentDifficulty() const {return _difficulty;}
};

#endif
