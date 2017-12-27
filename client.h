/* (c) 2017 Pttn (https://github.com/Pttn/rieMiner) */

#ifndef HEADER_CLIENT_H
#define HEADER_CLIENT_H

#include <vector>
#include <jansson.h>
#include <curl/curl.h>
#include "global.h"

#define GWDSIZE	1024

// Total 1024 bits/128 bytes (256 hex chars)
struct GetWorkData {
	uint32_t version;
	uint32_t prevBlockHash[8]; // 256 bits
	uint32_t merkleRoot[8];    // 256 bits
	uint32_t nBits;
	uint64_t nTime;            // Riecoin has 64bit timestamps
	uint32_t nOffset[8];       // 256 bits
	uint32_t remaining[4];     // 128 bits
	
	GetWorkData() {
		version = 0;
		nBits = 0;
		nTime = 0;
		for (uint8_t i(0) ; i < 8 ; i++) {
			prevBlockHash[i] = 0;
			merkleRoot[i] = 0;
			nOffset[i] = 0;
			if (i < 4) remaining[i] = 0;
		}
	}
};

struct WorkInfo {
	GetWorkData gwd;
	uint32_t height;
	uint32_t targetCompact;
	uint32_t target[8];
	
	WorkInfo() {
		gwd = GetWorkData();
		height = 0;
		targetCompact = 0;
		for (uint8_t i(0) ; i < 8 ; i++) {
			target[i] = 0;
		}
	}
};

class Client {
	bool _connected;
	std::string user;
	std::string pass;
	std::string host;
	uint16_t port;
	GetWorkData gwd;
	CURL *curl;
	pthread_mutex_t submitMutex;
	std::vector<std::pair<GetWorkData, uint8_t>> pendingSubmissions;
	
	std::string getUserPass() const {
		std::ostringstream oss;
		oss << user << ":" << pass;
		return oss.str();
	}
	
	std::string getHostPort() const {
		std::ostringstream oss;
		oss << "http://" << host << ":" << port << "/";
		return oss.str();
	}
	
	public:
	WorkInfo workInfo;
	
	Client();
	bool connect(const std::string&, const std::string&, const std::string&, uint16_t);
	bool getWork();
	void sendWork(const std::pair<GetWorkData, uint8_t>&) const;
	void addSubmission(const GetWorkData& gwdToSubmit, uint8_t difficulty) {
		pthread_mutex_lock(&submitMutex);
		pendingSubmissions.push_back(std::make_pair(gwdToSubmit, difficulty));
		pthread_mutex_unlock(&submitMutex);
	}
	bool process();
	bool connected() {return _connected;}
};

extern std::string minerVersionString;

#endif
