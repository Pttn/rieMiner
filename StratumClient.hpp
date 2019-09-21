// (c) 2018-2019 Pttn (https://github.com/Pttn/rieMiner)

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
	uint32_t height;
	std::vector<uint8_t> coinbase1, coinbase2;
	
	std::vector<std::pair<std::string, std::vector<uint8_t>>> sids; // Subscription Ids
	std::vector<uint8_t> extraNonce1, extraNonce2;
	std::string jobId; // This will never be converted to binary, so we can store this in a string; this will also help when there are leading zeros
	uint16_t extraNonce2Len;
	
	StratumData() : height(0), extraNonce2Len(0) {}
	void merkleRootGen();
};

#define RBUFSIZE	2048
#define RECVSIZE	(RBUFSIZE - 4)
#define STRATUMTIMEOUT	180. // in s

// Client for the Stratum protocol (pooled mining), working for the current Riecoin pools
class StratumClient : public Client {
	StratumData _sd;
	int _socket;
	std::array<char, RBUFSIZE> _buffer;
	std::chrono::time_point<std::chrono::system_clock> _lastDataRecvTp; // Used to disconnect if the server sent nothing since a long time
	
	enum State {INIT, SUBSCRIBE_SENT, SUBSCRIBE_RCVD, READY, SHARE_SENT};
	State _state;
	std::string _result; // Results of Stratum requests
	
	bool _getWork();
	// These will process _result, filled in process()
	void _getSubscribeInfo(); // Extracts mining.subscribe response data (in particular, extranonces data). Also sends mining.authorize
	void _getSentShareResponse(); // Checks if the server accepted the share
	void _handleOther(); // Handles various responses types by calling an appropriate function (for mining.notify or share submission response), or does nothing else for now
	
	public:
	using Client::Client;
	bool connect(); // Also sends mining.subscribe
	void sendWork(const WorkData&) const; // Via mining.submit
	bool process(); // Get data from the server and calls the adequate member function to process it
	WorkData workData() const;
};

#endif
