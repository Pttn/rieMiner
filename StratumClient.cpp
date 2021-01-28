// (c) 2018-2021 Pttn (https://github.com/Pttn/rieMiner)

#include "main.hpp"
#include "StratumClient.hpp"

constexpr const char* userAgent("rieMiner/0.92");

static std::array<uint8_t, 32> calculateMerkleRootStratum(const std::vector<std::array<uint8_t, 32>> &txHashes) {
	std::array<uint8_t, 32> merkleRoot{};
	if (txHashes.size() == 0)
		ERRORMSG("No transaction to hash");
	else if (txHashes.size() == 1)
		return txHashes[0];
	else {
		std::vector<uint8_t> hashData(64, 0);
		std::array<uint8_t, 32> hashTmp;
		std::copy(txHashes[0].begin(), txHashes[0].end(), hashData.begin());
		for (uint32_t i(1) ; i < txHashes.size() ; i++) {
			std::copy(txHashes[i].begin(), txHashes[i].end(), hashData.begin() + 32);
			hashTmp = sha256sha256(hashData.data(), 64);
			std::copy(hashTmp.begin(), hashTmp.end(), hashData.begin());
		}
		std::copy(hashData.begin(), hashData.begin() + 32, merkleRoot.begin());
	}
	return merkleRoot;
}
void StratumData::merkleRootGen() {
	std::vector<uint8_t> coinbase;
	extraNonce2 = std::vector<uint8_t>();
	coinbase.insert(coinbase.end(), coinbase1.begin(), coinbase1.end());
	coinbase.insert(coinbase.end(), extraNonce1.begin(), extraNonce1.end());
	for (uint32_t i(0) ; i < extraNonce2Len ; i++) extraNonce2.push_back(rand(0x00, 0xFF));
	coinbase.insert(coinbase.end(), extraNonce2.begin(), extraNonce2.end());
	coinbase.insert(coinbase.end(), coinbase2.begin(), coinbase2.end());
	
	std::array<uint8_t, 32> cbHash(sha256sha256(coinbase.data(), coinbase.size()));
	txHashes.insert(txHashes.begin(), cbHash);
	bh.merkleRoot = calculateMerkleRootStratum(txHashes);
}

bool StratumClient::_fetchWork() {
	std::lock_guard<std::mutex> lock(_workMutex);
	uint8_t heightLength;
	json_t *jsonMn(nullptr), *jsonMn_params(nullptr); // Mining.notify results
	json_error_t err;
	jsonMn = json_loads(_result.c_str(), 0, &err);
	if (jsonMn == nullptr) {
		std::cout << __func__ << ": invalid or no mining.notify result received!" << std::endl;
		return false;
	}
	jsonMn_params = json_object_get(jsonMn, "params");
	if (jsonMn_params == nullptr) {
		std::cout << __func__ << ": invalid or no params in mining.notify received!" << std::endl;
		goto failure;
	}
	const char *jobId, *prevhash, *coinbase1, *coinbase2, *version, *nbits, *ntime;
	int32_t powversion;
	json_t *jsonTxs, *patterns;
	
	jobId     = json_string_value(json_array_get(jsonMn_params, 0));
	prevhash  = json_string_value(json_array_get(jsonMn_params, 1));
	coinbase1 = json_string_value(json_array_get(jsonMn_params, 2));
	coinbase2 = json_string_value(json_array_get(jsonMn_params, 3));
	jsonTxs   = json_array_get(jsonMn_params, 4);
	if (!jsonTxs || !json_is_array(jsonTxs)) {
		std::cout << __func__ << ": missing or invalid Merkle data for params in mining.notify!" << std::endl;
		goto failure;
	}
	version = json_string_value(json_array_get(jsonMn_params, 5));
	nbits   = json_string_value(json_array_get(jsonMn_params, 6));
	ntime   = json_string_value(json_array_get(jsonMn_params, 7));
	powversion = json_integer_value(json_array_get(jsonMn_params, 9));
	patterns = json_array_get(jsonMn_params, 10);
	if (jobId == nullptr || prevhash == nullptr || coinbase1 == nullptr || coinbase2 == nullptr || version == nullptr || nbits == nullptr || ntime == nullptr || powversion == 0 || patterns == nullptr) {
		std::cout << __func__ << ": missing params in mining.notify!" << std::endl;
		std::cout << "The pool is outdated, please wait for it to upgrade or choose another one." << std::endl;
		goto failure;
	}
	if (strlen(prevhash) != 64 || strlen(version) != 8 || strlen(nbits) != 8 || strlen(ntime) != 8 || !json_is_array(patterns)) {
		std::cout << __func__ << ": invalid params in mining.notify!" << std::endl;
		goto failure;
	}
	_sd.bh = BlockHeader();
	_sd.txHashes = std::vector<std::array<uint8_t, 32>>();
	_sd.bh.previousblockhash = v8ToA8(hexStrToV8(prevhash));
	try {
		_sd.bh.version = std::stoll(version, nullptr, 16);
		_sd.bh.curtime = std::stoll(ntime, nullptr, 16);
		_sd.bh.bits = std::stoll(nbits, nullptr, 16);
	}
	catch (...) {
		std::cout << __func__ << ": invalid Block Header hex values !" << std::endl;
		goto failure;
	}
	_info.powVersion = powversion;
	if (_info.powVersion != -1 && _info.powVersion != 1) {
		std::cout << __func__ << ": invalid PoW Version " << _info.powVersion << "!" << std::endl;
		goto failure;
	}
	_info.acceptedPatterns = Client::extractAcceptedPatterns(patterns);
	if (_info.acceptedPatterns.size() == 0) {
		std::cout << __func__ << ": empty or invalid accepted constellation patterns list!" << std::endl;
		goto failure;
	}
	_sd.sharePrimeCountMin = std::max(static_cast<int>(_info.acceptedPatterns[0].size()) - 2, 3);
	_sd.coinbase1 = hexStrToV8(coinbase1);
	_sd.coinbase2 = hexStrToV8(coinbase2);
	_sd.jobId     = jobId;
	// Get Transactions Hashes
	for (uint32_t i(0) ; i < json_array_size(jsonTxs) ; i++) {
		const std::string txStr(json_string_value(json_array_get(jsonTxs, i)));
		if (txStr.size() != 64) {
			std::cout << __func__ << ": invalid transaction ID size!" << std::endl;
			goto failure;
		}
		const std::array<uint8_t, 32> txHash(v8ToA8(hexStrToV8(txStr)));
		_sd.txHashes.push_back(txHash);
	}
	// Extract BlockHeight from Coinbase
	heightLength = _sd.coinbase1[42];
	if (heightLength == 1) _sd.height = _sd.coinbase1[43];
	else if (heightLength == 2) _sd.height = _sd.coinbase1[43] + 256*_sd.coinbase1[44];
	else _sd.height = _sd.coinbase1[43] + 256*_sd.coinbase1[44] + 65536*_sd.coinbase1[45];
	json_decref(jsonMn);
	return true;
failure:
	_sd = StratumData();
	json_decref(jsonMn);
	return false;
}

void StratumClient::_getSubscribeInfo() {
	std::string r;
	json_t *jsonObj(nullptr), *jsonRes(nullptr), *jsonErr(nullptr);
	json_error_t err;
	
	for (const auto &c : _result) {
		if (c == '\n') break;
		r += c;
	}
	jsonObj = json_loads(r.c_str(), 0, &err);
	if (jsonObj == nullptr)
		std::cout << __func__ << ": JSON decode failed :| - " << err.text << std::endl;
	else {
		jsonRes = json_object_get(jsonObj, "result");
		jsonErr = json_object_get(jsonObj, "error");
		if (!jsonRes || json_is_null(jsonRes) || (jsonErr && !json_is_null(jsonErr))) {
			std::cout << __func__ << ": invalid or missing mining.subscribe data! " << std::endl;
			if (jsonErr) std::cout << " Reason: " << json_dumps(jsonErr, JSON_INDENT(3)) << std::endl;
			else std::cout << "No reason given" << std::endl;
		}
		else if (json_array_size(jsonRes) != 3)
			std::cout << __func__ << ": invalid mining.subscribe result size!" << std::endl;
		else {
			json_t *jsonSids;
			jsonSids = json_array_get(jsonRes, 0);
			if (jsonSids == nullptr || !json_is_array(jsonSids))
				std::cout << __func__ << ": invalid or missing mining.subscribe response!" << std::endl;
			else {
				_sd.sids = std::vector<std::pair<std::string, std::vector<uint8_t>>>();
				if (json_array_size(jsonSids) == 2 && !json_is_array(json_array_get(jsonSids, 0)) && !json_is_array(json_array_get(jsonSids, 1))) {
					std::string key;
					std::vector<uint8_t> value;
					if (json_string_value(json_array_get(jsonSids, 0)) != nullptr) key   = json_string_value(json_array_get(jsonSids, 0));
					if (json_string_value(json_array_get(jsonSids, 1)) != nullptr) value = hexStrToV8(json_string_value(json_array_get(jsonSids, 1)));
					_sd.sids.push_back(std::make_pair(key, value));
				}
				else {
					for (uint16_t i(0) ; i < json_array_size(jsonSids) ; i++) {
						json_t *jsonSid(json_array_get(jsonSids, i));
						if (jsonSid == nullptr || !json_is_array(jsonSid))
							std::cout << __func__ << ": invalid or missing Subscribtion Id " << i << " data received!" << std::endl;
						else if (json_array_size(jsonSid) != 2)
							std::cout << __func__ << ": invalid Subscribtion Id " << i << " array size!" << std::endl;
						else {
							std::string key;
							std::vector<uint8_t> value;
							if (json_string_value(json_array_get(jsonSid, 0)) != nullptr) key   = json_string_value(json_array_get(jsonSid, 0));
							if (json_string_value(json_array_get(jsonSid, 1)) != nullptr) value = hexStrToV8(json_string_value(json_array_get(jsonSid, 1)));
							_sd.sids.push_back(std::make_pair(key, value));
						}
						if (jsonSid != nullptr) json_decref(jsonSid);
					}
				}
			}
			_sd.extraNonce1 = hexStrToV8(json_string_value(json_array_get(jsonRes, 1)));
			_sd.extraNonce2Len = json_integer_value(json_array_get(jsonRes, 2));
			_state = SUBSCRIBE_RCVD;
			std::cout << "Subscriptions:";
			if (_sd.sids.size() == 0) std::cout << " none" << std::endl;
			else {
				std::cout << std::endl;
				for (uint16_t i(0) ; i < _sd.sids.size() ; i++)
					std::cout << " " << i << " - " << _sd.sids[i].first << ": " << v8ToHexStr(_sd.sids[i].second) << std::endl;
			}
			std::cout << "ExtraNonce1    = " << v8ToHexStr(_sd.extraNonce1) << std::endl;
			std::cout << "extraNonce2Len = " << _sd.extraNonce2Len << std::endl;
			
			std::ostringstream oss;
			oss << "{\"id\": 2, \"method\": \"mining.authorize\", \"params\": [\"" << _username << "\", \"" << _password << "\"]}\n";
			send(_socket, oss.str().c_str(), oss.str().size(), 0);
			_state = READY;
		}
	}
	
	if (jsonObj == nullptr) json_decref(jsonObj);
	if (jsonRes == nullptr) json_decref(jsonRes);
	if (jsonErr == nullptr) json_decref(jsonErr);
}

void StratumClient::_handleSentShareResponse() {
	json_error_t err;
	json_t *jsonObj(json_loads(_result.c_str(), 0, &err));
	if (jsonObj == nullptr)
		std::cout << __func__ << ": JSON decode failed :| - " << err.text << std::endl;
	else {
		json_t *jsonRes(json_object_get(jsonObj, "result")),
		       *jsonErr(json_object_get(jsonObj, "error"));
		if (jsonRes == nullptr || json_is_null(jsonRes) || !json_is_null(jsonErr)) {
			std::cout << "Share rejected :| ! Received: " << json_dumps(jsonObj, JSON_COMPACT) << std::endl;
			_rejectedShares++;
		}
		json_decref(jsonObj);
	}
}

void StratumClient::_handleOther() {
	json_t *jsonObj;
	json_error_t err;
	jsonObj = json_loads(_result.c_str(), 0, &err);
	if (jsonObj != nullptr) {
		const char *method(nullptr);
		method = json_string_value(json_object_get(jsonObj, "method"));
		if (method == nullptr) {
			if (_state == SHARE_SENT) {
				_handleSentShareResponse();
				_state = READY;
			}
		}
		else {
			if (strcasecmp(method, "mining.notify") == 0)
				_fetchWork();
		}
		json_decref(jsonObj);
	}
}

void StratumClient::connect() {
	if (!_connected) {
		_info = {0, {}};
		_sd = StratumData();
		_buffer = std::array<char, stratumBufferSize>();
		_lastDataRecvTp = std::chrono::steady_clock::now();
		_shares = 0;
		_rejectedShares = 0;
		_state = INIT;
		_result = std::string();
		
#ifdef _WIN32
		WORD wVersionRequested(MAKEWORD(2, 2));
		WSADATA wsaData;
		int err(WSAStartup(wVersionRequested, &wsaData));
		if (err != 0) {
			ERRORMSG("WSAStartup failed with error: " << err);
			return;
		}
#endif
		hostent* hostInfo = gethostbyname(_host.c_str());
		if (hostInfo == nullptr) {
			std::cout << __func__ << ": unable to resolve '" << _host << "'. Check the URL or your connection." << std::endl;
			return;
		}
		void** ipListPtr((void**) hostInfo->h_addr_list);
		uint32_t ip(0xFFFFFFFF);
		if (ipListPtr[0]) ip = *(uint32_t*) ipListPtr[0];
		std::ostringstream oss;
		oss << ((ip >> 0) & 0xFF) << "." << ((ip >> 8) & 0xFF) << "." << ((ip >> 16) & 0xFF) << "." << ((ip >> 24) & 0xFF);
		std::cout << "Host: " << _host  << " -> " << oss.str() << std::endl;
		
		_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		struct sockaddr_in addr;
		memset(&addr, 0, sizeof(sockaddr_in));
		addr.sin_family = AF_INET;
		addr.sin_port = htons(_port);
		addr.sin_addr.s_addr = inet_addr(oss.str().c_str());
		int result = ::connect(_socket, (sockaddr*) &addr, sizeof(sockaddr_in));
		if (result != 0) {
			std::cout << __func__ << ": unable to connect :| - " << std::strerror(errno) << std::endl;
			std::cout << "Check the port or your connection." << std::endl;
			_socket = -1;
			return;
		}
#ifdef _WIN32
		uint32_t nonBlocking(true), cbRet;
		WSAIoctl(_socket, FIONBIO, &nonBlocking, sizeof(nonBlocking), nullptr, 0, (LPDWORD) &cbRet, nullptr, nullptr);
#else
		int fcntlRet(fcntl(_socket, F_SETFL, fcntl(_socket, F_GETFL, 0) | O_NONBLOCK));
		if (fcntlRet == -1) ERRORMSG("Unable to make the socket non-blocking - " << std::strerror(errno));
#endif
		
		// Send mining.subscribe request
		std::ostringstream oss2;
		oss2 << "{\"id\": 1, \"method\": \"mining.subscribe\", \"params\": [\"" << userAgent << "\"]}\n";
		send(_socket, oss2.str().c_str(), oss2.str().size(), 0);
		DBG(std::cout << "Sent: " << oss2.str(););
		_state = SUBSCRIBE_SENT;
		_connected = true;
	}
}

NetworkInfo StratumClient::info() {
	const std::chrono::time_point<std::chrono::steady_clock> timeOutTimer(std::chrono::steady_clock::now());
	while (_info.powVersion == 0) { // Poll until valid work data is generated, with 2 s time out
		process();
		if (timeSince(timeOutTimer) > 2.) {
			std::cout << "Unable to get mining data from the pool :| !" << std::endl;
			_connected = false;
			return {0, {}};
		}
		std::this_thread::sleep_for(std::chrono::milliseconds(200));
	}
	return _info;
}

void StratumClient::_submit(const Job& share) {
	std::ostringstream oss;
	oss << "{\"method\": \"mining.submit\", \"params\": [\""
	    << _username << "\", \""
	    << share.jobId << "\", \""
	    << v8ToHexStr(share.extraNonce2) << "\", \""
	     << std::setfill('0') << std::setw(16) << std::hex << share.bh.curtime << "\", \""
	    << v8ToHexStr(reverse(a8ToV8(share.encodedOffset()))) << "\"], \"id\":0}\n";
	send(_socket, oss.str().c_str(), oss.str().size(), 0);
	DBG(std::cout << "Sent: " << oss.str(););
}

void StratumClient::process() {
	// Process pending submissions
	_submitMutex.lock();
	if (_pendingSubmissions.size() > 0) {
		for (const auto &submission : _pendingSubmissions) {
			_submit(submission);
			_shares++;
			_state = SHARE_SENT;
		}
		_pendingSubmissions.clear();
	}
	_submitMutex.unlock();
	// Get server data
	const ssize_t n(recv(_socket, _buffer.data(), stratumBufferSize, 0));
	_result = std::string();
	
	if (n <= 0) { // No data received. Usually, this is normal, because of the non-blocking socket...
#ifdef _WIN32
		if (WSAGetLastError() != WSAEWOULDBLOCK || n == 0 || timeSince(_lastDataRecvTp) > stratumTimeOut) { // ...but else, this is an error! Or a timeout.
#else
		if (errno != EWOULDBLOCK || n == 0 || timeSince(_lastDataRecvTp) > stratumTimeOut) { // ...but else, this is an error! Or a timeout.
#endif
			if (timeSince(_lastDataRecvTp) > stratumTimeOut)
				std::cout << __func__ << ": no server response since a very long time, disconnection assumed." << std::endl;
			else
				std::cout << __func__ << ": error receiving work data - " << std::strerror(errno) << std::endl;
			_socket = -1;
			_connected = false;
		}
		return;
	}
	
	_lastDataRecvTp = std::chrono::steady_clock::now();
	_result.append(_buffer.cbegin(), _buffer.cbegin() + n);
	DBG(std::cout << "Result = " << _result;);
	
	// Sometimes, the pool sends multiple lines in a single response (example, if a share is found immediately before a mining.notify). We need to process all of them.
	std::stringstream resultSS(_result);
	std::string line;
	while (std::getline(resultSS, line)) {
		_result = line;
		if (_state == SUBSCRIBE_SENT) _getSubscribeInfo();
		else _handleOther();
	}
}

static uint32_t toBEnd32(uint32_t n) { // Converts a uint32_t to Big Endian (ABCDEF01 -> 01EFCDAB in a Little Endian system, do nothing in a Big Endian system)
	const uint8_t *tmp((uint8_t*) &n);
	return (uint32_t) tmp[3] | ((uint32_t) tmp[2]) << 8 | ((uint32_t) tmp[1]) << 16 | ((uint32_t) tmp[0]) << 24;
}
bool StratumClient::getJob(Job& job, const bool) {
	std::lock_guard<std::mutex> lock(_workMutex);
	StratumData sd(_sd);
	sd.merkleRootGen();
	
	job.height           = sd.height;
	job.bh               = sd.bh;
	job.powVersion       = _info.powVersion;
	job.difficulty       = decodeBits(job.bh.bits, job.powVersion);
	job.primeCountMin    = sd.sharePrimeCountMin;
	job.primeCountTarget = _info.acceptedPatterns.size() != 0 ? _info.acceptedPatterns[0].size() : 1;
	job.extraNonce1      = sd.extraNonce1;
	job.extraNonce2      = sd.extraNonce2;
	job.jobId            = sd.jobId;
	// Change endianness for correct target computation
	for (uint8_t i(0) ; i < 8 ; i++) reinterpret_cast<uint32_t*>(job.bh.previousblockhash.data())[i] = toBEnd32(reinterpret_cast<uint32_t*>(job.bh.previousblockhash.data())[i]);
	job.target           = job.bh.target(job.powVersion);
	return job.height != 0;
}
