/* (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner) */

#ifndef HEADER_GLOBAL_H
#define HEADER_GLOBAL_H

#include <unistd.h>
#include <gmpxx.h>
#include <stdio.h>
#include <iostream>
#include <cstdint>
#include <string>
#include <sstream>
#include <array>
#include <vector>
#include <iomanip>
#include <chrono>
#include <thread>
#include <mutex>

#include "External/sha2.h"

struct GetWorkData;
struct WorkInfo;

void miningInit(uint64_t sieveMax, int16_t threads);
void miningProcess(const WorkInfo& block);
void submitWork(GetWorkData block, uint32_t* nOffset, uint8_t difficulty);

#define leading0s(x) std::setw(x) << std::setfill('0')
#define FIXED(x) std::fixed << std::setprecision(x)

inline double timeSince(std::chrono::time_point<std::chrono::system_clock> t0) {
	std::chrono::time_point<std::chrono::system_clock> t(std::chrono::system_clock::now());
	std::chrono::duration<double> dt(t - t0);
	return dt.count();
}

struct Stats {
	uint32_t foundTuples[7], foundTuplesSinceLastDifficulty[7];
	uint32_t difficulty, blockHeightAtDifficultyChange;
	std::chrono::time_point<std::chrono::system_clock> start, startMining, lastDifficultyChange;
	
	Stats() {
		for (uint8_t i(0) ; i < 7 ; i++) {
			foundTuples[i] = 0;
			foundTuplesSinceLastDifficulty[i] = 0;
		}
		difficulty = 1;
		blockHeightAtDifficultyChange = 0;
		lastDifficultyChange = std::chrono::system_clock::now();
		start = std::chrono::system_clock::now();
	}
	
	void printTime() {
		double elapsedSecs(timeSince(startMining));
		uint32_t elapsedSecsInt(elapsedSecs);
		std::cout << "[" << leading0s(4) << (elapsedSecsInt/3600) % 10000 << ":" << leading0s(2) << (elapsedSecsInt/60) % 60 << ":" << leading0s(2) << elapsedSecsInt % 60 << "]";
	}
	
	void printStats() {
		double elapsedSecs(timeSince(lastDifficultyChange));
		if (elapsedSecs > 1 && timeSince(startMining) > 1) {
			printTime();
			std::cout << " (2/3t/s) = (" << FIXED(2) << foundTuplesSinceLastDifficulty[2]/elapsedSecs << " " << FIXED(3) << foundTuplesSinceLastDifficulty[3]/elapsedSecs << ") ; "
			          << "(2-6t) = (" << foundTuples[2] << " " << foundTuples[3] << " " << foundTuples[4] << " " << foundTuples[5] << " " << foundTuples[6] << ")";
		}
	}
	
	void printEstimatedTimeToBlock() {
		double elapsedSecs(timeSince(lastDifficultyChange));
		if (elapsedSecs > 1 && timeSince(startMining) > 1) {
			if (foundTuplesSinceLastDifficulty[4] > 0) {
				double x(((double) foundTuplesSinceLastDifficulty[2])/((double) foundTuplesSinceLastDifficulty[3])),
				       y(((double) foundTuplesSinceLastDifficulty[3])/((double) foundTuplesSinceLastDifficulty[4])),
				       w(((double) foundTuplesSinceLastDifficulty[3])/elapsedSecs);
				std::cout << FIXED(2) << " | " << x*x*y/(86400.*w) << " d";
			}
			std::cout << std::endl;
		}
	}
};

extern Stats stats;

class Arguments {
	std::string _host;
	uint16_t _port;
	std::string _user;
	std::string _pass;
	uint16_t _threads;
	uint32_t _sieve;
	uint8_t _tuples;
	uint32_t _refresh;
	
	void parseLine(std::string, std::string&, std::string&) const;
	
	public:
	
	Arguments() {
		_user    = "";
		_pass    = "";
		_host    = "127.0.0.1";
		_port    = 28332;
		_threads = 8;
		_sieve   = 1073741824;
		_tuples  = 6;
		_refresh = 10;
	}
	
	void loadConf();
	
	std::string host() const {return _host;}
	uint16_t port() const {return _port;}
	std::string user() const {return _user;}
	std::string pass() const {return _pass;}
	uint16_t threads() const {return _threads;}
	uint32_t sieve() const {return _sieve;}
	uint8_t tuples() const {return _tuples;}
	uint32_t refresh() const {return _refresh;}
};

extern Arguments arguments;

extern volatile uint32_t monitorCurrentBlockHeight;
extern volatile uint32_t monitorCurrentBlockTime;

#define bswap_32(x) ((((x) << 24) & 0xff000000u) | (((x) << 8) & 0x00ff0000u) | (((x) >> 8) & 0x0000ff00u) | (((x) >> 24) & 0x000000ffu))

inline uint32_t swab32(uint32_t v) {
	return bswap_32(v);
}

#if !HAVE_DECL_BE32DEC
inline uint32_t be32dec(const void *pp) {
	const uint8_t *p = (uint8_t const *)pp;
	return ((uint32_t)(p[3]) + ((uint32_t)(p[2]) << 8) +
	    ((uint32_t)(p[1]) << 16) + ((uint32_t)(p[0]) << 24));
}
#endif

#if !HAVE_DECL_LE32DEC
inline uint32_t le32dec(const void *pp) {
	const uint8_t *p = (uint8_t const *)pp;
	return ((uint32_t)(p[0]) + ((uint32_t)(p[1]) << 8) +
	    ((uint32_t)(p[2]) << 16) + ((uint32_t)(p[3]) << 24));
}
#endif

#if !HAVE_DECL_LE32ENC
inline void le32enc(void *pp, uint32_t x) {
	uint8_t *p = (uint8_t *)pp;
	p[0] = x & 0xff;
	p[1] = (x >> 8) & 0xff;
	p[2] = (x >> 16) & 0xff;
	p[3] = (x >> 24) & 0xff;
}
#endif

#endif
