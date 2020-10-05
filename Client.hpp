// (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_Client_hpp
#define HEADER_Client_hpp

#include <memory>
#include <mutex>
#include <vector>
#include <curl/curl.h>
#include <jansson.h>
#include "main.hpp"

// Blockheader structure (with nOffset), total 896 bits/112 bytes (224 hex chars)
constexpr uint64_t zerosBeforeHash(8ULL);
struct BlockHeader {
	uint32_t version;
	uint8_t  previousblockhash[32]; // 256 bits
	uint8_t  merkleRoot[32];        // 256 bits
	uint64_t curtime;               // Riecoin has 64 bits timestamps
	uint32_t bits;
	uint8_t  nOffset[32];           // 256 bits
	
	BlockHeader() : version(0), previousblockhash{0}, merkleRoot{0}, curtime(0), bits(0), nOffset{0} {}
	constexpr BlockHeader(const BlockHeader&) = default; // Fix "-WDeprecated-Copy" Warning
	
	BlockHeader& operator=(const BlockHeader& bh) {
		version = bh.version;
		for (uint32_t i(0) ; i < 32 ; i++) {
			previousblockhash[i] = bh.previousblockhash[i];
			merkleRoot[i] = bh.merkleRoot[i];
			nOffset[i] = bh.nOffset[i];
		}
		curtime = bh.curtime;
		bits = bh.bits;
		return *this;
	}
	
	std::vector<uint8_t> toV8() const {
		std::vector<uint8_t> v8;
		for (uint32_t i(0) ; i <  4 ; i++) v8.push_back(reinterpret_cast<const uint8_t*>(&version)[i]);
		for (uint32_t i(0) ; i < 32 ; i++) v8.push_back(previousblockhash[i]);
		for (uint32_t i(0) ; i < 32 ; i++) v8.push_back(merkleRoot[i]);
		for (uint32_t i(0) ; i <  8 ; i++) v8.push_back(reinterpret_cast<const uint8_t*>(&curtime)[i]);
		for (uint32_t i(0) ; i <  4 ; i++) v8.push_back(reinterpret_cast<const uint8_t*>(&bits)[i]);
		for (uint32_t i(0) ; i < 32 ; i++) v8.push_back(nOffset[i]);
		return v8;
	}
	
	// Gives the base prime encoded in the blockheader
	mpz_class decodeSolution() const {
		const std::string bhStr(v8ToHexStr(toV8()));
		const uint32_t diff(decodeCompact(invEnd32(strtol(bhStr.substr(152, 8).c_str(), NULL, 16))));
		std::vector<uint8_t> SV8(32), XV8, tmp(powHash());
		for (uint64_t i(0) ; i < 256 ; i++) SV8[i/8] |= (((tmp[i/8] >> (i % 8)) & 1) << (7 - (i % 8)));
		mpz_class S(v8ToHexStr(SV8).c_str(), 16), target(1);
		mpz_mul_2exp(S.get_mpz_t(), S.get_mpz_t(), diff - 265);
		mpz_mul_2exp(target.get_mpz_t(), target.get_mpz_t(), diff - 1);
		target += S;
		XV8 = reverse(hexStrToV8(bhStr.substr(160, 64)));
		mpz_class X(v8ToHexStr(XV8).c_str(), 16);
		return target + X;
	}
	
	std::vector<uint8_t> powHash() const { // In Riecoin, nBits and nTime need to be swapped before hashing
		std::vector<uint8_t> bhForPow;
		for (uint32_t i(0) ; i <  4 ; i++) bhForPow.push_back(reinterpret_cast<const uint8_t*>(&version)[i]);
		for (uint32_t i(0) ; i < 32 ; i++) bhForPow.push_back(previousblockhash[i]);
		for (uint32_t i(0) ; i < 32 ; i++) bhForPow.push_back(merkleRoot[i]);
		for (uint32_t i(0) ; i <  4 ; i++) bhForPow.push_back(reinterpret_cast<const uint8_t*>(&bits)[i]);
		for (uint32_t i(0) ; i <  8 ; i++) bhForPow.push_back(reinterpret_cast<const uint8_t*>(&curtime)[i]);
		for (uint32_t i(0) ; i < 32 ; i++) bhForPow.push_back(nOffset[i]);
		return sha256sha256(bhForPow.data(), 80);
	}
	
	mpz_class target() const {
		mpz_class target(1);
		target <<= zerosBeforeHash;
		std::vector<uint8_t> hash(powHash());
		for (uint64_t i(0) ; i < 256 ; i++) {
			target <<= 1;
			if ((hash[i/8] >> (i % 8)) & 1)
				target.get_mpz_t()->_mp_d[0]++;
		}
		const uint64_t trailingZeros(decodeCompact(bits) - 1ULL - zerosBeforeHash - 256ULL);
		target <<= static_cast<uint32_t>(trailingZeros); // For some reason, Gmp dislikes 64 bits numbers (gmp: overflow in mpz type)...
		return target;
	}
};

// Stores all the information needed for the miner and submissions
struct WorkData {
	BlockHeader bh;
	std::vector<std::vector<uint64_t>> acceptedConstellationOffsets;
	uint32_t height, difficulty, primeCountTarget, primeCountMin;
	int32_t powVersion;
	mpz_class target, result;
	// For version 1 PoW; currently rieMiner only makes use of 64 bits (out of respectively 128 and 96)
	uint16_t primorialNumber;
	uint64_t primorialFactor, primorialOffset;
	
	// For GetBlockTemplate
	std::string transactions; // Store the concatenation in hex format
	uint16_t txCount;
	
	// For Stratum
	std::vector<uint8_t> extraNonce1, extraNonce2;
	std::string jobId;
	
	WorkData() : height(0), txCount(0) {}
	std::vector<uint8_t> encodedOffset() const;
};

// Abstract class with protocol independent member variables and functions
// Communicates with the server to get, parse, and submit mining work
class Client {
protected:
	bool _inited, _connected;
	CURL *_curl;
	std::mutex _workMutex, _submitMutex; // _workMutex prevents _getWork() (called from main() via process())/workData() (called from the miner) concurrency problems
	std::vector<WorkData> _pendingSubmissions;
	std::shared_ptr<Options> _options;
	
	virtual bool _getWork() = 0; // Get work (block data,...) from the sever, depending on the chosen protocol
	void _updateClient(); // For networked clients, ensures that the mining data is set (notably for updateMinerParameters). Disconnects if failure.
	
public:
	Client() : _inited(false) {}
	Client(const std::shared_ptr<Options> &options) : _inited(true), _connected(false), _curl(curl_easy_init()), _options(options) {}
	virtual bool connect(); // Returns false on error or if already connected
	virtual void updateMinerParameters(MinerParameters&) = 0; // Sets client dependent miner parameters like the Constellation Offsets
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
	virtual WorkData workData() = 0; // If the returned work data has height 0, it is invalid
	virtual uint32_t currentHeight() const = 0;
	virtual uint32_t currentDifficulty() const = 0;
	virtual bool getWork(WorkData& wd) {
		wd = workData();
		return wd.height != 0;
	}
	
	// Tools for constellation autodetection
	static std::vector<std::vector<uint64_t>> extractAcceptedConstellationOffsets(const json_t*);
	static std::vector<uint64_t> chooseConstellationOffsets(const std::vector<std::vector<uint64_t>>&, const std::vector<uint64_t>&);
};

// For BenchMarking, emulates a client to allow similar conditions to actual mining by providing
// dummy and (mostly) deterministic work at the desired difficulty.
class BMClient : public Client {
	uint32_t _height;
	uint64_t _requests;
	std::chrono::time_point<std::chrono::steady_clock> _timer;
	std::vector<uint64_t> _constellationOffsets;
	bool _getWork();
	
public:
	using Client::Client;
	bool connect();
	void updateMinerParameters(MinerParameters&);
	void sendWork(const WorkData&) const {} // Ignore blocks found
	WorkData workData();
	virtual bool getWork(WorkData& wd) {
		wd = workData();
		_requests++;
		return wd.height != 0;
	}
	virtual uint32_t currentHeight() const {return _height;};
	virtual uint32_t currentDifficulty() const {return _options->difficulty();};
};

// Client to use in order to break records, or to benchmark without blocks and with randomized work.
class SearchClient : public Client {
	std::chrono::time_point<std::chrono::steady_clock> _startTp;
	std::vector<uint64_t> _constellationOffsets;
	bool _getWork() {return _inited;} // Work is generated in workData
	
public:
	using Client::Client;
	bool connect();
	void updateMinerParameters(MinerParameters&);
	void sendWork(const WorkData&) const {} // Ignore tuples found (the Miner shows them)
	WorkData workData();
	virtual uint32_t currentHeight() const {return _connected ? 1 : 0;};
	virtual uint32_t currentDifficulty() const {return _options->difficulty();};
};

// Simulates various network situations to test/debug code.
class TestClient : public Client {
	BlockHeader _bh;
	uint32_t _height, _difficulty;
	uint64_t _requests;
	std::chrono::time_point<std::chrono::steady_clock> _timer;
	uint64_t _timeBeforeNextBlock;
	std::vector<std::vector<uint64_t>> _acceptedConstellationOffsets;
	bool _getWork();
	
public:
	TestClient(const std::shared_ptr<Options> &options) : Client(options) {_height = 0;}
	bool connect();
	void updateMinerParameters(MinerParameters&);
	void sendWork(const WorkData&) const {} // Ignore blocks found
	WorkData workData();
	virtual bool getWork(WorkData& wd) {
		wd = workData();
		_requests++;
		return wd.height != 0;
	}
	virtual uint32_t currentHeight() const {return _connected ? _height : 0;};
	virtual uint32_t currentDifficulty() const {return _difficulty;};
};

#endif
