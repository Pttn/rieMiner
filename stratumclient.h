// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_STRATUMCLIENT_H
#define HEADER_STRATUMCLIENT_H

#include "client.h"
#include "tools.h"

#ifdef _WIN32
	#include <winsock2.h>
#else
	#include <sys/socket.h>
	#include <netinet/in.h>
	#include <arpa/inet.h>
	#include <netdb.h>
#endif
#include <unistd.h>
#include <fcntl.h>

struct StratumData {
	BlockHeader bh;
	std::vector<std::array<uint32_t, 8>> txHashes;
	uint32_t height;
	std::vector<uint8_t> coinbase1, coinbase2, coinbase;
	uint8_t scriptPubKey[20]; // Calculated from custom payout address for Coinbase Transaction
	
	std::vector<std::pair<std::string, std::vector<uint8_t>>> sids; // Subscription Ids
	std::vector<uint8_t> extraNonce1, extraNonce2, jobId;
	uint16_t extraNonce1Len, extraNonce2Len;
	
	StratumData() {
		bh = BlockHeader();
		txHashes = std::vector<std::array<uint32_t, 8>>();
		height = 0;
		coinbase1 = std::vector<uint8_t>();
		coinbase2 = std::vector<uint8_t>();
		coinbase  = std::vector<uint8_t>();
		for (uint16_t i(0) ; i < 20 ; i++) scriptPubKey[i] = 0;
		sids = std::vector<std::pair<std::string, std::vector<uint8_t>>>();
		extraNonce1 = std::vector<uint8_t>();
		extraNonce2 = std::vector<uint8_t>();
		jobId = std::vector<uint8_t>();
		extraNonce1Len = 0;
		extraNonce2Len = 0;
	}
	
	void coinBaseGen();
	std::array<uint32_t, 8> coinBaseHash() {
		uint8_t cbHashTmp[32];
		sha256(coinbase.data(), cbHashTmp, coinbase.size());
		sha256(cbHashTmp, cbHashTmp, 32);
		std::array<uint32_t, 8> cbHash;
		for (uint32_t j(0) ; j < 8 ; j++) cbHash[j] = ((uint32_t*) cbHashTmp)[j];
		return cbHash;
	}
	void merkleRootGen() {
		if (txHashes.size() == 0) {
			std::cerr << "MerkleRootGen: no transaction to hash!";
			memset(bh.merkleRoot, 0, 32);
		}
		else if (txHashes.size() == 1)
			memcpy(bh.merkleRoot, &txHashes[0], 32);
		else {
			uint8_t hashData[64], hashOut[32];
			memcpy(hashData, txHashes[0].data(), 32);
			for (uint32_t i(1) ; i < txHashes.size() ; i++) {
				memcpy(&hashData[32], txHashes[i].data(), 32);
				sha256(hashData, hashOut, 64);
				sha256(hashOut, hashData, 32);
			}
			memcpy(bh.merkleRoot, hashData, 32);
		}
	}
};

#define RBUFSIZE 2048
#define RECVSIZE (RBUFSIZE - 4)

class StratumClient : public Client {
	StratumData _sd;
	int _socket;
	std::array<char, RBUFSIZE> _buffer;
	
	enum State {INIT, SUBSCRIBE_SENT, SUBSCRIBE_RCVD, AUTHORIZE_SENT, AUTHORIZE_RCVD, READY, SHARE_SENT};
	State _state;
	std::string _result; // Results of Stratum requests
	
	public:
	bool connect(const Arguments&);
	void getSubscribeInfo();
	void getSentShareResponse();
	void handleOther();
	bool getWork();
	void sendWork(const std::pair<WorkData, uint8_t>&) const;
	bool process();
};

#endif
