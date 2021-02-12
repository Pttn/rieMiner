// (c) 2017-2021 Pttn and contributors (https://github.com/Pttn/rieMiner)

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
std::string confPath("rieMiner.conf");
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
		std::cerr << "Cannot find the delimiter '=' for line or argument: '" << line << "'" << std::endl;
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
		std::cout << "Solo mining (solo) or pooled mining (pool)? ";
		std::cin >> value;
		if (value == "solo") {
			file << "Mode = Solo" << std::endl;
			_mode = "Solo";
		}
		else if (value == "pool") {
			file << "Mode = Pool" << std::endl;
			_mode = "Pool";
		}
		else {
			std::cout << "Invalid choice! Please answer exactly solo or pool." << std::endl;
			_stopConfig();
		}
		
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
			std::cout << "Get the list of pools on Riecoin.dev and their settings on their website." << std::endl;
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
			std::cout << "Invalid port !" << std::endl;
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
			std::cout << "Payout address: ";
			std::cin >> _payoutAddress;
			if (bech32ToScriptPubKey(_payoutAddress).size() == 0) {
				std::cout << "Invalid payout address!" << std::endl;
				_stopConfig();
			}
			file << "PayoutAddress = " << _payoutAddress << std::endl;
		}
		
		std::cout << "For more options, read the README.md and edit the configuration file." << std::endl;
		file << "Threads = 0" << std::endl;
		std::cout << "Happy Mining :D !" << std::endl;
		std::cout << "-----------------------------------------------------------" << std::endl;
		file.close();
	}
	else ERRORMSG("Unable to create " << confPath);
}

void Options::loadFileOptions(const std::string &filename, const bool hasCommandOptions) {
	std::ifstream file(filename, std::ios::in);
	if (file) {
		std::cout << "Opening configuration file " << confPath << "..." << std::endl;
		std::string line;
		while (std::getline(file, line))
			_options.push_back(line);
		file.close();
	}
	else if (!hasCommandOptions) {
		std::cout << confPath << " not found or unreadable and no other arguments given, please configure rieMiner now." << std::endl;
		askConf();
	}
}

void Options::loadCommandOptions(const int argc, char** argv) {
	if (argc > 2) std::cout << "Parsing " << argc - 2 << " option(s) given by command line..." << std::endl;
	for (int i(2) ; i < argc ; i++)
		_options.push_back(argv[i]);
}

void Options::parseOptions() {
	std::string key, value;
	for (const auto &line : _options) {
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
			else if (key == "PayoutAddress") _payoutAddress = value;
			else if (key == "EnableAVX2") _minerParameters.useAvx2 = (value == "Yes");
			else if (key == "Secret!!!") _secret = value;
			else if (key == "Threads") {
				try {_minerParameters.threads = std::stoi(value);}
				catch (...) {_minerParameters.threads = 0;}
			}
			else if (key == "PrimeTableLimit") {
				try {_minerParameters.primeTableLimit = std::stoll(value);}
				catch (...) {_minerParameters.primeTableLimit = 0;}
			}
			else if (key == "GeneratePrimeTableFileUpTo"){
				try {_filePrimeTableLimit = std::stoll(value);}
				catch (...) {_filePrimeTableLimit = 0;}
			}
			else if (key == "SieveWorkers") {
				try {_minerParameters.sieveWorkers = std::stoi(value);}
				catch (...) {_minerParameters.sieveWorkers = 0;}
			}
			else if (key == "SieveBits") {
				try {_minerParameters.sieveBits = std::stoi(value);}
				catch (...) {_minerParameters.sieveBits = 0;}
			}
			else if (key == "SieveIterations") {
				try {_minerParameters.sieveIterations = std::stoi(value);}
				catch (...) {_minerParameters.sieveIterations = 0;}
			}
			else if (key == "TupleLengthMin") {
				try {_minerParameters.tupleLengthMin = std::stoi(value);}
				catch (...) {_minerParameters.tupleLengthMin = 0;}
			}
			else if (key == "Donate") {
				if (value == "What a greedy dev!")
					_donate = 0;
				else {
					try {_donate = std::stoi(value);}
					catch (...) {_donate = 2;}
					if (_donate == 0) _donate = 1;
					if (_donate > 99) _donate = 99;
				}
			}
			else if (key == "RefreshInterval") {
				try {_refreshInterval = std::stod(value);}
				catch (...) {_refreshInterval = 30.;}
			}
			else if (key == "Difficulty") {
				try {_difficulty = std::stod(value);}
				catch (...) {_difficulty = 1024.;}
				if (_difficulty < 128.) _difficulty = 128.;
				if (_difficulty > 4294967296.) _difficulty = 4294967296.;
			}
			else if (key == "BenchmarkBlockInterval") {
				try {_benchmarkBlockInterval = std::stod(value);}
				catch (...) {_benchmarkBlockInterval = 150.;}
			}
			else if (key == "BenchmarkTimeLimit") {
				try {_benchmarkTimeLimit = std::stod(value);}
				catch (...) {_benchmarkTimeLimit = 86400.;}
			}
			else if (key == "BenchmarkPrimeCountLimit") {
				try {_benchmarkPrimeCountLimit = std::stoll(value);}
				catch (...) {_benchmarkPrimeCountLimit = 1000000;}
			}
			else if (key == "TuplesFile")
				_tuplesFile = value;
			else if (key == "ConstellationPattern") {
				for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
				std::stringstream offsetsSS(value);
				std::vector<uint64_t> offsets;
				uint64_t tmp;
				while (offsetsSS >> tmp) offsets.push_back(tmp);
				_minerParameters.pattern = offsets;
			}
			else if (key == "PrimorialNumber") {
				try {_minerParameters.primorialNumber = std::stoll(value);}
				catch (...) {_minerParameters.primorialNumber = 0;}
				if (_minerParameters.primorialNumber > 65535) _minerParameters.primorialNumber = 65535;
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
	
	DEBUG = _debug;
	DBG(std::cout << "Debug messages enabled" << std::endl;);
	DBG_VERIFY(std::cout << "Debug verification messages enabled" << std::endl;);
	if (_mode == "Benchmark") {
		std::cout << "Benchmark Mode at difficulty " << _difficulty << std::endl;
		if (_benchmarkBlockInterval > 0.) std::cout << " Block interval: " << _benchmarkBlockInterval << " s" << std::endl;
		if (_benchmarkTimeLimit > 0.) std::cout << " Time limit: " << _benchmarkTimeLimit << " s" << std::endl;
		if (_benchmarkPrimeCountLimit != 0) std::cout << " Prime (1-tuple) count limit: " << _benchmarkPrimeCountLimit << std::endl;
		if (_minerParameters.pattern.size() == 0) // Pick a default pattern if none was chosen
			_minerParameters.pattern = {0, 2, 4, 2, 4, 6, 2};
	}
	else if (_mode == "Search") {
		const double base10Exp(_difficulty*0.301029996);
		std::cout << "Search Mode at difficulty " << _difficulty << " (numbers around " << std::pow(10., base10Exp - std::floor(base10Exp)) << "*10^" << std::floor(base10Exp) << ") - Good luck!" << std::endl;
		if (_minerParameters.pattern.size() == 0) // Pick a default pattern if none was chosen
			_minerParameters.pattern = {0, 2, 4, 2, 4, 6, 2};
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
			std::vector<uint8_t> scriptPubKey(bech32ToScriptPubKey(_payoutAddress));
			std::cout << "Payout address: " << _payoutAddress << std::endl;
			if (scriptPubKey.size() == 0) {
				std::cout << "Invalid payout address! Please check it. Note that only Bech32 addresses are supported." << std::endl;
				exit(0);
			}
			else
				std::cout << "  ScriptPubKey: " << v8ToHexStr(scriptPubKey) << std::endl;
			if (_donate > 0) std::cout << "Donating " << _donate << "%" << std::endl;
			else std::cout << "You Meanie!" << std::endl;
			std::cout << "Consensus rules: " << formatContainer(_rules) << std::endl;
			if (std::find(_rules.begin(), _rules.end(), "segwit") == _rules.end()) {
				std::cout << "'segwit' rule must be present!" << std::endl;
				exit(0);
			}
		}
	}
	if (_refreshInterval > 0.) std::cout << "Stats refresh interval: " << _refreshInterval << " s" << std::endl;
}

void signalHandler(int signum) {
	std::cout << std::endl << "Signal " << signum << " received, stopping rieMiner." << std::endl;
	if (miner == nullptr) exit(0);
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
	std::cout << "Project page: https://riecoin.dev/en/rieMiner" << std::endl;
	std::cout << "Launch with 'help' as first argument for a quick usage guide" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	std::cout << "Assembly code by Michael Bell (Rockhawk)" << std::endl;
	std::cout << "G++ " << __GNUC__ << "." << __GNUC_MINOR__ << "." << __GNUC_PATCHLEVEL__ << " - https://gcc.gnu.org/" << std::endl;
	std::cout << "GMP " << __GNU_MP_VERSION << "." << __GNU_MP_VERSION_MINOR << "." << __GNU_MP_VERSION_PATCHLEVEL << " - https://gmplib.org/" << std::endl;
	std::cout << "Curl " << LIBCURL_VERSION << " - https://curl.haxx.se/" << std::endl;
	std::cout << "Jansson " << JANSSON_VERSION << " - https://digip.org/jansson/" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	
	if (argc >= 2)
		confPath = argv[1];
	
	if (confPath == "help") {
		std::cout << "Configuration file line syntax: Key = Value" << std::endl;
		std::cout << "Same syntax for the command line options." << std::endl;
		std::cout << "Available options are documented here. https://github.com/Pttn/rieMiner" << std::endl;
		std::cout << "Guides with configuration file examples can also be found here. https://riecoin.dev/en/rieMiner" << std::endl;
		std::cout << "Use default rieMiner.conf configuration file (will launch the assistant if not existing)" << std::endl;
		std::cout << "\t./rieMiner" << std::endl;
		std::cout << "Custom configuration file" << std::endl;
		std::cout << "\t./rieMiner existingConfigFile.conf" << std::endl;
		std::cout << "Launch the assistant" << std::endl;
		std::cout << "\t./rieMiner nonExistingConfigFile.conf" << std::endl;
		std::cout << "Custom configuration file and command line options" << std::endl;
		std::cout << "\t./rieMiner existingConfigFile.conf Option1=Value1 \"Option2 = Value2\" Option3=WeirdValue\\!\\!" << std::endl;
		std::cout << "No configuration file and command line options (dummy must not exist)" << std::endl;
		std::cout << "\t./rieMiner dummy Option1=Value1 \"Option2 = Value2\" Option3=WeirdValue\\!\\!" << std::endl;
		std::cout << "Examples:" << std::endl;
		std::cout << "\t./rieMiner Benchmark.conf" << std::endl;
		std::cout << "\t./rieMiner SoloMining.conf Threads=7" << std::endl;
		std::cout << "\t./rieMiner noconffile Mode=Pool Host=mining.example.com Port=5000 Username=username.worker Password=password" << std::endl;
		return 0;
	}
	
	Options options;
	options.loadFileOptions(confPath, argc > 2);
	options.loadCommandOptions(argc, argv);
	options.parseOptions();
	
	if (options.filePrimeTableLimit() > 1) {
		std::cout << "Generating prime table up to " << options.filePrimeTableLimit() << " and saving to " << primeTableFile << "..." << std::endl;
		std::fstream file(primeTableFile, std::ios::out | std::ios::binary);
		if (file) {
			const auto primeTable(generatePrimeTable(options.filePrimeTableLimit()));
			file.write(reinterpret_cast<const char*>(primeTable.data()), primeTable.size()*sizeof(decltype(primeTable)::value_type));
			file.close();
			std::cout << "Table of " << primeTable.size() << " primes generated. Don't forget to disable the generation in " << confPath << std::endl;
		}
		else
			ERRORMSG("Could not open file " << primeTableFile);
		return 0;
	}
	
	miner = std::make_shared<Miner>(options);
	if (options.mode() == "Solo")
		client = std::make_shared<GBTClient>(options);
	else if (options.mode() == "Pool")
		client = std::make_shared<StratumClient>(options);
	else if (options.mode() == "Search")
		client = std::make_shared<SearchClient>(options);
	else if (options.mode() == "Test")
		client = std::make_shared<TestClient>();
	else
		client = std::make_shared<BMClient>(options);
	miner->setClient(client);
	
	std::chrono::time_point<std::chrono::steady_clock> timer;
	running = true;
	if (client->isNetworked()) {
		const uint32_t waitReconnect(10); // Time in s to wait before auto reconnect.
		while (running) {
			if (!std::dynamic_pointer_cast<NetworkedClient>(client)->connected()) {
				std::cout << "Connecting to Riecoin server..." << std::endl;
				std::dynamic_pointer_cast<NetworkedClient>(client)->connect();
				if (!std::dynamic_pointer_cast<NetworkedClient>(client)->connected()) {
					std::cout << "Failure :| ! Check your connection, configuration or credentials. Retry in " << waitReconnect << " s..." << std::endl;
					std::this_thread::sleep_for(std::chrono::seconds(waitReconnect));
				}
				else {
					std::cout << "Success!" << std::endl;
					if (!miner->inited()) {
						const NetworkInfo networkInfo(std::dynamic_pointer_cast<NetworkedClient>(client)->info());
						MinerParameters minerParameters(options.minerParameters());
						minerParameters.pattern = Client::choosePatterns(networkInfo.acceptedPatterns, minerParameters.pattern);
						miner->init(minerParameters);
						if (!miner->inited()) {
							std::cout << "Something went wrong during the miner initialization, rieMiner cannot continue." << std::endl;
							running = false;
							break;
						}
					}
				}
			}
			else {
				if (options.refreshInterval() > 0. && timeSince(timer) > options.refreshInterval() && miner->running()) {
					miner->printStats();
					timer = std::chrono::steady_clock::now();
				}
				client->process();
				if (!std::dynamic_pointer_cast<NetworkedClient>(client)->connected()) {
					std::cout << "Connection lost :|, reconnecting in " << waitReconnect << " s..." << std::endl;
					miner->stopThreads();
					std::this_thread::sleep_for(std::chrono::seconds(waitReconnect));
				}
				else {
					if (miner->shouldRestart()) {
						std::cout << "Restarting miner to take in account Difficulty variations or other network changes." << std::endl;
						miner->stop();
						const NetworkInfo networkInfo(std::dynamic_pointer_cast<NetworkedClient>(client)->info());
						MinerParameters minerParameters(options.minerParameters());
						minerParameters.pattern = Client::choosePatterns(networkInfo.acceptedPatterns, minerParameters.pattern);
						miner->init(minerParameters);
						if (!miner->inited()) {
							std::cout << "Something went wrong during the miner reinitialization, rieMiner cannot continue." << std::endl;
							running = false;
							break;
						}
					}
					if (!miner->running() && client->currentHeight() != 0) {
						miner->startThreads();
						timer = std::chrono::steady_clock::now();
					}
					std::this_thread::sleep_for(std::chrono::milliseconds(10));
				}
			}
		}
	}
	else {
		miner->init(options.minerParameters());
		if (!miner->inited()) {
			std::cout << "Something went wrong during the miner initialization, rieMiner cannot continue." << std::endl;
			running = false;
		}
		miner->startThreads();
		timer = std::chrono::steady_clock::now();
		while (running) {
			if (options.mode() == "Benchmark" && miner->running()) {
				if (miner->benchmarkFinishedTimeOut(options.benchmarkTimeLimit()) || miner->benchmarkFinishedEnoughPrimes(options.benchmarkPrimeCountLimit())) {
					miner->printBenchmarkResults();
					miner->stop();
					running = false;
					break;
				}
			}
			if (options.refreshInterval() > 0. && timeSince(timer) > options.refreshInterval() && miner->running()) {
				miner->printStats();
				timer = std::chrono::steady_clock::now();
			}
			client->process();
			std::this_thread::sleep_for(std::chrono::milliseconds(10));
		}
	}
	return 0;
}
