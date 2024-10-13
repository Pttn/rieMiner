// (c) 2021-present Pttn (https://riecoin.xyz/rieMiner)

#ifndef HEADER_API_hpp
#define HEADER_API_hpp

#include <thread>
#include "Client.hpp"

class API {
	bool _running{false};
	std::thread _thread;
	uint16_t _port;
	std::shared_ptr<Client> _client{nullptr};
	
	double _uptime{0.}, _cps{0.}, _r{0.}, _bpd{0.};
	
	void _process();
public:
	API(const uint16_t port) : _port(port) {};
	
	bool running() {return _running;}
	void start() {
		if (_running)
			logger.log("The API is already running\n"s, MessageType::ERROR);
		else {
			_running = true;
			_thread = std::thread(&API::_process, this);
		}
	}
	void stop() {
		if (!_running)
			logger.log("The API is already stopped\n"s, MessageType::ERROR);
		else {
			_running = false;
			_thread.join();
		}
	}
	void setClient(const std::shared_ptr<Client> &client) {_client = client;}
	
	void setStats(const double, const double, const double, const double);
};

#endif
