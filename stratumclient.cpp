// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#include "global.h"
#include "stratumclient.h"

#define USER_AGENT "rieMiner/0.9a3"

bool StratumClient::connect(const Arguments& arguments) {
	if (_connected) return false;
	_user = arguments.user();
	_pass = arguments.pass();
	_host = arguments.host();
	_port = arguments.port();
	_sd = StratumData();
	_wd = WorkData();
	_buffer = std::array<char, RBUFSIZE>();
	_noDataCount = 0;
	_state = INIT;
	_result = std::string();
	
	hostent* hostInfo = gethostbyname(_host.c_str());
	if (hostInfo == NULL) {
		std::cerr << "Unable to resolve '" << _host << "'. Check the URL or your connection." << std::endl;
		return false;
	}
	void** ipListPtr = (void**) hostInfo->h_addr_list;
	uint32_t ip(0xFFFFFFFF);
	if (ipListPtr[0]) ip = *(uint32_t*) ipListPtr[0];
	std::ostringstream oss;
	oss << ((ip >> 0) & 0xFF) << "." << ((ip >> 8) & 0xFF) << "." << ((ip >> 16) & 0xFF) << "." << ((ip >> 24) & 0xFF);
	std::cout << "Host: " << _host << " -> " << oss.str() << std::endl;
	
	_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	struct sockaddr_in addr;
	memset(&addr, 0, sizeof(sockaddr_in));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(_port);
	addr.sin_addr.s_addr = inet_addr(oss.str().c_str());
	int result = ::connect(_socket, (sockaddr*) &addr, sizeof(sockaddr_in));
	if (result != 0) {
		std::cerr << "Unable to connect :| - " << std::strerror(errno) << std::endl;
		_socket = -1;
		return false;
	}
	
#ifdef _WIN32
	uint32_t nonBlocking(true), cbRet;
	WSAIoctl(_socket, FIONBIO, &nonBlocking, sizeof(nonBlocking), NULL, 0, (LPDWORD) &cbRet, NULL, NULL);
#else
	int fcntlRet(fcntl(_socket, F_SETFL, fcntl(_socket, F_GETFL, 0) | O_NONBLOCK));
	if (fcntlRet == -1) std::cerr << "Unable to make the socket non-blocking :| - " << std::strerror(errno) << std::endl;
#endif
	
	// Send mining.subscribe request
	std::ostringstream oss2;
	oss2 << "{\"id\": 1, \"method\": \"mining.subscribe\", \"params\": [\"" << USER_AGENT "\"]}\n";
	send(_socket, oss2.str().c_str(), oss2.str().size(), 0);
	_state = SUBSCRIBE_SENT;
	_connected = true;
	return true;
}

void StratumClient::getSubscribeInfo() {
	std::string r;
	json_t *jsonObj(NULL), *jsonRes(NULL), *jsonErr(NULL);
	json_error_t err;
	
	for (uint32_t i(0) ; i < _result.size() ; i++) {
		if (_result[i] == '\n') break;
		r += _result[i];
	}
	jsonObj = json_loads(r.c_str(), 0, &err);
	if (jsonObj == NULL)
		std::cerr << "getSubscribeInfo: JSON decode failed - " << err.text << std::endl;
	else {
		jsonRes = json_object_get(jsonObj, "result");
		jsonErr = json_object_get(jsonObj, "error");
		
		if (!jsonRes || json_is_null(jsonRes) || (jsonErr && !json_is_null(jsonErr))) {
			std::cerr << "getSubscribeInfo: Invalid or missing mining.subscribe data! " << std::endl;
			if (jsonErr) std::cerr << " Reason: " << json_dumps(jsonErr, JSON_INDENT(3)) << std::endl;
			else std::cerr << "No reason given" << std::endl;
			std::cerr << std::endl;
		}
		else if (json_array_size(jsonRes) != 3)
			std::cerr << "getSubscribeInfo: Invalid mining.subscribe result size!" << std::endl;
		else {
			json_t *jsonSids;
			jsonSids = json_array_get(jsonRes, 0);
			if (jsonSids == NULL || !json_is_array(jsonSids))
				std::cerr << "getSubscribeInfo: Invalid or missing mining.subscribe response!" << std::endl;
			else {
				_sd.sids = std::vector<std::pair<std::string, std::vector<uint8_t>>>();
				if (json_array_size(jsonSids) == 2 && !json_is_array(json_array_get(jsonSids, 0)) && !json_is_array(json_array_get(jsonSids, 1))) {
					_sd.sids.push_back(std::make_pair(
								json_string_value(json_array_get(jsonSids, 0)),
								hexStrToV8(json_string_value(json_array_get(jsonSids, 1)))));
				}
				else {
					for (uint16_t i(0) ; i < json_array_size(jsonSids) ; i++) {
						json_t *jsonSid(json_array_get(jsonSids, i));
						if (jsonSid == NULL || !json_is_array(jsonSid))
							std::cerr << "getSubscribeInfo: invalid or missing Subscribtion Id " << i << " data received!" << std::endl;
						else if (json_array_size(jsonSid) != 2)
							std::cerr << "getSubscribeInfo: invalid Subscribtion Id " << i << " array size!" << std::endl;
						else {
							_sd.sids.push_back(std::make_pair(
								json_string_value(json_array_get(jsonSid, 0)),
								hexStrToV8(json_string_value(json_array_get(jsonSid, 1)))));
							
						}
						if (jsonSid != NULL) json_decref(jsonSid);
					}
				}
			}
			
			_sd.extraNonce1 = hexStrToV8(json_string_value(json_array_get(jsonRes, 1)));
			_sd.extraNonce1Len = _sd.extraNonce1.size();
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
			std::cout << "extraNonce1Len = " << _sd.extraNonce1Len << std::endl;
			std::cout << "extraNonce2Len = " << _sd.extraNonce2Len << std::endl;
			
			std::ostringstream oss;
			oss << "{\"id\": 2, \"method\": \"mining.authorize\", \"params\": [\"" << _user << "\", \"" << _pass << "\"]}\n";
			send(_socket, oss.str().c_str(), oss.str().size(), 0);
			
			_state = AUTHORIZE_SENT;
			std::cout << "Waiting for server data..." << std::endl;
		}
	}
	
	if (jsonObj == NULL) json_decref(jsonObj);
	if (jsonRes == NULL) json_decref(jsonRes);
	if (jsonErr == NULL) json_decref(jsonErr);
}

void StratumClient::handleOther() {
	json_t *jsonObj/*, *id, *params*/;
	json_error_t err;

	jsonObj = json_loads(_result.c_str(), 0, &err);
	if (jsonObj == NULL)
		/*std::cerr << "handleOther: JSON decode failed :| - " << err.text << std::endl*/; // This happens sometimes but without harm
	else {
		const char *method(NULL);
		method = json_string_value(json_object_get(jsonObj, "method"));
		if (method == NULL) {
			if (_state == SHARE_SENT) {
				getSentShareResponse();
				_state = READY;
			}
		}
		else {
			/*id = json_object_get(jsonObj, "id");
			params = json_object_get(jsonObj, "params");
			std::cout << "Received: " << method << std::endl;*/
			if (strcasecmp(method, "mining.notify") == 0)
				getWork();
		}
	}
	
	if (jsonObj != NULL) json_decref(jsonObj);
}

bool StratumClient::getWork() {
	json_t *jsonMn(NULL), *jsonMn_params(NULL); // Mining.notify results
	json_error_t err;
	jsonMn = json_loads(_result.c_str(), 0, &err);
	if (jsonMn == NULL) {
		std::cerr << "getWork: Invalid or no mining.notify result received!" << std::endl;
		return false;
	}
	jsonMn_params = json_object_get(jsonMn, "params");
	if (jsonMn_params == NULL) {
		std::cerr << "getWork: Invalid or no params in mining.notify received!" << std::endl;
		json_decref(jsonMn);
		return false;
	}
	
	const char *job_id, *prevhash, *coinb1, *coinb2, *version, *nbits, *ntime;
	json_t *jsonTxs;
	
	job_id = json_string_value(json_array_get(jsonMn_params, 0));
	prevhash = json_string_value(json_array_get(jsonMn_params, 1));
	coinb1 = json_string_value(json_array_get(jsonMn_params, 2));
	coinb2 = json_string_value(json_array_get(jsonMn_params, 3));
	jsonTxs = json_array_get(jsonMn_params, 4);
	if (!jsonTxs || !json_is_array(jsonTxs)) {
		std::cerr << "getWork: Missing or invalid Merkle data for params in mining.notify!" << std::endl;
		json_decref(jsonMn);
		json_decref(jsonMn_params);
		return false;
	}
	version = json_string_value(json_array_get(jsonMn_params, 5));
	nbits = json_string_value(json_array_get(jsonMn_params, 6));
	ntime = json_string_value(json_array_get(jsonMn_params, 7));

	if (!job_id || !prevhash || !coinb1 || !coinb2 || !version || !nbits || !ntime) {
		std::cerr << "getWork: Missing params in mining.notify!" << std::endl;
		json_decref(jsonMn);
		json_decref(jsonMn_params);
		return false;
	}
	else if (strlen(prevhash) != 64 || strlen(version) != 8 || strlen(nbits) != 8 || strlen(ntime) != 8) {
		std::cerr << "getWork: Invalid params in mining.notify!" << std::endl;
		json_decref(jsonMn);
		json_decref(jsonMn_params);
		return false;
	}
	
	_sd.bh = BlockHeader();
	_sd.txHashes = std::vector<std::array<uint32_t, 8>>();
	hexStrToBin(version,  (uint8_t*) &_sd.bh.version);
	hexStrToBin(prevhash, (uint8_t*) &_sd.bh.previousblockhash);
	hexStrToBin(nbits,    (uint8_t*) &_sd.bh.bits);
	hexStrToBin(ntime,    (uint8_t*) &_sd.bh.curtime);
	_sd.coinbase1 = hexStrToV8(coinb1);
	_sd.coinbase2 = hexStrToV8(coinb2);
	_sd.jobId = hexStrToV8(job_id);
	memcpy(&_wd.bh, &_sd.bh, 128);
	// Get Transactions Hashes
	for (uint32_t i(0) ; i < json_array_size(jsonTxs) ; i++) {
		std::array<uint32_t, 8> txHash;
		uint8_t txHashTmp[32];
		hexStrToBin(json_string_value(json_array_get(jsonTxs, i)), txHashTmp);
		for (uint32_t j(0) ; j < 8 ; j++) txHash[j] = ((uint32_t*) txHashTmp)[j];
		_sd.txHashes.push_back(txHash);
	}
	
	// Extract BlockHeight from Coinbase
	uint32_t oldHeight(_wd.height), height(_sd.coinbase1[43] + 256*_sd.coinbase1[44] + 65536*_sd.coinbase1[45] - 1);
	// Notify when the network found a block
	if (oldHeight != height) {
		if (oldHeight != 0) {
			stats.printTime();
			if (_wd.height - stats.blockHeightAtDifficultyChange != 0) {
				std::cout << " Blockheight = " << height << ", average "
				          << FIXED(1) << timeSince(stats.lastDifficultyChange)/(_wd.height - stats.blockHeightAtDifficultyChange)
				          << " s, difficulty = " << stats.difficulty << std::endl;
			}
			else
				std::cout << " Blockheight = " << height << ", new difficulty = " << stats.difficulty << std::endl;
		}
		else stats.blockHeightAtDifficultyChange = height;
	}
	// Fill the work data for the workers
	_wd.height         = height;
	_wd.bh.bits        = swab32(_wd.bh.bits);
	_wd.targetCompact  = getCompact(_wd.bh.bits);
	_wd.txHashes       = _sd.txHashes;
	_wd.txCount        = _sd.txHashes.size();
	_wd.coinbase1      = _sd.coinbase1;
	_wd.coinbase2      = _sd.coinbase2;
	_wd.extraNonce1    = _sd.extraNonce1;
	_wd.extraNonce2Len = _sd.extraNonce2Len;
	_wd.jobId          = _sd.jobId;
	// Change endianness for mining (will revert back when submit share)
	for (uint8_t i(0) ; i < 8; i++)
		_wd.bh.previousblockhash[i] = be32dec(&_wd.bh.previousblockhash[i]);
	_wd.bh.curtime = be32dec(&_wd.bh.curtime);
	_wd.bh.version = swab32(_wd.bh.version);
	
	json_decref(jsonMn);
	json_decref(jsonMn_params);
	return true;
}

void StratumClient::getSentShareResponse() {
	json_t *jsonObj(NULL), *jsonRes, *jsonErr;
	json_error_t err;
	
	jsonObj = json_loads(_result.c_str(), 0, &err);
	if (jsonObj == NULL)
		std::cerr << "getSentShareResponse: JSON decode failed :| - " << err.text << std::endl;
	else {
		jsonRes = json_object_get(jsonObj, "result");
		jsonErr = json_object_get(jsonObj, "error");
		
		if (!jsonRes || json_is_null(jsonRes) || (jsonErr && !json_is_null(jsonErr))) {
			std::cout << "Share rejected :| ";
			if (jsonErr) std::cout << "Reason: " << json_dumps(jsonErr, JSON_INDENT(3));
			else std::cout << "No reason given";
			std::cout << std::endl;
		}
	}
}

void StratumClient::sendWork(const std::pair<WorkData, uint8_t>& share) const {
	stats.printTime();
	std::cout << " " << (uint16_t) share.second << "-share found" << std::endl;
	WorkData wdToSend(share.first);
	
	std::ostringstream oss;
	uint32_t nonce[8];
	wdToSend.bh.curtime = be32dec(&wdToSend.bh.curtime);
	wdToSend.bh.curtime <<= 32;
	
	for (uint32_t i(0) ; i < 8 ; i++)
		nonce[i] = swab32( *(((uint32_t *) wdToSend.bh.nOffset) + 8 - 1 - i) );
	
	oss << "{\"method\": \"mining.submit\", \"params\": [\""
	    << _user << "\", \""
	    << v8ToHexStr(wdToSend.jobId) << "\", \""
	    << v8ToHexStr(wdToSend.extraNonce2) << "\", \""
	    << binToHexStr((const uint8_t*) &wdToSend.bh.curtime, 8) << "\", \""
	    << binToHexStr(nonce, 32) << "\"], \"id\":0}\n";
	
	send(_socket, oss.str().c_str(), oss.str().size(), 0);
}

bool StratumClient::process() {
	_submitMutex.lock();
	if (_pendingSubmissions.size() > 0) {
		for (uint32_t i(0) ; i < _pendingSubmissions.size() ; i++) {
			std::pair<WorkData, uint8_t> share(_pendingSubmissions[i]);
			sendWork(share);
			_state = SHARE_SENT;
		}
		_pendingSubmissions.clear();
	}
	_submitMutex.unlock();
	
	// Get server data
	ssize_t n(recv(_socket, &_buffer[0], RECVSIZE, 0));
	_result = std::string();
	
	if (n <= 0) { // No data received. Usually, this is normal, because of the non-blocking socket...
		_noDataCount++;
#ifdef _WIN32
		if (WSAGetLastError() != WSAEWOULDBLOCK || n == 0 || _noDataCount > MAXNDC) { // ...but else, this is an error!
#else
		if (errno != EWOULDBLOCK || n == 0 || _noDataCount > MAXNDC) { // ...but else, this is an error!
#endif
			if (_noDataCount > MAXNDC)
				std::cerr << "process: no server response since a very long time, disconnection assumed." << std::endl;
			else
				std::cerr << "process: error receiving work data :| - " << std::strerror(errno) << std::endl;
			_socket = -1;
			_connected = false;
			return false;
		}
		return true;
	}
	
	_noDataCount = 0;
	_result.append(_buffer.cbegin(), _buffer.cbegin() + n);
	// std::cout << "Result = " << _result << std::endl; // Main line for Stratum debugging
	
	if      (_state == SUBSCRIBE_SENT) getSubscribeInfo();
	else if (_state == AUTHORIZE_SENT) _state = READY;
	else                               handleOther();
	
	return true;
}
