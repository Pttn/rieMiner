// (c) 2018-2021 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_GBTClient_hpp
#define HEADER_GBTClient_hpp

#include <curl/curl.h>

#include "Client.hpp"
#include "tools.hpp"

std::array<uint8_t, 32> calculateMerkleRoot(const std::vector<std::array<uint8_t, 32>>&);

// Stores the GetBlockTemplate data got from the RPC call
struct GetBlockTemplateData {
	BlockHeader bh;
	std::string transactions, default_witness_commitment; // In hex format
	std::vector<std::array<uint8_t, 32>> txHashes;
	uint64_t coinbasevalue;
	uint32_t height;
	std::vector<uint8_t> coinbase; // Store Coinbase Transaction here
	
	GetBlockTemplateData() : coinbasevalue(0), height(0) {}
	void coinBaseGen(const std::vector<uint8_t>&, const std::string&, uint16_t);
	std::array<uint8_t, 32> coinbaseTxId() const; // Generate the Coinbase TxId, see https://github.com/bitcoin/bips/blob/master/bip-0141.mediawiki#specification
	void merkleRootGen() {bh.merkleRoot = calculateMerkleRoot(txHashes);}
};

// Client for the GetBlockTemplate protocol (solo mining)
class GBTClient : public NetworkedClient {
	// Options
	const std::vector<std::string> _rules;
	const std::string _host, _url, _credentials, _coinbaseMessage;
	const uint16_t _donate;
	const std::vector<uint8_t> _scriptPubKey;
	// Client State Variables
	CURL *_curl;
	std::mutex _submitMutex; // Send results from the main thread rather than a miner one
	std::vector<Job> _pendingSubmissions;
	NetworkInfo _info;
	GetBlockTemplateData _gbtd;
	
	json_t* _sendRPCCall(const std::string&) const; // Send a RPC call to the server and returns the response
	bool _fetchWork(); // Via getblocktemplate
	void _submit(const Job& job); // Sends a pending result via submitblock
public:
	GBTClient(const Options &options) :
		_rules(options.rules()),
		_host(options.host()),
		_url("http://" + options.host() + ":" + std::to_string(options.port()) + "/"),
		_credentials(options.username() + ":" + options.password()),
		_coinbaseMessage(options.secret()),
		_donate(options.donate()),
		_scriptPubKey(bech32ToScriptPubKey(options.payoutAddress())),
		_curl(curl_easy_init()),
		_info{0, {}} {}
	void connect();
	NetworkInfo info();
	void process();
	bool getJob(Job&, const bool = false);
	void handleResult(const Job& job) { // Called by a miner thread, adds result to pending submissions, which will be processed in process() called by the main thread
		std::lock_guard<std::mutex> lock(_submitMutex);
		_pendingSubmissions.push_back(job);
	}
	uint32_t currentHeight() const {return _gbtd.height;}
	double currentDifficulty() const {return decodeBits(_gbtd.bh.bits, _info.powVersion);}
};

#endif
