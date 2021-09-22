// (c) 2018-2021 Pttn (https://riecoin.dev/en/rieMiner)

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
	coinbase = {};
	const std::vector<uint8_t> dwc(hexStrToV8(default_witness_commitment)); // for SegWit
	// Version (01000000)
	coinbase.insert(coinbase.end(), {0x01, 0x00, 0x00, 0x00});
	// Marker (00) and Flag (01) for SegWit
	if (dwc.size() > 0)
		coinbase.insert(coinbase.end(), {0x00, 0x01});
	// Input Count (01)
	coinbase.push_back(1);
	// Input TXID (0000000000000000000000000000000000000000000000000000000000000000)
	for (uint32_t i(0) ; i < 32 ; i++) coinbase.push_back(0x00);
	// Input VOUT (FFFFFFFF)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0xFF);
	// (ScriptSig Construction)
		std::vector<uint8_t> scriptSig;
		// Block Height (Bip 34)
		if (height < 17)
			scriptSig.push_back(80 + height);
		else if (height < 128) {
			scriptSig.push_back(1);
			scriptSig.push_back(height);
		}
		else if (height < 32768) {
			scriptSig.push_back(2);
			scriptSig.push_back(height % 256);
			scriptSig.push_back((height/256) % 256);
		}
		else {
			scriptSig.push_back(3);
			scriptSig.push_back(height % 256);
			scriptSig.push_back((height/256) % 256);
			scriptSig.push_back((height/65536) % 256);
		}
		// Secret Message
		for (uint32_t i(0) ; i < cbMsg.size() ; i++) scriptSig.push_back(cbMsg[i]);
		// Randomization to avoid having 2 threads working on the same problem
		for (uint32_t i(0) ; i < 4 ; i++) scriptSig.push_back(rand(0x00, 0xFF));
	// ScriptSig Size
	coinbase.push_back(scriptSig.size());
	// ScriptSig
	coinbase.insert(coinbase.end(), scriptSig.begin(), scriptSig.end());
	// Input Sequence (FFFFFFFF)
	for (uint32_t i(0) ; i < 4 ; i++) coinbase.push_back(0xFF);
	const std::vector<uint8_t> scriptPubKeyDon(hexStrToV8("00141c486c58cbffbfdc317c15c6d1ac7f133e46f679"));
	uint64_t donation(donationPercent*coinbasevalue/100);
	if (scriptPubKey == scriptPubKeyDon) donation = 0;
	uint64_t reward(coinbasevalue - donation);
	// Output Count
	coinbase.push_back(donation == 0 ? 1 : 2);
	if (dwc.size() > 0) coinbase.back()++; // Dummy Output for SegWit
	// Output Value
	for (uint32_t i(0) ; i < 8 ; i++) {
		coinbase.push_back(reward % 256);
		reward /= 256;
	}
	// Output/ScriptPubKey Length
	coinbase.push_back(scriptPubKey.size());
	// ScriptPubKey (for the payout address)
	coinbase.insert(coinbase.end(), scriptPubKey.begin(), scriptPubKey.end());
	// Donation output
	if (donation != 0) {
		for (uint32_t i(0) ; i < 8 ; i++) { // Output Value
			coinbase.push_back(donation % 256);
			donation /= 256;
		}
		coinbase.push_back(scriptPubKeyDon.size());
		coinbase.insert(coinbase.end(), scriptPubKeyDon.begin(), scriptPubKeyDon.end());
	}
	// Dummy output and witness for SegWit
	if (dwc.size() > 0) {
		for (uint32_t i(0) ; i < 8 ; i++) coinbase.push_back(0); // No reward
		coinbase.push_back(dwc.size()); // Output Length
		coinbase.insert(coinbase.end(), dwc.begin(), dwc.end()); // Default Witness Commitment
		coinbase.push_back(1); // Number of Witnesses/stack items
		coinbase.push_back(32); // Witness Length
		for (uint32_t i(0) ; i < 32 ; i++) coinbase.push_back(0x00); // Witness of the Coinbase Input (0000000000000000000000000000000000000000000000000000000000000000)
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
nlohmann::json GBTClient::_sendRequestToWallet(const std::string &method, const nlohmann::json &params) const {
	static uint64_t id(0ULL);
	nlohmann::json jsonObj;
	if (_curl) {
		std::string s;
		const nlohmann::json request{{"method", method}, {"params", params}, {"id", id++}};
		const std::string requestStr(request.dump());
		curl_easy_setopt(_curl, CURLOPT_URL, _url.c_str());
		curl_easy_setopt(_curl, CURLOPT_POSTFIELDSIZE, requestStr.size());
		curl_easy_setopt(_curl, CURLOPT_POSTFIELDS, requestStr.c_str());
		curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, curlWriteCallback);
		curl_easy_setopt(_curl, CURLOPT_WRITEDATA, &s);
		curl_easy_setopt(_curl, CURLOPT_USERPWD, _credentials.c_str());
		curl_easy_setopt(_curl, CURLOPT_TIMEOUT, 10);
		const CURLcode cc(curl_easy_perform(_curl));
		if (cc != CURLE_OK)
			ERRORMSG("Curl_easy_perform() failed: " << curl_easy_strerror(cc));
		else {
			try {jsonObj = nlohmann::json::parse(s);}
			catch (nlohmann::json::parse_error &e) {ERRORMSG("Bad JSON object received: " << e.what());}
		}
	}
	return jsonObj;
}

bool GBTClient::_fetchWork() {
	std::lock_guard<std::mutex> lock(_workMutex);
	nlohmann::json getblocktemplate;
	try {
		getblocktemplate = _sendRequestToWallet("getblocktemplate", {{{"rules", _rules}}})["result"];
	}
	catch (std::exception &e) {
		std::cout << __func__ << ": Could not get GetBlockTemplate Data - " << e.what() << std::endl;
		return false;
	}
	_gbtd.bh = BlockHeader();
	_gbtd.transactions = std::string();
	_gbtd.txHashes = std::vector<std::array<uint8_t, 32>>();
	_gbtd.default_witness_commitment = std::string();
	try { // Extract and build GetBlockTemplate data
		_gbtd.bh.version = getblocktemplate["version"];
		_gbtd.bh.previousblockhash = v8ToA8(reverse(hexStrToV8(getblocktemplate["previousblockhash"])));
		_gbtd.coinbasevalue = getblocktemplate["coinbasevalue"];
		_gbtd.bh.curtime = getblocktemplate["curtime"];
		_gbtd.bh.bits = std::stoll(std::string(getblocktemplate["bits"]), nullptr, 16);
		_gbtd.height = getblocktemplate["height"];
		_info.powVersion = getblocktemplate["powversion"];
		if (_info.powVersion != 1) {
			std::cout << __func__ << ": Unsupported PoW Version " << _info.powVersion << ", please upgrade rieMiner!" << std::endl;
			return false;
		}
		_info.acceptedPatterns = getblocktemplate["patterns"].get<decltype(_info.acceptedPatterns)>();
		if (_info.acceptedPatterns.size() == 0) {
			std::cout << __func__ << ": Empty or invalid accepted patterns list!" << std::endl;
			return false;
		}
		_gbtd.default_witness_commitment = getblocktemplate["default_witness_commitment"];
		for (const auto &transaction : getblocktemplate["transactions"]) {
			const std::vector<uint8_t> txId(reverse(hexStrToV8(transaction["txid"])));
			_gbtd.transactions += transaction["data"];
			_gbtd.txHashes.push_back(v8ToA8(txId));
		}
	}
	catch (std::exception &e) {
		std::cout << __func__ << ": Invalid GetBlockTemplate Data - " << e.what() << std::endl;
		return false;
	}
	return true;
}

void GBTClient::_submit(const Job& job) {
	std::cout << "Submitting block with " << job.txCount << " transaction(s) (including coinbase)..." << std::endl;
	BlockHeader bh(job.bh);
	bh.nOffset = job.encodedOffset();
	std::ostringstream oss;
	oss << v8ToHexStr(bh.toV8());
	// Using the Variable Length Integer format; having more than 65535 transactions is currently impossible
	if (job.txCount < 0xFD)
		oss << std::setfill('0') << std::setw(2) << std::hex << job.txCount;
	else
		oss << "fd" << std::setfill('0') << std::setw(2) << std::hex << job.txCount % 256 << std::setw(2) << job.txCount/256;
	oss << job.transactions;
	try {
		nlohmann::json submitblockResponse(_sendRequestToWallet("submitblock", {oss.str()}));
		if (submitblockResponse["result"] == nullptr && submitblockResponse["error"] == nullptr)
			std::cout << "Submission accepted :D !" << std::endl;
		else
			std::cout << "Submission rejected :| ! Received: " << submitblockResponse.dump() << std::endl;
	}
	catch (std::exception &e) {
		ERRORMSG("Failure submitting block");
		return;
	}
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
