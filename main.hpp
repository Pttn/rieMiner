// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#ifndef HEADER_main_hpp
#define HEADER_main_hpp

#define minerVersionString	"rieMiner 0.9-RC1"

#include <unistd.h>
#include <string>
#include <array>
#include <vector>
#include <algorithm>
#include <iomanip>
#include <chrono>
#include <thread>
#include <mutex>
#include <fstream>
#include "tools.hpp"

#define leading0s(x) std::setw(x) << std::setfill('0')
#define FIXED(x) std::fixed << std::setprecision(x)

class Options {
	std::string _host, _user, _pass, _protocol, _address, _tcFile;
	uint8_t _tuples, _sieveBits;
	uint16_t _port, _threads, _sieveWorkers;
	uint32_t _refresh, _testDiff, _testTime, _test2t;
	uint64_t _sieve, _pn;
	uint64_t _maxMem;
	std::vector<uint64_t> _consType, _pOff;
	
	void parseLine(std::string, std::string&, std::string&) const;
	
	public:
	Options() { // Default options: Standard Benchmark with 8 threads
		_user      = "";
		_pass      = "";
		_host      = "127.0.0.1";
		_protocol  = "Benchmark";
		_address   = "RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB";
		_tcFile    = "None";
		_port      = 28332;
		_threads   = 8;
		_sieveWorkers = 0;
		_sieve     = 1073741824;
		_tuples    = 6;
		_refresh   = 30;
		_testDiff  = 1600;
		_testTime  = 0;
		_test2t    = 50000;
		_pn        = 40; // Primorial Number
		_pOff      = {4209995887ull, 4209999247ull, 4210002607ull, 4210005967ull, 
		              7452755407ull, 7452758767ull, 7452762127ull, 7452765487ull}; // Primorial Offsets
		_maxMem    = 0;
		_sieveBits = 25;
		_consType  = {0, 4, 2, 4, 2, 4}; // What type of constellations are we mining (offsets)
	}
	
	void loadConf();
	void askConf();
	
	std::string host() const {return _host;}
	uint16_t port() const {return _port;}
	std::string user() const {return _user;}
	std::string pass() const {return _pass;}
	std::string protocol() const {return _protocol;}
	std::string address() const {return _address;}
	std::string tcFile() const {return _tcFile;}
	uint16_t threads() const {return _threads;}
	uint16_t sieveWorkers() const {return _sieveWorkers;}
	uint64_t sieve() const {return _sieve;}
	uint8_t tuples() const {return _tuples;}
	uint32_t refresh() const {return _refresh;}
	uint32_t testDiff() const {return _testDiff;}
	uint32_t testTime() const {return _testTime;}
	uint32_t test2t() const {return _test2t;}
	uint64_t pn() const {return _pn;}
	std::vector<uint64_t> pOff() const {return _pOff;}
	uint64_t maxMem() const {return _maxMem;}
	uint8_t sieveBits() const {return _sieveBits;}
	std::vector<uint64_t> consType() const {return _consType;}
};

#endif
