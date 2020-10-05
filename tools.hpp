// (c) 2018-2020 Pttn (https://github.com/Pttn/rieMiner)
// (c) 2018 Michael Bell/Rockhawk (CPUID tools)

#ifndef HEADER_tools_hpp
#define HEADER_tools_hpp

#include <array>
#include <chrono>
#include <condition_variable>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <deque>
#include <iomanip>
#include <iostream>
#include <openssl/sha.h>
#include <random>
#include <sstream>
#include <string>
#include <vector>
#include <cpuid.h>
#include <gmpxx.h>

#define leading0s(x) std::setw(x) << std::setfill('0')
#define FIXED(x) std::fixed << std::setprecision(x)

enum AddressFormat {INVALID, P2PKH, P2SH, BECH32};

uint8_t rand(uint8_t, uint8_t);

std::array<uint8_t, 32> v8ToA8(std::vector<uint8_t>);
std::vector<uint8_t> a8ToV8(std::array<uint8_t, 32>);

inline std::vector<uint8_t> reverse(const std::vector<uint8_t> &v0) {
	std::vector<uint8_t> v;
	for (uint8_t i(0) ; i < v0.size() ; i++) v.push_back(v0[v0.size() - i - 1]);
	return v;
}

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

inline uint64_t decodeCompact(uint32_t nCompact) { // Bitcoin Core's arith_uint256::SetCompact for UInt64_Ts
	const uint64_t nSize(nCompact >> 24), nWord(nCompact & 0x007fffff);
	if (nSize <= 3) return nWord >> (8ULL*(3ULL - nSize));
	else return nWord << (8ULL*(nSize - 3ULL));
}

// Get address type (P2PKH, P2SH, Bech32), no proper support for Bech32 currently
AddressFormat addressFormatOf(const std::string&);
// Convert address to ScriptPubKey used for building the Coinbase Transaction
bool addrToScriptPubKey(const std::string&, std::vector<uint8_t>&, bool = true);
bool bech32ToScriptPubKey(const std::string&, std::vector<uint8_t>&, bool = true);
// Calculate Merkle Root from a list of transactions
std::array<uint8_t, 32> calculateMerkleRoot(const std::vector<std::array<uint8_t, 32>>&);
std::array<uint8_t, 32> calculateMerkleRootStratum(const std::vector<std::array<uint8_t, 32>>&);

inline double timeSince(const std::chrono::time_point<std::chrono::steady_clock> &t0) {
	const std::chrono::time_point<std::chrono::steady_clock> t(std::chrono::steady_clock::now());
	const std::chrono::duration<double> dt(t - t0);
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
	const std::vector<uint8_t> hash(sha256(data, len));
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
	std::string _brand;
	bool _avx, _avx2, _avx512;
public:
	CpuID();
	std::string getBrand() const {return _brand;}
	bool hasAVX() const {return _avx;}
	bool hasAVX2() const {return _avx2;}
	bool hasAVX512() const {return _avx512;}
};

template<class T> class TsQueue {
	std::deque<T> _q;
	std::mutex _m;
	std::condition_variable _cv;
public:
	void push_back(T item) {
		std::unique_lock<std::mutex> lock(_m);
		_q.push_back(item);
		_cv.notify_one();
	}
	void push_front(T item) {
		std::unique_lock<std::mutex> lock(_m);
		_q.push_front(item);
		_cv.notify_one();
	}
	T blocking_pop_front() { // Blocks until an item is available to pop
		std::unique_lock<std::mutex> lock(_m);
		while (_q.empty())
			_cv.wait(lock);
		auto r(_q.front());
		_q.pop_front();
		return r;
	}
	bool try_pop_front(T& item) { // Pops the front and returns true if the queue isn't empty else returns false.
		std::lock_guard<std::mutex> lock(_m);
		if (_q.empty()) return false;
		item = _q.front();
		_q.pop_front();
		return true;
	}
	typename std::deque<T>::size_type clear() { // Nonblocking - clears queue, returns number of items removed
		std::unique_lock<std::mutex> lock(_m);
		auto s(_q.size());
		_q.clear();
		return s;
	}
	uint32_t size() {
		std::unique_lock<std::mutex> lock(_m);
		return _q.size();
	}
};

#endif
