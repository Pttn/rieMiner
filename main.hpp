// (c) 2017-2020 Pttn and contributors (https://github.com/Pttn/rieMiner)

#ifndef HEADER_main_hpp
#define HEADER_main_hpp

#include <algorithm>
#include <array>
#include <chrono>
#include <fstream>
#include <iomanip>
#include <mutex>
#include <string>
#include <thread>
#include <unistd.h>
#include <vector>
#include "tools.hpp"

#define versionString	"rieMiner 0.91d"

extern int DEBUG;
#define DBG(x) if (DEBUG) {x;};
#define DBG_VERIFY(x) if (DEBUG > 1) { x; };

class Options {
	bool _enableAvx2;
	std::string _host, _username, _password, _mode, _payoutAddress, _secret, _tuplesFile;
	AddressFormat _payoutAddressFormat;
	uint16_t _debug, _port, _threads, _sieveWorkers, _sieveBits, _refreshInterval, _tupleLengthMin, _donate;
	uint32_t _benchmarkDifficulty, _benchmarkTimeLimit, _benchmark2tupleCountLimit;
	uint64_t _primeTableLimit, _primorialNumber;
	std::vector<uint64_t> _primorialOffsets, _constellationType;
	std::vector<std::string> _rules;
	
	void _parseLine(std::string, std::string&, std::string&) const;
	void _stopConfig() const;
	
	public:
	Options() : // Default options: Standard Benchmark with 8 threads
		_enableAvx2(false),
		_host("127.0.0.1"),
		_username(""),
		_password(""),
		_mode("Benchmark"),
		_payoutAddress("RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB"),
		_secret("/rM0.91/"),
		_tuplesFile("None"),
		_payoutAddressFormat(AddressFormat::P2PKH),
		_debug(0),
		_port(28332),
		_threads(8),
		_sieveWorkers(0),
		_sieveBits(25),
		_refreshInterval(30),
		_tupleLengthMin(6),
		_donate(2),
		_benchmarkDifficulty(1600),
		_benchmarkTimeLimit(0),
		_benchmark2tupleCountLimit(50000),
		_primeTableLimit(2147483648),
		_primorialNumber(40),
		_primorialOffsets{4209995887ull, 4209999247ull, 4210002607ull, 4210005967ull,
		                  7452755407ull, 7452758767ull, 7452762127ull, 7452765487ull,
		                  8145217177ull, 8145220537ull, 8145223897ull, 8145227257ull},
		_constellationType{0, 4, 2, 4, 2, 4}, // What type of constellations are we mining (offsets)
		_rules{"segwit"} {}
	
	void askConf();
	void loadConf();
	
	bool enableAvx2() const {return _enableAvx2;}
	std::string mode() const {return _mode;}
	std::string host() const {return _host;}
	uint16_t port() const {return _port;}
	std::string username() const {return _username;}
	std::string password() const {return _password;}
	std::string payoutAddress() const {return _payoutAddress;}
	AddressFormat payoutAddressFormat() const {return _payoutAddressFormat;}
	void setPayoutAddress(const std::string&);
	std::string secret() const {return _secret;}
	std::string tuplesFile() const {return _tuplesFile;}
	uint16_t threads() const {return _threads;}
	uint16_t sieveWorkers() const {return _sieveWorkers;}
	uint64_t primeTableLimit() const {return _primeTableLimit;}
	uint16_t sieveBits() const {return _sieveBits;}
	uint32_t refreshInterval() const {return _refreshInterval;}
	uint16_t tupleLengthMin() const {return _tupleLengthMin;}
	uint16_t donate() const {return _donate;}
	uint32_t benchmarkDifficulty() const {return _benchmarkDifficulty;}
	uint32_t benchmarkTimeLimit() const {return _benchmarkTimeLimit;}
	uint32_t benchmark2tupleCountLimit() const {return _benchmark2tupleCountLimit;}
	std::vector<uint64_t> constellationType() const {return _constellationType;}
	uint64_t primorialNumber() const {return _primorialNumber;}
	std::vector<uint64_t> primorialOffsets() const {return _primorialOffsets;}
	std::vector<std::string> rules() const {return _rules;}
};

#endif
