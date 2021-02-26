// (c) 2018-2020 Pttn (https://github.com/Pttn/rieMiner)

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
#include <gmpxx.h>

#define leading0s(x) std::setw(x) << std::setfill('0')
#define FIXED(x) std::fixed << std::setprecision(x)

uint8_t rand(uint8_t, uint8_t);

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
template <class C> std::string formatContainer(const C& container) {
	std::ostringstream oss;
	for (auto it(container.begin()) ; it < container.end() ; it++) {
		oss << *it;
		if (it != container.end() - 1) oss << ", ";
	}
	return oss.str();
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

std::vector<uint32_t> generatePrimeTable(const uint32_t);

// Bech32 Code adapted from the reference C++ implementation, https://github.com/sipa/bech32/tree/master/ref/c%2B%2B
std::vector<uint8_t> bech32ToScriptPubKey(const std::string&);

inline double timeSince(const std::chrono::time_point<std::chrono::steady_clock> &t0) {
	const std::chrono::time_point<std::chrono::steady_clock> t(std::chrono::steady_clock::now());
	const std::chrono::duration<double> dt(t - t0);
	return dt.count();
}

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
