// (c) 2018-2022 Pttn (https://riecoin.dev/en/rieMiner)

#include <fcntl.h>
#ifdef _WIN32
	#include <winsock2.h>
#else
	#include <arpa/inet.h>
	#include <netdb.h>
#endif
#include <nlohmann/json.hpp>

#include "Client.hpp"

constexpr const char* userAgent("rieMiner/0.93");

static std::array<uint8_t, 32> calculateMerkleRootStratum(const std::vector<std::array<uint8_t, 32>> &merkleBranches) {
	std::array<uint8_t, 32> merkleRoot{};
	if (merkleBranches.size() == 0)
		ERRORMSG("No merkle branch");
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
		std::cout << "Could not parse Json Message!" << std::endl;
		std::cout << "Pool message was: " << message << std::endl;
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
				std::cout << "Could not parse mining.notify parameters!" << std::endl;
				std::cout << "Please check whether the pool or rieMiner is outdated." << std::endl;
				std::cout << "Pool message was: " << message << std::endl;
				_state = UNSUBSCRIBED;
				return;
			}
			if (!isHexStrOfSize(prevhash, 64) || !isHexStr(coinbase1) || coinbase1.size() % 2 != 0 || coinbase1.size() < 46 || !isHexStr(coinbase2) || coinbase2.size() % 2 != 0 || !isHexStrOfSize(version, 8) || !isHexStrOfSize(nbits, 8) || !isHexStr(ntime)) {
				std::cout << "Received invalid mining.notify parameters!" << std::endl;
				std::cout << "Please check whether the pool or rieMiner is outdated." << std::endl;
				std::cout << "Pool message was: " << message << std::endl;
				_state = UNSUBSCRIBED;
				return;
			}
			if (powVersion != 1) {
				std::cout << "The pool uses an unsupported PoW Version " << powVersion << ", your rieMiner version is likely outdated!" << std::endl;
				_state = UNSUBSCRIBED;
				return;
			}
			if (acceptedPatterns.size() == 0) {
				std::cout << "Received empty or invalid accepted constellation patterns list!" << std::endl;
				_state = UNSUBSCRIBED;
				return;
			}
			JobTemplate newJobTemplate;
			newJobTemplate.job.clientData.bh.previousblockhash = v8ToA8(hexStrToV8(prevhash));
			try {
				newJobTemplate.job.clientData.bh.version = std::stoll(version, nullptr, 16);
				newJobTemplate.job.clientData.bh.curtime = std::stoll(ntime, nullptr, 16);
				newJobTemplate.job.clientData.bh.bits = std::stoll(nbits, nullptr, 16);
			}
			catch (...) {
				std::cout << "Received invalid Block Header hex values!" << std::endl;
				_state = UNSUBSCRIBED;
				return;
			}
			newJobTemplate.job.clientData.jobId = jobId;
			newJobTemplate.coinbase1 = hexStrToV8(coinbase1);
			newJobTemplate.coinbase2 = hexStrToV8(coinbase2);
			for (const auto &merkleBranch : merkleBranches) {
				if (!isHexStrOfSize(merkleBranch, 64)) {
					std::cout << "Received invalid Merkle Branch" << merkleBranch << "!" << std::endl;
					_state = UNSUBSCRIBED;
					return;
				}
				newJobTemplate.merkleBranches.push_back(v8ToA8(hexStrToV8(merkleBranch)));
			}
			// Extract BlockHeight from Coinbase
			const uint8_t heightLength(newJobTemplate.coinbase1[42]);
			if (heightLength == 1) newJobTemplate.job.height = newJobTemplate.coinbase1[43];
			else if (heightLength == 2) newJobTemplate.job.height = newJobTemplate.coinbase1[43] + 256*newJobTemplate.coinbase1[44];
			else newJobTemplate.job.height = newJobTemplate.coinbase1[43] + 256*newJobTemplate.coinbase1[44] + 65536*newJobTemplate.coinbase1[45];
			newJobTemplate.job.powVersion = powVersion;
			newJobTemplate.job.acceptedPatterns = acceptedPatterns;
			newJobTemplate.job.primeCountTarget = newJobTemplate.job.acceptedPatterns[0].size();
			newJobTemplate.job.primeCountMin = std::max(static_cast<int>(newJobTemplate.job.acceptedPatterns[0].size()) - 2, 4);
			newJobTemplate.job.difficulty = decodeBits(newJobTemplate.job.clientData.bh.bits, newJobTemplate.job.powVersion);
			std::lock_guard<std::mutex> lock(_jobMutex);
			_currentJobTemplate = newJobTemplate;
		}
		else if (method == "client.show_message") {
			std::string messageToShow;
			try {
				nlohmann::json jsonParams(jsonMessage["params"]);
				messageToShow = jsonParams[0];
				std::cout << "Message from pool: \"" << messageToShow << "\"" << std::endl;
			}
			catch (std::exception &e) {
				std::cout << "Received invalid client.show_message request - " << e.what() << std::endl;
				std::cout << "Pool message was: " << message << std::endl;
				return;
			}
		}
		else {
			DBG(std::cout << "Received request from pool with unsupported method " << method << std::endl;);
			DBG(std::cout << "Pool message was: " << message << std::endl;);
		}
	}
	else {
		if (_state == UNSUBSCRIBED) {
			try {
				nlohmann::json jsonResult(jsonMessage["result"]);
				_sids = jsonResult[0].get<decltype(_sids)>();
				const std::string extraNonce1Str(jsonResult[1]);
				if (!isHexStr(extraNonce1Str) || extraNonce1Str.size() % 2 != 0) {
					std::cout << __func__ << ": Invalid Extra Nonce 1" << std::endl;
					return;
				}
				_extraNonce1 = hexStrToV8(extraNonce1Str);
				_extraNonce2Len = jsonResult[2];
			}
			catch (...) {
				std::cout << "Received invalid mining.subscribe result!" << std::endl;
				std::cout << "Please check whether the pool or rieMiner is outdated." << std::endl;
				std::cout << "Pool message was: " << message << std::endl;
				return;
			}
			_state = SUBSCRIBED;
			std::cout << "Successfully subscribed to the pool. Subscriptions:";
			if (_sids.size() == 0)
				std::cout << " none" << std::endl;
			else {
				std::cout << std::endl;
				for (const auto &sid : _sids)
					std::cout << "\t" << sid.first << ": " << sid.second << std::endl;
			}
			std::cout << "ExtraNonce1    = " << v8ToHexStr(_extraNonce1) << std::endl;
			std::cout << "extraNonce2Len = " << _extraNonce2Len << std::endl;
			const std::string miningAuthorizeMessage("{\"id\": "s + std::to_string(_jsonId++) + ", \"method\": \"mining.authorize\", \"params\": [\""s + _username + "\", \""s + _password + "\"]}\n"s);
			send(_socket, miningAuthorizeMessage.c_str(), miningAuthorizeMessage.size(), 0);
			DBG(std::cout << "Sent to pool: " << miningAuthorizeMessage;);
		}
		else if (_state == SUBSCRIBED) {
			nlohmann::json jsonResult;
			try {
				jsonResult = jsonMessage["result"];
			}
			catch (...) {
				std::cout << "Received bad mining.subscribe result!" << std::endl;
				std::cout << "Pool message was: " << message << std::endl;
				_state = UNSUBSCRIBED;
				return;
			}
			if (jsonResult != true) {
				std::cout << "Authorization refused by the pool. Please check your credentials." << std::endl;
				std::cout << "Pool message was: " << message << std::endl;
				_state = UNSUBSCRIBED;
			}
			else {
				std::cout << "Successfully authorized by the pool." << std::endl;
				_state = AUTHORIZED;
			}
		}
		else if (_state == AUTHORIZED) {
			nlohmann::json jsonResult;
			try {
				jsonResult = jsonMessage["result"];
			}
			catch (...) {
				std::cout << "Received bad mining.authorize result!" << std::endl;
				std::cout << "Pool message was: " << message << std::endl;
				_state = UNSUBSCRIBED;
				return;
			}
			if (jsonResult != true) {
				std::cout << "Share rejected :| ! Received: " << message << std::endl;
				_rejectedShares++;
			}
		}
	}
}

void StratumClient::_submit(const Job& share) {
	std::ostringstream oss;
	oss << "{\"id\": " << std::to_string(_jsonId++) << ", \"method\": \"mining.submit\", \"params\": [\""
	    << _username << "\", \""
	    << share.clientData.jobId << "\", \""
	    << v8ToHexStr(share.clientData.extraNonce2) << "\", \""
	    << std::setfill('0') << std::setw(16) << std::hex << share.clientData.bh.curtime << "\", \""
	    << v8ToHexStr(reverse(a8ToV8(share.encodedOffset()))) << "\"]}\n";
	send(_socket, oss.str().c_str(), oss.str().size(), 0);
	DBG(std::cout << "Sent: " << oss.str(););
}

void StratumClient::connect() {
	if (!_connected) {
		_pendingSubmissions = {};
		_sids = {};
		_extraNonce1 = {};
		_extraNonce2Len = 0;
		_currentJobTemplate = JobTemplate();
		_lastPoolMessageTp = std::chrono::steady_clock::now();
		_shares = 0;
		_rejectedShares = 0;
		_state = UNSUBSCRIBED;
		_jsonId = 0U;
#ifdef _WIN32
		WORD wVersionRequested(MAKEWORD(2, 2));
		WSADATA wsaData;
		const int err(WSAStartup(wVersionRequested, &wsaData));
		if (err != 0) {
			ERRORMSG("WSAStartup failed with error " << err);
			return;
		}
#endif
		hostent* hostInfo = gethostbyname(_host.c_str());
		if (hostInfo == nullptr) {
			std::cout << "Unable to resolve '" << _host << "', check the URL." << std::endl;
			return;
		}
		void** ipListPtr((void**) hostInfo->h_addr_list);
		uint32_t ip(0xFFFFFFFF);
		if (ipListPtr[0]) ip = *(uint32_t*) ipListPtr[0];
		std::ostringstream oss;
		oss << ((ip >> 0) & 0xFF) << "." << ((ip >> 8) & 0xFF) << "." << ((ip >> 16) & 0xFF) << "." << ((ip >> 24) & 0xFF);
		std::cout << "Host: " << _host  << " -> " << oss.str() << std::endl;
		_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if (_socket == -1) {
#ifdef _WIN32
			std::cout << "Could not create endpoint, error " << WSAGetLastError() << std::endl;
#else
			std::cout << "Could not create endpoint - " << std::strerror(errno) << std::endl;
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
			std::cout << "Could not connect to the pool, error " << WSAGetLastError() << std::endl;
#else
			std::cout << "Could not connect to the pool - " << std::strerror(errno) << std::endl;
#endif
			std::cout << "Check the port." << std::endl;
			return;
		}
#ifdef _WIN32
		uint32_t nonBlocking(true), cbRet;
		if (WSAIoctl(_socket, FIONBIO, &nonBlocking, sizeof(nonBlocking), nullptr, 0, (LPDWORD) &cbRet, nullptr, nullptr) != 0) {
#else
		if (fcntl(_socket, F_SETFL, fcntl(_socket, F_GETFL, 0) | O_NONBLOCK) == -1) {
#endif
			ERRORMSG("Unable to make the socket non-blocking");
			return;
		}
	}
	if (_state == UNSUBSCRIBED) {
		const std::string miningSubscribeMessage("{\"id\": "s + std::to_string(_jsonId++) + ", \"method\": \"mining.subscribe\", \"params\": [\""s + userAgent + "\"]}\n"s);
		send(_socket, miningSubscribeMessage.c_str(), miningSubscribeMessage.size(), 0);
		DBG(std::cout << "Sent: " << miningSubscribeMessage;);
	}
	const std::chrono::time_point<std::chrono::steady_clock> timeOutTimer(std::chrono::steady_clock::now());
	while (getJob().height == 0 || _state != AUTHORIZED) {
		process();
		if (timeSince(timeOutTimer) > 1.) {
			std::cout << "Could not get a first job from the pool!" << std::endl;
			std::lock_guard<std::mutex> lock(_jobMutex);
			_currentJobTemplate.job.height = 0;
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
	if (_pendingSubmissions.size() > 0) {
		for (const auto &submission : _pendingSubmissions) {
			_submit(submission);
			_shares++;
		}
		_pendingSubmissions.clear();
	}
	_submitMutex.unlock();
	// Get server data
	constexpr std::size_t bufferSize(4096);
	char buffer[bufferSize];
	memset(&buffer, 0, bufferSize);
	const ssize_t messageLength(recv(_socket, buffer, bufferSize - 1U, 0));
	if (messageLength <= 0) { // No data received.
		if (messageLength == 0)
			std::cout << "Connection closed by the pool" << std::endl;
		else if (timeSince(_lastPoolMessageTp) > stratumTimeOut)
			std::cout << "Received nothing from the pool since a long time, disconnection assumed." << std::endl;
#ifdef _WIN32
		else if (WSAGetLastError() != WSAEWOULDBLOCK)
			std::cout << "Error receiving work data from pool, error " << WSAGetLastError() << std::endl;
#else
		else if (errno != EWOULDBLOCK)
			std::cout << "Error receiving work data from pool: " << std::strerror(errno) << std::endl;
#endif
		else // Nothing went wrong, it is expected to get nothing most of the times due to the non blocking socket.
			return;
		_socket = -1;
		_state = UNSUBSCRIBED;
		_connected = false;
		std::lock_guard<std::mutex> lock(_jobMutex);
		_currentJobTemplate.job.height = 0;
		return;
	}
	_lastPoolMessageTp = std::chrono::steady_clock::now();
	DBG(std::cout << "Received: " << buffer;);
	// Sometimes, the pool sends multiple lines in a single response (example, if a share is found immediately before a mining.notify). We need to process all of them.
	std::stringstream resultSS(buffer);
	std::string line;
	while (std::getline(resultSS, line)) {
		_processMessage(line);
		if (_state == UNSUBSCRIBED) {
			_socket = -1;
			_connected = false;
			std::lock_guard<std::mutex> lock(_jobMutex);
			_currentJobTemplate.job.height = 0;
			return;
		}
	}
}

static uint32_t toBEnd32(uint32_t n) { // Converts a uint32_t to Big Endian (ABCDEF01 -> 01EFCDAB in a Little Endian system, do nothing in a Big Endian system)
	const uint8_t *tmp((uint8_t*) &n);
	return (uint32_t) tmp[3] | ((uint32_t) tmp[2]) << 8 | ((uint32_t) tmp[1]) << 16 | ((uint32_t) tmp[0]) << 24;
}
Job StratumClient::getJob(const bool) {
	std::lock_guard<std::mutex> lock(_jobMutex);
	Job job(_currentJobTemplate.job);
	if (job.height == 0) // Invalid Job
		return job;
	job.clientData.extraNonce2 = {};
	for (uint16_t i(0) ; i < _extraNonce2Len ; i++)
		job.clientData.extraNonce2.push_back(rand(0x00, 0xFF));
	job.clientData.bh.merkleRoot = merkleRootGen(_currentJobTemplate.merkleBranches, _currentJobTemplate.coinbase1, _currentJobTemplate.coinbase2, _extraNonce1, job.clientData.extraNonce2);
	_jobMutex.unlock();
	// Change endianness for correct target computation
	for (uint8_t i(0) ; i < 8 ; i++)
		reinterpret_cast<uint32_t*>(job.clientData.bh.previousblockhash.data())[i] = toBEnd32(reinterpret_cast<uint32_t*>(job.clientData.bh.previousblockhash.data())[i]);
	job.target = job.clientData.bh.target(job.powVersion);
	return job;
}
