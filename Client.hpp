// (c) 2017-present Pttn (https://riecoin.xyz/rieMiner)

#ifndef HEADER_Client_hpp
#define HEADER_Client_hpp

#include <curl/curl.h>
#include <mutex>
#include <nlohmann/json.hpp>
#include <optional>
#include <vector>
#include "Stella.hpp"
#include "main.hpp"
#include "tools.hpp"

// Decodes the nBits field from a Block Header
double decodeBits(const uint32_t, const int32_t);

std::array<uint8_t, 32> encodedOffset(const Stella::Result&);

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
	mpz_class targetOffsetMax(const int32_t) const;
};

// Client or Network Parameters/Context
struct ClientInfo {
	uint32_t height{0};
	int32_t powVersion;
	std::vector<std::vector<uint64_t>> acceptedPatterns;
	std::vector<bool> patternMin;
	uint32_t primeCountTarget, primeCountMin;
	double difficulty;
	uint32_t targetOffsetBits;
};

// Abstract class with protocol independent member variables and functions
// Communicates with the server to get, parse, and submit mining work (or takes the role of the server for non networked clients)
class Client {
protected:
	std::mutex _jobMutex; // Prevents process() (called from main())/getJob() (called from the miner) concurrency problems
public:
	virtual bool isNetworked() {return false;}
	virtual void process() {} // Processes submissions and updates work, polled in the main thread
	virtual std::optional<ClientInfo> info() const = 0;
	virtual std::optional<Stella::Job> getJob() = 0;
	virtual void handleResult(const Stella::Result&) {} // Handles a miner's result
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
	uint64_t _currentJobId{0};
	struct Job { // GBT Job Data/Context
		uint32_t id;
		uint32_t height{0};
		BlockHeader bh;
		std::string transactionsHex;
		uint16_t txCount;
	};
	std::vector<Job> _currentJobs;
	std::vector<Stella::Result> _pendingBlocks;
	struct JobTemplate {
		std::string default_witness_commitment;
		std::vector<std::array<uint8_t, 32>> txHashes;
		uint64_t coinbasevalue;
		std::vector<uint8_t> coinbase;
		Job job;
		std::optional<ClientInfo> clientInfo;
	} _currentJobTemplate;
	
	nlohmann::json _sendRequestToWallet(const std::string&, const nlohmann::json&) const; // Sends a RPC call to the Riecoin server and returns the response
	bool _fetchJob(); // Via getblocktemplate
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
	std::optional<ClientInfo> info() const;
	std::optional<Stella::Job> getJob();
	void handleResult(const Stella::Result& job) { // Called by a miner thread, adds result to pending submissions, which will be processed in process() called by the main thread
		std::lock_guard<std::mutex> lock(_submitMutex);
		_pendingBlocks.push_back(job);
	}
};

// Client for the Stratum protocol (pooled mining), working for the current Riecoin pools
class StratumClient : public NetworkedClient {
	// Options
	const std::string _username, _password, _host;
	const uint16_t _port;
	// Client State Variables
	std::mutex _submitMutex;
	uint64_t _currentJobId{0}, _shares{0}, _rejectedShares{0};
	struct Job { // Stratum Job Data/Context
		uint32_t id; // Local Id
		uint32_t height{0};
		BlockHeader bh;
		std::string jobId; // Id for the Pool
		std::vector<uint8_t> extraNonce2;
	};
	std::vector<Job> _currentJobs;
	std::vector<Stella::Result> _pendingShares; // Send results from the main thread rather than a miner one
	std::vector<std::pair<std::string, std::string>> _sids; // Subscription Ids, not really used for now
	std::vector<uint8_t> _extraNonce1;
	uint16_t _extraNonce2Len;
	struct JobTemplate {
		std::vector<uint8_t> coinbase1, coinbase2;
		std::vector<std::array<uint8_t, 32>> merkleBranches;
		Job job;
		std::optional<ClientInfo> clientInfo;
	} _currentJobTemplate;
	int _socket;
	std::chrono::time_point<std::chrono::steady_clock> _lastPoolMessageTp; // Used to disconnect if the server sent nothing since a long time
	enum State {UNSUBSCRIBED, SUBSCRIBED, AUTHORIZED} _state;
	uint32_t _jsonId; // Counter for the Id field when sending requests to the pool
	
	void _processMessage(const std::string&); // Processes a message received from the pool
public:
	StratumClient(const Options &options) : _username(options.username), _password(options.password), _host(options.host), _port(options.port) {}
	void connect(); // Also sends mining.subscribe
	void process(); // Get messages from the server and calls _processMessage to handle them
	std::optional<ClientInfo> info() const;
	std::optional<Stella::Job> getJob();
	virtual void handleResult(const Stella::Result& share) { // Add result to pending submissions
		std::lock_guard<std::mutex> lock(_submitMutex);
		_pendingShares.push_back(share);
	}
	uint64_t shares() {return _shares;}
	uint64_t rejectedShares() {return _rejectedShares;}
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
	BMClient(const Options &options) : _pattern(options.stellaConfig.pattern), _difficulty(options.difficulty), _blockInterval(options.benchmarkBlockInterval), _height(0), _requests(0) {} // The timer is initialized at the first getJob call.
	void process();
	std::optional<ClientInfo> info() const;
	std::optional<Stella::Job> getJob();
};

// Client to use in order to break records, or to benchmark without blocks and with randomized work.
class SearchClient : public Client {
	// Options
	const std::vector<uint64_t> _pattern;
	uint16_t _primeCountMin;
	const double _difficulty;
	const std::string _tuplesFilename;
	// Client State Variables
	std::mutex _tupleFileMutex;
public:
	SearchClient(const Options &options) : _pattern(options.stellaConfig.pattern), _difficulty(options.difficulty), _tuplesFilename(options.tuplesFile) {
		_primeCountMin = options.tupleLengthMin;
		if (_primeCountMin < 1 || _primeCountMin > _pattern.size())
			_primeCountMin = std::max(1, static_cast<int>(_pattern.size()) - 1);
		logger.log("Will display tuples of at least length "s + std::to_string(_primeCountMin) + " and write them to file "s + _tuplesFilename + "\n"s);
	}
	std::optional<ClientInfo> info() const;
	std::optional<Stella::Job> getJob(); // Work is generated here
	void handleResult(const Stella::Result&); // Save tuple to file
};

#endif
