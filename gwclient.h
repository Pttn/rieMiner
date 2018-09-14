// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_GWCLIENT_H
#define HEADER_GWCLIENT_H

#include "client.h"

#define GWDSIZE	1024

struct GetWorkData {
	BlockHeader bh;
	GetWorkData() {bh = BlockHeader();}
};

class GWClient : public RPCClient {
	GetWorkData _gwd;
	uint32_t _height;
	
	public:
	using RPCClient::RPCClient;
	bool connect();
	bool getWork();
	void sendWork(const std::pair<WorkData, uint8_t>&) const;
	WorkData workData() const;
};

#endif
