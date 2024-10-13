// (c) 2018-present Pttn and contributors (https://riecoin.xyz/rieMiner)

#ifndef HEADER_tools_hpp
#define HEADER_tools_hpp

#include <array>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <deque>
#include <filesystem>
#include <openssl/sha.h>
#include <random>
#include <vector>

#include "Stella.hpp"

uint8_t rand(uint8_t, uint8_t);

inline bool isHexStr(const std::string &str) {
	return std::all_of(str.begin(), str.end(), [](unsigned char c){return std::isxdigit(c);});
}
inline bool isHexStrOfSize(const std::string &str, const std::string::size_type size) {
	return str.size() == size && isHexStr(str);
}

inline std::string v8ToHexStr(const std::vector<uint8_t> &v) {
	std::ostringstream oss;
	for (const auto &u8 : v) oss << std::setfill('0') << std::setw(2) << std::hex << static_cast<uint32_t>(u8);
	return oss.str();
}
std::vector<uint8_t> hexStrToV8(std::string);
inline std::array<uint8_t, 32> v8ToA8(std::vector<uint8_t> v8) {
	std::array<uint8_t, 32> a8{0};
	std::copy_n(v8.begin(), std::min(static_cast<int>(v8.size()), 32), a8.begin());
	return a8;
}
inline std::vector<uint8_t> a8ToV8(const std::array<uint8_t, 32> &a8) {
	return std::vector<uint8_t>(a8.begin(), a8.end());
}

template <class C> inline C reverse(C c) {
	std::reverse(c.begin(), c.end());
	return c;
}

inline std::array<uint8_t, 32> sha256(const uint8_t *data, uint32_t len) {
	std::array<uint8_t, 32> hash;
	SHA256_CTX sha256;
	SHA256_Init(&sha256);
	SHA256_Update(&sha256, data, len);
	SHA256_Final(hash.data(), &sha256);
	return hash;
}
inline std::array<uint8_t, 32> sha256sha256(const uint8_t *data, uint32_t len) {
	return sha256(sha256(data, len).data(), 32);
}

// Bech32 Code adapted from the reference C++ implementation, https://github.com/sipa/bech32/tree/master/ref/c%2B%2B
std::vector<uint8_t> bech32ToScriptPubKey(const std::string&);

inline void waitForUser() {
	std::cout << "Press Enter to continue...";
	std::cin.ignore(std::numeric_limits<std::streamsize>::max(),'\n');
}

#ifdef _WIN32
#include <windows.h>
#ifdef ERROR
#undef ERROR
#endif
#endif
enum MessageType {NORMAL, BOLD, SUCCESS, WARNING, ERROR};
class Logger {
	bool _raw, _inStartupLog, _logDebug;
	std::string _startupLog, _debugLogFileName;
	std::mutex _mutex;
public:
	Logger(const std::string &debugLogFileName) : _raw(false), _inStartupLog(true), _logDebug(true), _debugLogFileName(debugLogFileName) {
		uint64_t nameSuffix(1);
		if (std::filesystem::exists(_debugLogFileName + ".log"s))
			_debugLogFileName = debugLogFileName + "_" + std::to_string(nameSuffix);
		while (std::filesystem::exists(_debugLogFileName + ".log"s)) {
			nameSuffix++;
			_debugLogFileName = debugLogFileName + "_" + std::to_string(nameSuffix);
		}
		_debugLogFileName += ".log"s;
	}
	std::string getDebugFile() const {return _debugLogFileName;}
	void setRawMode(const bool& raw) {_raw = raw;}
	void endStartupLog() {
		_inStartupLog = false;
		logDebug(_startupLog);
		_startupLog.clear();
	}
	void setLogDebug(const bool& logDebug) {_logDebug = logDebug;}
	void log(const std::string&, const MessageType& = MessageType::NORMAL);
	void hr(const MessageType &type = MessageType::NORMAL) {
		log("-----------------------------------------------------------\n", type);
	}
	void logDebug(const std::string&);
};

#endif
