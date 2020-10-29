// (c) 2018-2020 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_StratumClient_hpp
#define HEADER_StratumClient_hpp

#include <fcntl.h>
#ifdef _WIN32
	#include <winsock2.h>
#else
	#include <arpa/inet.h>
	#include <netdb.h>
#endif
#include "Client.hpp"

// Stores the Stratum data got from the RPC call
struct StratumData {
	BlockHeader bh;
	std::vector<std::array<uint8_t, 32>> txHashes;
	uint32_t height, sharePrimeCountMin;
	std::vector<uint8_t> coinbase1, coinbase2;
	
	std::vector<std::pair<std::string, std::vector<uint8_t>>> sids; // Subscription Ids
	std::vector<uint8_t> extraNonce1, extraNonce2;
	std::string jobId; // This will never be converted to binary, so we can store this in a string; this will also help when there are leading zeros
	uint16_t extraNonce2Len;
	
	StratumData() : height(0), extraNonce2Len(0) {}
	void merkleRootGen();
};

constexpr int stratumBufferSize(2048);
constexpr double stratumTimeOut(180.); // in s

// Client for the Stratum protocol (pooled mining), working for the current Riecoin pools
class StratumClient : public NetworkedClient {
	// Options
	const std::string _username, _password, _host;
	const uint16_t _port;
	// Client State Variables
	std::mutex _submitMutex;
	std::vector<Job> _pendingSubmissions; // Send results from the main thread rather than a miner one
	NetworkInfo _info;
	StratumData _sd;
	int _socket;
	std::array<char, stratumBufferSize> _buffer;
	std::chrono::time_point<std::chrono::steady_clock> _lastDataRecvTp; // Used to disconnect if the server sent nothing since a long time
	uint32_t _shares, _rejectedShares;
	enum State {INIT, SUBSCRIBE_SENT, SUBSCRIBE_RCVD, READY, SHARE_SENT} _state;
	std::string _result; // Results of Stratum requests
	
	bool _fetchWork();
	void _submit(const Job& job);
	// These will process _result, filled in process()
	void _getSubscribeInfo(); // Extracts mining.subscribe response data (in particular, extranonces data). Also sends mining.authorize
	void _handleSentShareResponse(); // Checks if the server accepted the share
	void _handleOther(); // Handles various responses types by calling an appropriate function (for mining.notify or share submission response), or does nothing else for now
public:
	StratumClient(const Options &options) : _username(options.username()), _password(options.password()), _host(options.host()), _port(options.port()), _info{0, {}} {}
	void connect(); // Also sends mining.subscribe
	NetworkInfo info();
	void process(); // Get data from the server and calls the adequate member function to process it
	bool getJob(Job&, const bool = false);
	virtual void handleResult(const Job& job) { // Add result to pending submissions
		std::lock_guard<std::mutex> lock(_submitMutex);
		_pendingSubmissions.push_back(job);
	}
	virtual uint32_t currentHeight() const {return _sd.height;}
	virtual double currentDifficulty() const {return decodeBits(_sd.bh.bits, _info.powVersion);}
	void printSharesStats() const { // Must be after a Stats::printStats()
		std::cout << " ; Sh: " << _shares - _rejectedShares << "/" << _shares;
		if (_shares > 0) std::cout << " (" << FIXED(1) << 100.*(static_cast<double>(_shares - _rejectedShares)/static_cast<double>(_shares)) << "%)";
	}
};

#endif
