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

#define versionString	"rieMiner 0.92-alpha1b"

extern int DEBUG;
#define DBG(x) if (DEBUG) {x;};
#define DBG_VERIFY(x) if (DEBUG > 1) { x; };
#define ERRORMSG(message) std::cerr << __func__ << ": " << message << " :| !" << std::endl

static const std::vector<std::pair<std::vector<uint64_t>, std::vector<uint64_t>>> defaultConstellationData = {
	// Default
	{{0, 4, 2, 4, 2, 4}, {4209995887ULL, 4209999247ULL, 4210002607ULL, 4210005967ULL, 7452755407ULL, 7452758767ULL, 7452762127ULL, 7452765487ULL, 8145217177ULL, 8145220537ULL, 8145223897ULL, 8145227257ULL}}, // Proposed by Michael Bell
	// 2-tuples
	{{0, 2}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645 (12-tuples)
	// 3-tuples
	{{0, 2, 4}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645 (12-tuples)
	{{0, 4, 2}, {1418575498573ULL, 2118274828903ULL, 4396774576273ULL, 6368171154193ULL, 6953798916913ULL, 27899359258003ULL, 28138953913303ULL, 34460918582323ULL, 40362095929003ULL, 42023308245613ULL, 44058461657443ULL, 61062361183903ULL, 76075560855373ULL, 80114623697803ULL, 84510447435493ULL, 85160397055813ULL}}, // OEIS A213646 (11-tuples)
	// 4-tuples
	{{0, 2, 4, 2}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213646 (12-tuples)
	// 5-tuples
	{{0, 4, 2, 4, 2}, {4209995887ULL, 4209999247ULL, 4210002607ULL, 4210005967ULL, 7452755407ULL, 7452758767ULL, 7452762127ULL, 7452765487ULL, 8145217177ULL, 8145220537ULL, 8145223897ULL, 8145227257ULL}}, // Proposed by Michael Bell
	{{0, 2, 4, 2, 4}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645 (12-tuples)
	// 6-tuples: set as default above
	// 7-tuples
	{{0, 2, 6, 4, 2, 4, 2}, {5639ULL, 88799ULL, 284729ULL, 626609ULL, 855719ULL, 1146779ULL, 6560999ULL, 7540439ULL, 8573429ULL, 17843459ULL, 19089599ULL, 24001709ULL, 42981929ULL, 43534019ULL, 69156539ULL, 74266259ULL}}, // OEIS A022010
	{{0, 2, 4, 2, 4, 6, 2}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645 (12-tuples)
	// 8-tuples
	{{0, 2, 4, 2, 4, 6, 2, 6}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645 (12-tuples)
	{{0, 2, 4, 6, 2, 6, 4, 2}, {9853497737ULL, 21956291867ULL, 22741837817ULL, 164444511587ULL, 179590045487ULL, 217999764107ULL, 231255798857ULL, 242360943257ULL, 666413245007ULL, 696391309697ULL, 867132039857ULL, 974275568237ULL, 976136848847ULL, 1002263588297ULL, 1086344116367ULL}}, // OEIS A027570 (10-tuples)
	{{0, 6, 2, 6, 4, 2, 4, 2}, {88793, 284723, 855713, 1146773, 6560993, 69156533, 74266253, 218033723, 261672773, 302542763, 964669613, 1340301863, 1400533223, 1422475913, 1837160183, 1962038783}}, // OEIS A022013
	// 9-tuples
	{{0, 2, 4, 2, 4, 6, 2, 6, 4}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645 (12-tuples)
	{{0, 2, 4, 6, 2, 6, 4, 2, 4}, {9853497737ULL, 21956291867ULL, 22741837817ULL, 164444511587ULL, 179590045487ULL, 217999764107ULL, 231255798857ULL, 242360943257ULL, 666413245007ULL, 696391309697ULL, 867132039857ULL, 974275568237ULL, 976136848847ULL, 1002263588297ULL, 1086344116367ULL}}, // OEIS A027570 (10-tuples)
	{{0, 4, 2, 4, 6, 2, 6, 4, 2}, {1418575498573ULL, 2118274828903ULL, 4396774576273ULL, 6368171154193ULL, 6953798916913ULL, 27899359258003ULL, 28138953913303ULL, 34460918582323ULL, 40362095929003ULL, 42023308245613ULL, 44058461657443ULL, 61062361183903ULL, 76075560855373ULL, 80114623697803ULL, 84510447435493ULL, 85160397055813ULL}}, // OEIS A213646 (11-tuples)
	{{0, 4, 6, 2, 6, 4, 2, 4, 2}, {88789ULL, 855709ULL, 74266249ULL, 964669609ULL, 1422475909ULL, 2117861719ULL, 2558211559ULL, 2873599429ULL, 5766036949ULL, 6568530949ULL, 8076004609ULL, 9853497739ULL, 16394542249ULL, 21171795079ULL, 21956291869ULL, 22741837819ULL, 26486447149ULL}}, // OEIS A022548
	// 10-tuples
	{{0, 2, 4, 2, 4, 6, 2, 6, 4, 2}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645 (12-tuples)
	{{0, 2, 4, 6, 2, 6, 4, 2, 4, 2}, {9853497737ULL, 21956291867ULL, 22741837817ULL, 164444511587ULL, 179590045487ULL, 217999764107ULL, 231255798857ULL, 242360943257ULL, 666413245007ULL, 696391309697ULL, 867132039857ULL, 974275568237ULL, 976136848847ULL, 1002263588297ULL, 1086344116367ULL}}, // OEIS A027570
	// 11-tuples
	{{0, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645 (12-tuples)
	{{0, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2}, {1418575498573ULL, 2118274828903ULL, 4396774576273ULL, 6368171154193ULL, 6953798916913ULL, 27899359258003ULL, 28138953913303ULL, 34460918582323ULL, 40362095929003ULL, 42023308245613ULL, 44058461657443ULL, 61062361183903ULL, 76075560855373ULL, 80114623697803ULL, 84510447435493ULL, 85160397055813ULL}}, // OEIS A213646
	// 12-tuples
	{{0, 2, 4, 2, 4, 6, 2, 6, 4, 2, 4, 6}, {380284918609481ULL, 437163765888581ULL, 701889794782061ULL, 980125031081081ULL, 1277156391416021ULL, 1487854607298791ULL, 1833994713165731ULL, 2115067287743141ULL, 2325810733931801ULL, 3056805353932061ULL, 3252606350489381ULL, 3360877662097841ULL}}, // OEIS A213645
	{{0, 6, 4, 2, 4, 6, 2, 6, 4, 2, 4, 2}, {1418575498567ULL, 27899359257997ULL, 34460918582317ULL, 76075560855367ULL, 186460616596327ULL, 218021188549237ULL, 234280497145537ULL, 282854319391717ULL, 345120905374087ULL, 346117552180627ULL, 604439135284057ULL, 727417501795057ULL}} // OEIS A213601
};

class Options {
	bool _enableAvx2, _customPrimorialOffsets;
	std::string _host, _username, _password, _mode, _payoutAddress, _secret, _tuplesFile;
	AddressFormat _payoutAddressFormat;
	uint16_t _debug, _port, _threads, _sieveWorkers, _sieveBits, _refreshInterval, _tupleLengthMin, _donate;
	uint32_t _difficulty, _benchmarkBlockInterval, _benchmarkTimeLimit, _benchmark2tupleCountLimit;
	uint64_t _primeTableLimit, _primorialNumber;
	std::vector<uint64_t> _constellationType, _primorialOffsets;
	std::vector<std::string> _rules;
	
	void _parseLine(std::string, std::string&, std::string&) const;
	void _stopConfig() const;
	
	public:
	Options() : // Default options: Standard Benchmark with 8 threads
		_enableAvx2(false),
		_customPrimorialOffsets(false),
		_host("127.0.0.1"),
		_username(""),
		_password(""),
		_mode("Benchmark"),
		_payoutAddress("ric1qpttn5u8u9470za84kt4y0lzz4zllzm4pyzhuge"),
		_secret("/rM0.92a/"),
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
		_difficulty(1600),
		_benchmarkBlockInterval(150),
		_benchmarkTimeLimit(0),
		_benchmark2tupleCountLimit(50000),
		_primeTableLimit(2147483648),
		_primorialNumber(40),
		_constellationType(defaultConstellationData[0].first), // What type of constellations are we mining (offsets)
		_primorialOffsets(defaultConstellationData[0].second),
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
	uint32_t difficulty() const {return _difficulty;}
	uint32_t benchmarkBlockInterval() const {return _benchmarkBlockInterval;}
	uint32_t benchmarkTimeLimit() const {return _benchmarkTimeLimit;}
	uint32_t benchmark2tupleCountLimit() const {return _benchmark2tupleCountLimit;}
	std::vector<uint64_t> constellationType() const {return _constellationType;}
	uint64_t primorialNumber() const {return _primorialNumber;}
	std::vector<uint64_t> primorialOffsets() const {return _primorialOffsets;}
	std::vector<std::string> rules() const {return _rules;}
};

#endif
