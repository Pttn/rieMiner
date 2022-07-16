// (c) 2018-2022 Pttn (https://riecoin.dev/en/rieMiner)
// (c) 2018 Michael Bell/Rockhawk (CPUID tools)

#include "tools.hpp"

std::random_device randomDevice;
uint8_t rand(uint8_t min, uint8_t max) {
	if (min > max) std::swap(min, max);
	std::uniform_int_distribution<uint8_t> urd(min, max);
	return urd(randomDevice);
}

std::vector<uint8_t> hexStrToV8(std::string str) {
	if (str.size() % 2 != 0) str = "0" + str;
	std::vector<uint8_t> v;
	for (std::string::size_type i(0) ; i < str.size() ; i += 2) {
		uint8_t byte;
		try {byte = std::stoll(str.substr(i, 2), nullptr, 16);}
		catch (...) {byte = 0;}
		v.push_back(byte);
	}
	return v;
}

std::vector<uint64_t> generatePrimeTable(const uint64_t limit) {
	if (limit < 2) return {};
	std::vector<uint64_t> compositeTable(limit/128ULL + 1ULL, 0ULL); // Booleans indicating whether an odd number is composite: 0000100100101100...
	for (uint64_t f(3ULL) ; f*f <= limit ; f += 2ULL) { // Eliminate f and its multiples m for odd f from 3 to square root of the limit
		if (compositeTable[f >> 7ULL] & (1ULL << ((f >> 1ULL) & 63ULL))) continue; // Skip if f is composite (f and its multiples were already eliminated)
		for (uint64_t m((f*f) >> 1ULL) ; m <= (limit >> 1ULL) ; m += f) // Start eliminating at f^2 (multiples of f below were already eliminated)
			compositeTable[m >> 6ULL] |= 1ULL << (m & 63ULL);
	}
	std::vector<uint64_t> primeTable(1, 2);
	for (uint64_t i(1ULL) ; (i << 1ULL) + 1ULL <= limit ; i++) { // Fill the prime table using the composite table
		if (!(compositeTable[i >> 6ULL] & (1ULL << (i & 63ULL))))
			primeTable.push_back((i << 1ULL) + 1ULL); // Add prime number 2i + 1
	}
	return primeTable;
}

constexpr std::array<uint8_t, 128> bech32Values = {
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	 15, 255,  10,  17,  21,  20,  26,  30,   7,   5, 255, 255, 255, 255, 255, 255,
	255,  29, 255,  24,  13,  25,   9,   8,  23, 255,  18,  22,  31,  27,  19, 255,
	  1,   0,   3,  16,  11,  28,  12,  14,   6,   4,   2, 255, 255, 255, 255, 255,
	255,  29, 255,  24,  13,  25,   9,   8,  23, 255,  18,  22,  31,  27,  19, 255,
	  1,   0,   3,  16,  11,  28,  12,  14,   6,   4,   2, 255, 255, 255, 255, 255
};

static std::vector<uint8_t> expandHrp(const std::string& hrp) {
	std::vector<uint8_t> expandedHrp(2*hrp.size() + 1, 0);
	for (uint8_t i(0) ; i < hrp.size() ; i++) {
		expandedHrp[i] = hrp[i] >> 5;
		expandedHrp[i + hrp.size() + 1] = hrp[i] & 31;
	}
	return expandedHrp;
}

static uint32_t bech32Polymod(const std::vector<uint8_t>& values) {
	const uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};
	uint32_t chk(1);
	for (uint8_t i(0) ; i < values.size() ; i++) {
		uint8_t b(chk >> 25);
		chk = ((chk & 0x1ffffff) << 5) ^ values[i];
		for (uint8_t j(0) ; j < 5 ; j++) {if (b & (1 << j)) chk ^= gen[j];}
	}
	return chk;
}

static std::vector<uint8_t> v5ToV8(const std::vector<uint8_t>& v5) {
	std::vector<uint8_t> v8;
    int acc(0), bits(0);
    const int maxv((1 << 8) - 1), max_acc((1 << (5 + 8 - 1)) - 1);
    for (const auto &d5 : v5) {
        int value = d5;
        acc = ((acc << 5) | value) & max_acc;
        bits += 5;
        while (bits >= 8) {
            bits -= 8;
            v8.push_back((acc >> bits) & maxv);
        }
    }
    if (bits >= 5 || ((acc << (8 - bits)) & maxv))
        return {};
    return v8;
}

std::vector<uint8_t> bech32ToScriptPubKey(const std::string &address) {
	if (address.size() < 6 || address.size() > 90)
		return {};
	const auto delimiterPos(address.find('1'));
	if (delimiterPos >= address.size() - 6)
		return {};
	std::string addrHrp(address.substr(0, delimiterPos)),
	            addrData(address.substr(delimiterPos + 1, address.size() - delimiterPos - 1));
	std::vector<uint8_t> v5;
	for (const auto &c : addrData) {
		const uint8_t d5(bech32Values[static_cast<uint8_t>(c)]);
		if (d5 == 255) return {};
		v5.push_back(d5);
	}
	std::vector<uint8_t> expHrpData(expandHrp(addrHrp));
	expHrpData.insert(expHrpData.end(), v5.begin(), v5.end());
	if (bech32Polymod(expHrpData) != 1)
		return {};
	std::vector<uint8_t> spk(v5ToV8(std::vector<uint8_t>(v5.begin() + 1, v5.end() - 6)));
	if ((spk.size() == 0 && addrData.size() != 6) || v5[0] > 16)
		return {};
	spk.insert(spk.begin(), spk.size());
	spk.insert(spk.begin(), v5[0] == 0 ? 0 : 80 + v5[0]);
	return spk;
}


#if defined(__x86_64__) || defined(__i586__)
#include <cpuid.h>
#define CPUID
#endif
#if defined(__linux__)
#include <sys/sysinfo.h>
#elif defined(_WIN32)
#include <sysinfoapi.h>
#endif

SysInfo::SysInfo() : _os("Unknown/Unsupported OS"), _cpuArchitecture("Unknown Architecture"), _cpuBrand("Unknown CPU"), _physicalMemory(0ULL), _avx(false), _avx2(false), _avx512(false) {
#if defined(__linux__)
	_os = "Linux";
	struct sysinfo si;
	if (sysinfo(&si) == 0)
		_physicalMemory = si.totalram;
#elif defined(_WIN32)
	_os = "Windows";
	MEMORYSTATUSEX statex;
	statex.dwLength = sizeof(statex);
	if (GlobalMemoryStatusEx(&statex) != 0)
		_physicalMemory = statex.ullTotalPhys;
#endif
#if defined(__x86_64__)
	_cpuArchitecture = "x64";
	_cpuBrand = "Unknown x64 CPU";
#elif defined(__i386__)
	_cpuArchitecture = "x86";
	_cpuBrand = "Unknown x86 CPU";
#elif defined(__aarch64__)
	_cpuArchitecture = "Arm64";
	_cpuBrand = "Unknown Arm64 CPU";
#elif defined(__arm__)
	_cpuArchitecture = "Arm";
	_cpuBrand = "Unknown Arm32 CPU";
#endif
#if defined(CPUID)
	if (__get_cpuid_max(0x80000004, nullptr)) {
		uint32_t brand[64];
		__get_cpuid(0x80000002, brand    , brand + 1, brand +  2, brand + 3);
		__get_cpuid(0x80000003, brand + 4, brand + 5, brand +  6, brand + 7);
		__get_cpuid(0x80000004, brand + 8, brand + 9, brand + 10, brand + 11);
		_cpuBrand = reinterpret_cast<char*>(brand);
	}
	
	uint32_t eax(0), ebx(0), ecx(0), edx(0);
	__get_cpuid(0, &eax, &ebx, &ecx, &edx);
	if (eax >= 7) {
		__get_cpuid(1, &eax, &ebx, &ecx, &edx);
		_avx = (ecx & (1 << 28)) != 0;
		// Must do this with inline assembly as __get_cpuid is unreliable for level 7 and __get_cpuid_count is not always available.
		//__get_cpuid_count(7, 0, &eax, &ebx, &ecx, &edx);
		uint32_t level(7), zero(0);
		asm ("cpuid\n\t"
		    : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
		    : "0"(level), "2"(zero));
		_avx2 = (ebx & (1 << 5)) != 0;
		_avx512 = (ebx & (1 << 16)) != 0;
	}
#endif
}
