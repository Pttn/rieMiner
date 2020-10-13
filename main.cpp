// (c) 2017-2020 Pttn and contributors (https://github.com/Pttn/rieMiner)

#include <iomanip>
#include <unistd.h>
#ifndef _WIN32
	#include <arpa/inet.h>
	#include <netdb.h>
	#include <signal.h>
#else
	#include <winsock2.h>
#endif
#include "GBTClient.hpp"
#include "StratumClient.hpp"
#include "main.hpp"
#include "Miner.hpp"
#include "tools.hpp"

int DEBUG(0);
static std::string confPath("rieMiner.conf");
bool running(false);
std::shared_ptr<Miner> miner(nullptr);
std::shared_ptr<Client> client(nullptr);

void Options::_parseLine(std::string line, std::string& key, std::string& value) const {
	const auto pos(line.find('='));
	if (pos != std::string::npos) {
		key   = line.substr(0, pos);
		value = line.substr(pos + 1, line.size() - pos - 1);
		if (key.size() > 0) { // Delete possible space before '='
			if (key.back() == ' ' || key.back() == '\t')
				key.pop_back();
		}
		if (value.size() > 0) { // Delete possible space after '='
			if (value.front() == ' ' || value.front() == '\t')
				value.erase(0, 1);
		}
	}
	else {
		std::cerr << "Cannot find the delimiter '=' for line: '" << line << "'" << std::endl;
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
				std::cout << "Please choose a pool that does not already have a lot of mining power to prevent centralization." << std::endl;
				std::cout << "Current pools " << std::endl;
				std::cout << "     XPoolX: mining.xpoolx.com:2090" << std::endl;
				std::cout << "   SuprNova: ric.suprnova.cc:5000" << std::endl;
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
				std::cout << "Payout address: ";
				std::cin >> value;
				setPayoutAddress(value);
				if (_payoutAddressFormat == AddressFormat::INVALID) {
					std::cerr << "Invalid payout address!" << std::endl;
					_stopConfig();
				}
				if (_payoutAddressFormat != AddressFormat::BECH32)
					std::cout << "Non Bech32 addresses are deprecated and their support in rieMiner will be dropped in the 0.92 stable release. Please use a Bech32 payout address." << std::endl;
				
				file << "PayoutAddress = " << _payoutAddress << std::endl;
			}
		}
		else std::cout << "Standard Benchmark values loaded. Edit the configuration file if needed." << std::endl;
		
		std::cout << "Number of threads: ";
		std::cin >> value;
		try {
			_minerParameters.threads = std::stoi(value);
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
					if (value == "Solo" || value == "Pool" || value == "Benchmark" || value == "Search" || value == "Test")
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
				else if (key == "EnableAVX2") _minerParameters.useAvx2 = (value == "Yes");
				else if (key == "Secret!!!") _secret = value;
				else if (key == "Threads") {
					try {_minerParameters.threads = std::stoi(value);}
					catch (...) {_minerParameters.threads = 8;}
				}
				else if (key == "SieveWorkers") {
					try {_minerParameters.sieveWorkers = std::stoi(value);}
					catch (...) {_minerParameters.sieveWorkers = 0;}
				}
				else if (key == "PrimeTableLimit") {
					try {_minerParameters.primeTableLimit = std::stoll(value);}
					catch (...) {_minerParameters.primeTableLimit = 2147483648;}
				}
				else if (key == "SieveBits") {
					try {_minerParameters.sieveBits = std::stoi(value);}
					catch (...) {_minerParameters.sieveBits = 25;}
				}
				else if (key == "RefreshInterval") {
					try {_refreshInterval = std::stoi(value);}
					catch (...) {_refreshInterval = 10;}
				}
				else if (key == "TupleLengthMin") {
					try {_minerParameters.tupleLengthMin = std::stoi(value);}
					catch (...) {_minerParameters.tupleLengthMin = 0;}
				}
				else if (key == "Donate") {
					try {_donate = std::stoi(value);}
					catch (...) {_donate = 2;}
					if (_donate == 0) _donate = 1;
					if (_donate > 99) _donate = 99;
				}
				else if (key == "Difficulty") {
					try {_difficulty = std::stod(value);}
					catch (...) {_difficulty = 1600.;}
					if (_difficulty < 128.) _difficulty = 128.;
					if (_difficulty > 4294967296.) _difficulty = 4294967296.;
				}
				else if (key == "BenchmarkBlockInterval") {
					try {_benchmarkBlockInterval = std::stoll(value);}
					catch (...) {_benchmarkBlockInterval = 150;}
					if (_benchmarkBlockInterval == 0) _benchmarkBlockInterval = 1;
				}
				else if (key == "BenchmarkTimeLimit") {
					try {_benchmarkTimeLimit = std::stoll(value);}
					catch (...) {_benchmarkTimeLimit = 0;}
				}
				else if (key == "Benchmark2tupleCountLimit") {
					try {_benchmark2tupleCountLimit = std::stoll(value);}
					catch (...) {_benchmark2tupleCountLimit = 50000;}
				}
				else if (key == "TuplesFile")
					_tuplesFile = value;
				else if (key == "ConstellationOffsets") {
					for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
					std::stringstream offsetsSS(value);
					std::vector<uint64_t> offsets;
					uint64_t tmp;
					while (offsetsSS >> tmp) offsets.push_back(tmp);
					if (offsets.size() < 2)
						std::cout << "Too short or invalid tuple offsets, ignoring." << std::endl;
					else _minerParameters.constellationOffsets = offsets;
				}
				else if (key == "PrimorialNumber") {
					try {_minerParameters.primorialNumber = std::stoll(value);}
					catch (...) {_minerParameters.primorialNumber = 40;}
					if (_minerParameters.primorialNumber < 1) _minerParameters.primorialNumber = 1;
				}
				else if (key == "PrimorialOffsets") {
					for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
					std::stringstream offsets(value);
					std::vector<uint64_t> primorialOffsets;
					uint64_t tmp;
					while (offsets >> tmp) primorialOffsets.push_back(tmp);
					_minerParameters.primorialOffsets = primorialOffsets;
				}
				else if (key == "Rules") {
					for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
					std::stringstream offsets(value);
					_rules = std::vector<std::string>();
					std::string tmp;
					while (offsets >> tmp) _rules.push_back(tmp);
				}
				else if (key == "Error") std::cout << "Ignoring invalid line" << std::endl;
				else std::cout << "Ignoring line with unused key '" << key << "'" << std::endl;
			}
		}
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
		std::cout << "Benchmark Mode at difficulty " << _difficulty << std::endl;
		std::cout << " Block interval: " << _benchmarkBlockInterval << " s" << std::endl;
		if (_benchmarkTimeLimit != 0) std::cout << " Time limit: " << _benchmarkTimeLimit << " s" << std::endl;
		if (_benchmark2tupleCountLimit != 0) std::cout << " 2-tuple count limit: " << _benchmark2tupleCountLimit << " 2-tuples" << std::endl;
		if (_difficulty == 1600 && _minerParameters.primeTableLimit == 2147483648 && _benchmark2tupleCountLimit >= 50000 && _benchmarkTimeLimit == 0)
			std::cout << " VALID parameters for Standard Benchmark" << std::endl;
	}
	else if (_mode == "Search") {
		mpz_class target(1);
		target <<= _difficulty - 1;
		target *= 65536.*std::pow(2., _difficulty - std::floor(_difficulty));
		target /= 65536;
		std::cout << "Search Mode at difficulty " << _difficulty << " (numbers around ~" << target.get_str()[0] << "." << target.get_str().substr(1, 2) << "*10^" << target.get_str().size() - 1 << ") - Good luck!" << std::endl;
	}
	else if (_mode == "Test")
		std::cout << "Test Mode" << std::endl;
	else {
		if (_mode == "Solo") std::cout << "Solo mining";
		else if (_mode == "Pool") std::cout << "Pooled mining";
		else {
			ERRORMSG("Invalid Mode");
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
			else if (_payoutAddressFormat == AddressFormat::BECH32) std::cout << " (Bech32 P2WPKH)";
			else {
				std::cout << std::endl << "Invalid or unsupported payout address! Exiting." << std::endl;
				exit(0);
			}
			if (_payoutAddressFormat != AddressFormat::BECH32)
				std::cout << std::endl << "Non Bech32 addresses are deprecated and their support in rieMiner will be dropped in the 0.92 stable release. Please use a Bech32 payout address.";
			std::cout << std::endl;
			if (_donate > 0) std::cout << "Donating " << _donate << "%" << std::endl;
			else std::cout << "Had fun looking into the source code? If so, consider contributing code!" << std::endl;
			std::cout << "Consensus rules: ";
			bool segwitFound(false);
			for (std::vector<std::string>::size_type i(0) ; i < _rules.size() ; i++) {
				std::cout << _rules[i];
				if (_rules[i] == "segwit") segwitFound = true;
				if (i != _rules.size() - 1) std::cout << ", ";
			}
			std::cout << std::endl;
			if (!segwitFound) {
				std::cout << "'segwit' rule must be present!" << std::endl;
				exit(0);
			}
		}
	}
	std::cout << "Stats refresh interval: " << _refreshInterval << " s" << std::endl;
}

void Options::setPayoutAddress(const std::string& address) {
	_payoutAddress = address;
	_payoutAddressFormat = addressFormatOf(_payoutAddress);
}

void signalHandler(int signum) {
	std::cout << std::endl << "Signal " << signum << " received, stopping rieMiner." << std::endl;
	if (miner->inited()) miner->stop();
	else exit(0);
	running = false;
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
	std::cout << "Go to the project page or open README.md for usage information" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	std::cout << "G++ " << __GNUC__ << "." << __GNUC_MINOR__ << "." << __GNUC_PATCHLEVEL__ << " - https://gcc.gnu.org/" << std::endl;
	std::cout << "GMP " << __GNU_MP_VERSION << "." << __GNU_MP_VERSION_MINOR << "." << __GNU_MP_VERSION_PATCHLEVEL << " - https://gmplib.org/" << std::endl;
	std::cout << "Curl " << LIBCURL_VERSION << " - https://curl.haxx.se/" << std::endl;
	std::cout << "Jansson " << JANSSON_VERSION << " - https://digip.org/jansson/" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	
	if (argc >= 2) {
		confPath = argv[1];
		std::cout << "Using custom configuration file path " << confPath << std::endl;
	}
	
	std::shared_ptr<Options> options(std::make_shared<Options>());
	options->loadConf();
	miner = std::make_shared<Miner>(options);
	if (options->mode() == "Solo")
		client = std::make_shared<GBTClient>(options);
	else if (options->mode() == "Pool")
		client = std::make_shared<StratumClient>(options);
	else if (options->mode() == "Search")
		client = std::make_shared<SearchClient>(options);
	else if (options->mode() == "Test")
		client = std::make_shared<TestClient>(options);
	else
		client = std::make_shared<BMClient>(options);
	miner->setClient(client);
	
	std::chrono::time_point<std::chrono::steady_clock> timer;
	const uint32_t waitReconnect(10); // Time in s to wait before auto reconnect.
	running = true;
	while (running) {
		if (options->mode() == "Benchmark" && miner->running()) {
			if (miner->benchmarkFinishedTimeOut() || miner->benchmarkFinished2Tuples()) {
				miner->printBenchmarkResults();
				miner->stop();
				running = false;
				break;
			}
		}
		
		if (client->connected()) {
			if (options->refreshInterval() != 0 && timeSince(timer) > options->refreshInterval() && miner->running()) {
				miner->printStats();
				timer = std::chrono::steady_clock::now();
			}
			client->process();
			if (!client->connected()) {
				std::cout << "Connection lost :|, reconnecting in " << waitReconnect << " s..." << std::endl;
				miner->stopThreads();
				usleep(1000000*waitReconnect);
			}
			else {
				if (options->mode() == "Solo" || options->mode() == "Pool" || options->mode() == "Test") {
					WorkData wd;
					client->getWork(wd);
					if (!miner->hasAcceptedConstellationOffsets(wd.acceptedConstellationOffsets)) {
						std::cout << "The current constellation type is no longer accepted, restarting the miner." << std::endl;
						MinerParameters minerParameters(options->minerParameters());
						miner->stop();
						minerParameters.primorialOffsets = {};
						client->updateMinerParameters(minerParameters);
						miner->init(minerParameters);
						if (!miner->inited()) {
							std::cout << "Something went wrong during the miner reinitialization, rieMiner cannot continue." << std::endl;
							running = false;
							break;
						}
					}
				}
				if (!miner->running() && client->currentHeight() != 0) {
					miner->startThreads();
					timer = std::chrono::steady_clock::now();
				}
				usleep(10000);
			}
		}
		else {
			std::cout << "Connecting to Riecoin server..." << std::endl;
			if (!client->connect()) {
				std::cout << "Failure :| ! Check your connection, configuration or credentials. Retry in " << waitReconnect << " s..." << std::endl;
				usleep(1000000*waitReconnect);
			}
			else {
				std::cout << "Success!" << std::endl;
				if (!miner->inited()) {
					MinerParameters minerParameters(options->minerParameters());
					client->updateMinerParameters(minerParameters);
					miner->init(minerParameters);
					if (!miner->inited()) {
						std::cout << "Something went wrong during the miner initialization, rieMiner cannot continue." << std::endl;
						running = false;
						break;
					}
				}
			}
		}
	}
	
	return 0;
}
