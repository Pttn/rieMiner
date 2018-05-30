// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#include "global.h"
#include "client.h"

std::string binToHexStr(const void* p, uint32_t len) {
	std::ostringstream oss;
	for (uint32_t i(0) ; i < len ; i++)
		oss << std::setfill('0') << std::setw(2) << std::hex << (uint32_t) ((uint8_t*) p)[i];
	return oss.str();
}

void hexStrToBin(std::string str, uint8_t* data) {
	if (str.size() % 2 != 0) str = "0" + str;
	
	for (uint16_t i(0) ; i < str.size() ; i += 2) {
		uint8_t byte(0);
		for (uint8_t j(0) ; j < 2 ; j++) {
			uint8_t m(1);
			if (j == 0) m = 16;
			if (str[i + j] >= '0' && str[i + j] <= '9')
				byte += m*(str[i + j] - '0');
			else if (str[i + j] >= 'A' && str[i + j] <= 'F')
				byte += m*(str[i + j] - 'A' + 10);
			else if (str[i + j] >= 'a' && str[i + j] <= 'f')
				byte += m*(str[i + j] - 'a' + 10);
			else byte += 0;
		}
		data[i/2] = byte;
	}
}

Client::Client() {
	user = "";
	pass = "";
	host = "127.0.0.1";
	port = 28332;
	_connected = false;
	pendingSubmissions = std::vector<std::pair<GetWorkData, uint8_t>>();
	curl = curl_easy_init();
}

// Returns false on error or if already connected
bool Client::connect(const Arguments& arguments) {
	if (_connected) return false;
	user = arguments.user();
	pass = arguments.pass();
	host = arguments.host();
	port = arguments.port();
	if (!getWork()) return false;
	gwd = GetWorkData();
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
		curl_easy_setopt(curl, CURLOPT_URL, getHostPort().c_str());
		curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, (long) strlen(req.c_str()));
		curl_easy_setopt(curl, CURLOPT_POSTFIELDS, req.c_str());
		curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, curlWriteCallback);
		curl_easy_setopt(curl, CURLOPT_WRITEDATA, &s);
		curl_easy_setopt(curl, CURLOPT_USERPWD, getUserPass().c_str());
		
		CURLcode cc;
		cc = curl_easy_perform(curl);
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

bool Client::getWork() {
	std::string reqGw("{\"method\": \"getwork\", \"params\": [], \"id\": 0}\n"),
	            reqGmi("{\"method\": \"getmininginfo\", \"params\": [], \"id\": 0}\n");
	json_t *jsonGw(NULL), *jsonGmi(NULL);
 	
	jsonGw  = sendRPCCall(curl, reqGw);
	jsonGmi = sendRPCCall(curl, reqGmi);
	// Failure to GetWork or GetMiningInfo
	if (jsonGw == NULL || jsonGmi == NULL) return false;
	
	// Extract GetWork data
	hexStrToBin(json_string_value(json_object_get(json_object_get(jsonGw, "result"), "data")), (unsigned char*) &gwd);
 	workInfo.gwd = gwd;
 	
 	// Get current block number and difficulty
	uint32_t height(json_integer_value(json_object_get(json_object_get(jsonGmi, "result"), "blocks"))),
	         difficulty(json_number_value(json_object_get(json_object_get(jsonGmi, "result"), "difficulty")));
	blockheight = height;
	if (stats.difficulty != difficulty) {
		stats.lastDifficultyChange = std::chrono::system_clock::now();
		stats.blockHeightAtDifficultyChange = workInfo.height;
		for (uint8_t i(0) ; i < 7 ; i++)
			stats.foundTuplesSinceLastDifficulty[i] = 0;
	}
	stats.difficulty = difficulty;
	
	json_decref(jsonGw);
	json_decref(jsonGmi);
	
	return true;
}


void Client::sendWork(const std::pair<GetWorkData, uint8_t>& share) const {
	GetWorkData gwdToSend;
	memcpy((uint8_t*) &gwdToSend, ((uint8_t*) &share.first), GWDSIZE/8);
	
	// Revert back endianness
	gwdToSend.version = swab32(gwdToSend.version);
	for (uint8_t i(0) ; i < 8; i++) {
		gwdToSend.prevBlockHash[i] = be32dec(&gwdToSend.prevBlockHash[i]);
		gwdToSend.merkleRoot[i] = be32dec(&gwdToSend.merkleRoot[i]);
		gwdToSend.nOffset[i] = be32dec(&gwdToSend.nOffset[i]);
	}
	gwdToSend.nBits = swab32(gwdToSend.nBits);
	gwdToSend.nTime = swab32(gwdToSend.nTime);
	
	json_t *jsonObj = NULL, *res = NULL, *reason = NULL;
	
	std::ostringstream oss;
	std::string req;
	oss << "{\"method\": \"getwork\", \"params\": [\"" << binToHexStr(&gwdToSend, GWDSIZE/8) << "\"], \"id\": 1}\n";
	req = oss.str();
	jsonObj = sendRPCCall(curl, req);
	
	uint8_t k(share.second);
	if (k >= 4) {
		stats.printTime();
		std::cout << " 4-tuple found";
		if (k == 4) std::cout << std::endl;
	}
	if (k >= 5) {
		std::cout << "... Actually it was a 5-tuple";
		if (k == 5) std::cout << std::endl;
	}
	if (k >= 6) {
		std::cout << "... No, no... A 6-tuple = BLOCK!!!!!!" << std::endl;
		std::cout << "Sent: " << req;
		if (jsonObj == NULL)
			std::cerr << "Failure submiting block :|" << std::endl;
		else {
			res = json_object_get(jsonObj, "result");
			reason = json_object_get(jsonObj, "reject-reason");
			if (!json_is_true(res)) {
				std::cout << "Submission rejected :| ! ";
				if (reason == NULL) std::cout << "No reason given" << std::endl;
				else std::cout << "Reason: " << reason << std::endl;
			}
			else std::cout << "Submission accepted :D !" << std::endl;
		}
	}
	
	if (jsonObj != NULL) json_decref(jsonObj);
}

uint32_t getCompact(uint32_t nCompact) {
	uint32_t p;
	unsigned int nSize = nCompact >> 24;
	//bool fNegative     =(nCompact & 0x00800000) != 0;
	unsigned int nWord = nCompact & 0x007fffff;
	if (nSize <= 3) {
		nWord >>= 8*(3 - nSize);
		p = nWord;
	}
	else {
		p = nWord;
		p <<= 8*(nSize - 3); // warning: this has problems if difficulty (uncompacted) ever goes past the 2^32 boundary
	}
	return p;
}

bool Client::process() {
	// Are there shares to submit?
	submitMutex.lock();
	if (pendingSubmissions.size() > 0) {
		for (uint32_t i(0) ; i < pendingSubmissions.size() ; i++) {
			std::pair<GetWorkData, uint8_t> share(pendingSubmissions[i]);
			sendWork(share);
		}
		pendingSubmissions.clear();
	}
	submitMutex.unlock();
	
	uint32_t prevBlockHashOld[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	memcpy(prevBlockHashOld, gwd.prevBlockHash, 32);
	if (getWork()) {
		if (memcmp(gwd.prevBlockHash, prevBlockHashOld, 32) != 0) {
			if (workInfo.height != 0) {
				stats.printTime();
				if (workInfo.height - stats.blockHeightAtDifficultyChange != 0) {
					std::cout << " Blockheight = " << blockheight << ", average "
					          << FIXED(1) << timeSince(stats.lastDifficultyChange)/(workInfo.height - stats.blockHeightAtDifficultyChange)
					          << " s, difficulty = " << stats.difficulty << std::endl;
				}
				else
					std::cout << " Blockheight = " << blockheight << ", new difficulty = " << stats.difficulty << std::endl;
			}
			workInfo.height++;
		}
		
		// Change endianness for mining (will revert back when submit share)
		workInfo.gwd.version = swab32(workInfo.gwd.version);
		for (uint8_t i(0) ; i < 8; i++) {
			workInfo.gwd.prevBlockHash[i] = be32dec(&workInfo.gwd.prevBlockHash[i]);
			workInfo.gwd.merkleRoot[i] = be32dec(&workInfo.gwd.merkleRoot[i]);
		}
		workInfo.gwd.nBits = swab32(workInfo.gwd.nBits);
		workInfo.gwd.nTime = swab32(workInfo.gwd.nTime);
		workInfo.targetCompact = getCompact(workInfo.gwd.nBits);
		return true;
	}
	else { // If GetWork failed then we can assume that the client is disconnected
		_connected = false;
		return false;
	}
}
