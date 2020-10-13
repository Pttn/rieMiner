// (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)

#include "Client.hpp"

double decodeBits(const uint32_t nBits, const int32_t powVersion) {
	if (powVersion == -1) { // // Bitcoin Core's arith_uint256::SetCompact for UInt64_Ts (double are exact up to 2^53 for integers)
		const uint64_t nSize(nBits >> 24), nWord(nBits & 0x007fffff);
		if (nSize <= 3) return nWord >> (8ULL*(3ULL - nSize));
		else return nWord << (8ULL*(nSize - 3ULL));
	}
	else if (powVersion == 1)
		return static_cast<double>(nBits)/256.;
	return 1.;
}

std::vector<uint8_t> WorkData::encodedOffset() const {
	std::vector<uint8_t> nOffset(32, 0);
	if (powVersion == -1) { // [31-0 Offset]
		const mpz_class offset(result - target);
		for (uint32_t l(0) ; l < std::min(32/static_cast<uint32_t>(sizeof(mp_limb_t)), static_cast<uint32_t>(offset.get_mpz_t()->_mp_size)) ; l++)
			*reinterpret_cast<mp_limb_t*>(nOffset.data() + l*sizeof(mp_limb_t)) = offset.get_mpz_t()->_mp_d[l];
	}
	else if (powVersion == 1) { // [31-30 Primorial Number|29-14 Primorial Factor|13-2 Primorial Offset|1-0 Reserved/Version]
		*reinterpret_cast<uint16_t*>(&nOffset.data()[ 0]) = 2;
		*reinterpret_cast<uint64_t*>(&nOffset.data()[ 2]) = primorialOffset; // Only 64 bits used out of 96
		*reinterpret_cast<uint64_t*>(&nOffset.data()[14]) = primorialFactor; // Only 64 bits used out of 128
		*reinterpret_cast<uint16_t*>(&nOffset.data()[30]) = primorialNumber;
	}
	else
		ERRORMSG("Invalid PoW Version " << powVersion);
	return nOffset;
}

void Client::_updateClient() {
	std::chrono::time_point<std::chrono::steady_clock> timeOutTimer(std::chrono::steady_clock::now());
	WorkData dummy;
	while (!getWork(dummy)) { // Poll until valid work data is generated, with 1 s time out
		process();
		if (timeSince(timeOutTimer) > 1.) {
			std::cout << "Unable to get mining data from the Riecoin Server :| !" << std::endl;
			_connected = false;
			break;
		}
	}
}

bool Client::connect() {
	if (_connected) return false;
	if (_inited) {
		if (!_getWork()) return false;
		_pendingSubmissions = std::vector<WorkData>();
		_connected = true;
		return true;
	}
	else {
		ERRORMSG("Cannot connect because the client was not inited");
		return false;
	}
}

bool Client::process() {
	_submitMutex.lock();
	if (_pendingSubmissions.size() > 0) {
		for (uint32_t i(0) ; i < _pendingSubmissions.size() ; i++)
			sendWork(_pendingSubmissions[i]);
		_pendingSubmissions.clear();
	}
	_submitMutex.unlock();
	
	if (_getWork()) return true;
	else { // If _getWork() failed, this means that the client is disconnected
		_connected = false;
		return false;
	}
}

std::vector<std::vector<uint64_t>> Client::extractAcceptedConstellationOffsets(const json_t* jsonConstellations) {
	std::vector<std::vector<uint64_t>> acceptedConstellationOffsets;
	if (json_array_size(jsonConstellations) == 0)
		return acceptedConstellationOffsets;
	for (uint16_t i(0) ; i < json_array_size(jsonConstellations) ; i++) {
		std::vector<uint64_t> acceptedConstellationType;
		if (json_array_size(json_array_get(jsonConstellations, i)) == 0)
			return std::vector<std::vector<uint64_t>>();
		json_t *json_Constellation(json_array_get(jsonConstellations, i));
		for (uint16_t j(0) ; j < json_array_size(json_Constellation) ; j++)
			acceptedConstellationType.push_back(json_integer_value(json_array_get(json_Constellation, j)));
		acceptedConstellationOffsets.push_back(acceptedConstellationType);
	}
	return acceptedConstellationOffsets;
}

std::vector<uint64_t> Client::chooseConstellationOffsets(const std::vector<std::vector<uint64_t>>& acceptedConstellationOffsets, const std::vector<uint64_t>& givenConstellationOffsets) {
	bool acceptedPattern(false);
	std::cout << "Accepted constellation offset(s):" << std::endl;
	if (acceptedConstellationOffsets.size() == 0) {
		std::cout << " None - something went wrong :|" << std::endl;
		return {};
	}
	else {
		for (uint16_t i(0) ; i < acceptedConstellationOffsets.size() ; i++) {
			std::cout << " " << i << " - ";
			bool compatible(true);
			for (uint16_t j(0) ; j < acceptedConstellationOffsets[i].size() ; j++) {
				const auto offset(acceptedConstellationOffsets[i][j]);
				std::cout << offset;
				if (j >= givenConstellationOffsets.size() ? true : offset != givenConstellationOffsets[j])
					compatible = false;
				if (j != acceptedConstellationOffsets[i].size() - 1) std::cout << ", ";
			}
			if (compatible) {
				std::cout << " <- compatible";
				acceptedPattern = true;
			}
			std::cout << std::endl;
		}
		if (!acceptedPattern) {
			const uint16_t patternIndex(rand(0, acceptedConstellationOffsets.size() - 1));
			std::cout << "None or not compatible one specified, choosing a random one: pattern " << patternIndex << std::endl;
			return acceptedConstellationOffsets[patternIndex];
		}
		else
			return givenConstellationOffsets;
	}
}

bool BMClient::_getWork() {
	std::lock_guard<std::mutex> lock(_workMutex);
	if (_inited) {
		if (_height == 0)
			_height = 1;
		else if (timeSince(_timer) >= _options->benchmarkBlockInterval()) {
			_height++;
			_requests = 0;
			_timer = std::chrono::steady_clock::now();
		}
		return true;
	}
	else return false;
}

bool BMClient::connect() {
	if (_connected) return false;
	if (_inited) {
		_height = 0;
		_requests = 0;
		_timer = std::chrono::steady_clock::now();
		_constellationOffsets = _options->minerParameters().constellationOffsets;
		if (_constellationOffsets.size() == 0) // Pick a default pattern if none was chosen
			_constellationOffsets = {0, 2, 4, 2, 4, 6, 2};
		_connected = true;
		return true;
	}
	else {
		ERRORMSG("Cannot start the benchmark because it was not inited");
		return false;
	}
}

void BMClient::updateMinerParameters(MinerParameters& minerParameters) {
	minerParameters.constellationOffsets = _constellationOffsets;
}

WorkData BMClient::workData() {
	std::lock_guard<std::mutex> lock(_workMutex);
	WorkData wd;
	wd.height = _height;
	wd.difficulty = _options->difficulty();
	const uint64_t difficultyAsInteger(std::round(65536.*wd.difficulty));
	// Target: (in binary) 1 . Leading Digits L (16 bits) . Height (32 bits) . Requests (32 bits) . (Difficulty - 81) zeros = 2^(Difficulty - 81)(2^80 + 2^64*L + 2^32*Height + Requests)
	wd.target = 1;
	wd.target <<= 16;
	wd.target += static_cast<uint16_t>(std::round(std::pow(2., 16. + static_cast<double>(difficultyAsInteger % 65536)/65536.)) - 65536.);
	wd.target <<= 32;
	wd.target += static_cast<uint32_t>(wd.height);
	wd.target <<= 32;
	wd.target += static_cast<uint32_t>(_requests);
	wd.target <<= (difficultyAsInteger/65536ULL - 81ULL);
	wd.acceptedConstellationOffsets = {_constellationOffsets};
	wd.primeCountTarget = _constellationOffsets.size();
	wd.primeCountMin = wd.primeCountTarget;
	return wd;
}

bool SearchClient::connect() {
	if (_connected) return false;
	if (_inited) {
		_startTp = std::chrono::steady_clock::now();
		_constellationOffsets = _options->minerParameters().constellationOffsets;
		if (_constellationOffsets.size() == 0) // Pick a default pattern if none was chosen
			_constellationOffsets = {0, 2, 4, 2, 4, 6, 2};
		_connected = true;
		return true;
	}
	else {
		ERRORMSG("Cannot start the search because it was not inited");
		return false;
	}
}

void SearchClient::updateMinerParameters(MinerParameters& minerParameters) {
	minerParameters.constellationOffsets = _constellationOffsets;
}

WorkData SearchClient::workData() {
	WorkData wd;
	wd.height = _connected ? 1 : 0;
	wd.difficulty = _options->difficulty();
	// Target: (in binary) 1 . Leading Digits L (16 bits) . 80 Random Bits . (Difficulty - 97) zeros = 2^(Difficulty - 97)*(2^96 + 2^80*L + Random)
	const uint64_t difficultyAsInteger(std::round(65536.*wd.difficulty));
	std::array<uint8_t, 10> random;
	for (auto &byte : random) byte = rand(0x00, 0xFF);
	wd.target = 1;
	wd.target <<= 16;
	wd.target += static_cast<uint16_t>(std::round(std::pow(2., 16. + static_cast<double>(difficultyAsInteger % 65536)/65536.)) - 65536.);
	for (uint8_t i(0) ; i < 5 ; i++) {
		wd.target <<= 16;
		wd.target += reinterpret_cast<uint16_t*>(random.data())[4 - i];
	}
	wd.target <<= (wd.difficulty - 97);
	wd.acceptedConstellationOffsets = {_constellationOffsets};
	wd.primeCountTarget = _constellationOffsets.size();
	wd.primeCountMin = wd.primeCountTarget;
	return wd;
}

bool TestClient::_getWork() {
	std::lock_guard<std::mutex> lock(_workMutex);
	if (_inited) {
		if (_height == 0) {
			_timer = std::chrono::steady_clock::now();
			_height = 1;
			_difficulty = 800;
			_timeBeforeNextBlock = 10;
			_acceptedConstellationOffsets = {{0, 2, 4, 2, 4}};
		}
		if (timeSince(_timer) >= _timeBeforeNextBlock) {
			_height++;
			_requests = 0;
			_difficulty += 10;
			if (_difficulty == 860) {
				_difficulty = 1600;
				_timeBeforeNextBlock = 30;
				if (_acceptedConstellationOffsets == std::vector<std::vector<uint64_t>>{{0, 2, 4, 2, 4}})
					_acceptedConstellationOffsets = {{0, 2, 4, 2, 4, 6, 2}}; // Fork simulation
				else
					return false; // Disconnect simulation
			}
			else if (_difficulty > 1600) {
				_difficulty += 30;
				_timeBeforeNextBlock -= 10;
				if (_timeBeforeNextBlock == 0) {
					_difficulty = 800;
					_timeBeforeNextBlock = 10;
					return false; // Disconnect simulation
				}
			}
			_timer = std::chrono::steady_clock::now();
		}
		_bh = BlockHeader();
		reinterpret_cast<uint64_t*>(&_bh.previousblockhash[0])[0] = _height - 1;
		reinterpret_cast<uint64_t*>(&_bh.merkleRoot[0])[0] = _requests;
		_bh.bits = 256*_difficulty;
		return true;
	}
	else return false;
}

bool TestClient::connect() {
	if (_connected) return false;
	if (_inited) {
		_bh = BlockHeader();
		_requests = 0;
		_timer = std::chrono::steady_clock::now();
		_connected = true;
		return true;
	}
	else {
		ERRORMSG("Cannot start the test because it was not inited");
		return false;
	}
}

void TestClient::updateMinerParameters(MinerParameters& minerParameters) {
	if (_acceptedConstellationOffsets.size() == 0)
		minerParameters.constellationOffsets = {0, 2, 4, 2, 4};
	else
		minerParameters.constellationOffsets = _acceptedConstellationOffsets[0];
}

WorkData TestClient::workData() {
	std::lock_guard<std::mutex> lock(_workMutex);
	WorkData wd;
	wd.bh = _bh;
	wd.height = _connected ? _height : 0;
	wd.powVersion = 1;
	wd.difficulty = decodeBits(wd.bh.bits, wd.powVersion);
	wd.target = wd.bh.target(wd.powVersion);
	wd.acceptedConstellationOffsets = _acceptedConstellationOffsets;
	wd.primeCountTarget = _acceptedConstellationOffsets[0].size();
	wd.primeCountMin = wd.primeCountTarget;
	return wd;
}
