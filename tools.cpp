// (c) 2018-2019 Pttn (https://github.com/Pttn/rieMiner)
// (c) 2018 Michael Bell/Rockhawk (CPUID tools)

#include "tools.hpp"

std::default_random_engine eng((std::random_device())());

uint8_t rand(uint8_t min, uint8_t max) {
	if (min > max) std::swap(min, max);
	std::uniform_int_distribution<uint8_t> urd(min, max);
	return urd(eng);
}
std::array<uint8_t, 32> v8ToA8(std::vector<uint8_t> v8) {
	std::array<uint8_t, 32> a8;
	for (uint8_t i(0) ; i < 32 ; i++) {
		if (i < v8.size()) a8[i] = v8[i];
		else a8[i] = 0;
	}
	return a8;
}

std::vector<uint8_t> a8ToV8(std::array<uint8_t, 32> a8) {
	std::vector<uint8_t> v8;
	for (uint8_t i(0) ; i < 32 ; i++) v8.push_back(a8[i]);
	return v8;
}

std::vector<uint8_t> hexStrToV8(std::string str) {
	if (str.size() % 2 != 0) str = "0" + str;
	std::vector<uint8_t> v;
	
	for (uint16_t i(0) ; i < str.size() ; i += 2) {
		uint8_t byte(0);
		for (uint8_t j(0) ; j < 2 ; j++) {
			uint8_t m(1);
			if (j == 0) m = 16;
			if (str[i + j] >= '0' && str[i + j] <= '9')
				byte += m*(str[i + j] - '0');
			else if (str[i + j] >= 'A' && str[i + j] <= 'F')
				byte += m*(str[i + j] - 'A' + 10);
			else if (str[i + j] >= 'a' && str[i + j] <= 'f')
				byte += m*(str[i + j] - 'a' + 10);
			else byte += 0;
		}
		v.push_back(byte);
	}
	return v;
}

// GMP base 58 digits    : 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuv
// Bitcoin base 58 digits: 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz
// GMP base 32 digits    : 0123456789ABCDEFGHIJKLMNOPQRSTUV
// Bitcoin Bech32 digits : qpzry9x8gf2tvdw0s3jn54khce6mua7l
// Ascii                                 ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}-⋅
//static const std::string b58GmpBtcTable("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!123456789A!!!!!!!BCDEFGHJKLMNPQRSTUVWXYZabc!!!!!!defghijkmnopqrstuvwxyz!!!!!!!!!");
static const std::string b58BtcGmpTable("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!012345678!!!!!!!9ABCDEFG!HIJKL!MNOPQRSTUVW!!!!!!XYZabcdefgh!ijklmnopqrstuv!!!!!");
//static const std::string b32GmpBtcTable("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!qpzry9x8gf!!!!!!!2tvdw0s3jn54khce6mua7l!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
static const std::string b32BtcGmpTable("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!F!AHLKQU75!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!T!ODP98N!IMVRJ!103GBSCE642!!!!!");
const uint8_t bech32Values[128] = {
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
	 15, 255,  10,  17,  21,  20,  26,  30,   7,   5, 255, 255, 255, 255, 255, 255,
	255,  29, 255,  24,  13,  25,   9,   8,  23, 255,  18,  22,  31,  27,  19, 255,
	  1,   0,   3,  16,  11,  28,  12,  14,   6,   4,   2, 255, 255, 255, 255, 255,
	255,  29, 255,  24,  13,  25,   9,   8,  23, 255,  18,  22,  31,  27,  19, 255,
	  1,   0,   3,  16,  11,  28,  12,  14,   6,   4,   2, 255, 255, 255, 255, 255
};

static std::vector<uint8_t> btcStrToV8(const std::string &btcStr, const std::string &convTable, uint8_t base) {
	std::string gmpStr;
	for (uint64_t i(0) ; i < btcStr.size() ; i++) {
		if (convTable[btcStr[i]] == '!') return {};
		gmpStr += convTable[btcStr[i]];
	}
	
	mpz_class data(gmpStr.c_str(), base);
	size_t size((mpz_sizeinbase(data.get_mpz_t(), 2) + 7)/8);
	std::vector<uint8_t> v8(size);
	mpz_export(&v8[0], &size, 1, 1, 0, 0, data.get_mpz_t());
	return v8;
}

AddressFormat addressFormatOf(const std::string &address) {
	std::vector<uint8_t> spk;
	if (addrToScriptPubKey(address, spk, false)) {
		if (address[0] == 'R' || address[0] == 'r')
			return AddressFormat::P2PKH;
		else if (address[0] == 'T' || address[0] == 't')
			return AddressFormat::P2SH;
	}
	else if (bech32ToScriptPubKey(address, spk, false))
		return AddressFormat::BECH32;
	return AddressFormat::INVALID;
}

bool addrToScriptPubKey(const std::string &address, std::vector<uint8_t> &spk, bool verbose) {
	spk = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	const std::vector<uint8_t> addr(btcStrToV8(address, b58BtcGmpTable, 58));
	
	if (addr.size() != 25) {
		if (verbose) std::cerr << __func__ << ": invalid address length!" << std::endl;
		return false;
	}
	else {
		std::vector<uint8_t> addressHash(sha256sha256(addr.data(), 21));
		if (*((uint32_t*) &addr[21]) != *((uint32_t*) &addressHash[0])) {
			if (verbose) std::cerr << __func__ << ": invalid checksum!" << std::endl;
			return false;
		}
		else {
			for (uint8_t i(0) ; i < 20 ; i++) spk[i] = addr[i + 1];
		}
	}
	return true;
}

static std::vector<uint8_t> expandHrp(const std::string& hrp) {
	std::vector<uint8_t> expandedHrp(2*hrp.size() + 1, 0);
	for (uint8_t i(0) ; i < hrp.size() ; i++) {
		expandedHrp[i] = hrp[i] >> 5;
		expandedHrp[i + hrp.size() + 1] = hrp[i] & 31;
	}
	return expandedHrp;
}

static uint32_t bech32Polymod(const std::vector<uint8_t>& values) {
	uint32_t gen[5] = {0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3};
	uint32_t chk(1);
	for (uint8_t i(0) ; i < values.size() ; i++) {
		uint8_t b(chk >> 25);
		chk = ((chk & 0x1ffffff) << 5) ^ values[i];
		for (uint8_t j(0) ; j < 5 ; j++) {if (b & (1 << j)) chk ^= gen[j];}
	}
	return chk;
}

bool bech32ToScriptPubKey(const std::string &address, std::vector<uint8_t> &spk, bool verbose) {
	spk = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; // For now only supports 20 bytes ScriptPubKeys
	if (address.size() < 15) {
		if (verbose) std::cerr << __func__ << ": invalid address length!" << std::endl;
		return false;
	}
	else {
		std::string addrHrp, addrData;
		if (address.substr(0, 4) == "ric1" && address.size() == 43) {
			addrHrp  = "ric";
			addrData = address.substr(4, address.size() - 4);
		}
		else if (address.substr(0, 5) == "tric1" && address.size() == 44) {
			addrHrp  = "tric";
			addrData = address.substr(5, address.size() - 5);
		}
		else {
			if (verbose) std::cerr << __func__ << ": invalid address prefix or length!" << std::endl;
			return false;
		}
		if (bech32Values[(uint8_t) address[addrHrp.size() + 1]] != 0) {
			if (verbose) std::cerr << __func__ << ": only witness version 0 adresses are supported for now." << std::endl;
			return false;
		}
		std::vector<uint8_t> values;
		for (uint8_t i(addrHrp.size() + 1) ; i < address.size() ; i++) {
			uint8_t v(bech32Values[(uint8_t) address[i]]);
			if (v == 255) {
				if (verbose) std::cerr << __func__ << ": invalid character " << address[i] << "!" << std::endl;
				return false;
			}
			values.push_back(v);
		}
		std::vector<uint8_t> expHrpData(expandHrp(addrHrp));
		expHrpData.insert(expHrpData.end(), values.begin(), values.end());
		if (bech32Polymod(expHrpData) != 1) {
			if (verbose) std::cerr << __func__ << ": invalid checksum!" << std::endl;
			return false;
		}
		else {
			const std::vector<uint8_t> data(btcStrToV8(address.substr(addrHrp.size() + 2, address.size() - addrHrp.size() - 8), b32BtcGmpTable, 32));
			for (uint8_t i(0) ; i < std::min((int) data.size(), 20) ; i++) // For leading zeroes
				spk[20 - i - 1] = data[data.size() - i - 1];
		}
	}
	return true;
}

std::array<uint8_t, 32> calculateMerkleRoot(const std::vector<std::array<uint8_t, 32>> &txHashes) {
	std::array<uint8_t, 32> merkleRoot{};
	if (txHashes.size() == 0)
		std::cerr << __func__ << ": no transaction to hash!" << std::endl;
	else if (txHashes.size() == 1)
		return txHashes[0];
	else {
		std::vector<std::array<uint8_t, 32>> txHashes2;
		
		for (uint32_t i(0) ; i < txHashes.size() ; i += 2) {
			uint8_t concat[64];
			for (uint32_t j(0) ; j < 32 ; j++) concat[j] = txHashes[i][j];
			if (i == txHashes.size() - 1) { // Concatenation of the last element with itself for an odd number of transactions
				for (uint32_t j(0) ; j < 32 ; j++) concat[j + 32] = txHashes[i][j];
			}
			else {
				for (uint32_t j(0) ; j < 32 ; j++) concat[j + 32] = txHashes[i + 1][j];
			}
			
			txHashes2.push_back(v8ToA8(sha256sha256((uint8_t*) concat, 64)));
		}
		// Process the next step
		merkleRoot = calculateMerkleRoot(txHashes2);
	}
	return merkleRoot;
}

std::array<uint8_t, 32> calculateMerkleRootStratum(const std::vector<std::array<uint8_t, 32>> &txHashes) {
	std::array<uint8_t, 32> merkleRoot{};
	if (txHashes.size() == 0)
		std::cerr << __func__ << ": no transaction to hash!";
	else if (txHashes.size() == 1)
		return txHashes[0];
	else {
		std::vector<uint8_t> hashData(64, 0), hashTmp;
		for (uint32_t i(0) ; i < 32 ; i++) hashData[i] = txHashes[0][i];
		for (uint32_t i(1) ; i < txHashes.size() ; i++) {
			for (uint32_t j(32) ; j < 64 ; j++) hashData[j] = txHashes[i][j - 32];
			hashTmp = sha256sha256(hashData.data(), 64);
			for (uint32_t j(0) ; j < 32 ; j++) hashData[j] = hashTmp[j];
		}
		for (uint32_t i(0) ; i < 32 ; i++) merkleRoot[i] = hashData[i];
	}
	return merkleRoot;
}

CpuID::CpuID() {
	uint32_t eax(0), ebx(0), ecx(0), edx(0);
	__get_cpuid(0, &eax, &ebx, &ecx, &edx);
	if (eax < 7) {
		_avx = false;
		_avx2 = false;
		_avx512 = false;
	}
	else {
		__get_cpuid(1, &eax, &ebx, &ecx, &edx);
		_avx = (ecx & (1 << 28)) != 0;

		// Must do this with inline assembly as __get_cpuid is unreliable for level 7
		// and __get_cpuid_count is not always available.
		//__get_cpuid_count(7, 0, &eax, &ebx, &ecx, &edx);
		uint32_t level(7), zero(0);
		asm ("cpuid\n\t"
		    : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
		    : "0"(level), "2"(zero));
		_avx2 = (ebx & (1 << 5)) != 0;
		_avx512 = (ebx & (1 << 16)) != 0;
	}
}
