// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_GLOBAL_H
#define HEADER_GLOBAL_H

#define BITS	64

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

struct GetWorkData;
struct BlockHeader;
struct WorkData;

void miningInit(uint64_t, int16_t);
void miningProcess(WorkData);
void submitWork(WorkData, uint32_t*, uint8_t);

#define leading0s(x) std::setw(x) << std::setfill('0')
#define FIXED(x) std::fixed << std::setprecision(x)

inline double timeSince(std::chrono::time_point<std::chrono::system_clock> t0) {
	std::chrono::time_point<std::chrono::system_clock> t(std::chrono::system_clock::now());
	std::chrono::duration<double> dt(t - t0);
	return dt.count();
}

struct Stats {
	std::array<uint32_t, 7> foundTuples, foundTuplesSinceLastDifficulty;
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
	
	void printTuplesStats() {
		std::array<uint32_t, 7> t(foundTuplesSinceLastDifficulty);
		double elapsedSecs(timeSince(lastDifficultyChange));
		std::cout << "Tuples found for diff " << difficulty <<  ": (" << t[2] << " " << t[3] << " " << t[4] << " " << t[5] << " " << t[6] << ") during " << FIXED(2) << elapsedSecs << " s" << std::endl;
		std::cout << "Tuples/s: (" << FIXED(6) << t[2]/elapsedSecs << " " << t[3]/elapsedSecs << " " << FIXED(6) << t[4]/elapsedSecs << " " << t[5]/elapsedSecs << " " << t[6]/elapsedSecs << ")" << std::endl;
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
	std::string _protocol;
	std::string _address;
	uint16_t _threads;
	uint64_t _sieve;
	uint8_t _tuples;
	uint32_t _refresh;
	
	void parseLine(std::string, std::string&, std::string&) const;
	
	public:
	
	Arguments() {
		_user     = "";
		_pass     = "";
		_host     = "127.0.0.1";
		_protocol = "GetBlockTemplate";
		_address  = "RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB";
		_port     = 28332;
		_threads  = 8;
		_sieve    = 1073741824;
		_tuples   = 6;
		_refresh  = 10;
	}
	
	void loadConf();
	
	std::string host() const {return _host;}
	uint16_t port() const {return _port;}
	std::string user() const {return _user;}
	std::string pass() const {return _pass;}
	std::string protocol() const {return _protocol;}
	std::string address() const {return _address;}
	uint16_t threads() const {return _threads;}
	uint64_t sieve() const {return _sieve;}
	uint8_t tuples() const {return _tuples;}
	uint32_t refresh() const {return _refresh;}
};

extern Arguments arguments;

extern volatile uint32_t currentBlockHeight;

#endif
