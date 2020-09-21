// (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)

#include "Client.hpp"

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
		_bh = BlockHeader();
		reinterpret_cast<uint64_t*>(&_bh.previousblockhash[0])[0] = _height - 1;
		reinterpret_cast<uint64_t*>(&_bh.merkleRoot[0])[0] = _requests;
		_bh.bits = 256*_options->difficulty() + 33554432;
		return true;
	}
	else return false;
}

bool BMClient::connect() {
	if (_connected) return false;
	if (_inited) {
		_bh = BlockHeader();
		_height = 0;
		_requests = 0;
		_timer = std::chrono::steady_clock::now();
		_connected = true;
		return true;
	}
	else {
		ERRORMSG("Cannot start the benchmark because it was not inited");
		return false;
	}
}

void BMClient::updateMinerParameters(MinerParameters& minerParameters) const {
	if (minerParameters.constellationOffsets.size() == 0) // Pick a default pattern if none was chosen
		minerParameters.constellationOffsets = {0, 2, 4, 2, 4, 6, 2};
}

WorkData BMClient::workData() {
	std::lock_guard<std::mutex> lock(_workMutex);
	WorkData wd;
	wd.bh = _bh;
	wd.height = _height;
	wd.difficulty = decodeCompact(wd.bh.bits);
	wd.target = wd.bh.target();
	return wd;
}

bool SearchClient::_getWork() {
	std::lock_guard<std::mutex> lock(_workMutex);
	if (_inited) {
		_bh = BlockHeader();
		_bh.curtime = timeSince(_startTp);
		for (uint32_t i(0) ; i < 32 ; i++) _bh.previousblockhash[i] = rand(0x00, 0xFF);
		for (uint32_t i(0) ; i < 32 ; i++) _bh.merkleRoot[i] = rand(0x00, 0xFF);
		_bh.bits = 256*_options->difficulty() + 33554432;
		return true;
	}
	else return false;
}

bool SearchClient::connect() {
	if (_connected) return false;
	if (_inited) {
		_startTp = std::chrono::steady_clock::now();
		_bh = BlockHeader();
		_connected = true;
		return true;
	}
	else {
		ERRORMSG("Cannot start the search because it was not inited");
		return false;
	}
}

void SearchClient::updateMinerParameters(MinerParameters& minerParameters) const {
	if (minerParameters.constellationOffsets.size() == 0) // Pick a default pattern if none was chosen
		minerParameters.constellationOffsets = {0, 2, 4, 2, 4, 6, 2};
}

WorkData SearchClient::workData() {
	std::lock_guard<std::mutex> lock(_workMutex);
	WorkData wd;
	wd.bh = _bh;
	wd.height = _connected ? 1 : 0;
	wd.difficulty = decodeCompact(wd.bh.bits);
	wd.target = wd.bh.target();
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
		_bh.bits = 256*_difficulty + 33554432;
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

void TestClient::updateMinerParameters(MinerParameters& minerParameters) const {
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
	wd.difficulty = decodeCompact(wd.bh.bits);
	wd.target = wd.bh.target();
	wd.acceptedConstellationOffsets = _acceptedConstellationOffsets;
	return wd;
}
