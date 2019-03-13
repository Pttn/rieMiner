// (c) 2017-2018 Pttn and contributors (https://github.com/Pttn/rieMiner)

#include "main.hpp"
#include "Client.hpp"
#include "Miner.hpp"
#include "WorkManager.hpp"
#include "tools.hpp"
#include <iomanip>
#include <unistd.h>
#ifndef _WIN32
	#include <signal.h>
	#include <arpa/inet.h>
	#include <netdb.h>
#else
	#include <winsock2.h>
#endif

int DEBUG(0);

std::shared_ptr<WorkManager> manager;
static std::string confPath("rieMiner.conf");

void Options::_parseLine(std::string line, std::string& key, std::string& value) const {
	for (uint16_t i(0) ; i < line.size() ; i++) { // Delete spaces
		if (line[i] == ' ' || line[i] == '\t') {
			line.erase (i, 1);
			i--;
		}
	}
	
	const auto pos(line.find('='));
	if (pos != std::string::npos) {
		key   = line.substr(0, pos);
		value = line.substr(pos + 1, line.size() - pos - 1);
	}
	else {
		std::cerr << "Ill formed configuration line: " << line << std::endl;
		key   = "Error";
		value = "Ill formed configuration line";
	}
}

void Options::_stopConfig() const {
	std::remove(confPath.c_str());
	exit(0);
}

void Options::askConf() {
	std::string value;
	std::ofstream file(confPath);
	if (file) {
		std::cout << "Solo mining (solo), pooled mining (pool), or benchmarking (benchmark)? ";
		std::cin >> value;
		if (value == "solo") {
			file << "Mode = Solo" << std::endl;
			_mode = "Solo";
		}
		else if (value == "pool") {
			file << "Mode = Pool" << std::endl;
			_mode = "Pool";
		}
		else if (value == "benchmark") {
			file << "Mode = Benchmark" << std::endl;
			_mode = "Benchmark";
		}
		else {
			std::cerr << "Invalid choice! Please answer solo, pool, or benchmark." << std::endl;
			_stopConfig();
		}
		
		if (_mode != "Benchmark") {
			if (_mode == "Solo") {
				std::cout << "Riecoin Core (wallet) IP: ";
				std::cin >> value;
#ifndef _WIN32
				struct sockaddr_in sa;
				if (inet_pton(AF_INET, value.c_str(), &(sa.sin_addr)) != 1) {
					std::cerr << "Invalid IP address!" << std::endl;
					_stopConfig();
				}
				else {
					file << "Host = " << value << std::endl;
					_host = value;
				}
#else
				file << "Host = " << value << std::endl;
				_host = value;
#endif
				std::cout << "RPC port: ";
			}
			else {
				std::cout << "Current pools " << std::endl;
				std::cout << "     XPoolX: mining.xpoolx.com:5000" << std::endl;
				std::cout << "  uBlock.it: mine.ublock.it:5000" << std::endl;
				std::cout << "Pool address (without port): ";
				std::cin >> value;
				file << "Host = " << value << std::endl;
				_host = value;
				std::cout << "Pool port (example: 5000): ";
			}
			
			std::cin >> value;
			try {
				_port = std::stoi(value);
				file << "Port = " << value << std::endl;
			}
			catch (...) {
				std::cerr << "Invalid port !" << std::endl;
				_stopConfig();
			}
			
			if (_mode == "Solo") std::cout << "RPC username: ";
			else std::cout << "Pool username.worker: ";
			
			std::cin >> value;
			file << "Username = " << value << std::endl;
			_username = value;
			
			if (_mode == "Solo") std::cout << "RPC password: ";
			else std::cout << "Worker password: ";
			
			std::cin >> value;
			file << "Password = " << value << std::endl;
			_password = value;
			
			if (_mode == "Solo") {
				std::vector<uint8_t> spk;
				std::cout << "Payout address (P2PKH or P2SH): ";
				std::cin >> value;
				setPayoutAddress(value);
				if (_payoutAddressFormat == AddressFormat::INVALID) {
					std::cerr << "Invalid payout address!" << std::endl;
					_stopConfig();
				}
				else if (_payoutAddressFormat == AddressFormat::BECH32) {
					std::cout << "Sorry, Bech32 addresses are currently not supported." << std::endl;
					_stopConfig();
				}
				
				file << "PayoutAddress = " << _payoutAddress << std::endl;
			}
		}
		else std::cout << "Standard Benchmark values loaded. Edit the configuration file if needed." << std::endl;
		
		std::cout << "Number of threads: ";
		std::cin >> value;
		try {
			_threads = std::stoi(value);
			file << "Threads = " << value << std::endl;
		}
		catch (...) {
			std::cerr << "Invalid thread number!" << std::endl;
			_stopConfig();
		}
		
		std::cout << "Thank you :D !" << std::endl;
		std::cout << "-----------------------------------------------------------" << std::endl;
		file.close();
	}
	else std::cerr << "Unable to create " << confPath << " :|, values for standard benchmark loaded." << std::endl;
}

void Options::loadConf() {
	std::ifstream file(confPath, std::ios::in);
	std::cout << "Opening " << confPath << "..." << std::endl;
	if (file) {
		std::string line, key, value;
		while (std::getline(file, line)) {
			if (line.size() != 0) {
				if (line[0] == '#') continue;
				_parseLine(line, key, value);
				if (key == "Debug") {
					try {_debug = std::stoi(value);}
					catch (...) {_debug = 0;}
				}
				else if (key == "Mode") {
					if (value == "Solo" || value == "Pool" || value == "Benchmark")
						_mode = value;
					else std::cout << "Invalid mode!" << std::endl;
				}
				else if (key == "Host") _host = value;
				else if (key == "Port") {
					try {_port = std::stoi(value);}
					catch (...) {_port = 28332;}
				}
				else if (key == "Username") _username = value;
				else if (key == "Password") _password = value;
				else if (key == "PayoutAddress") setPayoutAddress(value);
				else if (key == "Secret!!!") _secret = value;
				else if (key == "Threads") {
					try {_threads = std::stoi(value);}
					catch (...) {_threads = 8;}
				}
				else if (key == "SieveWorkers") {
					try {_sieveWorkers = std::stoi(value);}
					catch (...) {_sieveWorkers = 0;}
				}
				else if (key == "PrimeTableLimit") {
					try {_primeTableLimit = std::stoll(value);}
					catch (...) {_primeTableLimit = 2147483648;}
					if (_primeTableLimit < 65536) _primeTableLimit = 65536;
				}
				else if (key == "SieveBits") {
					try {_sieveBits = std::stoi(value);}
					catch (...) {_sieveBits = 25;}
				}
				else if (key == "RefreshInterval") {
					try {_refreshInterval = std::stoi(value);}
					catch (...) {_refreshInterval = 10;}
				}
				else if (key == "TupleLengthMin") {
					try {_tupleLengthMin = std::stoi(value);}
					catch (...) {_tupleLengthMin = 6;}
				}
				else if (key == "BenchmarkDifficulty") {
					try {_benchmarkDifficulty = std::stoll(value);}
					catch (...) {_benchmarkDifficulty = 304;}
					if (_benchmarkDifficulty < 265) _benchmarkDifficulty = 265;
					else if (_benchmarkDifficulty > 32767) _benchmarkDifficulty = 32767;
				}
				else if (key == "BenchmarkTimeLimit") {
					try {_benchmarkTimeLimit = std::stoll(value);}
					catch (...) {_benchmarkTimeLimit = 0;}
				}
				else if (key == "Benchmark2tupleCountLimit") {
					try {_benchmark2tupleCountLimit = std::stoll(value);}
					catch (...) {_benchmark2tupleCountLimit = 50000;}
				}
				else if (key == "ConstellationType") {
					for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
					std::stringstream offsetsSS(value);
					std::vector<uint64_t> offsets;
					uint64_t tmp;
					while (offsetsSS >> tmp) offsets.push_back(tmp);
					if (offsets.size() < 2)
						std::cout << "Too short or invalid tuple offsets, ignoring." << std::endl;
					else _constellationType = offsets;
				}
				else if (key == "PrimorialNumber") {
					try {_primorialNumber = std::stoll(value);}
					catch (...) {_primorialNumber = 40;}
				}
				else if (key == "PrimorialOffsets") {
					for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
					std::stringstream offsets(value);
					std::vector<uint64_t> primorialOffsets;
					uint64_t tmp;
					while (offsets >> tmp) primorialOffsets.push_back(tmp);
					if (primorialOffsets.size() < 1)
						std::cout << "Too short or invalid primorial offsets, ignoring." << std::endl;
					else _primorialOffsets = primorialOffsets;
				}
				else if (key == "Rules") {
					for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
					std::stringstream offsets(value);
					_rules = std::vector<std::string>();
					std::string tmp;
					while (offsets >> tmp) _rules.push_back(tmp);
				}
				else if (key == "Error") std::cout << "Ignoring invalid line" << std::endl;
				else std::cout << "Ignoring line with unused key " << key << std::endl;
			}
		}
		
		if (_tupleLengthMin < 2 || _tupleLengthMin > _constellationType.size())
			_tupleLengthMin = _constellationType.size();
		file.close();
	}
	else {
		std::cout << confPath << " not found or unreadable, please configure rieMiner now." << std::endl;
		askConf();
	}
	
	DEBUG = _debug;
	DBG(std::cout << "Debug messages enabled" << std::endl;);
	DBG_VERIFY(std::cout << "Debug verification messages enabled" << std::endl;);
	if (_mode == "Benchmark") {
		std::cout << "Benchmark Mode at difficulty " << _benchmarkDifficulty << std::endl;
		if (_benchmarkTimeLimit != 0) std::cout << " Time limit: " << _benchmarkTimeLimit << " s" << std::endl;
		if (_benchmark2tupleCountLimit   != 0) std::cout << " 2-tuple count limit: " << _benchmark2tupleCountLimit << " 2-tuples" << std::endl;
		if (_benchmarkDifficulty == 1600 && _primeTableLimit == 2147483648 && _benchmark2tupleCountLimit >= 50000 && _benchmarkTimeLimit == 0)
			std::cout << " VALID parameters for Standard Benchmark" << std::endl;
	}
	else {
		if (_mode == "Solo") std::cout << "Solo mining";
		else if (_mode == "Pool") std::cout << "Pooled mining";
		else {
			std::cerr << "Invalid Mode! Exiting." << std::endl;
			exit(-1);
		}
		std::cout << " via host " << _host << ", port " << _port << std::endl;
		if (_mode == "Pool") std::cout << "Username.worker: " << _username << std::endl;
		else std::cout << "Username: " << _username << std::endl;
		std::cout << "Password: ..." << std::endl;
		
		if (_mode == "Solo") {
			std::cout << "Payout address: " << _payoutAddress;
			if (_payoutAddressFormat == AddressFormat::P2PKH) std::cout << " (P2PKH)";
			else if (_payoutAddressFormat == AddressFormat::P2SH) std::cout << " (P2SH)";
			else {
				if (_payoutAddressFormat == AddressFormat::BECH32) std::cout << " (Bech32)";
				std::cout << std::endl << "Invalid or unsupported payout address! Exiting." << std::endl;
				exit(0);
			}
			std::cout << std::endl;
			if (_rules.size() > 0) {
				std::cout << "Consensus rules: ";
				for (std::vector<std::string>::size_type i(0) ; i < _rules.size() ; i++) {
					std::cout << _rules[i];
					if (i != _rules.size() - 1) std::cout << ", ";
				}
				std::cout << std::endl;
			}
		}
	}
	
	if (_threads < 2) {
		std::cout << "At least 2 threads are needed, overriding." << std::endl;
		_threads = 2;
	}
	std::cout << "Threads: " << _threads << std::endl;
	std::cout << "Prime table limit: " << _primeTableLimit << std::endl;
	std::cout << "Sieve bits: " <<  _sieveBits << std::endl;
	if (_mode == "Benchmark") std::cout << "Will show tuples of at least length " << _tupleLengthMin << std::endl;
	else if (_mode == "Solo") std::cout << "Will submit tuples of at least length " << _tupleLengthMin << std::endl;
	std::cout << "Stats refresh interval: " << _refreshInterval << " s" << std::endl;
	std::cout << "Constellation type: " << "(";
	uint64_t offsetTemp(0);
	for (std::vector<uint64_t>::size_type i(0) ; i < _constellationType.size() ; i++) {
		offsetTemp += _constellationType[i];
		if (offsetTemp == 0) std::cout << "n";
		else std::cout << "n + " << offsetTemp;
		if (i != _constellationType.size() - 1) std::cout << ", ";
	}
	std::cout << "), length " << _constellationType.size() << std::endl;
	std::cout << "Primorial number: " << _primorialNumber << std::endl;
	std::cout << "Primorial offsets: " << "(";
	for (std::vector<uint64_t>::size_type i(0) ; i < _primorialOffsets.size() ; i++) {
		std::cout << _primorialOffsets[i];
		if (i != _primorialOffsets.size() - 1) std::cout << ", ";
	}
	std::cout << ")" << std::endl;
}

void Options::setPayoutAddress(const std::string& address) {
	_payoutAddress = address;
	_payoutAddressFormat = addressFormatOf(_payoutAddress);
}

void signalHandler(int signum) {
	std::cout << std::endl << "Signal " << signum << " received, terminating rieMiner." << std::endl;
	manager->printTuplesStats();
	_exit(0);
}

int main(int argc, char** argv) {
#ifdef _WIN32
	// Set lower priority, else the whole Windows system would lag a lot if using all threads
	SetPriorityClass(GetCurrentProcess(), BELOW_NORMAL_PRIORITY_CLASS);
#else
	struct sigaction SIGINTHandler;
	SIGINTHandler.sa_handler = signalHandler;
	sigemptyset(&SIGINTHandler.sa_mask);
	SIGINTHandler.sa_flags = 0;
	sigaction(SIGINT, &SIGINTHandler, NULL);
#endif
	
	std::cout << versionString << ", Riecoin miner by Pttn and contributors" << std::endl;
	std::cout << "Assembly code by Michael Bell (Rockhawk)" << std::endl;
	std::cout << "Project page: https://github.com/Pttn/rieMiner" << std::endl;
	std::cout << "Go to project page or open README.md for usage information" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	std::cout << "GMP " << __GNU_MP_VERSION << "." << __GNU_MP_VERSION_MINOR << "." << __GNU_MP_VERSION_PATCHLEVEL << std::endl;
	std::cout << "LibCurl " << LIBCURL_VERSION << std::endl;
	std::cout << "Jansson " << JANSSON_VERSION << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	
	if (argc >= 2) {
		confPath = argv[1];
		std::cout << "Using custom configuration file path " << confPath << std::endl;
	}
	
	manager = std::shared_ptr<WorkManager>(new WorkManager);
	manager->init();
	manager->manage();
	
	return 0;
}
