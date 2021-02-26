// (c) 2018-2020 Pttn (https://github.com/Pttn/rieMiner)

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

std::vector<uint32_t> generatePrimeTable(const uint32_t limit) {
	if (limit < 2) return {};
	std::vector<uint64_t> compositeTable((limit + 127ULL)/128ULL, 0ULL); // Booleans indicating whether an odd number is composite: 0000100100101100...
	for (uint64_t f(3ULL) ; f*f <= limit ; f += 2ULL) { // Eliminate f and its multiples m for odd f from 3 to square root of the limit
		if (compositeTable[f >> 7ULL] & (1ULL << ((f >> 1ULL) & 63ULL))) continue; // Skip if f is composite (f and its multiples were already eliminated)
		for (uint64_t m((f*f) >> 1ULL) ; m <= (limit >> 1ULL) ; m += f) // Start eliminating at f^2 (multiples of f below were already eliminated)
			compositeTable[m >> 6ULL] |= 1ULL << (m & 63ULL);
	}
	std::vector<uint32_t> primeTable(1, 2);
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
	else {
		std::string addrHrp, addrData;
		if (address.substr(0, 4) == "ric1") {
			addrHrp  = "ric";
			addrData = address.substr(4, address.size() - 4);
		}
		else if (address.substr(0, 5) == "tric1") {
			addrHrp  = "tric";
			addrData = address.substr(5, address.size() - 5);
		}
		else return {};
		if (addrData.size() < 6) return {};
		std::vector<uint8_t> v5;
		for (const auto &c : addrData) {
			const uint8_t d5(bech32Values[static_cast<uint8_t>(c)]);
			if (d5 == 255) return {};
			v5.push_back(d5);
		}
		std::vector<uint8_t> expHrpData(expandHrp(addrHrp));
		expHrpData.insert(expHrpData.end(), v5.begin(), v5.end());
		if (bech32Polymod(expHrpData) != 1) return {};
		else {
			std::vector<uint8_t> spk(v5ToV8(std::vector<uint8_t>(v5.begin() + 1, v5.end() - 6)));
			if ((spk.size() == 0 && addrData.size() != 6) || v5[0] > 16) return {};
			spk.insert(spk.begin(), spk.size());
			spk.insert(spk.begin(), v5[0] == 0 ? 0 : 80 + v5[0]);
			return spk;
		}
	}
}
