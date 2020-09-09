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
		std::cout << "Cannot connect because the client was not inited!" << std::endl;
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
	if (_inited) {
		_bh = BlockHeader();
		((uint32_t*) &_bh.bits)[0] = 256*_options->benchmarkDifficulty() + 33554432;
		_height = 1;
		return true;
	}
	else return false;
}

bool BMClient::connect() {
	if (_connected) return false;
	if (_inited) {
		_bh = BlockHeader();
		_pendingSubmissions = std::vector<WorkData>();
		_connected = true;
		_height = 0;
		return true;
	}
	else {
		std::cout << "Cannot start the benchmark because it was not inited!" << std::endl;
		return false;
	}
}

void BMClient::sendWork(const WorkData &work) const {
	DBG(std::cout << "Dummy block header: " << binToHexStr(&work.bh, 112) << std::endl;);
	DBG(std::cout << "Decoded base prime: " << work.bh.decodeSolution() << std::endl;);
}

WorkData BMClient::workData() const {
	WorkData wd;
	if (_height == 1) {
		wd.bh = _bh;
		wd.height = _height;
		wd.difficulty = decodeCompact(wd.bh.bits);
		for (uint32_t i(0) ; i < 32 ; i++) wd.bh.merkleRoot[i] = rand(0x00, 0xFF);
	}
	return wd;
}
