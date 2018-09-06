/* Some parts taken from fastrie by dave-andersen (https://github.com/dave-andersen/fastrie).
(c) 2014-2017 dave-andersen (http://www.cs.cmu.edu/~dga/)
(c) 2018 Pttn (https://github.com/Pttn/rieMiner) */

#include "tools.h"

std::string binToHexStr(const void* p, uint32_t len) {
	std::ostringstream oss;
	for (uint32_t i(0) ; i < len ; i++)
		oss << std::setfill('0') << std::setw(2) << std::hex << (uint32_t) ((uint8_t*) p)[i];
	return oss.str();
}

void hexStrToBin(std::string str, uint8_t* data) {
	if (str.size() % 2 != 0) str = "0" + str;
	
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
		data[i/2] = byte;
	}
}

uint32_t getCompact(uint32_t nCompact) {
	uint32_t p;
	unsigned int nSize = nCompact >> 24;
	//bool fNegative     =(nCompact & 0x00800000) != 0;
	unsigned int nWord = nCompact & 0x007fffff;
	if (nSize <= 3) {
		nWord >>= 8*(3 - nSize);
		p = nWord;
	}
	else {
		p = nWord;
		p <<= 8*(nSize - 3); // warning: this has problems if difficulty (uncompacted) ever goes past the 2^32 boundary
	}
	return p;
}

const int8_t base58Decode[] = {
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
	-1, 0, 1, 2, 3, 4, 5, 6, 7, 8,-1,-1,-1,-1,-1,-1,
	-1, 9,10,11,12,13,14,15,16,-1,17,18,19,20,21,-1,
	22,23,24,25,26,27,28,29,30,31,32,-1,-1,-1,-1,-1,
	-1,33,34,35,36,37,38,39,40,41,42,43,-1,44,45,46,
	47,48,49,50,51,52,53,54,55,56,57,-1,-1,-1,-1,-1,
};

bool decodeBase58(char* base58Input, int inputLength, uint8_t* dataOut, int* dataOutLength) {
	if (inputLength == 0) return false;
	if (inputLength > 200) return false;
	uint32_t baseArray[32], baseTrack[32];
	memset(baseArray, 0x00, sizeof(baseArray));
	memset(baseTrack, 0x00, sizeof(baseTrack));
	uint32_t baseArraySize(1);
	baseArray[0] = 0;
	baseTrack[0] = 57;
	// Calculate exact size of output
	for(int i(0) ; i < inputLength - 1 ; i++) {
		// Multiply baseTrack with 58
		for(int b(baseArraySize - 1) ; b >= 0 ; b--) {
			uint64_t multiplyWithCarry((uint64_t) baseTrack[b] * 58ULL);
			baseTrack[b] = (uint32_t) (multiplyWithCarry & 0xFFFFFFFFUL);
			multiplyWithCarry >>= 32;
			if (multiplyWithCarry != 0) {
				// Add carry
				for (uint32_t carryIndex = b + 1 ; carryIndex < baseArraySize ; carryIndex++) {
					multiplyWithCarry += (uint64_t) baseTrack[carryIndex];
					baseTrack[carryIndex] = (uint32_t) (multiplyWithCarry & 0xFFFFFFFFUL);
					multiplyWithCarry >>= 32;
					if (multiplyWithCarry == 0)
						break;
				}
				if (multiplyWithCarry) {
					// Extend
					baseTrack[baseArraySize] = (uint32_t) multiplyWithCarry;
					baseArraySize++;
				}
			}
		}
	}
	// Get length of output data
	int outputLength(0);
	uint64_t last(baseTrack[baseArraySize - 1]);
	if (last & 0xFF000000)    outputLength = baseArraySize*4;
	else if (last & 0xFF0000) outputLength = baseArraySize*4 - 1;
	else if (last & 0xFF00)   outputLength = baseArraySize*4 - 2;
	else                      outputLength = baseArraySize*4 - 3;
	// Convert base
	for(int i(0) ; i < inputLength; i++) {
		if (base58Input[i] >= (int32_t) (sizeof(base58Decode)/sizeof(base58Decode[0])))
			return false;
		int8_t digit = base58Decode[(uint8_t) base58Input[i]];
		if (digit == -1) return false;
		//Multiply baseArray with 58
		for(int b(baseArraySize - 1) ; b >= 0 ; b--) {
			uint64_t multiplyWithCarry((uint64_t) baseArray[b]*58ULL);
			baseArray[b] = (uint32_t) (multiplyWithCarry & 0xFFFFFFFFUL);
			multiplyWithCarry >>= 32;
			if (multiplyWithCarry != 0) {
				// Add carry
				for (uint32_t carryIndex(b + 1) ; carryIndex < baseArraySize ; carryIndex++) {
					multiplyWithCarry += (uint64_t) baseArray[carryIndex];
					baseArray[carryIndex] = (uint32_t) (multiplyWithCarry & 0xFFFFFFFFUL);
					multiplyWithCarry >>= 32;
					if (multiplyWithCarry == 0) break;
				}
				if (multiplyWithCarry) {
					// Extend
					baseArray[baseArraySize] = (uint32_t) multiplyWithCarry;
					baseArraySize++;
				}
			}
		}
		// Add base58 digit to baseArray with carry
		uint64_t addWithCarry((uint64_t) digit);
		for(uint32_t b(0) ; addWithCarry != 0 && b < baseArraySize ; b++) {
			addWithCarry += (uint64_t) baseArray[b];
			baseArray[b] = (uint32_t) (addWithCarry & 0xFFFFFFFFUL);
			addWithCarry >>= 32;
		}
		if (addWithCarry) {
			// Extend
			baseArray[baseArraySize] = (uint32_t) addWithCarry;
			baseArraySize++;
		}
	}
	*dataOutLength = outputLength;
	// Write bytes
	for (int i(0) ; i < outputLength ; i++)
		dataOut[outputLength-i-1] = (uint8_t) (baseArray[i >> 2] >> 8*(i & 3));
	return true;
}

bool addrToScriptPubKey(std::string address, uint8_t* spk) {
	char* walletAddress(const_cast<char*>(address.c_str()));
	uint8_t hexAddr[256];
	int32_t hexAddrLen = sizeof(hexAddr);
	if (decodeBase58(walletAddress, strlen(walletAddress), hexAddr, &hexAddrLen) == false) {
		std::cerr << "AddrToScriptPubKey: failed to decode wallet address!" << std::endl;
		memset(spk, 0, 20);
		return false;
	}
	if (hexAddrLen != 25) {
		std::cerr << "AddrToScriptPubKey: invalid length of decoded address!" << std::endl;
		memset(spk, 0, 20);
		return false;
	}
	// Validate checksum
	uint8_t addressHash[32];
	{
		sha256(hexAddr, addressHash, hexAddrLen - 4);
		sha256(addressHash, addressHash, 32);
	}
	if (*(uint32_t*) (hexAddr + 21) != *(uint32_t*) addressHash) {
		std::cerr << "AddrToScriptPubKey: invalid checksum!" << std::endl;
		memset(spk, 0, 20);
		return false;
	}
	
	memcpy(spk, &hexAddr[1], 20);
	return true;
}

std::array<uint32_t, 8> calculateMerkleRoot(std::vector<std::array<uint32_t, 8>> txHashes) {
	std::array<uint32_t, 8> merkleRoot = {0, 0, 0, 0, 0, 0, 0, 0};
	if (txHashes.size() == 0)
		std::cerr << "CalculateMerkleRoot: no transaction to hash!" << std::endl;
	else if (txHashes.size() == 1)
		return txHashes[0];
	else {
		std::vector<std::array<uint32_t, 8>> txHashes2;
		
		for (uint32_t i(0) ; i < txHashes.size() ; i += 2) {
			uint32_t concat[16];
			for (uint32_t j(0) ; j < 8 ; j++)
				concat[j] = txHashes[i][j];
			if (i == txHashes.size() - 1) { // Concatenation of the last element with itself for an odd number of transactions
				for (uint32_t j(0) ; j < 8 ; j++)
					concat[j + 8] = txHashes[i][j];
			}
			else {
				for (uint32_t j(0) ; j < 8 ; j++)
					concat[j + 8] = txHashes[i + 1][j];
			}
			
			uint8_t concatHash[32];
			sha256((uint8_t*) concat, concatHash, 64);
			sha256(concatHash, concatHash, 32);
			std::array<uint32_t, 8> concatHash2;
			for (uint32_t j(0) ; j < 8 ; j++) concatHash2[j] = ((uint32_t*) concatHash)[j];
			txHashes2.push_back(concatHash2);
		}
		// Process the next step
		merkleRoot = calculateMerkleRoot(txHashes2);
	}
	return merkleRoot;
}
