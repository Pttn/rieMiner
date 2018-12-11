// (c) 2017-2018 Pttn and contributors (https://github.com/Pttn/rieMiner)

#ifndef HEADER_main_hpp
#define HEADER_main_hpp

#define versionString	"rieMiner 0.9L"

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

extern int DEBUG;
#define DBG(x) if (DEBUG) {x;};
#define DBG_VERIFY(x) if (DEBUG > 1) { x; };

enum AddressFormat {INVALID, P2PKH, P2SH, BECH32};

class Options {
	std::string _host, _username, _password, _mode, _payoutAddress, _secret;
	AddressFormat _payoutAddressFormat;
	uint16_t _debug, _port, _threads, _sieveWorkers, _sieveBits, _refreshInterval, _tupleLengthMin;
	uint32_t _benchmarkDifficulty, _benchmarkTimeLimit, _benchmark2tupleCountLimit;
	uint64_t _primeTableLimit, _primorialNumber;
	std::vector<uint64_t> _primorialOffsets, _constellationType;
	std::vector<std::string> _rules;
	
	void _parseLine(std::string, std::string&, std::string&) const;
	void _stopConfig() const;
	
	public:
	Options() { // Default options: Standard Benchmark with 8 threads
		_debug = 0;
		_mode = "Benchmark";
		_host = "127.0.0.1";
		_port = 28332;
		_username = "";
		_password = "";
		_payoutAddress = "RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB";
		_payoutAddressFormat = AddressFormat::P2PKH;
		_secret = "/rieMiner/";
		_threads = 8;
		_sieveWorkers = 0;
		_primeTableLimit = 2147483648;
		_sieveBits = 25;
		_refreshInterval = 30;
		_tupleLengthMin = 6;
		_benchmarkDifficulty = 1600;
		_benchmarkTimeLimit = 0;
		_benchmark2tupleCountLimit = 50000;
		_constellationType = {0, 4, 2, 4, 2, 4}; // What type of constellations are we mining (offsets)
		_primorialNumber = 40; // Primorial Number
		_primorialOffsets = {4209995887ull, 4209999247ull, 4210002607ull, 4210005967ull,
		                     7452755407ull, 7452758767ull, 7452762127ull, 7452765487ull,
		                     8145217177ull, 8145220537ull, 8145223897ull, 8145227257ull}; // Primorial Offsets
		_rules = std::vector<std::string>();
	}
	
	void askConf();
	void loadConf();
	
	std::string mode() const {return _mode;}
	std::string host() const {return _host;}
	uint16_t port() const {return _port;}
	std::string username() const {return _username;}
	std::string password() const {return _password;}
	std::string payoutAddress() const {return _payoutAddress;}
	AddressFormat payoutAddressFormat() const {return _payoutAddressFormat;}
	void setPayoutAddress(const std::string&);
	std::string secret() const {return _secret;}
	uint16_t threads() const {return _threads;}
	uint16_t sieveWorkers() const {return _sieveWorkers;}
	uint64_t primeTableLimit() const {return _primeTableLimit;}
	uint16_t sieveBits() const {return _sieveBits;}
	uint32_t refreshInterval() const {return _refreshInterval;}
	uint16_t tupleLengthMin() const {return _tupleLengthMin;}
	uint32_t benchmarkDifficulty() const {return _benchmarkDifficulty;}
	uint32_t benchmarkTimeLimit() const {return _benchmarkTimeLimit;}
	uint32_t benchmark2tupleCountLimit() const {return _benchmark2tupleCountLimit;}
	std::vector<uint64_t> constellationType() const {return _constellationType;}
	uint64_t primorialNumber() const {return _primorialNumber;}
	std::vector<uint64_t> primorialOffsets() const {return _primorialOffsets;}
	std::vector<std::string> rules() const {return _rules;}
};

#endif
