// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_GBTClient_hpp
#define HEADER_GBTClient_hpp

#include "Client.hpp"
#include "tools.hpp"

struct GetBlockTemplateData {
	BlockHeader bh;
	std::string transactions; // Store the concatenation in hex format
	std::vector<std::array<uint8_t, 32>> txHashes;
	uint64_t coinbasevalue;
	uint32_t height;
	uint32_t primes;
	std::vector<uint8_t> coinbase, // Store Coinbase Transaction here
	                     scriptPubKey; // Calculated from custom payout address for Coinbase Transaction
	std::vector<std::string> rules; // From GetBlockTemplate response
	std::string default_witness_commitment; // In hex format
	
	GetBlockTemplateData() {
		bh = BlockHeader();
		transactions = std::string();
		txHashes = std::vector<std::array<uint8_t, 32>>();
		coinbasevalue = 0;
		height = 0;
		primes = 6;
		coinbase = std::vector<uint8_t>();
		scriptPubKey = std::vector<uint8_t>(20, 0);
		rules = std::vector<std::string>();
		default_witness_commitment = std::string();
	}
	
	void coinBaseGen(const std::string& = "");
	std::array<uint8_t, 32> coinBaseHash() {
		std::vector<uint8_t> cbHashTmp(sha256sha256(coinbase.data(), coinbase.size()));
		std::array<uint8_t, 32> cbHash;
		for (uint8_t j(0) ; j < 32 ; j++) cbHash[j] = cbHashTmp[j];
		return cbHash;
	}
	void merkleRootGen() {
		std::array<uint8_t, 32> mr(calculateMerkleRoot(txHashes));
		memcpy(bh.merkleRoot, mr.data(), 32);
	}
	bool segwitActive() {
		for (uint32_t i(0) ; i < rules.size() ; i++) {
			if (rules[i] == "segwit") return true;
		}
		return false;
	}
};

class GBTClient : public RPCClient {
	GetBlockTemplateData _gbtd;
	
	public:
	using RPCClient::RPCClient;
	bool connect();
	bool getWork();
	void sendWork(const std::pair<WorkData, uint8_t>&) const;
	WorkData workData() const;
};

#endif
