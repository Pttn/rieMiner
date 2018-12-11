// (c) 2018 Pttn (https://github.com/Pttn/rieMiner)
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
// Ascii                          ⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅⋅ !"#$%&'()*+,-./0123465789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}-⋅
static const std::string b58GmpBtcTable("000000000000000000000000000000000000000000000000123456789A0000000BCDEFGHJKLMNPQRSTUVWXYZabc000000defghijkmnopqrstuvwxyz000000000");
static const std::string b58BtcGmpTable("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz012345678zzzzzzz9ABCDEFGzHIJKLzMNOPQRSTUVWzzzzzzXYZabcdefghzijklmnopqrstuvzzzzz");

/*static std::string gmp58Tobtc58(const std::string &gmp58Str) {
	std::string btc58Str;
	for (uint64_t i(0) ; i < gmp58Str.size() ; i++) {
		if (b58GmpBtcTable[gmp58Str[i]] == '0') {
			std::cerr << __func__ << ": invalid Base58 (GMP) string!" << std::endl;
			return "1";
		}
		btc58Str += b58GmpBtcTable[gmp58Str[i]];
	}
	return btc58Str;
}*/

static std::string btc58Togmp58(const std::string &btc58Str) {
	std::string gmp58Str;
	for (uint64_t i(0) ; i < btc58Str.size() ; i++) {
		if (b58BtcGmpTable[btc58Str[i]] == 'z') {
			std::cerr << __func__ << ": invalid Base58 (Bitcoin) string!" << std::endl;
			return "0";
		}
		gmp58Str += b58BtcGmpTable[btc58Str[i]];
	}
	return gmp58Str;
}

/*static std::string v8ToB58Str(const std::vector<uint8_t> &v8) {
	mpz_class data;
	mpz_import(data.get_mpz_t(), v8.size(), 1, 1, 0, 0, v8.data());
	char c[255];
	mpz_get_str(c, 58, data.get_mpz_t());
	return gmp58Tobtc58(c);
}*/

static std::vector<uint8_t> b58StrToV8(const std::string &btc58Str) {
	mpz_class data(btc58Togmp58(btc58Str).c_str(), 58);
	size_t size((mpz_sizeinbase(data.get_mpz_t(), 2) + 7)/8);
	std::vector<uint8_t> v8(size);
	mpz_export(&v8[0], &size, 1, 1, 0, 0, data.get_mpz_t());
	return v8;
}

bool addrToScriptPubKey(const std::string &address, std::vector<uint8_t> &spk) {
	spk = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	const std::vector<uint8_t> addr(b58StrToV8(address));
	
	if (addr.size() != 25) {
		std::cerr << __func__ << ": invalid address length!" << std::endl;
		return false;
	}
	else {
		std::vector<uint8_t> addressHash(sha256sha256(addr.data(), 21));
		if (*((uint32_t*) &addr[21]) != *((uint32_t*) &addressHash[0])) {
			std::cerr << __func__ << ": invalid checksum!" << std::endl;
			return false;
		}
		else {
			for (uint8_t i(0) ; i < 20 ; i++) spk[i] = addr[i + 1];
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
