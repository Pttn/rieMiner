// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#include "main.h"
#include "gwclient.h"
#include "tools.h"

bool GWClient::connect() {
	if (_connected) return false;
	if (_inited) {
		if (!getWork()) return false;
		_gwd = GetWorkData();
		_pendingSubmissions = std::vector<std::pair<WorkData, uint8_t>>();
		_connected = true;
		_height = 0;
		return true;
	}
	else {
		std::cout << "Cannot connect because the client was not inited!" << std::endl;
		return false;
	}
}

bool GWClient::getWork() {
	uint32_t previousblockhashOld[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	memcpy(previousblockhashOld, _gwd.bh.previousblockhash, 32);
	
	std::string reqGw("{\"method\": \"getwork\", \"params\": [], \"id\": 0}\n"),
	            reqGmi("{\"method\": \"getmininginfo\", \"params\": [], \"id\": 0}\n");
	json_t *jsonGw(NULL), *jsonGmi(NULL);
 	
	jsonGw  = sendRPCCall(reqGw);
	if (jsonGw == NULL) return false;
	jsonGmi = sendRPCCall(reqGmi);
	if (jsonGmi == NULL) {
		json_decref(jsonGw);
		return false;
	}
	// Extract GetWork data
	hexStrToBin(json_string_value(json_object_get(json_object_get(jsonGw, "result"), "data")), (unsigned char*) &_gwd);
	// Get current block number and difficulty
	_height = json_integer_value(json_object_get(json_object_get(jsonGmi, "result"), "blocks"));
	// Notify when the network found a block
	if (memcmp(_gwd.bh.previousblockhash, previousblockhashOld, 32) != 0)
		_manager->updateHeight(_height);
	
	json_decref(jsonGw);
	json_decref(jsonGmi);
	return true;
}


void GWClient::sendWork(const std::pair<WorkData, uint8_t>& share) const {
	BlockHeader bhToSend;
	memcpy((uint8_t*) &bhToSend, ((uint8_t*) &share.first.bh), GWDSIZE/8);
	
	// Revert back endianness
	bhToSend.version = swab32(bhToSend.version);
	for (uint8_t i(0) ; i < 8 ; i++) {
		((uint32_t*) bhToSend.previousblockhash)[i] = be32dec(&((uint32_t*) bhToSend.previousblockhash)[i]);
		((uint32_t*) bhToSend.merkleRoot)[i] = be32dec(&((uint32_t*) bhToSend.merkleRoot)[i]);
		((uint32_t*) bhToSend.nOffset)[i] = be32dec(&((uint32_t*) bhToSend.nOffset)[i]);
	}
	bhToSend.bits = swab32(bhToSend.bits);
	bhToSend.curtime = swab32(bhToSend.curtime);
	
	json_t *jsonObj(NULL), *res(NULL), *reason(NULL);
	
	std::ostringstream oss;
	std::string req;
	oss << "{\"method\": \"getwork\", \"params\": [\"" << binToHexStr(&bhToSend, GWDSIZE/8) << "\"], \"id\": 1}\n";
	req = oss.str();
	jsonObj = sendRPCCall(req);
	
	uint8_t k(share.second);
	if (k >= 4) {
		_manager->printTime();
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

WorkData GWClient::workData() const {
	WorkData wd;
	wd.height = _height;
	wd.bh = _gwd.bh;
	// Change endianness just for mining (will revert back when submit share)
	wd.bh.version = swab32(wd.bh.version);
	for (uint8_t i(0) ; i < 8 ; i++) {
		((uint32_t*) wd.bh.previousblockhash)[i] = be32dec(&((uint32_t*) wd.bh.previousblockhash)[i]);
		((uint32_t*) wd.bh.merkleRoot)[i] = be32dec(&((uint32_t*) wd.bh.merkleRoot)[i]);
	}
	wd.bh.bits = swab32(wd.bh.bits);
	wd.bh.curtime = swab32(wd.bh.curtime);
	wd.targetCompact = getCompact(wd.bh.bits);
	return wd;
}
