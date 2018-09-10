// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_CLIENT_H
#define HEADER_CLIENT_H

#include <vector>
#include <jansson.h>
#include <curl/curl.h>
#include "global.h"
#include "tools.h"

struct BlockHeader { // Total 1024 bits/128 bytes (256 hex chars)
	uint32_t version;
	uint32_t previousblockhash[8]; // 256 bits
	uint32_t merkleRoot[8];        // 256 bits
	uint32_t bits;
	uint64_t curtime;              // Riecoin has 64 bits timestamps
	uint32_t nOffset[8];           // 256 bits
	uint32_t remaining[4];         // 128 bits
	
	BlockHeader() {
		version = 0;
		bits = 0;
		curtime = 0;
		for (uint8_t i(0) ; i < 8 ; i++) {
			previousblockhash[i] = 0;
			merkleRoot[i] = 0;
			nOffset[i] = 0;
			if (i < 4) remaining[i] = 0;
		}
	}
};

// Store all the information needed for the miner and submissions
struct WorkData {
	BlockHeader bh;
	uint32_t height;
	uint32_t targetCompact;
	uint32_t target[8];
	
	// For GetBlockTemplate
	std::string transactions; // Store the concatenation in hex format
	uint16_t txCount;
	
	// For Stratum
	std::vector<std::array<uint32_t, 8>> txHashes;
	std::vector<uint8_t> coinbase1, coinbase2;
	uint16_t extraNonce2Len;
	std::vector<uint8_t> extraNonce1, extraNonce2, jobId;
	
	WorkData() {
		bh = BlockHeader();
		height = 0;
		targetCompact = 0;
		for (uint8_t i(0) ; i < 8 ; i++)
			target[i] = 0;
		transactions = std::string();
		txCount = 0;
		
		txHashes = std::vector<std::array<uint32_t, 8>>();
		coinbase1 = std::vector<uint8_t>();
		coinbase2 = std::vector<uint8_t>();
		extraNonce2Len = 0;
		extraNonce1 = std::vector<uint8_t>();
		extraNonce2 = std::vector<uint8_t>();
		jobId = std::vector<uint8_t>();
	}
	
	void merkleRootGenStratum() {
		std::vector<uint8_t> coinbase;
		extraNonce2 = std::vector<uint8_t>();
		for (uint32_t i(0) ; i < coinbase1.size() ; i++)   coinbase.push_back(coinbase1[i]);
		for (uint32_t i(0) ; i < extraNonce1.size() ; i++) coinbase.push_back(extraNonce1[i]);
		for (uint32_t i(0) ; i < extraNonce2Len ; i++) {
			extraNonce2.push_back(rand(0x00, 0xFF));
			coinbase.push_back(extraNonce2[i]);
		}
		for (uint32_t i(0) ; i < coinbase2.size() ; i++) coinbase.push_back(coinbase2[i]);
		
		uint8_t cbHashTmp[32];
		sha256(coinbase.data(), cbHashTmp, coinbase.size());
		sha256(cbHashTmp, cbHashTmp, 32);
		std::array<uint32_t, 8> cbHash;
		for (uint32_t i(0) ; i < 8 ; i++) cbHash[i] = ((uint32_t*) cbHashTmp)[i];
		txHashes.insert(txHashes.begin(), cbHash);
		memcpy(bh.merkleRoot, calculateMerkleRootStratum(txHashes).data(), 32);
	}
};

// Communicates with the server to get, parse, and submit mining work
// Absctract class with protocol independent member variables and functions
// Child concrete classes: GWClient, GBTClient
class Client {
	protected:
	bool _connected;
	std::string _user;
	std::string _pass;
	std::string _host;
	uint16_t _port;
	WorkData _wd;
	CURL *_curl;
	std::mutex _submitMutex;
	std::vector<std::pair<WorkData, uint8_t>> _pendingSubmissions;
	
	std::string getUserPass() const {
		std::ostringstream oss;
		oss << _user << ":" << _pass;
		return oss.str();
	}
	
	std::string getHostPort() const {
		std::ostringstream oss;
		oss << "http://" << _host << ":" << _port << "/";
		return oss.str();
	}
	
	public:
	Client();
	virtual bool connect(const Arguments&); // Returns false on error or if already connected
	json_t* sendRPCCall(CURL*, const std::string&) const; // Send a RPC call to the server
	virtual bool getWork() = 0; // Get work (block data,...) from the sever, depending on the chosen protocol
	virtual void sendWork(const std::pair<WorkData, uint8_t>&) const = 0;  // Send work (share or block) to the sever, depending on the chosen protocol
	void addSubmission(const WorkData& bhToSubmit, uint8_t difficulty) {
		_submitMutex.lock();
		_pendingSubmissions.push_back(std::make_pair(bhToSubmit, difficulty));
		_submitMutex.unlock();
	}
	virtual bool process(); // Processes submissions and updates work
	bool connected() {return _connected;}
	WorkData workData() const {return _wd;}
};

extern std::string minerVersionString;

#endif
