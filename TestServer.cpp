// (c) 2021-present Pttn (https://riecoin.xyz/rieMiner)

#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <netinet/in.h>
#include <sstream>
#include <thread>
#include <unistd.h>
#include <vector>

constexpr uint16_t port(3004);

int serverFd, clientFd;
sockaddr_in address;
socklen_t addressLength(sizeof(address));

constexpr uint16_t maxMessageSize(256);
char buffer[256] = {0};
std::string receiveMessage() {
	/*int bytesRead(0);
	bytesRead = */read(clientFd, buffer, 256);
	// std::cout << "Got " << bytesRead << " bytes from rieMiner: " << buffer << std::endl;
	return buffer;
}

void sendMessage(const std::string &message) {
	// std::cout << "Sending " << message.size() << " bytes: " << message << std::endl;
	send(clientFd , message.c_str(), message.size(), MSG_NOSIGNAL);
}

void acceptMiner() {
	if ((clientFd = accept(serverFd, reinterpret_cast<sockaddr*>(&address), &addressLength)) < 0) {
		std::cerr << "Could not accept connection" << std::endl;
		exit(-1);
	}
	receiveMessage();
	sendMessage("{\"id\": 0, \"result\": [[[\"mining.notify\", \"00\"]], \"00\", 1], \"error\": null}\n");
	receiveMessage();
	sendMessage("{\"id\": 0, \"result\": true, \"error\": null}\n");
}

template <class C> std::string formatContainer(const C& container) {
	std::ostringstream oss;
	for (auto it(container.begin()) ; it < container.end() ; it++) {
		oss << *it;
		if (it != container.end() - 1) oss << ", ";
	}
	return oss.str();
}

uint64_t timestampNow() {
	const auto now(std::chrono::system_clock::now());
	return std::chrono::duration_cast<std::chrono::seconds>(now.time_since_epoch()).count();
}

std::string formattedHeight(const uint32_t height) {
	std::ostringstream oss;
	if (height < 128)
		oss << "01" << std::setfill('0') << std::setw(2) << std::hex << height;
	else if (height < 32768)
		oss << "02" << std::setfill('0') << std::setw(2) << std::hex << height % 256 << std::setfill('0') << std::setw(2) << std::hex << (height/256) % 256;
	else
		oss << "03" << std::setfill('0') << std::setw(2) << std::hex << height % 256 << std::setfill('0') << std::setw(2) << std::hex << (height/256) % 256 << std::setfill('0') << std::setw(2) << std::hex << (height/65536) % 256;
	return oss.str();
}
std::string generateMiningNotify(const uint32_t height, const uint32_t nBits, const std::vector<std::vector<uint64_t>> acceptedPatterns, const bool cleanJobs) {
	uint64_t currentJobId(0);
	std::ostringstream oss;
	oss << "{\"id\": null, \"method\": \"mining.notify\", \"params\": [\"";
	oss << std::hex << currentJobId++ << "\"";
	oss << ", \"0000000000000000000000000000000000000000000000000000000000000000\"";
	oss << ", \"000000000000000000000000000000000000000000000000000000000000000000000000000000000000" << formattedHeight(height) << "\"";
	oss << ", \"\"";
	oss << ", []";
	oss << ", \"20000000\"";
	oss << ", \"" << std::setfill('0') << std::setw(8) << std::hex << nBits << "\"";
	oss << ", \"" << std::setfill('0') << std::setw(8) << std::hex << timestampNow() << "\"";
	oss << ", " << (cleanJobs ? "true" : "false");
	oss << ", 1";
	oss << ", [";
	for (uint64_t i(0) ; i < acceptedPatterns.size() ; i++) {
		oss << "[" << formatContainer(acceptedPatterns[i]) << "]";
		if (i + 1 !=  acceptedPatterns.size())
			oss << ", ";
	}
	oss << "]]}\n";
	return oss.str();
}

int main() {
	std::cout << "rieMiner Test Server" << std::endl;
	std::cout << "-----------------------------------------------------------" << std::endl;
	if ((serverFd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
		std::cerr << "Could not get a File Descriptor for the Server" << std::endl;
		exit(-1);
	}
	int optval(1);
	if (setsockopt(serverFd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &optval, sizeof(decltype(optval))) != 0) {
		std::cerr << "Setsockopt could not set SO_REUSEADDR | SO_REUSEPORT" << std::endl;
		exit(-1);
	}
	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(port);
	if (bind(serverFd, reinterpret_cast<sockaddr*>(&address), sizeof(address)) < 0) {
		std::cerr << "Could not bind" << std::endl;
		exit(-1);
	}
	if (listen(serverFd, 1) < 0) {
		std::cerr << "Could not listen" << std::endl;
		exit(-1);
	}
	
	std::cout << "Please start rieMiner in Pool Mode with Port " << port << std::endl;
	uint32_t height(1U);
	while (true) {
		std::cout << "Test 1: connection to a Pool" << std::endl;
		std::cout << "Expected behavior: rieMiner initializes the miner and starts mining" << std::endl;
		acceptMiner();
		uint32_t difficulty(768U);
		std::cout << "-----------------------------------------------------------" << std::endl;
		std::cout << "Test 2: Varying Difficulty" << std::endl;
		std::cout << "Expected behavior: rieMiner finds shares and restarts correctly in reaction to the increasing and decreasing Difficulty" << std::endl;
		for ( ; difficulty < 896 ; difficulty += 8) {
			std::cout << "Current Difficulty: " << difficulty << " (Block " << height << ")" << std::endl;
			sendMessage(generateMiningNotify(height++, difficulty*256, {{0, 4, 2, 4, 2}, {0, 2, 4, 2, 4}}, true));
			for (uint16_t i(0) ; i < 8 ; i++) {
				receiveMessage();
				sendMessage("{\"id\": 0, \"result\": true, \"error\": null}\n");
			}
		}
		for ( ; difficulty > 640 ; difficulty -= 16) {
			std::cout << "Current Difficulty: " << difficulty << " (Block " << height << ")" << std::endl;
			sendMessage(generateMiningNotify(height++, difficulty*256, {{0, 4, 2, 4, 2}, {0, 2, 4, 2, 4}}, true));
			for (uint16_t i(0) ; i < 8 ; i++) {
				receiveMessage();
				sendMessage("{\"id\": 0, \"result\": true, \"error\": null}\n");
			}
		}
		std::cout << "-----------------------------------------------------------" << std::endl;
		std::cout << "Test 3: Disconnects" << std::endl;
		std::cout << "Expected behavior: rieMiner gets disconnected several times, but always reconnects and resumes mining properly" << std::endl;
		std::cout << "8 disconnections after 5 s" << std::endl;
		for (uint16_t i(0) ; i < 8 ; i++) {
			std::this_thread::sleep_for(std::chrono::seconds(5));
			std::cout << "Disconnect " << i << std::endl;
			close(clientFd);
			acceptMiner();
			std::cout << "Reconnected" << std::endl;
			sendMessage(generateMiningNotify(height, difficulty*256, {{0, 4, 2, 4, 2}, {0, 2, 4, 2, 4}}, true));
		}
		std::cout << "4 disconnections after 15 s" << std::endl;
		for (uint16_t i(0) ; i < 4 ; i++) {
			std::this_thread::sleep_for(std::chrono::seconds(15));
			std::cout << "Disconnect " << i << std::endl;
			close(clientFd);
			acceptMiner();
			std::cout << "Reconnected" << std::endl;
			sendMessage(generateMiningNotify(height, difficulty*256, {{0, 4, 2, 4, 2}, {0, 2, 4, 2, 4}}, true));
		}
		std::cout << "2 disconnections after 30 s" << std::endl;
		for (uint16_t i(0) ; i < 2 ; i++) {
			std::this_thread::sleep_for(std::chrono::seconds(30));
			std::cout << "Disconnect " << i << std::endl;
			close(clientFd);
			acceptMiner();
			std::cout << "Reconnected" << std::endl;
			sendMessage(generateMiningNotify(height, difficulty*256, {{0, 4, 2, 4, 2}, {0, 2, 4, 2, 4}}, true));
		}
		std::cout << "-----------------------------------------------------------" << std::endl;
		std::cout << "Test 4: Constellation Pattern Change/Hard Fork Simulation" << std::endl;
		std::cout << "Expected behavior: rieMiner finds shares and restarts correctly in reaction to the Pattern or Difficulty Change" << std::endl;
		difficulty = 540;
		sendMessage(generateMiningNotify(height++, difficulty*256, {{0, 2, 4, 2, 4, 6, 2}, {0, 2, 6, 4, 2, 4, 2}}, true));
		std::cout << "rieMiner should now mine 7-tuples. Current Difficulty: " << difficulty << " (Block " << height << ")" << std::endl;
		for (uint16_t i(0) ; i < 64 ; i++) {
			receiveMessage();
			sendMessage("{\"id\": 0, \"result\": true, \"error\": null}\n");
		}
		difficulty = 480;
		sendMessage(generateMiningNotify(height++, difficulty*256, {{0, 2, 4, 2, 4, 6, 2, 6}, {0, 2, 4, 6, 2, 6, 4, 2}, {0, 6, 2, 6, 4, 2, 4, 2}}, true));
		std::cout << "rieMiner should now mine 8-tuples. Current Difficulty: " << difficulty << " (Block " << height << ")" << std::endl;
		for (uint16_t i(0) ; i < 8 ; i++) {
			receiveMessage();
			sendMessage("{\"id\": 0, \"result\": true, \"error\": null}\n");
		}
		std::cout << "Test loop finished." << std::endl;
		close(clientFd);
		std::cout << "-----------------------------------------------------------" << std::endl;
	}
	return 0;
}
