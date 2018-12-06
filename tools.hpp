// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)
// (c) 2018 Michael Bell/Rockhawk (CPUID tools)

#ifndef HEADER_tools_hpp
#define HEADER_tools_hpp

#include <iostream>
#include <cstdio>
#include <cstdint>
#include <cstring>
#include <string>
#include <sstream>
#include <iomanip>
#include <array>
#include <vector>
#include <chrono>
#include <openssl/sha.h>
#include <random>
#include <gmpxx.h>
#include <cpuid.h>

inline std::string v8ToHexStr(const std::vector<uint8_t> &v) {
	std::ostringstream oss;
	for (uint32_t i(0) ; i < v.size() ; i++)
		oss << std::setfill('0') << std::setw(2) << std::hex << (uint32_t) v[i];
	return oss.str();
}

inline std::string binToHexStr(const void* p, uint32_t len) {
	std::vector<uint8_t> v;
	for (uint32_t i(0) ; i < len ; i++) v.push_back(((uint8_t*) p)[i]);
	return v8ToHexStr(v);
}

std::vector<uint8_t> hexStrToV8(std::string);
inline void hexStrToBin(std::string str, uint8_t* data) {
	const std::vector<uint8_t> v(hexStrToV8(str));
	for (uint16_t i(0) ; i < v.size() ; i++) data[i] = v[i];
}

inline uint32_t getCompact(uint32_t nCompact) {
	const uint32_t nSize(nCompact >> 24), nWord(nCompact & 0x007fffff);
	if (nSize <= 3) return nWord >> 8*(3 - nSize);
	else return nWord << 8*(nSize - 3); // warning: this has problems if difficulty (uncompacted) ever goes past the 2^32 boundary
}

// Convert address to ScriptPubKey used for building the Coinbase Transaction
bool addrToScriptPubKey(const std::string&, std::vector<uint8_t>&);
// Calculate Merkle Root from a list of transactions
std::array<uint8_t, 32> calculateMerkleRoot(const std::vector<std::array<uint8_t, 32>>&);
std::array<uint8_t, 32> calculateMerkleRootStratum(const std::vector<std::array<uint8_t, 32>>&);
uint8_t rand(uint8_t, uint8_t);

inline double timeSince(const std::chrono::time_point<std::chrono::system_clock> &t0) {
	std::chrono::time_point<std::chrono::system_clock> t(std::chrono::system_clock::now());
	std::chrono::duration<double> dt(t - t0);
	return dt.count();
}

inline std::vector<uint8_t> sha256(const uint8_t *data, uint32_t len) {
	std::vector<uint8_t> hash;
	uint8_t hashTmp[32];
	SHA256_CTX sha256;
	SHA256_Init(&sha256);
	SHA256_Update(&sha256, data, len);
	SHA256_Final(hashTmp, &sha256);
	for (uint8_t i(0) ; i < 32 ; i++) hash.push_back(hashTmp[i]);
	return hash;
}

inline std::vector<uint8_t> sha256sha256(const uint8_t *data, uint32_t len) {
	std::vector<uint8_t> hash(sha256(data, len));
	return sha256(hash.data(), 32);
}

// Reverse the Endianness of a uint32_t (ABCDEF01 -> 01EFCDAB)
inline uint32_t invEnd32(uint32_t x) {
	return ((x << 24) & 0xff000000u) | ((x << 8) & 0x00ff0000u) | ((x >> 8) & 0x0000ff00u) | ((x >> 24) & 0x000000ffu);
}

// Convert a uint32_t to Big Endian (ABCDEF01 -> 01EFCDAB in a Little Endian system, do nothing in a Big Endian system)
inline uint32_t toBEnd32(uint32_t n) {
	const uint8_t *tmp((uint8_t*) &n);
	return (uint32_t) tmp[3] | ((uint32_t) tmp[2]) << 8 | ((uint32_t) tmp[1]) << 16 | ((uint32_t) tmp[0]) << 24;
}

class CpuID {
	bool _avx, _avx2, _avx512, _intel;
	
public:
	CpuID();
	
	bool hasAVX() const {return _avx;}
	bool hasAVX2() const {return _avx2;}
	bool hasAVX512() const {return _avx512;}
	bool isIntel() const {return _intel;}
};

#endif
