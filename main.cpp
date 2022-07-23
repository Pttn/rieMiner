// (c) 2017-2022 Pttn and contributors (https://riecoin.dev/en/rieMiner)

#include <iomanip>
#include <nlohmann/json.hpp>
#include <unistd.h>
#ifndef _WIN32
	#include <arpa/inet.h>
	#include <netdb.h>
	#include <signal.h>
#else
	#include <winsock2.h>
#endif
#include "API.hpp"
#include "Client.hpp"
#include "main.hpp"
#include "Miner.hpp"
#include "tools.hpp"

int DEBUG(0);
std::string confPath("rieMiner.conf");
bool running(false);
std::shared_ptr<API> api(nullptr);
std::shared_ptr<Miner> miner(nullptr);
std::shared_ptr<Client> client(nullptr);

std::optional<std::pair<std::string, std::string>> Configuration::_parseLine(const std::string &line) const {
	if (line.size() == 0)
		return std::nullopt;
	if (line[0] == '#')
		return std::nullopt;
	const auto pos(line.find('='));
	if (pos != std::string::npos) {
		std::pair<std::string, std::string> option{line.substr(0, pos), line.substr(pos + 1, line.size() - pos - 1)};
		option.first.erase(std::find_if(option.first.rbegin(), option.first.rend(), [](unsigned char c) {return !std::isspace(c);}).base(), option.first.end()); // Trim spaces before =
		option.second.erase(option.second.begin(), std::find_if(option.second.begin(), option.second.end(), [](unsigned char c) {return !std::isspace(c);})); // Trim spaces after =
		return option;
	}
	else {
		std::cout << "Cannot find the delimiter '=' for: '" << line << "'" << std::endl;
		return std::nullopt;
	}
}

bool Configuration::parse(const int argc, char** argv) {
	if (argc >= 2)
		confPath = argv[1];
	
	if (confPath == "help") {
		std::cout << "Configuration file line syntax: Key = Value" << std::endl;
		std::cout << "Same syntax for the command line options." << std::endl;
		std::cout << "Available options are documented here. https://github.com/Pttn/rieMiner" << std::endl;
		std::cout << "Guides with configuration file examples can also be found here. https://riecoin.dev/en/rieMiner" << std::endl;
		std::cout << "Use default rieMiner.conf configuration file" << std::endl;
		std::cout << "\t./rieMiner" << std::endl;
		std::cout << "Custom configuration file" << std::endl;
		std::cout << "\t./rieMiner existingConfigFile.conf" << std::endl;
		std::cout << "Custom configuration file and command line options" << std::endl;
		std::cout << "\t./rieMiner existingConfigFile.conf Option1=Value1 \"Option2 = Value2\" Option3=WeirdValue\\!\\!" << std::endl;
		std::cout << "No configuration file and command line options (dummy must not exist)" << std::endl;
		std::cout << "\t./rieMiner dummy Option1=Value1 \"Option2 = Value2\" Option3=WeirdValue\\!\\!" << std::endl;
		std::cout << "Examples:" << std::endl;
		std::cout << "\t./rieMiner Benchmark.conf" << std::endl;
		std::cout << "\t./rieMiner SoloMining.conf Threads=7" << std::endl;
		std::cout << "\t./rieMiner noconffile Mode=Pool Host=mining.example.com Port=5000 Username=username.worker Password=password" << std::endl;
		waitForUser();
		return false;
	}
	
	std::vector<std::string> lines;
	std::ifstream file(confPath, std::ios::in);
	if (file) {
		std::cout << "Opening configuration file " << confPath << "..." << std::endl;
		std::string line;
		while (std::getline(file, line))
			lines.push_back(line);
		file.close();
	}
	else if (argc <= 2) {
		std::cout << confPath << " not found or unreadable and no other arguments given. Please read the guides and README to learn how to configure rieMiner." << std::endl;
		std::cout << "https://riecoin.dev/en/rieMiner" << std::endl;
		std::cout << "https://github.com/Pttn/rieMiner/" << std::endl;
		waitForUser();
		return false;
	}
	
	if (argc > 2) {
		std::cout << "Parsing " << argc - 2 << " option(s) given by command line..." << std::endl;
		for (int i(2) ; i < argc ; i++)
			lines.push_back(argv[i]);
	}
	
	for (const auto &line : lines) {
		const std::optional<std::pair<std::string, std::string>> option(_parseLine(line));
		if (!option.has_value())
			continue;
		std::string key(option.value().first), value(option.value().second);
		if (key == "Debug") {
			try {_options.debug = std::stoi(value);}
			catch (...) {_options.debug = 0;}
		}
		else if (key == "Mode") {
			if (value == "Solo" || value == "Pool" || value == "Benchmark" || value == "Search")
				_options.mode = value;
			else std::cout << "Invalid mode!" << std::endl;
		}
		else if (key == "Host") _options.host = value;
		else if (key == "Port") {
			try {_options.port = std::stoi(value);}
			catch (...) {_options.port = 28332;}
		}
		else if (key == "Username") _options.username = value;
		else if (key == "Password") _options.password = value;
		else if (key == "PayoutAddress") _options.payoutAddress = value;
		else if (key == "Threads") {
			try {_options.minerParameters.threads = std::stoi(value);}
			catch (...) {_options.minerParameters.threads = 0;}
		}
		else if (key == "PrimeTableLimit") {
			try {_options.minerParameters.primeTableLimit = std::stoll(value);}
			catch (...) {_options.minerParameters.primeTableLimit = 0;}
		}
		else if (key == "GeneratePrimeTableFileUpTo"){
			try {_options.filePrimeTableLimit = std::stoll(value);}
			catch (...) {_options.filePrimeTableLimit = 0;}
		}
		else if (key == "SieveWorkers") {
			try {_options.minerParameters.sieveWorkers = std::stoi(value);}
			catch (...) {_options.minerParameters.sieveWorkers = 0;}
		}
		else if (key == "SieveBits") {
			try {_options.minerParameters.sieveBits = std::stoi(value);}
			catch (...) {_options.minerParameters.sieveBits = 0;}
		}
		else if (key == "SieveIterations") {
			try {_options.minerParameters.sieveIterations = std::stoi(value);}
			catch (...) {_options.minerParameters.sieveIterations = 0;}
		}
		else if (key == "RestartDifficultyFactor") {
			try {_options.minerParameters.restartDifficultyFactor = std::stod(value);}
			catch (...) {_options.minerParameters.restartDifficultyFactor = 1.03;}
			if (_options.minerParameters.restartDifficultyFactor < 1.)
				_options.minerParameters.restartDifficultyFactor = 1.;
		}
		else if (key == "TupleLengthMin") {
			try {_options.minerParameters.tupleLengthMin = std::stoi(value);}
			catch (...) {_options.minerParameters.tupleLengthMin = 0;}
		}
		else if (key == "RefreshInterval") {
			try {_options.refreshInterval = std::stod(value);}
			catch (...) {_options.refreshInterval = 30.;}
		}
		else if (key == "Difficulty") {
			try {_options.difficulty = std::stod(value);}
			catch (...) {_options.difficulty = 1024.;}
			if (_options.difficulty < 128.) _options.difficulty = 128.;
			if (_options.difficulty > 4294967296.) _options.difficulty = 4294967296.;
		}
		else if (key == "BenchmarkBlockInterval") {
			try {_options.benchmarkBlockInterval = std::stod(value);}
			catch (...) {_options.benchmarkBlockInterval = 150.;}
		}
		else if (key == "BenchmarkTimeLimit") {
			try {_options.benchmarkTimeLimit = std::stod(value);}
			catch (...) {_options.benchmarkTimeLimit = 86400.;}
		}
		else if (key == "BenchmarkPrimeCountLimit") {
			try {_options.benchmarkPrimeCountLimit = std::stoll(value);}
			catch (...) {_options.benchmarkPrimeCountLimit = 1000000;}
		}
		else if (key == "TuplesFile")
			_options.tuplesFile = value;
		else if (key == "ConstellationPattern") {
			for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
			std::stringstream offsetsSS(value);
			std::vector<uint64_t> offsets;
			uint64_t tmp;
			while (offsetsSS >> tmp) offsets.push_back(tmp);
			_options.minerParameters.pattern = offsets;
		}
		else if (key == "PrimorialNumber") {
			try {_options.minerParameters.primorialNumber = std::stoll(value);}
			catch (...) {_options.minerParameters.primorialNumber = 0;}
			if (_options.minerParameters.primorialNumber > 65535) _options.minerParameters.primorialNumber = 65535;
		}
		else if (key == "PrimorialOffsets") {
			for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
			std::stringstream offsets(value);
			std::vector<uint64_t> primorialOffsets;
			uint64_t tmp;
			while (offsets >> tmp) primorialOffsets.push_back(tmp);
			_options.minerParameters.primorialOffsets = primorialOffsets;
		}
		else if (key == "Rules") {
			for (uint16_t i(0) ; i < value.size() ; i++) {if (value[i] == ',') value[i] = ' ';}
			std::stringstream offsets(value);
			_options.rules = std::vector<std::string>();
			std::string tmp;
			while (offsets >> tmp) _options.rules.push_back(tmp);
		}
		else if (key == "APIPort") {
			try {_options.apiPort = std::stoi(value);}
			catch (...) {_options.apiPort = 0U;}
		}
		else std::cout << "Ignoring line with unused key '" << key << "'" << std::endl;
	}
	DEBUG = _options.debug;
	DBG(std::cout << "Debug messages enabled" << std::endl;);
	DBG_VERIFY(std::cout << "Debug verification messages enabled" << std::endl;);
	if (_options.mode == "Benchmark") {
		std::cout << "Benchmark Mode at difficulty " << _options.difficulty << std::endl;
		if (_options.benchmarkBlockInterval > 0.) std::cout << " Block interval: " << _options.benchmarkBlockInterval << " s" << std::endl;
		if (_options.benchmarkTimeLimit > 0.) std::cout << " Time limit: " << _options.benchmarkTimeLimit << " s" << std::endl;
		if (_options.benchmarkPrimeCountLimit != 0) std::cout << " Prime (1-tuple) count limit: " << _options.benchmarkPrimeCountLimit << std::endl;
		if (_options.minerParameters.pattern.size() == 0) // Pick a default pattern if none was chosen
			_options.minerParameters.pattern = {0, 2, 4, 2, 4, 6, 2};
	}
	else if (_options.mode == "Search") {
		const double base10Exp(_options.difficulty*0.301029996);
		std::cout << "Search Mode at difficulty " << _options.difficulty << " (numbers around " << std::pow(10., base10Exp - std::floor(base10Exp)) << "*10^" << std::floor(base10Exp) << ") - Good luck!" << std::endl;
		if (_options.minerParameters.pattern.size() == 0) // Pick a default pattern if none was chosen
			_options.minerParameters.pattern = {0, 2, 4, 2, 4, 6, 2};
	}
	else {
		if (_options.mode == "Solo") std::cout << "Solo mining";
		else if (_options.mode == "Pool") std::cout << "Pooled mining";
		else {
			std::cout << "Invalid Mode" << std::endl;
			return false;
		}
		std::cout << " via host " << _options.host << ", port " << _options.port << std::endl;
		std::cout << "Username: " << _options.username << std::endl;
		std::cout << "Password: ..." << std::endl;
		if (_options.mode == "Solo") {
			std::vector<uint8_t> scriptPubKey(bech32ToScriptPubKey(_options.payoutAddress));
			std::cout << "Payout address: " << _options.payoutAddress << std::endl;
			if (scriptPubKey.size() == 0) {
				std::cout << "Invalid payout address! Please check it. Note that only Bech32 addresses are supported." << std::endl;
				waitForUser();
				return false;
			}
			else
				std::cout << "  ScriptPubKey: " << v8ToHexStr(scriptPubKey) << std::endl;
			std::cout << "Consensus rules: " << formatContainer(_options.rules) << std::endl;
			if (std::find(_options.rules.begin(), _options.rules.end(), "segwit") == _options.rules.end()) {
				std::cout << "'segwit' rule must be present!" << std::endl;
				waitForUser();
				return false;
			}
		}
		std::cout << "Auto retune when the Difficulty varies by a factor " << _options.minerParameters.restartDifficultyFactor << std::endl;
	}
	if (_options.refreshInterval > 0.) std::cout << "Stats refresh interval: " << _options.refreshInterval << " s" << std::endl;
	return true;
}

#ifdef _WIN32
BOOL WINAPI signalHandler(DWORD signum) {
#else
void signalHandler(int signum) {
#endif
	std::cout << std::endl << "Signal " << signum << " received, stopping rieMiner." << std::endl;
	if (miner == nullptr || api == nullptr) exit(0);
	if (api->running()) api->stop();
	if (!miner->inited()) exit(0);
	miner->stop();
	running = false;
#ifdef _WIN32
	return true;
#endif
}

int main(int argc, char** argv) {
#ifdef _WIN32
	SetPriorityClass(GetCurrentProcess(), BELOW_NORMAL_PRIORITY_CLASS); // Set lower priority, else the whole Windows system would lag a lot if using all threads
	if (!SetConsoleCtrlHandler((PHANDLER_ROUTINE) signalHandler, TRUE))
		std::cerr << "Could not set the Console Ctrl Handler" << std::endl;
#else
	struct sigaction SIGINTHandler;
	SIGINTHandler.sa_handler = signalHandler;
	sigemptyset(&SIGINTHandler.sa_mask);
	SIGINTHandler.sa_flags = 0;
	sigaction(SIGINT, &SIGINTHandler, NULL);
#endif
	std::cout << versionString;
	std::cout << ", Riecoin miner by Pttn and contributors" << std::endl;
	std::cout << "Project page: https://riecoin.dev/en/rieMiner" << std::endl;
	std::cout << "Launch with 'help' as first argument for a quick usage guide" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	std::cout << "Assembly code by Michael Bell (Rockhawk)" << std::endl;
	std::cout << "G++ " << __GNUC__ << "." << __GNUC_MINOR__ << "." << __GNUC_PATCHLEVEL__ << " - https://gcc.gnu.org/" << std::endl;
	std::cout << "GMP " << __GNU_MP_VERSION << "." << __GNU_MP_VERSION_MINOR << "." << __GNU_MP_VERSION_PATCHLEVEL << " - https://gmplib.org/" << std::endl;
	std::cout << OPENSSL_VERSION_TEXT << " - https://www.openssl.org/" << std::endl;
	std::cout << "Curl " << LIBCURL_VERSION << " - https://curl.haxx.se/" << std::endl;
	std::cout << "NLohmann Json " << NLOHMANN_JSON_VERSION_MAJOR << "." << NLOHMANN_JSON_VERSION_MINOR << "." << NLOHMANN_JSON_VERSION_PATCH << " - https://json.nlohmann.me/" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	std::cout << "Build for: " << sysInfo.getOs() << " on " << sysInfo.getCpuArchitecture();
	std::cout << std::endl << "Processor: " << sysInfo.getCpuBrand() << std::endl;
	if (sysInfo.getCpuArchitecture() == "x64") {
		std::cout << "Best SIMD instructions supported by the CPU: ";
		if (sysInfo.hasAVX512()) std::cout << "AVX-512";
		else if (sysInfo.hasAVX2()) std::cout << "AVX2";
		else if (sysInfo.hasAVX()) std::cout << "AVX";
		else std::cout << "None";
		std::cout << std::endl;
#ifdef __AVX2__
		std::cout << "This build supports AVX2" << std::endl;
#else
		std::cout << "This build does not support AVX2" << std::endl;
#endif
	}
	const double physicalMemory(sysInfo.getPhysicalMemory());
	std::cout << "Physical Memory: ";
	if (physicalMemory < 1.)
		std::cout << "Detection Failed";
	else if (physicalMemory > 1099511627776.)
		std::cout << physicalMemory/1099511627776. << " TiB";
	else if (physicalMemory > 1073741824.)
		std::cout << physicalMemory/1073741824. << " GiB";
	else
		std::cout << physicalMemory/1048576. << " MiB";
	std::cout << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	
	Configuration configuration;
	if (!configuration.parse(argc, argv))
		return 0;
	
	if (configuration.options().filePrimeTableLimit > 1) {
		std::cout << "Generating prime table up to " << configuration.options().filePrimeTableLimit << " and saving to " << primeTableFile << "..." << std::endl;
		std::fstream file(primeTableFile, std::ios::out | std::ios::binary);
		if (file) {
			const auto primeTable(generatePrimeTable(configuration.options().filePrimeTableLimit));
			file.write(reinterpret_cast<const char*>(primeTable.data()), primeTable.size()*sizeof(decltype(primeTable)::value_type));
			file.close();
			std::cout << "Table of " << primeTable.size() << " primes generated. Don't forget to disable the generation in " << confPath << std::endl;
		}
		else
			ERRORMSG("Could not open file " << primeTableFile);
		return 0;
	}
	
	miner = std::make_shared<Miner>(configuration.options());
	if (configuration.options().mode == "Solo")
		client = std::make_shared<GBTClient>(configuration.options());
	else if (configuration.options().mode == "Pool")
		client = std::make_shared<StratumClient>(configuration.options());
	else if (configuration.options().mode == "Search")
		client = std::make_shared<SearchClient>(configuration.options());
	else
		client = std::make_shared<BMClient>(configuration.options());
	miner->setClient(client);
	api = std::make_shared<API>(configuration.options().apiPort);
	if (configuration.options().apiPort != 0) {
		api->setMiner(miner);
		api->setClient(client);
		api->start();
	}
	
	std::chrono::time_point<std::chrono::steady_clock> timer;
	running = true;
	if (client->isNetworked()) {
		const uint32_t waitReconnect(10); // Time in s to wait before auto reconnect.
		while (running) {
			if (!std::dynamic_pointer_cast<NetworkedClient>(client)->connected()) {
				std::cout << "Connecting to Riecoin server..." << std::endl;
				std::dynamic_pointer_cast<NetworkedClient>(client)->connect();
				if (!std::dynamic_pointer_cast<NetworkedClient>(client)->connected()) {
					std::cout << "Please check your connection, configuration or credentials. Retry in " << waitReconnect << " s..." << std::endl;
					std::this_thread::sleep_for(std::chrono::seconds(waitReconnect));
				}
				else if (!miner->inited()) {
					MinerParameters minerParameters(configuration.options().minerParameters);
					minerParameters.pattern = Client::choosePatterns(client->getJob(true).acceptedPatterns, minerParameters.pattern);
					miner->init(minerParameters);
					if (!miner->inited()) {
						std::cerr << "Something went wrong during the miner initialization, rieMiner cannot continue." << std::endl;
						running = false;
						break;
					}
				}
			}
			else {
				if (configuration.options().refreshInterval > 0. && timeSince(timer) > configuration.options().refreshInterval && miner->running()) {
					miner->printStats();
					timer = std::chrono::steady_clock::now();
				}
				client->process();
				if (!std::dynamic_pointer_cast<NetworkedClient>(client)->connected()) {
					std::cout << "Connection lost, reconnecting in " << waitReconnect << " s..." << std::endl;
					miner->stopThreads();
					std::this_thread::sleep_for(std::chrono::seconds(waitReconnect));
				}
				else {
					if (miner->shouldRestart()) {
						std::cout << "Restarting miner to take in account Difficulty variations or other network changes." << std::endl;
						miner->stop();
						MinerParameters minerParameters(configuration.options().minerParameters);
						minerParameters.pattern = Client::choosePatterns(client->getJob(true).acceptedPatterns, minerParameters.pattern);
						miner->init(minerParameters);
						if (!miner->inited()) {
							std::cerr << "Something went wrong during the miner reinitialization, rieMiner cannot continue." << std::endl;
							running = false;
							break;
						}
					}
					if (running && !miner->running()) {
						miner->startThreads();
						timer = std::chrono::steady_clock::now();
					}
					std::this_thread::sleep_for(std::chrono::milliseconds(10));
				}
			}
		}
	}
	else {
		miner->init(configuration.options().minerParameters);
		if (!miner->inited()) {
			std::cout << "Something went wrong during the miner initialization, rieMiner cannot continue." << std::endl;
			running = false;
		}
		miner->startThreads();
		timer = std::chrono::steady_clock::now();
		while (running) {
			if (configuration.options().mode == "Benchmark" && miner->running()) {
				if (miner->benchmarkFinishedTimeOut(configuration.options().benchmarkTimeLimit) || miner->benchmarkFinishedEnoughPrimes(configuration.options().benchmarkPrimeCountLimit)) {
					miner->printBenchmarkResults();
					miner->stop();
					running = false;
					break;
				}
			}
			if (configuration.options().refreshInterval > 0. && timeSince(timer) > configuration.options().refreshInterval && miner->running()) {
				miner->printStats();
				timer = std::chrono::steady_clock::now();
			}
			client->process();
			std::this_thread::sleep_for(std::chrono::milliseconds(10));
		}
	}
	return 0;
}
