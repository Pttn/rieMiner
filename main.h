// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_GLOBAL_H
#define HEADER_GLOBAL_H

#define minerVersionString	"rieMiner 0.9-beta2"
#define BITS	64

#include <unistd.h>
#include <gmpxx.h>
#include <string>
#include <array>
#include <vector>
#include <iomanip>
#include <chrono>
#include <thread>
#include <mutex>
#include "tools.h"

struct GetWorkData;
struct BlockHeader;
struct WorkData;
class Client;
class Miner;

#define leading0s(x) std::setw(x) << std::setfill('0')
#define FIXED(x) std::fixed << std::setprecision(x)

class Stats {
	std::array<uint32_t, 7> _tuples, _tuplesSinceLastDiff;
	uint32_t _height, _difficulty, _heightAtDiffChange;
	std::chrono::time_point<std::chrono::system_clock> _miningStartTp, _lastDiffChangeTp;
	bool _solo;
	
	bool inited() const {return _difficulty != 1 && _height != 0;}
	
	public:
	Stats() {
		for (uint8_t i(0) ; i < 7 ; i++) {
			_tuples[i] = 0;
			_tuplesSinceLastDiff[i] = 0;
		}
		_difficulty = 1;
		_heightAtDiffChange = 0;
		_lastDiffChangeTp = std::chrono::system_clock::now();
		_solo = true;
	}
	
	void startTimer() {
		_miningStartTp = std::chrono::system_clock::now();
		_lastDiffChangeTp = std::chrono::system_clock::now();
	}
	
	void setMiningType(std::string protocol) {_solo = !(protocol == "Stratum");}
	
	void incTupleCount(uint8_t i) {
		_tuples[i]++;
		_tuplesSinceLastDiff[i]++;
	}
	
	uint32_t height() const {return _height;}
	void updateHeight(uint32_t height) {
		if (inited()) {
			printTime();
			if (height - _heightAtDiffChange != 0) {
				std::cout << " Blockheight = " << height << ", average "
					      << FIXED(1) << timeSince(_lastDiffChangeTp)/(height - _heightAtDiffChange)
					      << " s, difficulty = " << _difficulty << std::endl;
			}
			else std::cout << " Blockheight = " << height << ", new difficulty = " << _difficulty << std::endl;
		}
	}
	
	uint32_t difficulty() const {return _difficulty;}
	void updateDifficulty(uint32_t newDifficulty, uint32_t height) {
		printTuplesStats();
		_difficulty = newDifficulty;
		_heightAtDiffChange = height;
		_lastDiffChangeTp = std::chrono::system_clock::now();
		for (uint8_t i(0) ; i < 7 ; i++) _tuplesSinceLastDiff[i] = 0;
	}
	uint32_t heightAtDiffChange() const {return _heightAtDiffChange;}
	
	std::chrono::time_point<std::chrono::system_clock> miningStartTp() const {return _miningStartTp;}
	std::array<uint32_t, 7> tuplesCount() const {return _tuples;}
	
	void printTime() const {
		double elapsedSecs(timeSince(_miningStartTp));
		uint32_t elapsedSecsInt(elapsedSecs);
		std::cout << "[" << leading0s(4) << (elapsedSecsInt/3600) % 10000 << ":" << leading0s(2) << (elapsedSecsInt/60) % 60 << ":" << leading0s(2) << elapsedSecsInt % 60 << "]";
	}
	
	void printStats() const {
		double elapsedSecs(timeSince(_lastDiffChangeTp));
		if (elapsedSecs > 1 && timeSince(_miningStartTp) > 1) {
			printTime();
			std::cout << " (2-4t/s) = (" << FIXED(2) << _tuplesSinceLastDiff[2]/elapsedSecs << " " << FIXED(3) << _tuplesSinceLastDiff[3]/elapsedSecs << " " << FIXED(4) << _tuplesSinceLastDiff[4]/elapsedSecs << ") ; "
			          << "(2-6t) = (" << _tuples[2] << " " << _tuples[3] << " " << _tuples[4] << " " << _tuples[5] << " " << _tuples[6] << ")";
		}
	}
	
	void printTuplesStats() const {
		if (inited()) {
			std::array<uint32_t, 7> t(_tuplesSinceLastDiff);
			double elapsedSecs(timeSince(_lastDiffChangeTp));
			std::cout << "Tuples found for diff " << _difficulty <<  ": (" << t[2] << " " << t[3] << " " << t[4] << " " << t[5] << " " << t[6] << ") during " << FIXED(3) << elapsedSecs << " s" << std::endl;
			std::cout << "Tuples/s: (" << FIXED(6) << t[2]/elapsedSecs << " " << t[3]/elapsedSecs << " " << FIXED(6) << t[4]/elapsedSecs << " " << t[5]/elapsedSecs << " " << t[6]/elapsedSecs << ")" << std::endl;
			std::cout << "Ratios: (" << FIXED(1);
			for (uint32_t i(3) ; i <= 6 ; i++) {
				if (t[i] != 0) std::cout << ((double) t[i - 1])/((double) t[i]);
				else std::cout << "inf";
				if (i != 6) std::cout << " ";
			}
			std::cout << ")" << std::endl;
		}
	}
	
	void printEstimatedTimeToBlock() const {
		double elapsedSecs(timeSince(_lastDiffChangeTp));
		if (elapsedSecs > 1 && timeSince(_miningStartTp) > 1) {
			if (_tuplesSinceLastDiff[4] > 0) {
				if (_solo) {
					double r23(((double) _tuplesSinceLastDiff[2])/((double) _tuplesSinceLastDiff[3])),
						   r34(((double) _tuplesSinceLastDiff[3])/((double) _tuplesSinceLastDiff[4])),
						   s3(((double) _tuplesSinceLastDiff[3])/elapsedSecs);
					std::cout << FIXED(2) << " | " << r23*r23*r34/(86400.*s3) << " d";
				}
				else { // Hint: it is 15x easier to find a 2 or 4-share, and 20x for 3 shares, than true k-tuples: (6 2) = (6 4) = 15, (6 3) = 20
					double r34(((double) _tuplesSinceLastDiff[2]/15.)/((double) _tuplesSinceLastDiff[3]/20.)),
						   r23(((double) _tuplesSinceLastDiff[3]/20.)/((double) _tuplesSinceLastDiff[4]/15.)),
						   s3(((double) _tuplesSinceLastDiff[3]/20.)/elapsedSecs);
					std::cout << FIXED(2) << " | " << (25.*86400.*s3)/(r23*r23*r34) << " RIC/d";
				}
			}
			std::cout << std::endl;
		}
	}
};

class Options {
	std::string _host, _user, _pass, _protocol, _address;
	uint8_t _tuples;
	uint16_t _port, _threads;
	uint32_t _refresh, _testDiff, _testTime, _test3t;
	uint64_t _sieve;
	
	void parseLine(std::string, std::string&, std::string&) const;
	
	public:
	Options() { // Default options: Standard Benchmark with 8 threads
		_user     = "";
		_pass     = "";
		_host     = "127.0.0.1";
		_protocol = "Benchmark";
		_address  = "RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB";
		_port     = 28332;
		_threads  = 8;
		_sieve    = 1073741824;
		_tuples   = 6;
		_refresh  = 30;
		_testDiff = 1600;
		_testTime = 0;
		_test3t   = 1000;
	}
	
	void loadConf();
	void askConf();
	
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
	uint32_t testDiff() const {return _testDiff;}
	uint32_t testTime() const {return _testTime;}
	uint32_t test3t() const {return _test3t;}
};

class WorkManager : public std::enable_shared_from_this<WorkManager> {
	Options _options;
	Stats _stats;
	std::unique_ptr<Client> _client;
	std::unique_ptr<Miner> _miner;
	std::mutex _clientMutex;
	std::vector<std::thread> _threads;
	bool _inited, _miningStarted;
	uint16_t _waitReconnect; // Time in s to wait before reconnecting after disconnect
	uint16_t _workRefresh;   // Time in ms for each fetch work cycle
	
	void minerThread();
	
	public:
	WorkManager();
	
	void init();
	void submitWork(WorkData wd, uint32_t* nOffset, uint8_t length);
	void manage();
	Options options() {return _options;}
	uint32_t height() {return _stats.height();}
	uint32_t difficulty() {return _stats.difficulty();}
	void printTime() {_stats.printTime();}
	void printTuplesStats() {_stats.printTuplesStats();}
	void incTupleCount(uint8_t i) {_stats.incTupleCount(i);}
	void updateDifficulty(uint32_t newDifficulty, uint32_t height) {_stats.updateDifficulty(newDifficulty, height);}
	void updateHeight(uint32_t height) {_stats.updateHeight(height);}
};

#endif
