// (c) 2017-present Pttn and contributors (https://riecoin.xyz/rieMiner)

#ifndef HEADER_main_hpp
#define HEADER_main_hpp

#include <algorithm>
#include <array>
#include <chrono>
#include <iomanip>
#include <mutex>
#include <optional>
#include <string>
#include <thread>
#include <unistd.h>
#include <vector>
#include "tools.hpp"
#include "Stella.hpp"

#ifndef versionShort
	#define versionShort	"0.9x"
#endif
#ifndef versionString
	#define versionString	"rieMiner 0.9x"
#endif

static inline std::string timeNowStr() {
	const auto now(std::chrono::system_clock::now());
	const std::time_t timeT(std::chrono::system_clock::to_time_t(now));
	const std::tm *timeTm(std::localtime(&timeT));
	std::ostringstream oss;
	oss << std::put_time(timeTm, "%Y-%m-%d_%H%M%S");
	return oss.str();
}

inline Logger logger("rieMiner_debug_"s + timeNowStr());
extern std::string confPath;

struct Options {
	Stella::Configuration stellaConfig;
	uint16_t tupleLengthMin{0U};
	std::string host{"127.0.0.1"}, username{""}, password{""}, mode{"Benchmark"}, payoutAddress{"ric1pstellap55ue6keg3ta2qwlxr0h58g66fd7y4ea78hzkj3r4lstrsk4clvn"}, tuplesFile{"Tuples.txt"};
	uint64_t filePrimeTableLimit{0ULL};
	uint16_t port{28332U};
	double refreshInterval{30.}, difficulty{1024.}, benchmarkBlockInterval{150.}, benchmarkTimeLimit{960.};
	uint64_t benchmarkPrimeCountLimit{10000000};
	double restartDifficultyFactor{1.03};
	std::vector<std::string> rules{"segwit"};
	uint16_t apiPort{0U};
	bool logDebug{true}, keepRunning{false};
};

class Configuration {
	Options _options;
	std::optional<std::pair<std::string, std::string>> _parseLine(const std::string&, std::string&) const;
public:
	bool parse(const int, char**, std::string&);
	Options options() const {return _options;}
};

#endif
