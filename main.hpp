// (c) 2017-2021 Pttn and contributors (https://github.com/Pttn/rieMiner)

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

#define versionString	"rieMiner 0.92Lb"
#define primeTableFile	"PrimeTable32.bin"

extern int DEBUG;
extern std::string confPath;

#define DBG(x) if (DEBUG) {x;};
#define DBG_VERIFY(x) if (DEBUG > 1) { x; };
#define ERRORMSG(message) std::cerr << __func__ << ": " << message << " :| !" << std::endl

static const std::vector<std::pair<std::vector<uint32_t>, std::vector<uint32_t>>> defaultConstellationData = {
	// 1-tuples
	{{0}, {15760091U, 25658441U, 93625991U, 182403491U, 226449521U, 661972301U, 910935911U, 1042090781U, 1071322781U, 1170221861U, 1394025161U, 1459270271U, 1712750771U, 1742638811U, 1935587651U, 2048038451U}}, // OEIS A022011 (8-tuples)
	// 2-tuples
	{{0, 2}, {15760091U, 25658441U, 93625991U, 182403491U, 226449521U, 661972301U, 910935911U, 1042090781U, 1071322781U, 1170221861U, 1394025161U, 1459270271U, 1712750771U, 1742638811U, 1935587651U, 2048038451U}}, // OEIS A022011 (8-tuples)
	{{0, 2, 4}, {15760091U, 25658441U, 93625991U, 182403491U, 226449521U, 661972301U, 910935911U, 1042090781U, 1071322781U, 1170221861U, 1394025161U, 1459270271U, 1712750771U, 1742638811U, 1935587651U, 2048038451U}}, // OEIS A022011 (8-tuples)
	{{0, 4, 2}, {1091257U, 1615837U, 1954357U, 2822707U, 2839927U, 3243337U, 3400207U, 6005887U, 6503587U, 7187767U, 7641367U, 8061997U, 8741137U, 10526557U, 11086837U, 11664547U}}, // OEIS A022013 (6-tuples)
	// 4-tuples
	{{0, 2, 4, 2}, {15760091U, 25658441U, 93625991U, 182403491U, 226449521U, 661972301U, 910935911U, 1042090781U, 1071322781U, 1170221861U, 1394025161U, 1459270271U, 1712750771U, 1742638811U, 1935587651U, 2048038451U}}, // OEIS A022011 (8-tuples)
	// 5-tuples
	{{0, 2, 4, 2, 4}, {15760091U, 25658441U, 93625991U, 182403491U, 226449521U, 661972301U, 910935911U, 1042090781U, 1071322781U, 1170221861U, 1394025161U, 1459270271U, 1712750771U, 1742638811U, 1935587651U, 2048038451U}}, // OEIS A022011 (8-tuples)
	{{0, 4, 2, 4, 2}, {1091257U, 1615837U, 1954357U, 2822707U, 2839927U, 3243337U, 3400207U, 6005887U, 6503587U, 7187767U, 7641367U, 8061997U, 8741137U, 10526557U, 11086837U, 11664547U}}, // OEIS A022013 (6-tuples)
	// 6-tuples
	{{0, 4, 2, 4, 2, 4}, {1091257U, 1615837U, 1954357U, 2822707U, 2839927U, 3243337U, 3400207U, 6005887U, 6503587U, 7187767U, 7641367U, 8061997U, 8741137U, 10526557U, 11086837U, 11664547U}}, // OEIS A022013
	// 7-tuples
	{{0, 2, 4, 2, 4, 6, 2}, {15760091U, 25658441U, 93625991U, 182403491U, 226449521U, 661972301U, 910935911U, 1042090781U, 1071322781U, 1170221861U, 1394025161U, 1459270271U, 1712750771U, 1742638811U, 1935587651U, 2048038451U}}, // OEIS A022011 (8-tuples)
	{{0, 2, 6, 4, 2, 4, 2}, {855719U, 1146779U, 6560999U, 7540439U, 8573429U, 17843459U, 19089599U, 24001709U, 42981929U, 43534019U, 69156539U, 74266259U, 79208399U, 80427029U, 84104549U, 87988709U}}, // OEIS A022010
	// 8-tuples
	{{0, 2, 4, 2, 4, 6, 2, 6}, {15760091U, 25658441U, 93625991U, 182403491U, 226449521U, 661972301U, 910935911U, 1042090781U, 1071322781U, 1170221861U, 1394025161U, 1459270271U, 1712750771U, 1742638811U, 1935587651U, 2048038451U}}, // OEIS A022011
	{{0, 2, 4, 6, 2, 6, 4, 2}, {2580647U, 20737877U, 58208387U, 73373537U, 76170527U, 100658627U, 134764997U, 137943347U, 165531257U, 171958667U, 224008217U, 252277007U, 294536147U, 309740987U, 311725847U, 364154027U}}, // OEIS A022012
	{{0, 6, 2, 6, 4, 2, 4, 2}, {855713U, 1146773U, 6560993U, 69156533U, 74266253U, 218033723U, 261672773U, 302542763U, 964669613U, 1340301863U, 1400533223U, 1422475913U, 1837160183U, 1962038783U, 2117861723U, 2249363093U}}, // OEIS A022013
};

struct MinerParameters {
	uint16_t threads, sieveWorkers, tupleLengthMin;
	uint32_t primorialNumber, primeTableLimit;
	uint32_t sieveBits, sieveSize, sieveWords, sieveIterations;
	std::vector<uint32_t> pattern, primorialOffsets;
	
	MinerParameters() :
		threads(0), sieveWorkers(0), tupleLengthMin(0),
		primorialNumber(0), primeTableLimit(0),
		sieveBits(0), sieveSize(0), sieveWords(0), sieveIterations(0),
		pattern{}, primorialOffsets{} {}
};

class Options {
	MinerParameters _minerParameters;
	std::string _host, _username, _password, _mode, _payoutAddress, _secret, _tuplesFile;
	uint32_t _filePrimeTableLimit;
	uint16_t _debug, _port, _threads, _donate;
	double _refreshInterval, _difficulty, _benchmarkBlockInterval, _benchmarkTimeLimit;
	uint64_t _benchmarkPrimeCountLimit;
	std::vector<std::string> _rules;
	std::vector<std::string> _options;
	
	void _parseLine(std::string, std::string&, std::string&) const;
	void _stopConfig() const;
	
	public:
	Options() : // Default options: Standard Benchmark with 8 threads
		_host("127.0.0.1"),
		_username(""),
		_password(""),
		_mode("Benchmark"),
		_payoutAddress("ric1qpttn5u8u9470za84kt4y0lzz4zllzm4pyzhuge"),
		_secret("/rM0.92L/"),
		_tuplesFile("Tuples.txt"),
		_filePrimeTableLimit(0),
		_debug(0),
		_port(28332),
		_donate(2),
		_refreshInterval(30.),
		_difficulty(1024.),
		_benchmarkBlockInterval(150.),
		_benchmarkTimeLimit(86400.),
		_benchmarkPrimeCountLimit(1000000),
		_rules{"segwit"},
		_options{} {}
	
	void askConf();
	void loadFileOptions(const std::string&, const bool);
	void loadCommandOptions(const int, char**);
	void parseOptions();
	
	MinerParameters minerParameters() const {return _minerParameters;}
	std::string mode() const {return _mode;}
	std::string host() const {return _host;}
	uint16_t port() const {return _port;}
	std::string username() const {return _username;}
	std::string password() const {return _password;}
	std::string payoutAddress() const {return _payoutAddress;}
	std::string secret() const {return _secret;}
	std::string tuplesFile() const {return _tuplesFile;}
	uint32_t filePrimeTableLimit() const {return _filePrimeTableLimit;}
	uint16_t donate() const {return _donate;}
	double refreshInterval() const {return _refreshInterval;}
	double difficulty() const {return _difficulty;}
	double benchmarkBlockInterval() const {return _benchmarkBlockInterval;}
	double benchmarkTimeLimit() const {return _benchmarkTimeLimit;}
	uint64_t benchmarkPrimeCountLimit() const {return _benchmarkPrimeCountLimit;}
	std::vector<std::string> rules() const {return _rules;}
};

#endif
