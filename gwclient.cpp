// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#include "global.h"
#include "gwclient.h"
#include "tools.h"

bool GWClient::connect(const Arguments& arguments) {
	if (_connected) return false;
	_user = arguments.user();
	_pass = arguments.pass();
	_host = arguments.host();
	_port = arguments.port();
	if (!getWork()) return false;
	_gwd = GetWorkData();
	_wd = WorkData();
	_pendingSubmissions = std::vector<std::pair<WorkData, uint8_t>>();
	_connected = true;
	return true;
}

bool GWClient::getWork() {
	uint32_t previousblockhashOld[8] = {0, 0, 0, 0, 0, 0, 0, 0};
	memcpy(previousblockhashOld, _gwd.bh.previousblockhash, 32);
	
	std::string reqGw("{\"method\": \"getwork\", \"params\": [], \"id\": 0}\n"),
	            reqGmi("{\"method\": \"getmininginfo\", \"params\": [], \"id\": 0}\n");
	json_t *jsonGw(NULL), *jsonGmi(NULL);
 	
	jsonGw  = sendRPCCall(_curl, reqGw);
	jsonGmi = sendRPCCall(_curl, reqGmi);
	// Failure to GetWork or GetMiningInfo
	if (jsonGw == NULL || jsonGmi == NULL) return false;
	
	// Extract GetWork data
	hexStrToBin(json_string_value(json_object_get(json_object_get(jsonGw, "result"), "data")), (unsigned char*) &_gwd);
 	_wd.bh = _gwd.bh;
 	
 	// Get current block number and difficulty
	uint32_t height(json_integer_value(json_object_get(json_object_get(jsonGmi, "result"), "blocks")));
	
	// Notify when the network found a block
	if (memcmp(_gwd.bh.previousblockhash, previousblockhashOld, 32) != 0) {
		if (_wd.height != 0) {
			stats.printTime();
			if (_wd.height - stats.blockHeightAtDifficultyChange != 0) {
				if (stats.difficulty != 1) {
					std::cout << " Blockheight = " << height << ", average "
						      << FIXED(1) << timeSince(stats.lastDifficultyChange)/(_wd.height - stats.blockHeightAtDifficultyChange)
						      << " s, difficulty = " << stats.difficulty << std::endl;
				}
			}
			else
				std::cout << " Blockheight = " << _wd.height << ", new difficulty = " << stats.difficulty << std::endl;
		}
		else stats.blockHeightAtDifficultyChange = height;
	}
	
	_wd.height = height;
	
	// Change endianness just for mining (will revert back when submit share)
	_wd.bh.version = swab32(_wd.bh.version);
	for (uint8_t i(0) ; i < 8; i++) {
		_wd.bh.previousblockhash[i] = be32dec(&_wd.bh.previousblockhash[i]);
		_wd.bh.merkleRoot[i] = be32dec(&_wd.bh.merkleRoot[i]);
	}
	_wd.bh.bits = swab32(_wd.bh.bits);
	_wd.bh.curtime = swab32(_wd.bh.curtime);
	_wd.targetCompact = getCompact(_wd.bh.bits);
	
	json_decref(jsonGw);
	json_decref(jsonGmi);
	
	return true;
}


void GWClient::sendWork(const std::pair<WorkData, uint8_t>& share) const {
	BlockHeader bhToSend;
	memcpy((uint8_t*) &bhToSend, ((uint8_t*) &share.first.bh), GWDSIZE/8);
	
	// Revert back endianness
	bhToSend.version = swab32(bhToSend.version);
	for (uint8_t i(0) ; i < 8; i++) {
		bhToSend.previousblockhash[i] = be32dec(&bhToSend.previousblockhash[i]);
		bhToSend.merkleRoot[i] = be32dec(&bhToSend.merkleRoot[i]);
		bhToSend.nOffset[i] = be32dec(&bhToSend.nOffset[i]);
	}
	bhToSend.bits = swab32(bhToSend.bits);
	bhToSend.curtime = swab32(bhToSend.curtime);
	
	json_t *jsonObj = NULL, *res = NULL, *reason = NULL;
	
	std::ostringstream oss;
	std::string req;
	oss << "{\"method\": \"getwork\", \"params\": [\"" << binToHexStr(&bhToSend, GWDSIZE/8) << "\"], \"id\": 1}\n";
	req = oss.str();
	jsonObj = sendRPCCall(_curl, req);
	
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
