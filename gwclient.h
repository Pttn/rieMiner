// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_GWCLIENT_H
#define HEADER_GWCLIENT_H

#include "client.h"

#define GWDSIZE	1024

struct GetWorkData {
	BlockHeader bh;
	GetWorkData() {bh = BlockHeader();}
};

class GWClient : public Client {
	GetWorkData _gwd;
	
	public:
	bool connect(const Arguments&);
	bool getWork();
	void sendWork(const std::pair<WorkData, uint8_t>&) const;
};

#endif
