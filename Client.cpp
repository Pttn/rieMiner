// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#include "Client.hpp"
#include "WorkManager.hpp"

Client::Client(const std::shared_ptr<WorkManager> &manager) {
	_manager = manager;
	_connected = false;
	_pendingSubmissions = std::vector<WorkData>();
	_curl = curl_easy_init();
	_inited = true;
}

bool Client::connect() {
	if (_connected) return false;
	if (_inited) {
		if (!_getWork()) return false;
		_pendingSubmissions = std::vector<WorkData>();
		_connected = true;
		return true;
	}
	else {
		std::cout << "Cannot connect because the client was not inited!" << std::endl;
		return false;
	}
}

bool Client::process() {
	_submitMutex.lock();
	if (_pendingSubmissions.size() > 0) {
		for (uint32_t i(0) ; i < _pendingSubmissions.size() ; i++)
			sendWork(_pendingSubmissions[i]);
		_pendingSubmissions.clear();
	}
	_submitMutex.unlock();
	
	if (_getWork()) return true;
	else { // If _getWork() failed, this means that the client is disconnected
		_connected = false;
		return false;
	}
}

std::string RPCClient::_getUserPass() const {
	std::ostringstream oss;
	oss << _manager->options().username() << ":" << _manager->options().password();
	return oss.str();
}

std::string RPCClient::_getHostPort() const {
	std::ostringstream oss;
	oss << "http://" << _manager->options().host() << ":" << _manager->options().port() << "/";
	return oss.str();
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
		curl_easy_setopt(_curl, CURLOPT_URL, _getHostPort().c_str());
		curl_easy_setopt(_curl, CURLOPT_POSTFIELDSIZE, (long) strlen(req.c_str()));
		curl_easy_setopt(_curl, CURLOPT_POSTFIELDS, req.c_str());
		curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, curlWriteCallback);
		curl_easy_setopt(_curl, CURLOPT_WRITEDATA, &s);
		curl_easy_setopt(_curl, CURLOPT_USERPWD, _getUserPass().c_str());
		curl_easy_setopt(_curl, CURLOPT_TIMEOUT, 10);
		
		const CURLcode cc(curl_easy_perform(_curl));
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

bool BMClient::_getWork() {
	if (_inited) {
		_bh = BlockHeader();
		((uint32_t*) &_bh.bits)[0] = 256*_manager->options().benchmarkDifficulty() + 33554432;
		_height = 1;
		return true;
	}
	else return false;
}

bool BMClient::connect() {
	if (_connected) return false;
	if (_inited) {
		_bh = BlockHeader();
		_pendingSubmissions = std::vector<WorkData>();
		_connected = true;
		_height = 0;
		return true;
	}
	else {
		std::cout << "Cannot start the benchmark because it was not inited!" << std::endl;
		return false;
	}
}

void BMClient::sendWork(const WorkData &work) const {
	_manager->printTime();
	std::cout << " " << work.primes << "-tuple found: ";
	std::cout << "Base prime: " << work.bh.decodeSolution() << std::endl;
	DBG(std::cout << "Dummy block header: " << binToHexStr(&work.bh, 112) << std::endl;);
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
