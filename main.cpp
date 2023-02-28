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

std::string confPath("rieMiner.conf");
bool running(false);
std::shared_ptr<API> api(nullptr);
std::shared_ptr<Miner> miner(nullptr);
std::shared_ptr<Client> client(nullptr);

std::optional<std::pair<std::string, std::string>> Configuration::_parseLine(const std::string &line, std::string &parsingMessages) const {
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
		parsingMessages += "Cannot find the delimiter '=' for: '"s + line + "'\n"s;
		return std::nullopt;
	}
}

bool Configuration::parse(const int argc, char** argv, std::string &parsingMessages) {
	if (argc >= 2)
		confPath = argv[1];
	
	if (confPath == "help") {
		logger.log("Configuration file line syntax: Key = Value\n"
		           "Same syntax for the command line options.\n"
		           "Available options are documented here. https://github.com/Pttn/rieMiner\n"
		           "Guides with configuration file examples can also be found here. https://riecoin.dev/en/rieMiner\n"
		           "Use default rieMiner.conf configuration file\n"
		           "\t./rieMiner\n"
		           "Custom configuration file\n"
		           "\t./rieMiner existingConfigFile.conf\n"
		           "Custom configuration file and command line options\n"
		           "\t./rieMiner existingConfigFile.conf Option1=Value1 \"Option2 = Value2\" Option3=WeirdValue\\!\\!\n"
		           "No configuration file and command line options (a file named 'dummy' must not exist)\n"
		           "\t./rieMiner dummy Option1=Value1 \"Option2 = Value2\" Option3=WeirdValue\\!\\!\n"
		           "Examples:\n"
		           "\t./rieMiner Benchmark.conf\n"
		           "\t./rieMiner SoloMining.conf Threads=7\n"
		           "\t./rieMiner noconffile Mode=Pool Host=mining.example.com Port=5000 Username=username.worker Password=password\n"s);
		waitForUser();
		return false;
	}
	
	std::vector<std::string> lines;
	std::ifstream file(confPath, std::ios::in);
	if (file) {
		logger.log("Opening configuration file "s + confPath + "...\n"s);
		std::string line;
		while (std::getline(file, line))
			lines.push_back(line);
		file.close();
	}
	else if (argc <= 2) {
		logger.log(confPath + " not found or unreadable and no other arguments given. Please read the guides and README to learn how to configure rieMiner.\n"
		           "https://riecoin.dev/en/rieMiner\n"
		           "https://github.com/Pttn/rieMiner/\n"s, MessageType::WARNING);
		waitForUser();
		return false;
	}
	
	if (argc > 2) {
		logger.log("Parsing "s + std::to_string(argc - 2) + " option(s) given by command line...\n"s);
		for (int i(2) ; i < argc ; i++)
			lines.push_back(argv[i]);
	}
	
	for (const auto &line : lines) {
		const std::optional<std::pair<std::string, std::string>> option(_parseLine(line, parsingMessages));
		if (!option.has_value())
			continue;
		std::string key(option.value().first), value(option.value().second);
		if (key == "Mode") {
			if (value == "Solo" || value == "Pool" || value == "Benchmark" || value == "Search")
				_options.mode = value;
			else {
				parsingMessages += "Invalid mode '"s + value + "'!\n"s
				                   "Possible values (case sensitive) are: Solo, Pool, Benchmark, Search\n";
			}
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
		else if (key == "RawOutput") {
			if (value == "Yes")
				logger.setRawMode(true);
			else
				logger.setRawMode(false);
		}
		else if (key == "KeepRunning")
		{
			if(value == "Yes")
				_options.keepRunning = true;
			else
				_options.keepRunning = false;
		}
		else
			parsingMessages += "Ignoring option with unused key '"s + key + "'\n"s;
	}
	if (_options.mode == "Benchmark" || _options.mode == "Search") { // Pick a default pattern if none was chosen
		if (_options.minerParameters.pattern.size() == 0)
			_options.minerParameters.pattern = {0, 2, 4, 2, 4, 6, 2};
	}
	return true;
}

#ifdef _WIN32
BOOL WINAPI signalHandler(DWORD signum) {
#else
void signalHandler(int signum) {
#endif
	logger.log("\nSignal "s + std::to_string(signum) + " received, stopping rieMiner.\n", MessageType::WARNING);
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
		logger.log("Could not set the Console Ctrl Handler\n", MessageType::ERROR);
#else
	struct sigaction SIGINTHandler;
	SIGINTHandler.sa_handler = signalHandler;
	sigemptyset(&SIGINTHandler.sa_mask);
	SIGINTHandler.sa_flags = 0;
	sigaction(SIGINT, &SIGINTHandler, NULL);
#endif
	Configuration configuration;
	logger.log(std::string(versionString) + ", Riecoin miner by Pttn and contributors\n"s
	           "Project page: https://riecoin.dev/en/rieMiner\n"s
	           "Launch with 'help' as first argument for a quick usage guide\n"s);
	logger.hr();
	logger.log("Assembly code by Michael Bell (Rockhawk)\n"s
	           "G++ "s + std::to_string(__GNUC__) + "."s + std::to_string(__GNUC_MINOR__) + "."s + std::to_string(__GNUC_PATCHLEVEL__) + " - https://gcc.gnu.org/\n"s +
	           OPENSSL_VERSION_TEXT + " - https://www.openssl.org/\n"s
	           "Curl "s + LIBCURL_VERSION + " - https://curl.haxx.se/\n"s
	           "NLohmann Json "s + std::to_string(NLOHMANN_JSON_VERSION_MAJOR) + "."s + std::to_string(NLOHMANN_JSON_VERSION_MINOR) + "."s + std::to_string(NLOHMANN_JSON_VERSION_PATCH) + " - https://json.nlohmann.me/\n"s);
	logger.hr();
	logger.log("Build for: "s + sysInfo.getOs() + " on "s + sysInfo.getCpuArchitecture() + "\n"s
	           "Processor: "s + sysInfo.getCpuBrand() + "\n"s);
	if (sysInfo.getCpuArchitecture() == "x64") {
		logger.log("Best SIMD instructions supported by the CPU: "s);
		if (sysInfo.hasAVX512()) logger.log("AVX-512"s);
		else if (sysInfo.hasAVX2()) logger.log("AVX2"s);
		else if (sysInfo.hasAVX()) logger.log("AVX"s);
		else logger.log("None"s);
		logger.log("\n"s);
#ifdef __AVX2__
		logger.log("This build supports AVX2\n"s);
#else
		logger.log("This build does not support AVX2\n"s, MessageType::BOLD);
#endif
	}
	const double physicalMemory(sysInfo.getPhysicalMemory());
	logger.log("Physical Memory: "s);
	if (physicalMemory < 1.)
		logger.log("Detection Failed"s, MessageType::WARNING);
	else if (physicalMemory > 1099511627776.)
		logger.log(doubleToString(physicalMemory/1099511627776., 3) + " TiB"s);
	else if (physicalMemory > 1073741824.)
		logger.log(doubleToString(physicalMemory/1073741824., 3) + " GiB"s);
	else
		logger.log(doubleToString(physicalMemory/1048576., 3) + " MiB"s);
	logger.log("\n"s);
	logger.hr();
	
	std::string parsingMessages;
	if (!configuration.parse(argc, argv, parsingMessages))
		return 0;
	if (parsingMessages.size() > 0ULL)
		logger.log(parsingMessages, MessageType::WARNING);
	
	if (configuration.options().filePrimeTableLimit > 1) {
		logger.log("Generating prime table up to "s + std::to_string(configuration.options().filePrimeTableLimit) + " and saving to "s + primeTableFile + "...\n"s);
		std::fstream file(primeTableFile, std::ios::out | std::ios::binary);
		if (file) {
			const auto primeTable(generatePrimeTable(configuration.options().filePrimeTableLimit));
			file.write(reinterpret_cast<const char*>(primeTable.data()), primeTable.size()*sizeof(decltype(primeTable)::value_type));
			file.close();
			logger.log("Table of "s + std::to_string(primeTable.size()) + " primes generated. Don't forget to disable the generation in "s + confPath + ".\n"s, MessageType::SUCCESS);
		}
		else
			logger.log("Could not open file  "s + primeTableFile + "!\n"s, MessageType::ERROR);
		return 0;
	}
	
	if (configuration.options().mode == "Benchmark") {
		logger.log("Benchmark Mode at difficulty "s + doubleToString(configuration.options().difficulty) + "\n"s);
		if (configuration.options().benchmarkBlockInterval > 0.)
			logger.log("\tBlock interval: " + doubleToString(configuration.options().benchmarkBlockInterval) + " s\n"s);
		if (configuration.options().benchmarkTimeLimit > 0.)
			logger.log("\tTime limit: " + doubleToString(configuration.options().benchmarkTimeLimit) + " s\n"s);
		if (configuration.options().benchmarkPrimeCountLimit != 0)
			logger.log("\tPrime (1-tuple) count limit: " + std::to_string(configuration.options().benchmarkPrimeCountLimit) + "\n"s);
	}
	else if (configuration.options().mode == "Search") {
		const double base10Exp(configuration.options().difficulty*0.301029996);
		logger.log("Search Mode at difficulty "s + doubleToString(configuration.options().difficulty) + " (numbers around "s + doubleToString(std::pow(10., base10Exp - std::floor(base10Exp))) + "*10^"s + doubleToString(std::floor(base10Exp)) + ") - Good luck!\n"s);
	}
	else {
		if (configuration.options().mode == "Solo")
			logger.log("Solo mining"s);
		else
			logger.log("Pooled mining"s);
		logger.log(" via host "s + configuration.options().host + ", port "s + std::to_string(configuration.options().port) + "\n"s);
		logger.log("Username: "s + configuration.options().username + "\n"s);
		logger.log("Password: <"s + std::to_string(configuration.options().password.size()) + " character(s)>\n"s);
		if (configuration.options().mode == "Solo") {
			std::vector<uint8_t> scriptPubKey(bech32ToScriptPubKey(configuration.options().payoutAddress));
			logger.log("Payout address: "s + configuration.options().payoutAddress + "\n"s);
			if (scriptPubKey.size() == 0) {
				logger.log("Invalid payout address! Please check it. Note that only Bech32 addresses are supported.\n"s, MessageType::ERROR);
				waitForUser();
				return false;
			}
			else
			logger.log("ScriptPubKey:   "s + v8ToHexStr(scriptPubKey) + "\n"s);
			logger.log("Consensus rules: "s + formatContainer(configuration.options().rules) + "\n"s);
			if (std::find(configuration.options().rules.begin(), configuration.options().rules.end(), "segwit") == configuration.options().rules.end()) {
				logger.log("'segwit' rule must be present!\n"s, MessageType::ERROR);
				waitForUser();
				return false;
			}
		}
		logger.log("Auto retune when the Difficulty varies by a factor "s + doubleToString(configuration.options().minerParameters.restartDifficultyFactor) + "\n"s);
	}
	if (configuration.options().refreshInterval > 0.)
		logger.log("Stats refresh interval: "s + doubleToString(configuration.options().refreshInterval) + " s\n"s);
	
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
				logger.log("Connecting to Riecoin server...\n"s);
				std::dynamic_pointer_cast<NetworkedClient>(client)->connect();
				if (!std::dynamic_pointer_cast<NetworkedClient>(client)->connected()) {
					logger.log("Please check your connection, configuration or credentials. Retry in " + std::to_string(waitReconnect) + " s...\n"s, MessageType::WARNING);
					std::this_thread::sleep_for(std::chrono::seconds(waitReconnect));
				}
				else if (!miner->inited()) {
					MinerParameters minerParameters(configuration.options().minerParameters);
					minerParameters.pattern = Client::choosePatterns(client->getJob(true).acceptedPatterns, minerParameters.pattern);
					miner->init(minerParameters);
					if (!miner->inited()) {
						logger.log("Something went wrong during the miner initialization, rieMiner cannot continue.\n"s, MessageType::ERROR);
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
					logger.log("Connection lost, reconnecting in " + std::to_string(waitReconnect) + " s...\n"s, MessageType::WARNING);
					miner->stopThreads();
					std::this_thread::sleep_for(std::chrono::seconds(waitReconnect));
				}
				else {
					if (miner->shouldRestart()) {
						logger.log("Restarting miner to take in account Difficulty variations or other network changes.\n");
						miner->stop();
						MinerParameters minerParameters(configuration.options().minerParameters);
						minerParameters.pattern = Client::choosePatterns(client->getJob(true).acceptedPatterns, minerParameters.pattern);
						miner->init(minerParameters);
						if (!miner->inited()) {
							logger.log("Something went wrong during the miner initialization, rieMiner cannot continue.\n"s, MessageType::ERROR);
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
			logger.log("Something went wrong during the miner initialization, rieMiner cannot continue.\n"s, MessageType::ERROR);
			running = false;
		}
		miner->startThreads();
		timer = std::chrono::steady_clock::now();
		while (running) {
			if (!configuration.options().keepRunning && configuration.options().mode == "Search" && miner->running()) {
				if(miner->tupleFound()) {
					miner->printStats();
					miner->stop();
					running = false;
					break;
				}
			}
			else if (configuration.options().mode == "Benchmark" && miner->running()) {
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
