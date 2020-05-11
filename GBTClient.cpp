// (c) 2018-2020 Pttn (https://github.com/Pttn/rieMiner)

#include "GBTClient.hpp"
#include "main.hpp"
#include "WorkManager.hpp"

void GetBlockTemplateData::coinBaseGen(const AddressFormat &addressFormat, const std::string &cbMsg, uint16_t donationPercent) {
	coinbase = std::vector<uint8_t>();
	std::vector<uint8_t> scriptSig;
	const std::vector<uint8_t> dwc(hexStrToV8(default_witness_commitment)); // for SegWit
	for (uint32_t i(0) ; i < cbMsg.size() ; i++) scriptSig.push_back(cbMsg[i]);
	
	// Randomization to avoid 2 threads working on the same problem
	for (uint32_t i(0) ; i < 4 ; i++) scriptSig.push_back(rand(0x00, 0xFF));
	
	// Version (01000000)
	coinbase.push_back(0x01); coinbase.push_back(0x00); coinbase.push_back(0x00); coinbase.push_back(0x00);
	
	if (dwc.size() > 0) {
		coinbase.push_back(0x00); // Marker
		coinbase.push_back(0x01); // Flag
	}
	
	// Input Count (01)
	coinbase.push_back(1);
	// 0000000000000000000000000000000000000000000000000000000000000000 (Input TXID)
	for (uint32_t i(0) ; i < 32 ; i++) coinbase.push_back(0);
	// Input VOUT (FFFFFFFF)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0xFF);
	// ScriptSig Size
	coinbase.push_back(4 + scriptSig.size()); // Block Height Push (4) + scriptSig.size()
	// Block Height Length
	if (height/65536 == 0) {
		if (height/256 == 0) coinbase.push_back(1);
		else coinbase.push_back(2);
	}
	else coinbase.push_back(3);
	// Block Height
	coinbase.push_back(height % 256);
	coinbase.push_back((height/256) % 256);
	coinbase.push_back((height/65536) % 256);
	// ScriptSig
	for (uint32_t i(0) ; i < scriptSig.size() ; i++) coinbase.push_back(scriptSig[i]);
	// Input Sequence (FFFFFFFF)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0xFF);
	
	std::vector<uint8_t> scriptPubKeyDon(hexStrToV8("a0524c3936b8cb020dd1debadd81353d5577b79a"));
	uint64_t donation(donationPercent*coinbasevalue/100);
	if (scriptPubKey == scriptPubKeyDon) donation = 0;
	uint64_t reward(coinbasevalue - donation);
	// Output Count
	if (donation == 0) coinbase.push_back(1);
	else coinbase.push_back(2);
	if (dwc.size() > 0) coinbase[coinbase.size() - 1]++; // Dummy Output for SegWit if needed
	// Output Value
	for (uint32_t i(0) ; i < 8 ; i++) {
		coinbase.push_back(reward % 256);
		reward /= 256;
	}
	
	if (addressFormat == AddressFormat::P2SH) {
		coinbase.push_back(scriptPubKey.size() + 3); // Output Length
		coinbase.push_back(0xA9); // OP_HASH160
		coinbase.push_back(0x14); // Bytes Pushed on Stack
	}
	else if (addressFormat == AddressFormat::BECH32) {
		coinbase.push_back(scriptPubKey.size() + 2); // Output Length
		coinbase.push_back(0x00); // OP_0
		coinbase.push_back(scriptPubKey.size()); // Script Length
	}
	else {
		coinbase.push_back(scriptPubKey.size() + 5); // Output Length
		coinbase.push_back(0x76); // OP_DUP
		coinbase.push_back(0xA9); // OP_HASH160
		coinbase.push_back(0x14); // Bytes Pushed on Stack
	}
	// ScriptPubKey (for payout address)
	for (uint32_t i(0) ; i < scriptPubKey.size() ; i++) coinbase.push_back(scriptPubKey[i]);
	if (addressFormat == AddressFormat::P2SH)
		coinbase.push_back(0x87); // OP_EQUAL
	else if (addressFormat == AddressFormat::P2PKH) {
		coinbase.push_back(0x88); // OP_EQUALVERIFY
		coinbase.push_back(0xAC); // OP_CHECKSIG
	}
	
	// Donation output
	if (donation != 0) {
		// Output Value
		for (uint32_t i(0) ; i < 8 ; i++) {
			coinbase.push_back(donation % 256);
			donation /= 256;
		}
		coinbase.push_back(25);
		coinbase.push_back(0x76);
		coinbase.push_back(0xA9);
		coinbase.push_back(0x14);
		for (uint32_t i(0) ; i < 20 ; i++) coinbase.push_back(scriptPubKeyDon[i]);
		coinbase.push_back(0x88);
		coinbase.push_back(0xAC);
	}
	
	// SegWit specifics (dummy output, witness)
	if (dwc.size() > 0) {
		for (uint32_t i(0) ; i < 8 ; i++) coinbase.push_back(0x00); // No reward
		coinbase.push_back(dwc.size()); // Output Length
		// default_witness_commitment from GetBlockTemplate
		for (uint32_t i(0) ; i < dwc.size() ; i++) coinbase.push_back(dwc[i]);
		
		coinbase.push_back(1); // Number of Witnesses/stack items
		coinbase.push_back(32); // Witness Length
		// Witness of the Coinbase Input
		for (uint32_t i(0) ; i < 32 ; i++) coinbase.push_back(0x00);
	}
	
	// Lock Time (00000000)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0);
}

bool GBTClient::_getWork() {
	const std::vector<std::string> rules(_manager->options().rules());
	std::string req;
	if (rules.size() == 0) req = "{\"method\": \"getblocktemplate\", \"params\": [], \"id\": 0}\n";
	else {
		std::ostringstream oss;
		oss << "{\"method\": \"getblocktemplate\", \"params\": [{\"rules\":[";
		for (uint32_t i(0) ; i < rules.size() ; i++) {
			oss << "\"" << rules[i] << "\"";
			if (i < rules.size() - 1) oss << ", ";
		}
		oss << "]}], \"id\": 0}\n";
		req = oss.str();
	}
	
	json_t *jsonGbt(sendRPCCall(req.c_str())),
	       *jsonGbt_Res(json_object_get(jsonGbt, "result")),
	       *jsonGbt_Res_Txs(json_object_get(jsonGbt_Res, "transactions")),
	       *jsonGbt_Res_Rules(json_object_get(jsonGbt_Res, "rules")),
	       *jsonGbt_Res_Dwc(json_object_get(jsonGbt_Res, "default_witness_commitment"));
	
	// Failure to GetBlockTemplate
	if (jsonGbt == NULL || jsonGbt_Res == NULL || jsonGbt_Res_Txs == NULL) {
		_gbtd = GetBlockTemplateData();
		return false;
	}
	
	const uint32_t oldHeight(_gbtd.height);
	uint8_t bitsTmp[4];
	hexStrToBin(json_string_value(json_object_get(jsonGbt_Res, "bits")), bitsTmp);
	_gbtd.bh = BlockHeader();
	_gbtd.transactions = std::string();
	_gbtd.rules = std::vector<std::string>();
	_gbtd.txHashes = std::vector<std::array<uint8_t, 32>>();
	_gbtd.default_witness_commitment = std::string();
	
	// Extract and build GetBlockTemplate data
	_gbtd.bh.version = json_integer_value(json_object_get(jsonGbt_Res, "version"));
	hexStrToBin(json_string_value(json_object_get(jsonGbt_Res, "previousblockhash")), (uint8_t*) &_gbtd.bh.previousblockhash);
	_gbtd.height = json_integer_value(json_object_get(jsonGbt_Res, "height"));
	_gbtd.coinbasevalue = json_integer_value(json_object_get(jsonGbt_Res, "coinbasevalue"));
	_gbtd.bh.bits = ((uint32_t*) &bitsTmp)[0];
	_gbtd.bh.curtime = json_integer_value(json_object_get(jsonGbt_Res, "curtime"));
	
	for (uint32_t i(0) ; i < json_array_size(jsonGbt_Res_Rules) ; i++)
		_gbtd.rules.push_back(json_string_value(json_array_get(jsonGbt_Res_Rules, i)));
	if (jsonGbt_Res_Dwc != NULL)
		_gbtd.default_witness_commitment = json_string_value(jsonGbt_Res_Dwc);
	
	_gbtd.transactions += binToHexStr(_gbtd.coinbase.data(), _gbtd.coinbase.size());
	for (uint32_t i(0) ; i < json_array_size(jsonGbt_Res_Txs) ; i++) {
		std::vector<uint8_t> txHash;
		if (_gbtd.isActive("segwit"))
			txHash = reverse(hexStrToV8(json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "txid"))));
		else
			txHash = reverse(hexStrToV8(json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "hash"))));
		_gbtd.transactions += json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "data"));
		_gbtd.txHashes.push_back(v8ToA8(txHash));
	}
	
	// Notify when the network found a block
	const uint64_t difficulty(getCompact(invEnd32(_gbtd.bh.bits)));
	if (_manager->difficulty() != difficulty) _manager->updateDifficulty(difficulty, _gbtd.height);
	if (oldHeight != _gbtd.height && oldHeight != 0) _manager->newHeightMessage(_gbtd.height);
	
	json_decref(jsonGbt);
	
	return true;
}

bool GBTClient::connect() {
	if (_connected) return false;
	if (_inited) {
		if (!_getWork()) return false;
		_gbtd = GetBlockTemplateData();
		if (addrToScriptPubKey(_manager->options().payoutAddress(), _gbtd.scriptPubKey, false));
		else if (bech32ToScriptPubKey(_manager->options().payoutAddress(), _gbtd.scriptPubKey, false));
		else {
			std::cerr << "Invalid payout address! Using donation address instead." << std::endl;
			addrToScriptPubKey("RPttnMeDWkzjqqVp62SdG2ExtCor9w54EB", _gbtd.scriptPubKey);
		}
		_pendingSubmissions = std::vector<WorkData>();
		_connected = true;
		return true;
	}
	else {
		std::cout << "Cannot connect because the client was not inited!" << std::endl;
		return false;
	}
}

void GBTClient::sendWork(const WorkData &work) const {
	std::ostringstream oss;
	std::string req;
	
	oss << "{\"method\": \"submitblock\", \"params\": [\"" << binToHexStr(&work.bh, 112);
	// Using the Variable Length Integer format
	if (work.txCount < 0xFD)
		oss << binToHexStr((uint8_t*) &work.txCount, 1);
	else // Having more than 65535 transactions is currently impossible
		oss << "fd" << binToHexStr((uint8_t*) &work.txCount, 2);
	oss << work.transactions << "\"], \"id\": 0}\n";
	req = oss.str();
	
	_manager->printTime();
	std::cout << " " << work.primes << "-tuple found";
	json_t *jsonSb(sendRPCCall(req)); // SubmitBlock response
	if (work.primes < _gbtd.primes) std::cout << std::endl;
	else {
		std::cout << ", this is a block!" << std::endl;
		std::cout << "Base prime: " << work.bh.decodeSolution() << std::endl;
		DBG(std::cout << "Sent: " << req;);
		if (jsonSb == NULL) std::cerr << "Failure submiting block :|" << std::endl;
		else {
			json_t *jsonSb_Res(json_object_get(jsonSb, "result")),
			       *jsonSb_Err(json_object_get(jsonSb, "error"));
			if (json_is_null(jsonSb_Res) && json_is_null(jsonSb_Err)) std::cout << "Submission accepted :D !" << std::endl;
			else std::cout << "Submission rejected :| ! Received: " << json_dumps(jsonSb, JSON_COMPACT) << std::endl;
		}
	}
	if (jsonSb != NULL) json_decref(jsonSb);
}

WorkData GBTClient::workData() const {
	GetBlockTemplateData gbtd(_gbtd);
	gbtd.coinBaseGen(_manager->options().payoutAddressFormat(), _manager->options().secret(), _manager->options().donate());
	gbtd.transactions = binToHexStr(gbtd.coinbase.data(), gbtd.coinbase.size()) + gbtd.transactions;
	gbtd.txHashes.insert(gbtd.txHashes.begin(), gbtd.coinBaseHash());
	gbtd.merkleRootGen();
	
	WorkData wd;
	memcpy(&wd.bh, &gbtd.bh, 128);
	wd.height = gbtd.height;
	wd.bh.bits       = invEnd32(wd.bh.bits);
	wd.targetCompact = getCompact(wd.bh.bits);
	wd.transactions  = gbtd.transactions;
	wd.txCount       = gbtd.txHashes.size();
	// Change endianness for mining (will revert back when submit share)
	for (uint8_t i(0) ; i < 32; i++) wd.bh.previousblockhash[i] = gbtd.bh.previousblockhash[31 - i];
	return wd;
}
