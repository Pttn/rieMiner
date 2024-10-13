// (c) 2018-present Pttn (https://riecoin.xyz/rieMiner)

#include <fcntl.h>
#ifdef _WIN32
	#include <winsock2.h>
#else
	#include <arpa/inet.h>
	#include <netdb.h>
#endif
#include <nlohmann/json.hpp>

#include "Client.hpp"
#include "Stella.hpp"

constexpr const char* userAgent("rieMiner/0.93");

static std::array<uint8_t, 32> calculateMerkleRootStratum(const std::vector<std::array<uint8_t, 32>> &merkleBranches) {
	std::array<uint8_t, 32> merkleRoot{};
	if (merkleBranches.size() == 0)
		logger.log("No merkle branch!\n"s, MessageType::ERROR);
	else if (merkleBranches.size() == 1)
		return merkleBranches[0];
	else {
		std::vector<uint8_t> hashData(64, 0);
		std::array<uint8_t, 32> hashTmp;
		std::copy(merkleBranches[0].begin(), merkleBranches[0].end(), hashData.begin());
		for (uint32_t i(1) ; i < merkleBranches.size() ; i++) {
			std::copy(merkleBranches[i].begin(), merkleBranches[i].end(), hashData.begin() + 32);
			hashTmp = sha256sha256(hashData.data(), 64);
			std::copy(hashTmp.begin(), hashTmp.end(), hashData.begin());
		}
		std::copy(hashData.begin(), hashData.begin() + 32, merkleRoot.begin());
	}
	return merkleRoot;
}
static std::array<uint8_t, 32> merkleRootGen(std::vector<std::array<uint8_t, 32>> merkleBranches, const std::vector<uint8_t> &coinbase1, const std::vector<uint8_t> &coinbase2, const std::vector<uint8_t> &extraNonce1, const std::vector<uint8_t> &extraNonce2) {
	std::vector<uint8_t> coinbase;
	coinbase.insert(coinbase.end(), coinbase1.begin(), coinbase1.end());
	coinbase.insert(coinbase.end(), extraNonce1.begin(), extraNonce1.end());
	coinbase.insert(coinbase.end(), extraNonce2.begin(), extraNonce2.end());
	coinbase.insert(coinbase.end(), coinbase2.begin(), coinbase2.end());
	std::array<uint8_t, 32> cbHash(sha256sha256(coinbase.data(), coinbase.size()));
	merkleBranches.insert(merkleBranches.begin(), cbHash);
	return calculateMerkleRootStratum(merkleBranches);
}

void StratumClient::_processMessage(const std::string &message) {
	nlohmann::json jsonMessage;
	try {
		jsonMessage = nlohmann::json::parse(message);
	}
	catch (...) {
		logger.log("Could not parse Json Message!\n"s
		           "Pool message was: "s + message + "\n"s, MessageType::ERROR);
		_state = UNSUBSCRIBED;
		return;
	}
	if (jsonMessage.contains("method")) {
		const std::string method(jsonMessage["method"]);
		if (method == "mining.notify") {
			std::string jobId, prevhash, coinbase1, coinbase2, version, nbits, ntime;
			std::vector<std::string> merkleBranches;
			int32_t powVersion;
			std::vector<std::vector<uint64_t>> acceptedPatterns;
			try {
				nlohmann::json jsonParams(jsonMessage["params"]);
				jobId = jsonParams[0];
				prevhash = jsonParams[1];
				coinbase1 = jsonParams[2];
				coinbase2 = jsonParams[3];
				merkleBranches = jsonParams[4].get<decltype(merkleBranches)>();
				version = jsonParams[5];
				nbits = jsonParams[6];
				ntime = jsonParams[7];
				powVersion = jsonParams[9];
				acceptedPatterns = jsonParams[10].get<decltype(acceptedPatterns)>();
			}
			catch (...) {
				logger.log("Could not parse mining.notify parameters!\n"s
				           "Please check whether the pool or rieMiner is outdated.\n"s
				           "Pool message was: "s + message + "\n"s, MessageType::ERROR);
				_state = UNSUBSCRIBED;
				return;
			}
			if (!isHexStrOfSize(prevhash, 64) || !isHexStr(coinbase1) || coinbase1.size() % 2 != 0 || coinbase1.size() < 46 || !isHexStr(coinbase2) || coinbase2.size() % 2 != 0 || !isHexStrOfSize(version, 8) || !isHexStrOfSize(nbits, 8) || !isHexStr(ntime)) {
				logger.log("Received invalid mining.notify parameters!\n"s
				           "Please check whether the pool or rieMiner is outdated.\n"s
				           "Pool message was: "s + message + "\n"s, MessageType::ERROR);
				_state = UNSUBSCRIBED;
				return;
			}
			if (powVersion != 1) {
				logger.log("The pool uses an unsupported PoW Version "s + std::to_string(powVersion) + ", your rieMiner version is likely outdated!\n"s, MessageType::ERROR);
				_state = UNSUBSCRIBED;
				return;
			}
			if (acceptedPatterns.size() == 0) {
				logger.log("Received empty or invalid accepted constellation patterns list!\n"s, MessageType::ERROR);
				_state = UNSUBSCRIBED;
				return;
			}
			JobTemplate newJobTemplate;
			newJobTemplate.job.bh.previousblockhash = v8ToA8(hexStrToV8(prevhash));
			try {
				newJobTemplate.job.bh.version = std::stoll(version, nullptr, 16);
				newJobTemplate.job.bh.curtime = std::stoll(ntime, nullptr, 16);
				newJobTemplate.job.bh.bits = std::stoll(nbits, nullptr, 16);
			}
			catch (...) {
				logger.log("Received invalid Block Header hex values!\n"s, MessageType::ERROR);
				_state = UNSUBSCRIBED;
				return;
			}
			newJobTemplate.job.jobId = jobId;
			newJobTemplate.coinbase1 = hexStrToV8(coinbase1);
			newJobTemplate.coinbase2 = hexStrToV8(coinbase2);
			for (const auto &merkleBranch : merkleBranches) {
				if (!isHexStrOfSize(merkleBranch, 64)) {
					logger.log("Received invalid Merkle Branch " + merkleBranch + "!\n"s, MessageType::ERROR);
					_state = UNSUBSCRIBED;
					return;
				}
				newJobTemplate.merkleBranches.push_back(v8ToA8(hexStrToV8(merkleBranch)));
			}
			
			ClientInfo newClientParams;
			// Extract BlockHeight from Coinbase
			const uint8_t heightLength(newJobTemplate.coinbase1[42]);
			if (heightLength == 1) newClientParams.height = newJobTemplate.coinbase1[43];
			else if (heightLength == 2) newClientParams.height = newJobTemplate.coinbase1[43] + 256*newJobTemplate.coinbase1[44];
			else newClientParams.height = newJobTemplate.coinbase1[43] + 256*newJobTemplate.coinbase1[44] + 65536*newJobTemplate.coinbase1[45];
			newClientParams.powVersion = powVersion;
			newClientParams.acceptedPatterns = acceptedPatterns;
			newClientParams.patternMin = std::vector<bool>(acceptedPatterns[0].size(), false);
			if (newClientParams.patternMin.size() > 0) newClientParams.patternMin[0] = true;
			if (newClientParams.patternMin.size() > 1) newClientParams.patternMin[1] = true;
			newClientParams.primeCountTarget = newClientParams.acceptedPatterns[0].size();
			newClientParams.primeCountMin = std::max(static_cast<int>(newClientParams.acceptedPatterns[0].size()) - 2, 4);
			newClientParams.difficulty = decodeBits(newJobTemplate.job.bh.bits, newClientParams.powVersion);
			newClientParams.targetOffsetBits = static_cast<uint32_t>(newClientParams.difficulty) - 264U;
			newJobTemplate.clientInfo = newClientParams;
			std::lock_guard<std::mutex> lock(_jobMutex);
			_currentJobTemplate = newJobTemplate;
		}
		else if (method == "client.show_message") {
			std::string messageToShow;
			try {
				nlohmann::json jsonParams(jsonMessage["params"]);
				messageToShow = jsonParams[0];
				logger.log("Message from pool: \""s + messageToShow + "\"\n"s, MessageType::BOLD);
			}
			catch (std::exception &e) {
				logger.log("Received invalid client.show_message request - "s + e.what() + "\n"s
				           "Pool message was: "s + message + "\n"s, MessageType::ERROR);
				return;
			}
		}
		else {
			logger.logDebug("Received request from pool with unsupported method "s + method + "\n"s
			                "Pool message was: "s + message);
		}
	}
	else {
		if (_state == UNSUBSCRIBED) {
			try {
				nlohmann::json jsonResult(jsonMessage["result"]);
				_sids = jsonResult[0].get<decltype(_sids)>();
				const std::string extraNonce1Str(jsonResult[1]);
				if (!isHexStr(extraNonce1Str) || extraNonce1Str.size() % 2 != 0) {
					logger.log("Received invalid Extra Nonce 1!\n"s
					           "Please check whether the pool or rieMiner is outdated.\n"s
					           "Pool message was: "s + message + "\n"s, MessageType::ERROR);
					return;
				}
				_extraNonce1 = hexStrToV8(extraNonce1Str);
				_extraNonce2Len = jsonResult[2];
			}
			catch (...) {
				logger.log("Received invalid mining.subscribe result!\n"s
				           "Please check whether the pool or rieMiner is outdated.\n"s
				           "Pool message was: "s + message + "\n"s, MessageType::ERROR);
				return;
			}
			_state = SUBSCRIBED;
			logger.log("Successfully subscribed to the pool."s, MessageType::SUCCESS);
			logger.log(" Subscriptions:"s);
			if (_sids.size() == 0)
				logger.log("\tnone\n"s);
			else {
				logger.log("\n"s);
				for (const auto &sid : _sids)
					logger.log("\t"s + sid.first + ": "s + sid.second + "\n"s);
			}
			logger.log("ExtraNonce1    = "s + v8ToHexStr(_extraNonce1) + "\n"s);
			logger.log("extraNonce2Len = "s + std::to_string(_extraNonce2Len) + "\n"s);
			const std::string miningAuthorizeMessage("{\"id\": "s + std::to_string(_jsonId++) + ", \"method\": \"mining.authorize\", \"params\": [\""s + _username + "\", \""s + _password + "\"]}\n"s);
			send(_socket, miningAuthorizeMessage.c_str(), miningAuthorizeMessage.size(), 0);
			// logger.logDebug("Sent to pool: "s + miningAuthorizeMessage);
		}
		else if (_state == SUBSCRIBED) {
			nlohmann::json jsonResult;
			try {
				jsonResult = jsonMessage["result"];
			}
			catch (...) {
				logger.log("Received bad mining.subscribe result!\n"s
				           "Pool message was: "s + message + "\n"s, MessageType::ERROR);
				_state = UNSUBSCRIBED;
				return;
			}
			if (jsonResult != true) {
				logger.log("Authorization refused by the pool. Please check your credentials.\n"s
				           "Pool message was: "s + message + "\n", MessageType::ERROR);
				_state = UNSUBSCRIBED;
			}
			else {
				logger.log("Successfully authorized by the pool.\n"s, MessageType::SUCCESS);
				_state = AUTHORIZED;
			}
		}
		else if (_state == AUTHORIZED) {
			nlohmann::json jsonResult;
			try {
				jsonResult = jsonMessage["result"];
			}
			catch (...) {
				logger.log("Received bad mining.authorize result!\n"s
				           "Pool message was: "s + message + "\n", MessageType::ERROR);
				_state = UNSUBSCRIBED;
				return;
			}
			if (jsonResult != true) {
				logger.log("Rejected share: "s + message + "\n", MessageType::WARNING);
				_rejectedShares++;
			}
		}
	}
}

void StratumClient::connect() {
	if (!_connected) {
		_pendingShares = {};
		_sids = {};
		_extraNonce1 = {};
		_extraNonce2Len = 0;
		_currentJobTemplate = JobTemplate();
		_lastPoolMessageTp = std::chrono::steady_clock::now();
		_state = UNSUBSCRIBED;
		_jsonId = 0U;
#ifdef _WIN32
		WORD wVersionRequested(MAKEWORD(2, 2));
		WSADATA wsaData;
		const int err(WSAStartup(wVersionRequested, &wsaData));
		if (err != 0) {
			logger.log("WSAStartup failed with error "s + std::to_string(err) + "\n"s, MessageType::ERROR);
			return;
		}
#endif
		hostent* hostInfo = gethostbyname(_host.c_str());
		if (hostInfo == nullptr) {
			logger.log("Unable to resolve '"s + _host + "', check the URL.\n"s, MessageType::ERROR);
			return;
		}
		void** ipListPtr((void**) hostInfo->h_addr_list);
		uint32_t ip(0xFFFFFFFF);
		if (ipListPtr[0]) ip = *(uint32_t*) ipListPtr[0];
		std::ostringstream oss;
		oss << ((ip >> 0) & 0xFF) << "." << ((ip >> 8) & 0xFF) << "." << ((ip >> 16) & 0xFF) << "." << ((ip >> 24) & 0xFF);
		logger.log("Host: '"s + _host + " -> " + oss.str() + "\n"s);
		_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if (_socket == -1) {
#ifdef _WIN32
			logger.log("Could not create endpoint, error "s + std::to_string(WSAGetLastError()) + "\n"s, MessageType::ERROR);
#else
			logger.log("Could not create endpoint: "s + std::strerror(errno) + "\n"s, MessageType::ERROR);
#endif
			return;
		}
		struct sockaddr_in addr;
		memset(&addr, 0, sizeof(sockaddr_in));
		addr.sin_family = AF_INET;
		addr.sin_port = htons(_port);
		addr.sin_addr.s_addr = inet_addr(oss.str().c_str());
		int result = ::connect(_socket, (sockaddr*) &addr, sizeof(sockaddr_in));
		if (result != 0) {
#ifdef _WIN32
			logger.log("Could not connect to the pool, error "s + std::to_string(WSAGetLastError()) + "\n"s +
#else
			logger.log("Could not connect to the pool: "s + std::strerror(errno) + "\n"s +
#endif
			"Check the port."s, MessageType::ERROR);
			return;
		}
#ifdef _WIN32
		uint32_t nonBlocking(true), cbRet;
		if (WSAIoctl(_socket, FIONBIO, &nonBlocking, sizeof(nonBlocking), nullptr, 0, (LPDWORD) &cbRet, nullptr, nullptr) != 0) {
#else
		if (fcntl(_socket, F_SETFL, fcntl(_socket, F_GETFL, 0) | O_NONBLOCK) == -1) {
#endif
			logger.log("Unable to make the socket non-blocking\n"s, MessageType::ERROR);
			return;
		}
	}
	if (_state == UNSUBSCRIBED) {
		const std::string miningSubscribeMessage("{\"id\": "s + std::to_string(_jsonId++) + ", \"method\": \"mining.subscribe\", \"params\": [\""s + userAgent + "\"]}\n"s);
		send(_socket, miningSubscribeMessage.c_str(), miningSubscribeMessage.size(), 0);
		logger.logDebug("Sent to pool: "s + miningSubscribeMessage);
	}
	const std::chrono::time_point<std::chrono::steady_clock> timeOutTimer(std::chrono::steady_clock::now());
	while (!getJob().has_value() || _state != AUTHORIZED) {
		process();
		if (Stella::timeSince(timeOutTimer) > 1.) {
			logger.log("Could not get a first job from the pool!\n"s, MessageType::ERROR);
			std::lock_guard<std::mutex> lock(_jobMutex);
			_currentJobTemplate.clientInfo = {};
			return;
		}
		std::this_thread::sleep_for(std::chrono::milliseconds(100));
	}
	_connected = true;
}

constexpr double stratumTimeOut(120.); // in s
void StratumClient::process() {
	if (_socket == -1)
		return;
	// Process pending submissions
	_submitMutex.lock();
	if (_pendingShares.size() > 0) {
		for (const auto &share : _pendingShares) {
			std::lock_guard<std::mutex> lock(_jobMutex);
			for (const auto &job : _currentJobs) {
				if (job.id == share.jobId) {
					logger.logDebug(Stella::formattedClockTimeNow() + " "s + std::to_string(share.primeCount) + "-share found by worker thread "s + std::to_string(share.threadId) + "\n"s);
					std::ostringstream oss;
					oss << "{\"id\": " << std::to_string(_jsonId++) << ", \"method\": \"mining.submit\", \"params\": [\""
						<< _username << "\", \""
						<< job.jobId << "\", \""
						<< v8ToHexStr(job.extraNonce2) << "\", \""
						<< std::setfill('0') << std::setw(16) << std::hex << job.bh.curtime << "\", \""
						<< v8ToHexStr(reverse(a8ToV8(encodedOffset(share)))) << "\"]}\n";
					send(_socket, oss.str().c_str(), oss.str().size(), 0);
					logger.logDebug("Sent to pool: "s + oss.str());
					_shares++;
					break;
				} // If not found then Job was obsoleted due to a new Block, do not submit.
			}
		}
		_pendingShares.clear();
	}
	_submitMutex.unlock();
	// Get server data
	constexpr std::size_t bufferSize(4096);
	char buffer[bufferSize];
	memset(&buffer, 0, bufferSize);
	const ssize_t messageLength(recv(_socket, buffer, bufferSize - 1U, 0));
	if (messageLength <= 0) { // No data received.
		if (messageLength == 0)
			logger.log("Connection closed by the pool.\n"s, MessageType::WARNING);
		else if (Stella::timeSince(_lastPoolMessageTp) > stratumTimeOut)
			logger.log("Received nothing from the pool since a long time, disconnection assumed.\n"s, MessageType::WARNING);
#ifdef _WIN32
		else if (WSAGetLastError() != WSAEWOULDBLOCK)
			logger.log("Error receiving work data from pool, error "s + std::to_string(WSAGetLastError()) + "\n"s, MessageType::ERROR);
#else
		else if (errno != EWOULDBLOCK)
			logger.log("Error receiving work data from pool: "s + std::strerror(errno) + "\n"s, MessageType::ERROR);
#endif
		else // Nothing went wrong, it is expected to get nothing most of the times due to the non blocking socket.
			return;
		_socket = -1;
		_state = UNSUBSCRIBED;
		_connected = false;
		std::lock_guard<std::mutex> lock(_jobMutex);
		_currentJobTemplate.clientInfo = {};
		return;
	}
	_lastPoolMessageTp = std::chrono::steady_clock::now();
	logger.logDebug("Received: "s + buffer);
	// Sometimes, the pool sends multiple lines in a single response (example, if a share is found immediately before a mining.notify). We need to process all of them.
	std::stringstream resultSS(buffer);
	std::string line;
	while (std::getline(resultSS, line)) {
		_processMessage(line);
		if (_state == UNSUBSCRIBED) {
			_socket = -1;
			_connected = false;
			std::lock_guard<std::mutex> lock(_jobMutex);
			_currentJobTemplate.clientInfo = {};
			return;
		}
	}
}

static uint32_t toBEnd32(uint32_t n) { // Converts a uint32_t to Big Endian (ABCDEF01 -> 01EFCDAB in a Little Endian system, do nothing in a Big Endian system)
	const uint8_t *tmp((uint8_t*) &n);
	return (uint32_t) tmp[3] | ((uint32_t) tmp[2]) << 8 | ((uint32_t) tmp[1]) << 16 | ((uint32_t) tmp[0]) << 24;
}
std::optional<Stella::Job> StratumClient::getJob() {
	std::lock_guard<std::mutex> lock(_jobMutex);
	Job job(_currentJobTemplate.job);
	if (!_currentJobTemplate.clientInfo.has_value())
		return {};
	Stella::Job stellaJob;
	job.id = _currentJobId;
	job.height = _currentJobTemplate.clientInfo->height;
	job.extraNonce2 = {};
	for (uint16_t i(0) ; i < _extraNonce2Len ; i++)
		job.extraNonce2.push_back(rand(0x00, 0xFF));
	job.bh.merkleRoot = merkleRootGen(_currentJobTemplate.merkleBranches, _currentJobTemplate.coinbase1, _currentJobTemplate.coinbase2, _extraNonce1, job.extraNonce2);
	_jobMutex.unlock();
	// Change endianness for correct target computation
	for (uint8_t i(0) ; i < 8 ; i++)
		reinterpret_cast<uint32_t*>(job.bh.previousblockhash.data())[i] = toBEnd32(reinterpret_cast<uint32_t*>(job.bh.previousblockhash.data())[i]);
	if (_currentJobs.size() == 0)
		_currentJobs = {job};
	else if (_currentJobTemplate.clientInfo->height != _currentJobs.back().height)
		_currentJobs = {job};
	else
		_currentJobs.push_back(job);
	stellaJob.id = _currentJobId;
	stellaJob.target = job.bh.target(_currentJobTemplate.clientInfo->powVersion);
	_currentJobId++;
	return stellaJob;
}

std::optional<ClientInfo> StratumClient::info() const {
	return _currentJobTemplate.clientInfo;
}
