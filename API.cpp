// (c) 2021 Pttn (https://riecoin.dev/en/rieMiner)

#ifdef _WIN32
	#include <winsock2.h>
#else
	#include <arpa/inet.h>
#endif
#include <fcntl.h>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <thread>
#include <unistd.h>
#include <vector>

#include "API.hpp"
#include "Miner.hpp"
#include "Client.hpp"

constexpr uint16_t maxMessageSize(64);
void API::_process() {
	std::cout << "Starting rieMiner's API server, port " << _port << std::endl;
#ifdef _WIN32
		WORD wVersionRequested(MAKEWORD(2, 2));
		WSADATA wsaData;
		const int err(WSAStartup(wVersionRequested, &wsaData));
		if (err != 0) {
			ERRORMSG("WSAStartup failed with error " << err);
			return;
		}
#endif
	int apiFd;
	if ((apiFd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
		ERRORMSG("Could not get a File Descriptor for the API Server");
		return;
	}
#ifdef _WIN32
	uint32_t nonBlocking(true), cbRet;
	if (WSAIoctl(apiFd, FIONBIO, &nonBlocking, sizeof(nonBlocking), nullptr, 0, (LPDWORD) &cbRet, nullptr, nullptr) != 0) {
#else
	if (fcntl(apiFd, F_SETFL, fcntl(apiFd, F_GETFL, 0) | O_NONBLOCK) == -1) {
#endif
		ERRORMSG("Unable to make the socket non-blocking");
		return;
	}
	
	sockaddr_in address;
	address.sin_family = AF_INET;
	address.sin_port = htons(_port);
	address.sin_addr.s_addr = htonl(INADDR_ANY);
#ifndef _WIN32
	int optval(1);
	if (setsockopt(apiFd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &optval, sizeof(decltype(optval))) != 0) {
		ERRORMSG("Setsockopt could not set SO_REUSEADDR | SO_REUSEPORT");
	}
#endif
	if (bind(apiFd, reinterpret_cast<sockaddr*>(&address), sizeof(address)) < 0) {
		ERRORMSG("Could not bind");
		return;
	}
	if (listen(apiFd, 1) < 0) {
		ERRORMSG("Could not listen");
		return;
	}
	
	while (_running) {
		int clientFd(accept(apiFd, NULL, NULL));
		if (clientFd < 0) {
#ifdef _WIN32
			if (WSAGetLastError() == WSAEWOULDBLOCK)
#else
			if (errno == EWOULDBLOCK)
#endif
				std::this_thread::sleep_for(std::chrono::milliseconds(100));
			else
				ERRORMSG("Could not accept connection");
		}
		else {
#ifdef _WIN32
			uint32_t nonBlocking(true), cbRet;
			if (WSAIoctl(clientFd, FIONBIO, &nonBlocking, sizeof(nonBlocking), nullptr, 0, (LPDWORD) &cbRet, nullptr, nullptr) == 0) {
#else
			if (fcntl(clientFd, F_SETFL, fcntl(apiFd, F_GETFL, 0) | O_NONBLOCK) != -1) {
#endif
				while (_running) {
					char buffer[maxMessageSize] = {0};
					const ssize_t messageLength(recv(clientFd, buffer, maxMessageSize - 1U, 0));
					if (messageLength <= 0) {
#ifdef _WIN32
						if (WSAGetLastError() != WSAEWOULDBLOCK || messageLength == 0)
#else
						if (errno != EWOULDBLOCK || messageLength == 0)
#endif
							break;
						std::this_thread::sleep_for(std::chrono::milliseconds(100));
						continue;
					}
					const std::string method(buffer);
					std::string messageToSend;
					std::ostringstream oss;
					if (method == "getstats" || method == "getstatsjson") {
						bool running(false);
						double uptime(0.), cps(0.), r(0.), bpd(0.), miningPower(0.), difficulty(600.);
						uint16_t patternLength(0U);
						uint32_t shares(0ULL), sharesRejected(0ULL);
						if (_miner != nullptr && _client != nullptr ? _miner->inited() : false) {
							const Stats statsRecent(_miner->getStatsRecent()), stats(_miner->getStats());
							const Job job(_client->getJob());
							if (job.acceptedPatterns.size() > 0)
								patternLength = job.acceptedPatterns[0].size();
							running = true;
							uptime = stats.duration();
							cps = statsRecent.cps();
							r = statsRecent.r();
							bpd = statsRecent.estimatedAverageTimeToFindBlock(patternLength) == 0. ? 0. : (86400./statsRecent.estimatedAverageTimeToFindBlock(patternLength));
							difficulty = job.difficulty;
							miningPower = 150.*bpd*std::pow(difficulty/600., static_cast<double>(patternLength) + 2.3)/86400.;
							if (std::dynamic_pointer_cast<StratumClient>(_client) != nullptr) {
								shares = std::dynamic_pointer_cast<StratumClient>(_client)->shares();
								sharesRejected = std::dynamic_pointer_cast<StratumClient>(_client)->sharesRejected();
							}
						}
						if (method == "getstatsjson") {
							oss << "{\"running\": " << (running ? "true" : "false") << ", ";
							oss << "\"uptime\": " << uptime << ", ";
							oss << "\"cps\": " << cps << ", ";
							oss << "\"r\": " << r << ", ";
							oss << "\"bpd\": " << bpd << ", ";
							oss << "\"miningpower\": " << miningPower << ", ";
							oss << "\"shares\": " << shares << ", ";
							oss << "\"sharesrejected\": " << sharesRejected << "}\n";
						}
						else {
							oss << (running ? "true" : "false") << "\n";
							oss << uptime << "\n";
							oss << cps << "\n";
							oss << r << "\n";
							oss << bpd << "\n";
							oss << miningPower << "\n";
							oss << shares << "\n";
							oss << sharesRejected << "\n";
						}
						messageToSend = oss.str();
					}
					else if (method == "getminerinfo") {
						oss << "rieMiner\n";
						oss << versionShort << "\n";
						messageToSend = oss.str();
					}
					else if (method == "getminerinfojson") {
						oss << "{\"name\": \"rieMiner\", \"version\": \"" << versionShort << "\"}\n";
						messageToSend = oss.str();
					}
					else
						messageToSend = "Unknown method " + method;
					send(clientFd , messageToSend.c_str(), messageToSend.size(), 0);
					break;
				}
			}
			close(clientFd);
		}
	}
}
