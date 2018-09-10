// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_STRATUMCLIENT_H
#define HEADER_STRATUMCLIENT_H

#include "client.h"

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
	std::vector<uint8_t> coinbase1, coinbase2;
	
	std::vector<std::pair<std::string, std::vector<uint8_t>>> sids; // Subscription Ids
	std::vector<uint8_t> extraNonce1, jobId;
	uint16_t extraNonce1Len, extraNonce2Len;
	
	StratumData() {
		bh = BlockHeader();
		txHashes = std::vector<std::array<uint32_t, 8>>();
		height = 0;
		coinbase1 = std::vector<uint8_t>();
		coinbase2 = std::vector<uint8_t>();
		sids = std::vector<std::pair<std::string, std::vector<uint8_t>>>();
		extraNonce1 = std::vector<uint8_t>();
		jobId = std::vector<uint8_t>();
		extraNonce1Len = 0;
		extraNonce2Len = 0;
	}
};

#define RBUFSIZE	2048
#define RECVSIZE	(RBUFSIZE - 4)
#define MAXNDC  	1024 // A sort of Timeout

class StratumClient : public Client {
	StratumData _sd;
	int _socket;
	std::array<char, RBUFSIZE> _buffer;
	uint16_t _noDataCount; // Used to disconnect if the server sent nothing since a long time
	
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
