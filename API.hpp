// (c) 2021 Pttn (https://riecoin.dev/en/rieMiner)

#ifndef HEADER_API_hpp
#define HEADER_API_hpp

#include <thread>
#include "main.hpp"
#include "tools.hpp"

class Miner;
class Client;

class API {
	bool _running;
	std::thread _thread;
	uint16_t _port;
	std::shared_ptr<Miner> _miner;
	std::shared_ptr<Client> _client;
	
	void _process();
public:
	API(const uint16_t port) : _running(false), _port(port), _miner(nullptr), _client(nullptr) {};
	
	bool running() {return _running;}
	void start() {
		if (_running)
			ERRORMSG("The API is already running");
		else {
			_running = true;
			_thread = std::thread(&API::_process, this);
		}
	}
	void stop() {
		if (!_running)
			ERRORMSG("The API is already not running");
		else {
			_running = false;
			_thread.join();
		}
	}
	void setMiner(const std::shared_ptr<Miner> &miner) {_miner = miner;}
	void setClient(const std::shared_ptr<Client> &client) {_client = client;}
};

#endif
