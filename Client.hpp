// (c) 2017-2019 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Client_hpp
#define HEADER_Client_hpp

#include <memory>
#include <mutex>
#include <vector>
#include <curl/curl.h>
#include <jansson.h>
#include "tools.hpp"

class WorkManager;

// Blockheader structure (with nOffset and padding), total 1024 bits/128 bytes (256 hex chars)
struct BlockHeader {
	uint32_t version;
	uint8_t  previousblockhash[32]; // 256 bits
	uint8_t  merkleRoot[32];        // 256 bits
	uint32_t bits;
	uint64_t curtime;               // Riecoin has 64 bits timestamps
	uint8_t  nOffset[32];           // 256 bits
	uint8_t  remaining[16];         // 128 bits
	
	BlockHeader() : version(0), previousblockhash{0}, merkleRoot{0}, bits(0), curtime(0), nOffset{0}, remaining{0} {}
	
	// Gives the base prime encoded in the blockheader
	mpz_class decodeSolution() const {
		const std::string bhStr(binToHexStr(this, 112));
		const uint32_t diff(getCompact(invEnd32(strtol(bhStr.substr(136, 8).c_str(), NULL, 16))));
		std::vector<uint8_t> SV8(32), XV8, tmp(sha256sha256(hexStrToV8(bhStr.substr(0, 160)).data(), 80));
		for (uint64_t i(0) ; i < 256 ; i++) SV8[i/8] |= (((tmp[i/8] >> (i % 8)) & 1) << (7 - (i % 8)));
		mpz_class S(v8ToHexStr(SV8).c_str(), 16), target(1);
		mpz_mul_2exp(S.get_mpz_t(), S.get_mpz_t(), diff - 265);
		mpz_mul_2exp(target.get_mpz_t(), target.get_mpz_t(), diff - 1);
		target += S;
		XV8 = reverse(hexStrToV8(bhStr.substr(160, 64)));
		mpz_class X(v8ToHexStr(XV8).c_str(), 16);
		return target + X;
	}
};

// Stores all the information needed for the miner and submissions
struct WorkData {
	BlockHeader bh;
	uint32_t height, targetCompact;
	uint16_t primes;
	
	// For GetBlockTemplate
	std::string transactions; // Store the concatenation in hex format
	uint16_t txCount;
	
	// For Stratum
	std::vector<uint8_t> extraNonce1, extraNonce2;
	std::string jobId;
	
	WorkData() : height(0), targetCompact(0), primes(0), txCount(0) {}
};

// Abstract class with protocol independent member variables and functions
// Communicates with the server to get, parse, and submit mining work
class Client {
	protected:
	bool _inited, _connected;
	CURL *_curl;
	std::mutex _submitMutex;
	std::vector<WorkData> _pendingSubmissions;
	std::shared_ptr<WorkManager> _manager;
	
	virtual bool _getWork() = 0; // Get work (block data,...) from the sever, depending on the chosen protocol
	
	public:
	Client() : _inited(false) {}
	Client(const std::shared_ptr<WorkManager>& manager) : _inited(true), _connected(false), _curl(curl_easy_init()), _manager(manager) {}
	virtual bool connect(); // Returns false on error or if already connected
	virtual void sendWork(const WorkData&) const = 0;  // Send work (share or block) to the sever, depending on the chosen protocol
	void addSubmission(const WorkData& work) {
		_submitMutex.lock();
		_pendingSubmissions.push_back(work);
		_submitMutex.unlock();
	}
	virtual bool process(); // Processes submissions and updates work
	bool connected() const {return _connected;}
	// Using this, the WorkManager will get a ready-to-send work to the miner
	// In particular, this will do the needed endianness changes or randomizations
	virtual WorkData workData() const = 0; // If the returned work data has height 0, it is invalid
};

// Class for RPC-based communications (for example via the GetBlockTemplate protocol , or formerly via GetWork)
class RPCClient : public Client {
	std::string _getUserPass() const; // Returns "username:password", for sendRPCCall(...)
	std::string _getHostPort() const; // Returns "http://host:port/", for sendRPCCall(...)
	
	public:
	using Client::Client;
	json_t* sendRPCCall(const std::string&) const; // Send a RPC call to the server and returns the response
};

// For BenchMarking, emulates a client to allow similar conditions to actual mining by providing
// dummy randomized work at the desired difficulty
class BMClient : public Client {
	BlockHeader _bh;
	uint32_t _height;
	
	bool _getWork();
	
	public:
	using Client::Client;
	bool connect();
	void sendWork(const WorkData&) const;
	WorkData workData() const;
};

#endif
