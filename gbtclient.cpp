// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)

#include "main.h"
#include "gbtclient.h"

bool GBTClient::connect() {
	if (_connected) return false;
	if (_inited) {
		if (!getWork()) return false;
		_gbtd = GetBlockTemplateData();
		if (!addrToScriptPubKey(_manager->options().address(), _gbtd.scriptPubKey)) {
			std::cerr << "Invalid payout address! Using donation address instead." << std::endl;
			addrToScriptPubKey("RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB", _gbtd.scriptPubKey);
		}
		_pendingSubmissions = std::vector<std::pair<WorkData, uint8_t>>();
		_connected = true;
		return true;
	}
	else {
		std::cout << "Cannot connect because the client was not inited!" << std::endl;
		return false;
	}
}

void GetBlockTemplateData::coinBaseGen() {
	coinbase = std::vector<uint8_t>();
	uint8_t scriptSig[64], scriptSigLen(26 + 4);
	// rieMiner's signature
	hexStrToBin("4d696e65642077697468205074746e2773207269654d696e6572", scriptSig);
	// Randomize this so 2 instances will not work on the same problem
	scriptSig[26] = rand(0x00, 0xFF);
	scriptSig[27] = rand(0x00, 0xFF);
	scriptSig[28] = rand(0x00, 0xFF);
	scriptSig[29] = rand(0x00, 0xFF);
	
	// Version [0 -> 3] (01000000)
	coinbase.push_back(1);
	coinbase.push_back(0); coinbase.push_back(0); coinbase.push_back(0);
	// Input Count [4] (01)
	coinbase.push_back(1);
	// 0000000000000000000000000000000000000000000000000000000000000000 (Input TXID [5 -> 36])
	for (uint32_t i(0) ; i < 32 ; i++) coinbase.push_back(0);
	// Input VOUT [37 -> 40] (FFFFFFFF)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0xFF);
	// ScriptSig Size [41]
	coinbase.push_back(4 + scriptSigLen); // Block Height Push (4) + scriptSigLen
	// Block Height Length [42]
	if (height/65536 == 0) {
		if (height/256 == 0) coinbase.push_back(1);
		else coinbase.push_back(2);
	}
	else coinbase.push_back(3);
	// Block Height [43 -> 45]
	coinbase.push_back(height % 256);
	coinbase.push_back((height/256) % 256);
	coinbase.push_back((height/65536) % 256);
	// ScriptSig [46 -> 46 + scriptSigLen = s]
	for (uint32_t i(0) ; i < scriptSigLen ; i++) coinbase.push_back(scriptSig[i]);
	// Input Sequence [s -> s + 3] (FFFFFFFF)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0xFF);
	
	// Output Count [s + 4]
	coinbase.push_back(1);
	// Output Value [s + 5 -> s + 12]
	uint64_t coinbasevalue2(coinbasevalue);
	for (uint32_t i(0) ; i < 8 ; i++) {
		coinbase.push_back(coinbasevalue2 % 256);
		coinbasevalue2 /= 256;
	}
	coinbase.push_back(25); // Output Length [s + 13]
	coinbase.push_back(0x76); // OP_DUP [s + 14]
	coinbase.push_back(0xA9); // OP_HASH160 [s + 15]
	coinbase.push_back(0x14); // Bytes Pushed on Stack [s + 16]
	// ScriptPubKey (for payout address) [s + 17 -> s + 36]
	for (uint32_t i(0) ; i < 20 ; i++) coinbase.push_back(scriptPubKey[i]);
	coinbase.push_back(0x88); // OP_EQUALVERIFY [s + 37]
	coinbase.push_back(0xAC); // OP_CHECKSIG [s + 38]
	// Lock Time  [s + 39 -> s + 42] (00000000)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0);
}

bool GBTClient::getWork() {
	json_t *jsonGbt(sendRPCCall("{\"method\": \"getblocktemplate\", \"params\": [], \"id\": 0}\n")),
	       *jsonGbt_Res(json_object_get(jsonGbt, "result")),
	       *jsonGbt_Res_Txs(json_object_get(jsonGbt_Res, "transactions"));
	
	// Failure to GetBlockTemplate
	if (jsonGbt == NULL || jsonGbt_Res == NULL || jsonGbt_Res_Txs == NULL ) return false;
	
	uint32_t oldHeight(_gbtd.height);
	uint8_t bitsTmp[4];
	hexStrToBin(json_string_value(json_object_get(jsonGbt_Res, "bits")), bitsTmp);
	_gbtd.bh = BlockHeader();
	_gbtd.transactions = std::string();
	_gbtd.txHashes = std::vector<std::array<uint32_t, 8>>();
	
	// Extract and build GetBlockTemplate data
	_gbtd.bh.version = json_integer_value(json_object_get(jsonGbt_Res, "version"));
	hexStrToBin(json_string_value(json_object_get(jsonGbt_Res, "previousblockhash")), (uint8_t*) &_gbtd.bh.previousblockhash);
	_gbtd.height = json_integer_value(json_object_get(jsonGbt_Res, "height"));
	_gbtd.coinbasevalue = json_integer_value(json_object_get(jsonGbt_Res, "coinbasevalue"));
	_gbtd.bh.bits = ((uint32_t*) &bitsTmp)[0];
	_gbtd.bh.curtime = json_integer_value(json_object_get(jsonGbt_Res, "curtime"));
	_gbtd.transactions += binToHexStr(_gbtd.coinbase.data(), _gbtd.coinbase.size());
	for (uint32_t i(0) ; i < json_array_size(jsonGbt_Res_Txs) ; i++) {
		std::array<uint32_t, 8> txHash;
		uint8_t txHashTmp[32], txHashInvTmp[32];
		hexStrToBin(json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "hash")), txHashInvTmp);
		for (uint16_t j(0) ; j < 32 ; j++) txHashTmp[j] = txHashInvTmp[31 - j];
		for (uint32_t j(0) ; j < 8 ; j++) txHash[j] = ((uint32_t*) txHashTmp)[j];
		_gbtd.transactions += json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "data"));
		_gbtd.txHashes.push_back(txHash);
	}
	
	// Notify when the network found a block
	if (oldHeight != _gbtd.height) _manager->updateHeight(_gbtd.height - 1);
	
	json_decref(jsonGbt);
	
	return true;
}

void GBTClient::sendWork(const std::pair<WorkData, uint8_t>& share) const {
	WorkData wdToSend(share.first);
	json_t *jsonSb(NULL), *jsonSb_Res(NULL), *jsonSb_Err(NULL); // SubmitBlock response
	
	std::ostringstream oss;
	std::string req;
	oss << "{\"method\": \"submitblock\", \"params\": [\"" << binToHexStr(&wdToSend.bh, (32 + 256 + 256 + 32 + 64 + 256)/8);
	// Using the Variable Length Integer format
	if (wdToSend.txCount < 0xFD)
		oss << binToHexStr((uint8_t*) &wdToSend.txCount, 1);
	else // Having more than 65535 transactions is currently impossible
		oss << "fd" << binToHexStr((uint8_t*) &wdToSend.txCount, 2);
	oss << wdToSend.transactions << "\"], \"id\": 0}\n";
	req = oss.str();
	jsonSb = sendRPCCall(req);
	
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
		if (jsonSb == NULL) std::cerr << "Failure submiting block :|" << std::endl;
		else {
			jsonSb_Res = json_object_get(jsonSb, "result");
			jsonSb_Err = json_object_get(jsonSb, "error");
			if (json_is_null(jsonSb_Res) && json_is_null(jsonSb_Err)) std::cout << "Submission accepted :D !" << std::endl;
			else {
				std::cout << "Submission rejected :| ! ";
				if (json_is_null(jsonSb_Err)) std::cout << "No reason given" << std::endl;
				else std::cout << "Reason: " << json_string_value(json_object_get(jsonSb_Err, "message")) << std::endl;
			}
		}
	}
	
	if (jsonSb != NULL) json_decref(jsonSb);
}

WorkData GBTClient::workData() const {
	GetBlockTemplateData gbtd(_gbtd);
	gbtd.coinBaseGen();
	gbtd.transactions = binToHexStr(gbtd.coinbase.data(), gbtd.coinbase.size()) + gbtd.transactions;
	gbtd.txHashes.insert(gbtd.txHashes.begin(), gbtd.coinBaseHash());
	gbtd.merkleRootGen();
	
	WorkData wd;
	memcpy(&wd.bh, &gbtd.bh, 128);
	if (gbtd.height != 0) wd.height = gbtd.height - 1;
	wd.bh.bits       = swab32(wd.bh.bits);
	wd.targetCompact = getCompact(wd.bh.bits);
	wd.transactions  = gbtd.transactions;
	wd.txCount       = gbtd.txHashes.size();
	// Change endianness for mining (will revert back when submit share)
	for (uint8_t i(0) ; i < 32; i++) wd.bh.previousblockhash[i] = gbtd.bh.previousblockhash[31 - i];
	return wd;
}
