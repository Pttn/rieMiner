// (c) 2018-2020 Pttn (https://github.com/Pttn/rieMiner)

#include "GBTClient.hpp"
#include "main.hpp"

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
	coinbase.push_back(scriptSig.size()); // Block Height Push Size (1-4 added later) + scriptSig.size()
	if (height < 17) {
		coinbase.back()++;
		coinbase.push_back(80 + height);
	}
	else if (height < 128) {
		coinbase.back() += 2;
		coinbase.push_back(1);
		coinbase.push_back(height);
	}
	else if (height < 32768) {
		coinbase.back() += 3;
		coinbase.push_back(2);
		coinbase.push_back(height % 256);
		coinbase.push_back((height/256) % 256);
	}
	else {
		coinbase.back() += 4;
		coinbase.push_back(3);
		coinbase.push_back(height % 256);
		coinbase.push_back((height/256) % 256);
		coinbase.push_back((height/65536) % 256);
	}
	// ScriptSig
	for (uint32_t i(0) ; i < scriptSig.size() ; i++) coinbase.push_back(scriptSig[i]);
	// Input Sequence (FFFFFFFF)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0xFF);
	
	std::vector<uint8_t> scriptPubKeyDon(hexStrToV8("0ad73a70fc2d7cf174f5b2ea47fc42a8bff16ea1"));
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
	coinbase.insert(coinbase.end(), scriptPubKey.begin(), scriptPubKey.end());
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
		coinbase.push_back(scriptPubKeyDon.size() + 2); // Output Length
		coinbase.push_back(0x00); // OP_0
		coinbase.push_back(scriptPubKeyDon.size()); // Script Length
		coinbase.insert(coinbase.end(), scriptPubKeyDon.begin(), scriptPubKeyDon.end());
	}
	
	// SegWit specifics (dummy output, witness)
	if (dwc.size() > 0) {
		for (uint32_t i(0) ; i < 8 ; i++) coinbase.push_back(0x00); // No reward
		coinbase.push_back(dwc.size()); // Output Length
		// default_witness_commitment from GetBlockTemplate
		coinbase.insert(coinbase.end(), dwc.begin(), dwc.end());
		
		coinbase.push_back(1); // Number of Witnesses/stack items
		coinbase.push_back(32); // Witness Length
		// Witness of the Coinbase Input
		for (uint32_t i(0) ; i < 32 ; i++) coinbase.push_back(0x00);
	}
	
	// Lock Time (00000000)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0);
}

std::string GBTClient::_getUserPass() const {
	std::ostringstream oss;
	oss << _options->username() << ":" << _options->password();
	return oss.str();
}

std::string GBTClient::_getHostPort() const {
	std::ostringstream oss;
	oss << "http://" << _options->host() << ":" << _options->port() << "/";
	return oss.str();
}

static size_t curlWriteCallback(void *data, size_t size, size_t nmemb, std::string *s) {
	s->append((char*) data, size*nmemb);
	return size*nmemb;
}

json_t* GBTClient::sendRPCCall(const std::string& req) const {
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

bool GBTClient::_getWork() {
	const std::vector<std::string> rules(_options->rules());
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
	       *jsonGbt_Res_Dwc(json_object_get(jsonGbt_Res, "default_witness_commitment")),
	       *jsonGbt_Res_Constellations(json_object_get(jsonGbt_Res, "constellations"));
	
	// Failure to GetBlockTemplate (or invalid response)
	if (jsonGbt == NULL || jsonGbt_Res == NULL || jsonGbt_Res_Txs == NULL || jsonGbt_Res_Rules == NULL || json_array_size(jsonGbt_Res_Constellations) == 0) {
		_gbtd = GetBlockTemplateData();
		std::cerr << "Invalid GetBlockTemplate response!" << std::endl;
		if (jsonGbt != NULL) json_decref(jsonGbt);
		return false;
	}
	
	uint8_t bitsTmp[4];
	hexStrToBin(json_string_value(json_object_get(jsonGbt_Res, "bits")), bitsTmp);
	_gbtd.bh = BlockHeader();
	_gbtd.transactions = std::string();
	_gbtd.rules = std::vector<std::string>();
	_gbtd.txHashes = std::vector<std::array<uint8_t, 32>>();
	_gbtd.default_witness_commitment = std::string();
	
	// Extract and build GetBlockTemplate data
	_gbtd.bh.version = json_integer_value(json_object_get(jsonGbt_Res, "version"));
	uint8_t previousblockhashTmp[32];
	hexStrToBin(json_string_value(json_object_get(jsonGbt_Res, "previousblockhash")), previousblockhashTmp);
	for (uint8_t i(0) ; i < 32; i++) _gbtd.bh.previousblockhash[i] = previousblockhashTmp[31 - i];
	_gbtd.coinbasevalue = json_integer_value(json_object_get(jsonGbt_Res, "coinbasevalue"));
	_gbtd.bh.curtime = json_integer_value(json_object_get(jsonGbt_Res, "curtime"));
	_gbtd.bh.bits = invEnd32(reinterpret_cast<uint32_t*>(&bitsTmp)[0]);
	_gbtd.height = json_integer_value(json_object_get(jsonGbt_Res, "height"));
	
	_gbtd.acceptedConstellationTypes = std::vector<std::vector<uint64_t>>();
	for (uint16_t i(0) ; i < json_array_size(jsonGbt_Res_Constellations) ; i++) {
		std::vector<uint64_t> acceptedConstellationType;
		if (json_array_size(json_array_get(jsonGbt_Res_Constellations, i)) == 0) {
			json_decref(jsonGbt);
			return false;
		}
		json_t *json_Constellation(json_array_get(jsonGbt_Res_Constellations, i));
		for (uint16_t j(0) ; j < json_array_size(json_Constellation) ; j++)
			acceptedConstellationType.push_back(json_integer_value(json_array_get(json_Constellation, j)));
		_gbtd.acceptedConstellationTypes.push_back(acceptedConstellationType);
	}
	if (!_gbtd.acceptsConstellationType(_options->constellationType())) {
		std::cerr << "The network does not support the miner's constellation type! Accepted constellation types(s):" << std::endl;
		for (uint16_t i(0) ; i < _gbtd.acceptedConstellationTypes.size() ; i++) {
			std::cout << " " << i << " - ";
			for (uint16_t j(0) ; j < _gbtd.acceptedConstellationTypes[i].size() ; j++) {
				std::cout << _gbtd.acceptedConstellationTypes[i][j];
				if (j != _gbtd.acceptedConstellationTypes[i].size() - 1) std::cout << ", ";
			}
			std::cout << std::endl;
		}
		json_decref(jsonGbt);
		return false;
	}
	_gbtd.constellationSize = _gbtd.acceptedConstellationTypes[0].size();
	
	if (jsonGbt_Res_Dwc != NULL)
		_gbtd.default_witness_commitment = json_string_value(jsonGbt_Res_Dwc);
	
	for (uint32_t i(0) ; i < json_array_size(jsonGbt_Res_Rules) ; i++)
		_gbtd.rules.push_back(json_string_value(json_array_get(jsonGbt_Res_Rules, i)));
	if (jsonGbt_Res_Dwc != NULL)
		_gbtd.default_witness_commitment = json_string_value(jsonGbt_Res_Dwc);
	
	_gbtd.transactions += binToHexStr(_gbtd.coinbase.data(), _gbtd.coinbase.size());
	for (uint32_t i(0) ; i < json_array_size(jsonGbt_Res_Txs) ; i++) {
		std::vector<uint8_t> txHash;
		if (_gbtd.isActive("!segwit"))
			txHash = reverse(hexStrToV8(json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "txid"))));
		else
			txHash = reverse(hexStrToV8(json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "hash"))));
		_gbtd.transactions += json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "data"));
		_gbtd.txHashes.push_back(v8ToA8(txHash));
	}
	json_decref(jsonGbt);
	return true;
}

bool GBTClient::connect() {
	if (_connected) return false;
	if (_inited) {
		if (!_getWork()) return false;
		_gbtd = GetBlockTemplateData();
		if (addrToScriptPubKey(_options->payoutAddress(), _gbtd.scriptPubKey, false));
		else if (bech32ToScriptPubKey(_options->payoutAddress(), _gbtd.scriptPubKey, false));
		else {
			std::cout << "Invalid payout address! Using donation address instead." << std::endl;
			addrToScriptPubKey("ric1qpttn5u8u9470za84kt4y0lzz4zllzm4pyzhuge", _gbtd.scriptPubKey);
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
	std::cout << "Submitting block with " << work.txCount << " transaction(s) (including coinbase)..." << std::endl;
	std::ostringstream oss;
	std::string req;
	
	BlockHeader bh(work.bh);
	mpz_class offset(work.result - work.target);
	for (uint32_t d(0) ; d < std::min(32/static_cast<uint32_t>(sizeof(mp_limb_t)), static_cast<uint32_t>(offset.get_mpz_t()->_mp_size)) ; d++)
		*reinterpret_cast<mp_limb_t*>(bh.nOffset + d*sizeof(mp_limb_t)) = offset.get_mpz_t()->_mp_d[d];
	oss << "{\"method\": \"submitblock\", \"params\": [\"" << v8ToHexStr(bh.toV8());
	// Using the Variable Length Integer format
	if (work.txCount < 0xFD)
		oss << binToHexStr((uint8_t*) &work.txCount, 1);
	else // Having more than 65535 transactions is currently impossible
		oss << "fd" << binToHexStr((uint8_t*) &work.txCount, 2);
	oss << work.transactions << "\"], \"id\": 0}\n";
	req = oss.str();
	
	json_t *jsonSb(sendRPCCall(req)); // SubmitBlock response
	DBG(std::cout << "Decoded solution: " << bh.decodeSolution() << std::endl;);
	DBG(std::cout << "Sent: " << req;);
	if (jsonSb == NULL) std::cerr << "Failure submitting block :|" << std::endl;
	else {
		json_t *jsonSb_Res(json_object_get(jsonSb, "result")),
			    *jsonSb_Err(json_object_get(jsonSb, "error"));
		if (json_is_null(jsonSb_Res) && json_is_null(jsonSb_Err)) std::cout << "Submission accepted :D !" << std::endl;
		else std::cout << "Submission rejected :| ! Received: " << json_dumps(jsonSb, JSON_COMPACT) << std::endl;
	}
	if (jsonSb != NULL) json_decref(jsonSb);
}

WorkData GBTClient::workData() const {
	GetBlockTemplateData gbtd(_gbtd);
	gbtd.coinBaseGen(_options->payoutAddressFormat(), _options->secret(), _options->donate());
	gbtd.transactions = binToHexStr(gbtd.coinbase.data(), gbtd.coinbase.size()) + gbtd.transactions;
	gbtd.txHashes.insert(gbtd.txHashes.begin(), gbtd.coinBaseHash());
	gbtd.merkleRootGen();
	
	WorkData wd;
	wd.bh           = gbtd.bh;
	wd.height       = gbtd.height;
	wd.difficulty   = decodeCompact(wd.bh.bits);
	wd.target       = wd.bh.target();
	wd.transactions = gbtd.transactions;
	wd.txCount      = gbtd.txHashes.size();
	return wd;
}
