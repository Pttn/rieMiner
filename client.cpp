// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#include "global.h"
#include "client.h"
#include "tools.h"

Client::Client() {
	_user = "";
	_pass = "";
	_host = "127.0.0.1";
	_port = 28332;
	_connected = false;
	_wd = WorkData();
	_pendingSubmissions = std::vector<std::pair<WorkData, uint8_t>>();
	_curl = curl_easy_init();
}

bool Client::connect(const Arguments& arguments) {
	if (_connected) return false;
	_user = arguments.user();
	_pass = arguments.pass();
	_host = arguments.host();
	_port = arguments.port();
	if (!getWork()) return false;
	_wd = WorkData();
	_pendingSubmissions = std::vector<std::pair<WorkData, uint8_t>>();
	_connected = true;
	return true;
}

size_t curlWriteCallback(void *data, size_t size, size_t nmemb, std::string *s) {
	size_t newLength = size*nmemb;
	size_t oldLength = s->size();
	s->resize(oldLength + newLength);
	std::copy((char*) data, (char*) data + newLength, s->begin() + oldLength);
	return size*nmemb;
}

json_t* Client::sendRPCCall(CURL *curl, const std::string& req) const {
	std::string s;
	json_t *jsonObj = NULL;
	
	if (curl) {
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
			std::cerr << "Curl_easy_perform() failed :| : " << curl_easy_strerror(cc) << std::endl;
		else {
			jsonObj = json_loads(s.c_str(), 0, &err);
			if (jsonObj == NULL)
				std::cerr << "JSON decoding failed :|" << std::endl;
		}
	}
	
	return jsonObj;
}

bool Client::process() {
	_submitMutex.lock();
	if (_pendingSubmissions.size() > 0) {
		for (uint32_t i(0) ; i < _pendingSubmissions.size() ; i++) {
			std::pair<WorkData, uint8_t> share(_pendingSubmissions[i]);
			sendWork(share);
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
