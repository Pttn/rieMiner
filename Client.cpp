// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#include "Client.hpp"
#include "WorkManager.hpp"

Client::Client(const std::shared_ptr<WorkManager> &manager) {
	_manager = manager;
	_connected = false;
	_pendingSubmissions = std::vector<std::pair<WorkData, uint8_t>>();
	_curl = curl_easy_init();
	_inited = true;
}

std::string Client::getUserPass() const {
	std::ostringstream oss;
	oss << _manager->options().user() << ":" << _manager->options().pass();
	return oss.str();
}

std::string Client::getHostPort() const {
	std::ostringstream oss;
	oss << "http://" << _manager->options().host() << ":" << _manager->options().port() << "/";
	return oss.str();
}

bool Client::connect() {
	if (_connected) return false;
	if (_inited) {
		if (!getWork()) return false;
		_pendingSubmissions = std::vector<std::pair<WorkData, uint8_t>>();
		_connected = true;
		return true;
	}
	else {
		std::cout << "Cannot connect because the client was not inited!" << std::endl;
		return false;
	}
}

static size_t curlWriteCallback(void *data, size_t size, size_t nmemb, std::string *s) {
	s->append((char*) data, size*nmemb);
	return size*nmemb;
}

json_t* RPCClient::sendRPCCall(const std::string& req) const {
	std::string s;
	json_t *jsonObj(NULL);
	
	if (_curl) {
		json_error_t err;
		curl_easy_setopt(_curl, CURLOPT_URL, getHostPort().c_str());
		curl_easy_setopt(_curl, CURLOPT_POSTFIELDSIZE, (long) strlen(req.c_str()));
		curl_easy_setopt(_curl, CURLOPT_POSTFIELDS, req.c_str());
		curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, curlWriteCallback);
		curl_easy_setopt(_curl, CURLOPT_WRITEDATA, &s);
		curl_easy_setopt(_curl, CURLOPT_USERPWD, getUserPass().c_str());
		curl_easy_setopt(_curl, CURLOPT_TIMEOUT, 10);
		
		CURLcode cc;
		cc = curl_easy_perform(_curl);
		if (cc != CURLE_OK)
			std::cerr << __func__ << ": curl_easy_perform() failed :| - " << curl_easy_strerror(cc) << std::endl;
		else {
			jsonObj = json_loads(s.c_str(), 0, &err);
			if (jsonObj == NULL)
				std::cerr << __func__ << ": JSON decoding failed :| - " << err.text << std::endl;
		}
	}
	
	return jsonObj;
}

bool Client::process() {
	_submitMutex.lock();
	if (_pendingSubmissions.size() > 0) {
		for (uint32_t i(0) ; i < _pendingSubmissions.size() ; i++) {
			const std::pair<WorkData, uint8_t> work(_pendingSubmissions[i]);
			sendWork(work);
		}
		_pendingSubmissions.clear();
	}
	_submitMutex.unlock();
	
	if (getWork()) return true;
	else { // If getWork() failed, this means that the client is disconnected
		_connected = false;
		return false;
	}
}

bool BMClient::connect() {
	if (_connected) return false;
	if (_inited) {
		_bh = BlockHeader();
		_pendingSubmissions = std::vector<std::pair<WorkData, uint8_t>>();
		_connected = true;
		_height = 0;
		return true;
	}
	else {
		std::cout << "Cannot start the benchmark because it was not inited!" << std::endl;
		return false;
	}
}

bool BMClient::getWork() {
	if (_inited) {
		_bh = BlockHeader();
		((uint32_t*) &_bh.bits)[0] = 256*_manager->options().testDiff() + 33554432;
		_height = 1;
		return true;
	}
	else return false;
}

void BMClient::sendWork(const std::pair<WorkData, uint8_t>& share) const {
	const WorkData wdToSend(share.first);
	const uint16_t k(share.second);
	_manager->printTime();
	std::cout << " " << k << "-tuple found: ";
	
	const std::string bhStr(binToHexStr(&wdToSend, 112));
	const uint32_t diff(getCompact(invEnd32(strtol(bhStr.substr(136, 8).c_str(), NULL, 16))));
	std::vector<uint8_t> SV8(32), XV8, tmp(sha256sha256(hexStrToV8(bhStr.substr(0, 160)).data(), 80));
	for (uint64_t i(0) ; i < 256 ; i++) SV8[i/8] |= (((tmp[i/8] >> (i % 8)) & 1) << (7 - (i % 8)));
	mpz_class S(v8ToHexStr(SV8).c_str(), 16), target(1);
	mpz_mul_2exp(S.get_mpz_t(), S.get_mpz_t(), diff - 265);
	mpz_mul_2exp(target.get_mpz_t(), target.get_mpz_t(), diff - 1);
	target += S;
	tmp = hexStrToV8(bhStr.substr(160, 64));
	for (uint8_t i(0) ; i < tmp.size() ; i++) XV8.push_back(tmp[tmp.size() - i - 1]);
	mpz_class X(v8ToHexStr(XV8).c_str(), 16);
	std::cout << "n = " << target + X << std::endl;
	DBG(std::cout << "Dummy block header: " << bhStr << std::endl;);
}

WorkData BMClient::workData() const {
	WorkData wd;
	if (_height == 1) {
		memcpy(&wd.bh, &_bh, 128);
		wd.height = _height;
		wd.targetCompact = getCompact(wd.bh.bits);
		for (uint32_t i(0) ; i < 32 ; i++) wd.bh.merkleRoot[i] = rand(0x00, 0xFF);
	}
	return wd;
}
