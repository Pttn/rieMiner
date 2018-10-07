// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_GBTCLIENT_H
#define HEADER_GBTCLIENT_H

#include "client.h"
#include "tools.h"

struct GetBlockTemplateData {
	BlockHeader bh;
	std::string transactions; // Store the concatenation in hex format
	std::vector<std::array<uint32_t, 8>> txHashes;
	uint64_t coinbasevalue;
	uint32_t height;
	uint32_t primes;
	std::vector<uint8_t> coinbase; // Store Coinbase Transaction here
	uint8_t scriptPubKey[20]; // Calculated from custom payout address for Coinbase Transaction
	
	GetBlockTemplateData() {
		bh = BlockHeader();
		transactions = std::string();
		txHashes = std::vector<std::array<uint32_t, 8>>();
		coinbasevalue = 0;
		height = 0;
		primes = 6;
		coinbase = std::vector<uint8_t>();
		for (uint16_t i(0) ; i < 20 ; i++) scriptPubKey[i] = 0;
	}
	
	void coinBaseGen();
	std::array<uint32_t, 8> coinBaseHash() {
		std::vector<uint8_t> cbHashTmp(sha256sha256(coinbase.data(), coinbase.size()));
		std::array<uint32_t, 8> cbHash;
		for (uint32_t j(0) ; j < 8 ; j++) cbHash[j] = ((uint32_t*) cbHashTmp.data())[j];
		return cbHash;
	}
	void merkleRootGen() {
		std::array<uint32_t, 8> mr(calculateMerkleRoot(txHashes));
		memcpy(bh.merkleRoot, mr.data(), 32);
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
