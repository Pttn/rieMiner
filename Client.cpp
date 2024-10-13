// (c) 2017-present Pttn (https://riecoin.xyz/rieMiner)

#include "Client.hpp"
#include "Stella.hpp"

double decodeBits(const uint32_t nBits, const int32_t powVersion) {
	if (powVersion == 1)
		return static_cast<double>(nBits)/256.;
	else
		logger.log("Unexpected PoW Version "s + std::to_string(powVersion) + "\n"s, MessageType::ERROR);
	return 1.;
}

std::vector<uint8_t> BlockHeader::toV8() const {
	std::vector<uint8_t> v8;
	for (uint32_t i(0) ; i < 4 ; i++) v8.push_back(reinterpret_cast<const uint8_t*>(&version)[i]);
	v8.insert(v8.end(), previousblockhash.begin(), previousblockhash.end());
	v8.insert(v8.end(), merkleRoot.begin(), merkleRoot.end());
	for (uint32_t i(0) ; i < 8 ; i++) v8.push_back(reinterpret_cast<const uint8_t*>(&curtime)[i]);
	for (uint32_t i(0) ; i < 4 ; i++) v8.push_back(reinterpret_cast<const uint8_t*>(&bits)[i]);
	v8.insert(v8.end(), nOffset.begin(), nOffset.end());
	return v8;
}

mpz_class BlockHeader::target(const int32_t powVersion) const {
	const uint32_t difficultyIntegerPart(decodeBits(bits, powVersion));
	uint32_t trailingZeros;
	const std::array<uint8_t, 32> hash(sha256sha256(toV8().data(), 80));
	mpz_class target;
	if (powVersion == 1) {
		if (difficultyIntegerPart < 264U) return 0;
		const uint32_t df(bits & 255U);
		target = 256 + ((10U*df*df*df + 7383U*df*df + 5840720U*df + 3997440U) >> 23U);
		target <<= 256;
		mpz_class hashGmp;
		mpz_import(hashGmp.get_mpz_t(), 32, -1, sizeof(uint8_t), 0, 0, hash.begin());
		target += hashGmp;
		trailingZeros = difficultyIntegerPart - 264U;
		target <<= trailingZeros;
	}
	else
		logger.log("Unexpected PoW Version "s + std::to_string(powVersion) + "\n"s, MessageType::ERROR);
	return target;
}

std::array<uint8_t, 32> encodedOffset(const Stella::Result &result) {
	std::array<uint8_t, 32> nOffset;
	for (auto &byte : nOffset) byte = 0;
	// [31-30 Primorial Number|29-14 Primorial Factor|13-2 Primorial Offset|1-0 Reserved/Version]
	*reinterpret_cast<uint16_t*>(&nOffset.data()[ 0]) = 2;
	*reinterpret_cast<uint64_t*>(&nOffset.data()[ 2]) = result.primorialOffset; // Only 64 bits used out of 96
	*reinterpret_cast<uint64_t*>(&nOffset.data()[14]) = result.primorialFactor; // Only 64 bits used out of 128
	*reinterpret_cast<uint16_t*>(&nOffset.data()[30]) = result.primorialNumber;
	return nOffset;
}

std::vector<uint64_t> Client::choosePatterns(const std::vector<std::vector<uint64_t>>& acceptedPatterns, const std::vector<uint64_t>& givenPattern) {
	logger.log("Accepted constellation pattern(s):\n"s);
	if (acceptedPatterns.size() == 0) {
		logger.log("\tNone - something went wrong :|\n"s, MessageType::ERROR);
		return {};
	}
	else {
		bool accepted(false);
		for (uint16_t i(0) ; i < acceptedPatterns.size() ; i++) {
			logger.log("\t"s + std::to_string(i) + " - "s + Stella::formatContainer(acceptedPatterns[i]));
			bool compatible(true);
			for (uint16_t j(0) ; j < acceptedPatterns[i].size() ; j++) {
				const auto offset(acceptedPatterns[i][j]);
				if (j >= givenPattern.size() ? true : offset != givenPattern[j])
					compatible = false;
			}
			if (compatible) {
				logger.log(" <- compatible"s);
				accepted = true;
			}
			logger.log("\n"s);
		}
		if (!accepted) {
			const uint16_t patternIndex(rand(0, acceptedPatterns.size() - 1));
			logger.log("None or not compatible one specified, choosing a random one: pattern "s + std::to_string(patternIndex) + "\n");
			return acceptedPatterns[patternIndex];
		}
		else
			return givenPattern;
	}
}

void BMClient::process() {
	std::lock_guard<std::mutex> lock(_jobMutex);
	if (_height != 0 && _blockInterval > 0. && Stella::timeSince(_timer) >= _blockInterval) {
		_height++;
		_requests = 0;
		_timer = std::chrono::steady_clock::now();
	}
}

std::optional<ClientInfo> BMClient::info() const {
	return ClientInfo{
		.height = _height,
		.powVersion = 1,
		.acceptedPatterns = {_pattern},
		.patternMin = std::vector<bool>(_pattern.size(), true),
		.primeCountTarget = static_cast<uint16_t>(_pattern.size()),
		.primeCountMin = static_cast<uint16_t>(_pattern.size()),
		.difficulty = _difficulty,
		.targetOffsetBits = static_cast<uint32_t>(std::round(65536.*_difficulty)/65536ULL - 80ULL)
	};
}

std::optional<Stella::Job> BMClient::getJob() {
	std::lock_guard<std::mutex> lock(_jobMutex);
	if (_height == 0) {
		_height = 1;
		_timer = std::chrono::steady_clock::now();
	}
	Stella::Job job;
	// Target: (in binary) 1 . Leading Digits L (16 bits) . Height (32 bits) . Requests (32 bits) . (Difficulty - 80) zeros = 2^(Difficulty - 80)(2^80 + 2^64*L + 2^32*Height + Requests)
	const uint64_t difficultyAsInteger(std::round(65536.*_difficulty)), offsetBits(difficultyAsInteger/65536ULL - 80ULL);
	job.target = 1;
	job.target <<= 16;
	job.target += static_cast<uint16_t>(std::round(std::pow(2., 16. + static_cast<double>(difficultyAsInteger % 65536)/65536.)) - 65536.);
	job.target <<= 32;
	job.target += _height;
	job.target <<= 32;
	job.target += _requests;
	job.target <<= offsetBits;
	_requests++;
	return job;
}

std::optional<Stella::Job> SearchClient::getJob() {
	Stella::Job job;
	// Target: (in binary) 1 . Leading Digits L (16 bits) . 80 Random Bits . (Difficulty - 96) zeros = 2^(Difficulty - 96)*(2^96 + 2^80*L + Random)
	const uint64_t difficultyAsInteger(std::round(65536.*_difficulty)), offsetBits(difficultyAsInteger/65536ULL - 96ULL);
	std::array<uint8_t, 10> random;
	for (auto &byte : random) byte = rand(0x00, 0xFF);
	job.target = 1;
	job.target <<= 16;
	job.target += static_cast<uint16_t>(std::round(std::pow(2., 16. + static_cast<double>(difficultyAsInteger % 65536)/65536.)) - 65536.);
	for (uint8_t i(0) ; i < 5 ; i++) {
		job.target <<= 16;
		job.target += reinterpret_cast<uint16_t*>(random.data())[4 - i];
	}
	job.target <<= offsetBits;
	return job;
}

std::optional<ClientInfo> SearchClient::info() const {
	return ClientInfo{
		.height = 1,
		.powVersion = 1,
		.acceptedPatterns = {_pattern},
		.patternMin = std::vector<bool>(_pattern.size(), true),
		.primeCountTarget = static_cast<uint16_t>(_pattern.size()),
		.primeCountMin = _primeCountMin,
		.difficulty = _difficulty,
		.targetOffsetBits = static_cast<uint32_t>(std::round(65536.*_difficulty)/65536ULL - 80ULL)
	};
}

void SearchClient::handleResult(const Stella::Result& job) {
	std::lock_guard<std::mutex> lock(_tupleFileMutex);
	std::ofstream file(_tuplesFilename, std::ios::app);
	if (file)
		file << job.primeCount << "-tuple: " << job.result << std::endl;
	else
		logger.log("Unable to write tuple to file "s + _tuplesFilename + "\n"s, MessageType::ERROR);
}
