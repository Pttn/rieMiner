/* (c) 2017 Pttn (https://github.com/Pttn/rieMiner) */

#ifndef HEADER_GLOBAL_H
#define HEADER_GLOBAL_H

#include <unistd.h>
#include <pthread.h>
#include <gmp.h>
#include <gmpxx.h>
#include <stdio.h>
#include <iostream>
#include <cstdlib>
#include <cstdint>
#include <string>
#include <sstream>
#include <array>
#include <vector>
#include <iomanip>
#include <chrono>

#include "client.h"
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
		start = std::chrono::system_clock::now();
	}
	
	void printTime() {
		double elapsedSecs(timeSince(startMining));
		uint32_t elapsedSecsInt(elapsedSecs);
		std::cout << "[" << leading0s(4) << (elapsedSecsInt/3600) % 10000 << ":" << leading0s(2) << (elapsedSecsInt/60) % 60 << ":" << leading0s(2) << elapsedSecsInt % 60 << "]";
	}
	
	void printStats() {
		double elapsedSecs(timeSince(lastDifficultyChange));
		if (elapsedSecs > 1) {
			printTime();
			std::cout << " (2/3t/s) = (" << FIXED(2) << foundTuplesSinceLastDifficulty[2]/elapsedSecs << " " << FIXED(3) << foundTuplesSinceLastDifficulty[3]/elapsedSecs << ") ; "
			          << "(2-6t) = (" << foundTuples[2] << " " << foundTuples[3] << " " << foundTuples[4] << " " << foundTuples[5] << " " << foundTuples[6] << ") ; "
			          << "Diff: " << difficulty << std::endl;
		}
	}
	
	void printEstimatedTimeToBlock() {
		double elapsedSecs(timeSince(lastDifficultyChange));
		if (elapsedSecs > 1. && foundTuplesSinceLastDifficulty[4] > 2) {
			double x(((double) foundTuplesSinceLastDifficulty[2])/((double) foundTuplesSinceLastDifficulty[3])),
			       y(((double) foundTuplesSinceLastDifficulty[3])/((double) foundTuplesSinceLastDifficulty[4])),
			       w(((double) foundTuplesSinceLastDifficulty[3])/elapsedSecs);
			std::cout << "             Estimated average time to block: " << x*y*y/(86400.*w) << " days" << std::endl;
		}
	}
};

extern Stats stats;

struct Arguments {
	std::string host;
	uint16_t port;
	std::string user;
	std::string pass;
	uint16_t threads;
	uint32_t sieveMax;
	uint8_t tuples;
	uint32_t refreshRate;
	
	Arguments() {
		user = "";
		pass = "";
		host = "127.0.0.1";
		port = 28332;
		threads = 1;
		sieveMax = 1073741824;
		tuples = 6;
		refreshRate = 10;
	}
};

extern Arguments arguments;

extern volatile uint32_t monitorCurrentBlockHeight;
extern volatile uint32_t monitorCurrentBlockTime;

uint64_t getTimeMilliseconds();
uint64_t getTimeHighRes();
uint64_t getTimerRes();

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
