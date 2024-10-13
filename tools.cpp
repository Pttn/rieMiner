// (c) 2018-present Pttn and contributors (https://riecoin.xyz/rieMiner)

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
	if (bech32Polymod(expHrpData) != (address[delimiterPos + 1] == 'q' ? 1 : 0x2bc830a3))
		return {};
	std::vector<uint8_t> spk(v5ToV8(std::vector<uint8_t>(v5.begin() + 1, v5.end() - 6)));
	if ((spk.size() == 0 && addrData.size() != 6) || v5[0] > 16)
		return {};
	spk.insert(spk.begin(), spk.size());
	spk.insert(spk.begin(), v5[0] == 0 ? 0 : 80 + v5[0]);
	return spk;
}

void Logger::log(const std::string &message, const MessageType &type) {
	logDebug(message);
	if (_raw)
		std::cout << message;
	else {
#ifdef _WIN32
		HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
		if (type == MessageType::BOLD)
			SetConsoleTextAttribute(hConsole, 15);
		else if (type == MessageType::WARNING)
			SetConsoleTextAttribute(hConsole, 14);
		else if (type == MessageType::SUCCESS)
			SetConsoleTextAttribute(hConsole, 10);
		else if (type == MessageType::ERROR)
			SetConsoleTextAttribute(hConsole, 12);
		std::cout << message;
		SetConsoleTextAttribute(hConsole, 7);
#else
		if (type == MessageType::BOLD)
			std::cout << "\e[1m" << message << "\e[0m";
		else if (type == MessageType::WARNING)
			std::cout << "\e[1m\x1B[33m" << message << "\e[0m";
		else if (type == MessageType::SUCCESS)
			std::cout << "\e[1m\x1B[32m" << message << "\e[0m";
		else if (type == MessageType::ERROR)
			std::cerr << "\e[1m\x1B[31m" << message << "\e[0m";
		else
			std::cout << message;
#endif
	}
	std::cout << std::flush;
}

void Logger::logDebug(const std::string &message) {
	if (!_logDebug)
		return;
	if (_inStartupLog) {
		_startupLog += message;
		return;
	}
	std::lock_guard<std::mutex> lock(_mutex);
	std::ofstream file(_debugLogFileName, std::ios::app);
	if (file)
		file << message;
	else
		std::cerr << "Unable to write debug output to file " << _debugLogFileName << std::endl;
	file << std::flush;
}
