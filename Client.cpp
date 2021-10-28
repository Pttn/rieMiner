// (c) 2017-2021 Pttn (https://riecoin.dev/en/rieMiner)

#include "Client.hpp"

double decodeBits(const uint32_t nBits, const int32_t powVersion) {
	if (powVersion == 1)
		return static_cast<double>(nBits)/256.;
	else
		ERRORMSG("Unexpected PoW Version " << powVersion);
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
		ERRORMSG("Unexpected PoW Version " << powVersion);
	return target;
}

std::array<uint8_t, 32> Job::encodedOffset() const {
	std::array<uint8_t, 32> nOffset;
	for (auto &byte : nOffset) byte = 0;
	if (powVersion == 1) { // [31-30 Primorial Number|29-14 Primorial Factor|13-2 Primorial Offset|1-0 Reserved/Version]
		*reinterpret_cast<uint16_t*>(&nOffset.data()[ 0]) = 2;
		*reinterpret_cast<uint64_t*>(&nOffset.data()[ 2]) = primorialOffset; // Only 64 bits used out of 96
		*reinterpret_cast<uint64_t*>(&nOffset.data()[14]) = primorialFactor; // Only 64 bits used out of 128
		*reinterpret_cast<uint16_t*>(&nOffset.data()[30]) = primorialNumber;
	}
	else
		ERRORMSG("Unexpected PoW Version " << powVersion);
	return nOffset;
}

std::vector<uint64_t> Client::choosePatterns(const std::vector<std::vector<uint64_t>>& acceptedPatterns, const std::vector<uint64_t>& givenPattern) {
	std::cout << "Accepted constellation pattern(s):" << std::endl;
	if (acceptedPatterns.size() == 0) {
		std::cout << " None - something went wrong :|" << std::endl;
		return {};
	}
	else {
		bool accepted(false);
		for (uint16_t i(0) ; i < acceptedPatterns.size() ; i++) {
			std::cout << " " << i << " - " << formatContainer(acceptedPatterns[i]);
			bool compatible(true);
			for (uint16_t j(0) ; j < acceptedPatterns[i].size() ; j++) {
				const auto offset(acceptedPatterns[i][j]);
				if (j >= givenPattern.size() ? true : offset != givenPattern[j])
					compatible = false;
			}
			if (compatible) {
				std::cout << " <- compatible";
				accepted = true;
			}
			std::cout << std::endl;
		}
		if (!accepted) {
			const uint16_t patternIndex(rand(0, acceptedPatterns.size() - 1));
			std::cout << "None or not compatible one specified, choosing a random one: pattern " << patternIndex << std::endl;
			return acceptedPatterns[patternIndex];
		}
		else
			return givenPattern;
	}
}

void BMClient::process() {
	std::lock_guard<std::mutex> lock(_jobMutex);
	if (_height != 0 && _blockInterval > 0. && timeSince(_timer) >= _blockInterval) {
		_height++;
		_requests = 0;
		_timer = std::chrono::steady_clock::now();
	}
}

Job BMClient::getJob(const bool dummy) {
	std::lock_guard<std::mutex> lock(_jobMutex);
	if (_height == 0 && !dummy) {
		_height = 1;
		_timer = std::chrono::steady_clock::now();
	}
	Job job;
	job.height = _height;
	job.powVersion = 1;
	job.acceptedPatterns = {_pattern};
	job.primeCountTarget = _pattern.size();
	job.primeCountMin = job.primeCountTarget;
	job.difficulty = _difficulty;
	const uint64_t difficultyAsInteger(std::round(65536.*job.difficulty));
	// Target: (in binary) 1 . Leading Digits L (16 bits) . Height (32 bits) . Requests (32 bits) . (Difficulty - 80) zeros = 2^(Difficulty - 80)(2^80 + 2^64*L + 2^32*Height + Requests)
	job.target = 1;
	job.target <<= 16;
	job.target += static_cast<uint16_t>(std::round(std::pow(2., 16. + static_cast<double>(difficultyAsInteger % 65536)/65536.)) - 65536.);
	job.target <<= 32;
	job.target += job.height;
	job.target <<= 32;
	job.target += _requests;
	job.target <<= (difficultyAsInteger/65536ULL - 80ULL);
	if (!dummy) _requests++;
	return job;
}

Job SearchClient::getJob(const bool) {
	Job job;
	job.height = 1;
	job.powVersion = 1;
	job.acceptedPatterns = {_pattern};
	job.primeCountTarget = _pattern.size();
	job.primeCountMin = job.primeCountTarget;
	job.difficulty = _difficulty;
	// Target: (in binary) 1 . Leading Digits L (16 bits) . 80 Random Bits . (Difficulty - 96) zeros = 2^(Difficulty - 96)*(2^96 + 2^80*L + Random)
	const uint64_t difficultyAsInteger(std::round(65536.*job.difficulty));
	std::array<uint8_t, 10> random;
	for (auto &byte : random) byte = rand(0x00, 0xFF);
	job.target = 1;
	job.target <<= 16;
	job.target += static_cast<uint16_t>(std::round(std::pow(2., 16. + static_cast<double>(difficultyAsInteger % 65536)/65536.)) - 65536.);
	for (uint8_t i(0) ; i < 5 ; i++) {
		job.target <<= 16;
		job.target += reinterpret_cast<uint16_t*>(random.data())[4 - i];
	}
	job.target <<= (job.difficulty - 96);
	return job;
}

void SearchClient::handleResult(const Job& job) {
	std::lock_guard<std::mutex> lock(_tupleFileMutex);
	std::ofstream file(_tuplesFilename, std::ios::app);
	if (file)
		file << job.resultPrimeCount << "-tuple: " << job.result << std::endl;
	else
		ERRORMSG("Unable to write tuple to file " << _tuplesFilename);
}
