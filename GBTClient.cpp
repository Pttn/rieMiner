// (c) 2018-2021 Pttn (https://github.com/Pttn/rieMiner)

#include "GBTClient.hpp"
#include "main.hpp"

std::array<uint8_t, 32> calculateMerkleRoot(const std::vector<std::array<uint8_t, 32>> &txHashes) {
	std::array<uint8_t, 32> merkleRoot{};
	if (txHashes.size() == 0)
		ERRORMSG("No transaction to hash");
	else if (txHashes.size() == 1)
		return txHashes[0];
	else {
		std::vector<std::array<uint8_t, 32>> txHashes2;
		for (uint32_t i(0) ; i < txHashes.size() ; i += 2) {
			std::array<uint8_t, 64> concat;
			std::copy(txHashes[i].begin(), txHashes[i].end(), concat.begin());
			if (i == txHashes.size() - 1) // Concatenation of the last element with itself for an odd number of transactions
				std::copy(txHashes[i].begin(), txHashes[i].end(), concat.begin() + 32);
			else
				std::copy(txHashes[i + 1].begin(), txHashes[i + 1].end(), concat.begin() + 32);
			txHashes2.push_back(sha256sha256(concat.data(), 64));
		}
		// Process the next step
		merkleRoot = calculateMerkleRoot(txHashes2);
	}
	return merkleRoot;
}

void GetBlockTemplateData::coinBaseGen(const std::vector<uint8_t> &scriptPubKey, const std::string &cbMsg, uint16_t donationPercent) {
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
	
	const std::vector<uint8_t> scriptPubKeyDon(hexStrToV8("00140ad73a70fc2d7cf174f5b2ea47fc42a8bff16ea1"));
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
	
	coinbase.push_back(scriptPubKey.size()); // Output/ScriptPubKey Length
	coinbase.insert(coinbase.end(), scriptPubKey.begin(), scriptPubKey.end()); // ScriptPubKey (for payout address)
	if (donation != 0) { // Donation output
		for (uint32_t i(0) ; i < 8 ; i++) { // Output Value
			coinbase.push_back(donation % 256);
			donation /= 256;
		}
		coinbase.push_back(scriptPubKeyDon.size());
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

std::array<uint8_t, 32> GetBlockTemplateData::coinbaseTxId() const {
	std::vector<uint8_t> coinbase2;
	for (uint32_t i(0) ; i < 4 ; i++) coinbase2.push_back(coinbase[i]); // nVersion
	for (uint32_t i(6) ; i < coinbase.size() - 38 ; i++) coinbase2.push_back(coinbase[i]); // txins . txouts
	for (uint32_t i(coinbase.size() - 4) ; i < coinbase.size() ; i++) coinbase2.push_back(coinbase[i]); // nLockTime
	return sha256sha256(coinbase2.data(), coinbase2.size());
}

static size_t curlWriteCallback(void *data, size_t size, size_t nmemb, std::string *s) {
	s->append((char*) data, size*nmemb);
	return size*nmemb;
}
json_t* GBTClient::_sendRPCCall(const std::string& req) const {
	std::string s;
	json_t *jsonObj(nullptr);
	if (_curl) {
		json_error_t err;
		curl_easy_setopt(_curl, CURLOPT_URL, _url.c_str());
		curl_easy_setopt(_curl, CURLOPT_POSTFIELDSIZE, (long) strlen(req.c_str()));
		curl_easy_setopt(_curl, CURLOPT_POSTFIELDS, req.c_str());
		curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, curlWriteCallback);
		curl_easy_setopt(_curl, CURLOPT_WRITEDATA, &s);
		curl_easy_setopt(_curl, CURLOPT_USERPWD, _credentials.c_str());
		curl_easy_setopt(_curl, CURLOPT_TIMEOUT, 10);
		const CURLcode cc(curl_easy_perform(_curl));
		if (cc != CURLE_OK)
			ERRORMSG("Curl_easy_perform() failed: " << curl_easy_strerror(cc));
		else {
			jsonObj = json_loads(s.c_str(), 0, &err);
			if (jsonObj == nullptr)
				ERRORMSG("JSON decoding failed: " << err.text);
		}
	}
	return jsonObj;
}

bool GBTClient::_fetchWork() {
	std::lock_guard<std::mutex> lock(_workMutex);
	std::string req;
	if (_rules.size() == 0) req = "{\"method\": \"getblocktemplate\", \"params\": [], \"id\": 0}\n";
	else {
		std::ostringstream oss;
		oss << "{\"method\": \"getblocktemplate\", \"params\": [{\"rules\":[";
		for (uint32_t i(0) ; i < _rules.size() ; i++) {
			oss << "\"" << _rules[i] << "\"";
			if (i < _rules.size() - 1) oss << ", ";
		}
		oss << "]}], \"id\": 0}\n";
		req = oss.str();
	}
	
	json_t *jsonGbt(_sendRPCCall(req.c_str())),
	       *jsonGbt_Res(json_object_get(jsonGbt, "result")),
	       *jsonGbt_Res_Txs(json_object_get(jsonGbt_Res, "transactions")),
	       *jsonGbt_Res_Rules(json_object_get(jsonGbt_Res, "rules")),
	       *jsonGbt_Res_Dwc(json_object_get(jsonGbt_Res, "default_witness_commitment")),
	       *jsonGbt_Res_Patterns(json_object_get(jsonGbt_Res, "patterns"));
	
	// Failure to GetBlockTemplate (or invalid response)
	if (jsonGbt == nullptr || jsonGbt_Res == nullptr || jsonGbt_Res_Txs == nullptr || jsonGbt_Res_Rules == nullptr || jsonGbt_Res_Dwc == nullptr || json_array_size(jsonGbt_Res_Patterns) == 0) {
		std::cout << __func__ << ": invalid GetBlockTemplate response! Ensure that you use Riecoin Core 0.20+ and that it is properly configured and synced!" << std::endl;
		if (jsonGbt != nullptr) json_decref(jsonGbt);
		return false;
	}
	
	_gbtd.bh = BlockHeader();
	_gbtd.transactions = std::string();
	_gbtd.txHashes = std::vector<std::array<uint8_t, 32>>();
	_gbtd.default_witness_commitment = std::string();
	
	// Extract and build GetBlockTemplate data
	_gbtd.bh.version = json_integer_value(json_object_get(jsonGbt_Res, "version"));
	_gbtd.bh.previousblockhash = v8ToA8(reverse(hexStrToV8(json_string_value(json_object_get(jsonGbt_Res, "previousblockhash")))));
	
	_gbtd.coinbasevalue = json_integer_value(json_object_get(jsonGbt_Res, "coinbasevalue"));
	_gbtd.bh.curtime = json_integer_value(json_object_get(jsonGbt_Res, "curtime"));
	_gbtd.bh.bits = std::stoll(json_string_value(json_object_get(jsonGbt_Res, "bits")), nullptr, 16);
	_gbtd.height = json_integer_value(json_object_get(jsonGbt_Res, "height"));
	
	_info.powVersion = json_integer_value(json_object_get(jsonGbt_Res, "powversion"));
	if (_info.powVersion != -1 && _info.powVersion != 1) {
		std::cout << __func__ << ": invalid PoW Version " << _info.powVersion << "!" << std::endl;
		json_decref(jsonGbt);
		return false;
	}
	_info.acceptedPatterns = Client::extractAcceptedPatterns(jsonGbt_Res_Patterns);
	if (_info.acceptedPatterns.size() == 0) {
		std::cout << __func__ << ": empty or invalid accepted patterns list!" << std::endl;
		json_decref(jsonGbt);
		return false;
	}
	
	_gbtd.default_witness_commitment = json_string_value(jsonGbt_Res_Dwc);
	_gbtd.transactions += v8ToHexStr(_gbtd.coinbase);
	for (uint32_t i(0) ; i < json_array_size(jsonGbt_Res_Txs) ; i++) {
		const std::vector<uint8_t> txHash(reverse(hexStrToV8(json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "txid")))));
		_gbtd.transactions += json_string_value(json_object_get(json_array_get(jsonGbt_Res_Txs, i), "data"));
		_gbtd.txHashes.push_back(v8ToA8(txHash));
	}
	json_decref(jsonGbt);
	return true;
}

void GBTClient::_submit(const Job& job) {
	std::cout << "Submitting block with " << job.txCount << " transaction(s) (including coinbase)..." << std::endl;
	std::ostringstream oss;
	std::string req;
	
	BlockHeader bh(job.bh);
	bh.nOffset = job.encodedOffset();
	oss << "{\"method\": \"submitblock\", \"params\": [\"" << v8ToHexStr(bh.toV8());
	// Using the Variable Length Integer format
	if (job.txCount < 0xFD)
		oss << std::setfill('0') << std::setw(2) << std::hex << job.txCount;
	else // Having more than 65535 transactions is currently impossible
		oss << "fd" << std::setfill('0') << std::setw(2) << std::hex << job.txCount % 256 << std::setw(2) << job.txCount/256;
	oss << job.transactions << "\"], \"id\": 0}\n";
	req = oss.str();
	
	DBG(std::cout << "Sending: " << req;);
	json_t *jsonSb(_sendRPCCall(req)); // SubmitBlock response
	if (jsonSb == nullptr) ERRORMSG("Failure submitting block");
	else {
		json_t *jsonSb_Res(json_object_get(jsonSb, "result")),
			    *jsonSb_Err(json_object_get(jsonSb, "error"));
		if (json_is_null(jsonSb_Res) && json_is_null(jsonSb_Err)) std::cout << "Submission accepted :D !" << std::endl;
		else std::cout << "Submission rejected :| ! Received: " << json_dumps(jsonSb, JSON_COMPACT) << std::endl;
	}
	if (jsonSb != nullptr) json_decref(jsonSb);
}

void GBTClient::process() {
	// Process pending submissions
	_submitMutex.lock();
	if (_pendingSubmissions.size() > 0) {
		for (const auto &submission : _pendingSubmissions) _submit(submission);
		_pendingSubmissions.clear();
	}
	_submitMutex.unlock();
	// Update work
	if (!_fetchWork()) _connected = false; // If _fetchWork() failed, this means that the client is disconnected
}

void GBTClient::connect() {
	if (!_connected) {
		_gbtd = GetBlockTemplateData();
		_pendingSubmissions = std::vector<Job>();
		_info = info();
		if (_info.powVersion != 0)
			_connected = true;
	}
}

NetworkInfo GBTClient::info() {
	const std::chrono::time_point<std::chrono::steady_clock> timeOutTimer(std::chrono::steady_clock::now());
	while (_info.powVersion == 0) { // Poll until valid work data is generated, with 0.5 s time out
		_fetchWork();
		if (timeSince(timeOutTimer) > 0.5) {
			std::cout << "Unable to get mining data from the server :| !" << std::endl;
			std::cout << "================================================================" << std::endl;
			std::cout << "There is certainly a problem with your configuration files " << confPath << " or riecoin.conf." << std::endl;
			std::cout << "Be sure to have carefully read the Solo Mining guide" << std::endl;
			std::cout << "\thttps://riecoin.dev/en/rieMiner/Solo_Mining" << std::endl;
			std::cout << "and also check the following hints before asking for help!" << std::endl;
			std::cout << "Check that Riecoin Core is running, connected and synced." << std::endl;
			std::cout << "Common riecoin.conf issues:" << std::endl;
			std::cout << "\tMissing 'rpcuser=...' or 'rpcpassword=...'" << std::endl;
			std::cout << "\tNot configured as server with 'server=1'" << std::endl;
			if (_host != "127.0.0.1") {
				std::cout << "\tYour miner's IP was not allowed with 'rpcallowip=...'" << std::endl;
				std::cout << "\tYou may need to add 'rpcbind=" << _host << "' (IP of the node)" << std::endl;
			}
			std::cout << "Common " << confPath << " issues:" << std::endl;
			std::cout << "\tWrong syntax (lines are in the form 'Key = Value', no ':', no ';', etc.)" << std::endl;
			std::cout << "\tMaybe you meant to do pooled mining? In this case use 'Mode = Pool'" << std::endl;
			std::cout << "\tWrong Username/Password (must be the same as the rpcuser/rpcpassword)" << std::endl;
			std::cout << "If you still have problems, you can ask for help on the Riecoin discussion channels, but please give detailed infos! What you tried to do, your configuration files, don't just say that you have trouble connecting or are getting an error!" << std::endl;
			std::cout << "Also do not open a GitHub issue about this!" << std::endl;
			std::cout << "================================================================" << std::endl;
			_connected = false;
			return {0, {}};
		}
		std::this_thread::sleep_for(std::chrono::milliseconds(50));
	}
	return _info;
}

bool GBTClient::getJob(Job& job, const bool) {
	std::lock_guard<std::mutex> lock(_workMutex);
	GetBlockTemplateData gbtd(_gbtd);
	gbtd.coinBaseGen(_scriptPubKey, _coinbaseMessage, _donate);
	gbtd.transactions = v8ToHexStr(gbtd.coinbase) + gbtd.transactions;
	gbtd.txHashes.insert(gbtd.txHashes.begin(), gbtd.coinbaseTxId());
	gbtd.merkleRootGen();
	
	job.bh               = gbtd.bh;
	job.height           = gbtd.height;
	job.powVersion       = _info.powVersion;
	job.difficulty       = decodeBits(job.bh.bits, job.powVersion);
	job.primeCountTarget = _info.acceptedPatterns.size() != 0 ? _info.acceptedPatterns[0].size() : 1;
	job.primeCountMin    = job.primeCountTarget;
	job.target           = job.bh.target(job.powVersion);
	job.transactions     = gbtd.transactions;
	job.txCount          = gbtd.txHashes.size();
	return job.height != 0;
}
