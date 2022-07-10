// (c) 2018-2022 Pttn (https://riecoin.dev/en/rieMiner)

#include "Client.hpp"
#include "main.hpp"

const std::string cbMsg("/rM0.93/");
static std::vector<uint8_t> coinbaseGen(const std::vector<uint8_t> &scriptPubKey, const uint32_t height, const uint64_t coinbasevalue, const std::vector<uint8_t> &dwc) {
	std::vector<uint8_t> coinbase;
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
		// Coinbase Message
		for (uint32_t i(0) ; i < cbMsg.size() ; i++) scriptSig.push_back(cbMsg[i]);
		// Randomization to avoid having 2 threads working on the same problem
		for (uint32_t i(0) ; i < 4 ; i++) scriptSig.push_back(rand(0x00, 0xFF));
	// ScriptSig Size
	coinbase.push_back(scriptSig.size());
	// ScriptSig
	coinbase.insert(coinbase.end(), scriptSig.begin(), scriptSig.end());
	// Input Sequence (FFFFFFFF)
	coinbase.insert(coinbase.end(), {0xFF, 0xFF, 0xFF, 0xFF});
	// Output Count
	coinbase.push_back(1U);
	if (dwc.size() > 0) coinbase.back()++; // Dummy Output for SegWit
	// Output Value
	uint64_t reward(coinbasevalue);
	for (uint32_t i(0) ; i < 8 ; i++) {
		coinbase.push_back(reward % 256);
		reward /= 256;
	}
	// Output/ScriptPubKey Length
	coinbase.push_back(scriptPubKey.size());
	// ScriptPubKey (for the payout address)
	coinbase.insert(coinbase.end(), scriptPubKey.begin(), scriptPubKey.end());
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
	coinbase.insert(coinbase.end(), {0x00, 0x00, 0x00, 0x00});
	return coinbase;
}

std::array<uint8_t, 32> coinbaseTxId(const std::vector<uint8_t> &coinbase) {
	std::vector<uint8_t> coinbase2;
	for (uint32_t i(0) ; i < 4 ; i++) coinbase2.push_back(coinbase[i]); // nVersion
	for (uint32_t i(6) ; i < coinbase.size() - 38 ; i++) coinbase2.push_back(coinbase[i]); // txins . txouts
	for (uint32_t i(coinbase.size() - 4) ; i < coinbase.size() ; i++) coinbase2.push_back(coinbase[i]); // nLockTime
	return sha256sha256(coinbase2.data(), coinbase2.size());
}

static std::array<uint8_t, 32> calculateMerkleRoot(const std::vector<std::array<uint8_t, 32>> &txHashes) {
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
			catch (nlohmann::json::parse_error &e) {
				if (s.size() == 0)
					std::cout << "Nothing was received from the server!" << std::endl;
				else {
					std::cout << "Received bad JSON object!" << std::endl;
					std::cout << "Server message was: " << s << std::endl;
				}
			}
		}
	}
	return jsonObj;
}

bool GBTClient::_fetchJob() {
	nlohmann::json getblocktemplate, getblocktemplateResult;
	try {
		getblocktemplate = _sendRequestToWallet("getblocktemplate", {{{"rules", _rules}}});
		if (getblocktemplate == nullptr)
			return false;
		getblocktemplateResult = getblocktemplate["result"];
	}
	catch (...) {
		std::cout << "Could not get GetBlockTemplate Data!" << std::endl;
		return false;
	}
	JobTemplate newJobTemplate;
	std::vector<std::vector<uint64_t>> acceptedPatterns;
	try { // Extract and build GetBlockTemplate data
		newJobTemplate.job.clientData.bh.version = getblocktemplateResult["version"];
		newJobTemplate.job.clientData.bh.previousblockhash = v8ToA8(reverse(hexStrToV8(getblocktemplateResult["previousblockhash"])));
		newJobTemplate.job.clientData.bh.curtime = getblocktemplateResult["curtime"];
		newJobTemplate.job.clientData.bh.bits = std::stoll(std::string(getblocktemplateResult["bits"]), nullptr, 16);
		newJobTemplate.coinbasevalue = getblocktemplateResult["coinbasevalue"];
		std::vector<std::array<uint8_t, 32>> wTxIds{std::array<uint8_t, 32>{}};
		for (const auto &transaction : getblocktemplateResult["transactions"]) {
			const std::vector<uint8_t> txId(reverse(hexStrToV8(transaction["txid"])));
			newJobTemplate.job.clientData.transactionsHex += transaction["data"];
			newJobTemplate.txHashes.push_back(v8ToA8(txId));
			wTxIds.push_back(v8ToA8(reverse(hexStrToV8(transaction["hash"]))));
		}
		newJobTemplate.default_witness_commitment = "6a24aa21a9ed" + v8ToHexStr(a8ToV8(calculateMerkleRoot({calculateMerkleRoot(wTxIds), std::array<uint8_t, 32>{}})));
		newJobTemplate.job.clientData.txCount = newJobTemplate.txHashes.size() + 1; // Include Coinbase
		newJobTemplate.job.height = getblocktemplateResult["height"];
		newJobTemplate.job.powVersion = getblocktemplateResult["powversion"];
		if (newJobTemplate.job.powVersion != 1) {
			std::cout << "Unsupported PoW Version " << newJobTemplate.job.powVersion << ", your rieMiner version is likely outdated!" << std::endl;
			return false;
		}
		newJobTemplate.job.acceptedPatterns = getblocktemplateResult["patterns"].get<decltype(newJobTemplate.job.acceptedPatterns)>();
		if (newJobTemplate.job.acceptedPatterns.size() == 0) {
			std::cout << "Empty or invalid accepted patterns list!" << std::endl;
			return false;
		}
		newJobTemplate.job.primeCountTarget = newJobTemplate.job.acceptedPatterns[0].size();
		newJobTemplate.job.primeCountMin = newJobTemplate.job.primeCountTarget;
		newJobTemplate.job.difficulty = decodeBits(newJobTemplate.job.clientData.bh.bits, newJobTemplate.job.powVersion);
	}
	catch (...) {
		std::cout << "Received GetBlockTemplate Data with invalid parameters!" << std::endl;
		std::cout << "Json Object was: " << getblocktemplate.dump() << std::endl;
		return false;
	}
	std::lock_guard<std::mutex> lock(_jobMutex);
	_currentJobTemplate = newJobTemplate;
	return true;
}

void GBTClient::_submit(const Job& job) {
	std::cout << "Submitting block with " << job.clientData.txCount << " transaction(s) (including coinbase)..." << std::endl;
	BlockHeader bh(job.clientData.bh);
	bh.nOffset = job.encodedOffset();
	std::ostringstream oss;
	oss << v8ToHexStr(bh.toV8());
	// Using the Variable Length Integer format; having more than 65535 transactions is currently impossible
	if (job.clientData.txCount < 0xFD)
		oss << std::setfill('0') << std::setw(2) << std::hex << job.clientData.txCount;
	else
		oss << "fd" << std::setfill('0') << std::setw(2) << std::hex << job.clientData.txCount % 256 << std::setw(2) << job.clientData.txCount/256;
	oss << job.clientData.transactionsHex;
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

void GBTClient::connect() {
	if (!_connected) {
		_currentJobTemplate = JobTemplate();
		_pendingSubmissions = {};
		process();
		if (_currentJobTemplate.job.height == 0) {
			std::cout << "Could not get a first job from the server!" << std::endl;
			return;
		}
		_connected = true;
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
	if (!_fetchJob()) {
		_connected = false; // If _fetchJob() failed, this means that the client is disconnected
		std::lock_guard<std::mutex> lock(_jobMutex);
		_currentJobTemplate.job.height = 0;
	}
}

Job GBTClient::getJob(const bool) {
	std::lock_guard<std::mutex> lock(_jobMutex);
	Job job(_currentJobTemplate.job);
	if (job.height == 0) // Invalid Job
		return job;
	const std::vector<uint8_t> coinbase(coinbaseGen(_scriptPubKey, job.height, _currentJobTemplate.coinbasevalue, hexStrToV8(_currentJobTemplate.default_witness_commitment)));
	job.clientData.transactionsHex = v8ToHexStr(coinbase) + job.clientData.transactionsHex;
	std::vector<std::array<uint8_t, 32>> txHashesWithCoinbase{coinbaseTxId(coinbase)};
	txHashesWithCoinbase.insert(txHashesWithCoinbase.end(), _currentJobTemplate.txHashes.begin(), _currentJobTemplate.txHashes.end());
	_jobMutex.unlock();
	job.clientData.bh.merkleRoot = calculateMerkleRoot(txHashesWithCoinbase);
	job.target = job.clientData.bh.target(job.powVersion);
	return job;
}
