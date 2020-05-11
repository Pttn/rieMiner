// (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)

#include "Stats.hpp"

void Stats::startTimer() {
	_miningStartTp = std::chrono::system_clock::now();
	_lastDiffChangeTp = std::chrono::system_clock::now();
}

void Stats::newHeightMessage(const uint32_t height) {
	if (_inited()) {
		printTime();
		if (height - _heightAtDiffChange != 0) {
			std::cout << " Block " << height << ", average "
				      << FIXED(1) << timeSince(_lastDiffChangeTp)/(height - _heightAtDiffChange)
				      << " s, difficulty " << _difficulty << std::endl;
		}
		else std::cout << " Block " << height << ", new difficulty " << _difficulty << std::endl;
	}
}

void Stats::updateDifficulty(const uint32_t newDifficulty, const uint32_t height) {
	if (_difficulty != newDifficulty) {
		printTuplesStats();
		for (std::vector<uint64_t>::size_type i(0) ; i < _tuplesSinceLastDiff.size() ; i++)
			_tuplesSinceLastDiff[i] = 0;
		_difficulty = newDifficulty;
		_heightAtDiffChange = height;
		_lastDiffChangeTp = std::chrono::system_clock::now();
	}
}

void Stats::printTime() const {
	const double elapsedSecs(timeSince(_miningStartTp));
	const uint32_t elapsedSecsInt(elapsedSecs);
	std::cout << "[" << (elapsedSecsInt/86400) << ":" << leading0s(2) << (elapsedSecsInt/3600) % 24 << ":" << leading0s(2) << (elapsedSecsInt/60) % 60 << ":" << leading0s(2) << elapsedSecsInt % 60 << "]";
}

void Stats::printStats() const {
	const double elapsedSecs(timeSince(_lastDiffChangeTp));
	if (elapsedSecs > 1 && timeSince(_miningStartTp) > 1) {
		printTime();
			// 0-tuples/s metric is not more precise than the 1-tuples/s one (except for huge Difficulties), but helps a lot for the ratio
			std::cout << " "/* << FIXED(1) << _tuplesSinceLastDiff[0]/elapsedSecs << " nps";
			std::cout << ", " */<< FIXED(2) << _tuplesSinceLastDiff[1]/elapsedSecs << " pps";
			if (_tuplesSinceLastDiff[1] > 0) std::cout << ", r " << ((double) _tuplesSinceLastDiff[0])/((double) _tuplesSinceLastDiff[1]);
		if (_solo) {
			std::cout << " ; (2-" << _tuples.size() - 1 << "t) = (";
			for (uint32_t i(2) ; i < _tuples.size() ; i++) {
				std::cout << _tuples[i];
				if (i != _tuples.size() - 1) std::cout << " ";
			}
			std::cout << ")";
		}
		else {
			std::cout << " ; Sh: " << _tuples[4] - _rejectedShares << "/" << _tuples[4];
			if (_tuples[4] > 0) std::cout << " (" << FIXED(1) << 100.*((double) _tuples[4] - _rejectedShares)/((double) _tuples[4]) << "%, " << 60.*((double) _tuplesSinceLastDiff[4])/elapsedSecs << " sh/min)";
		}
	}
}

void Stats::printTuplesStats() const {
	if (_inited()) {
		const std::vector<uint64_t> t(_tuplesSinceLastDiff);
		const double elapsedSecs(timeSince(_lastDiffChangeTp));
		if (_solo) {
			std::cout << "Tuples found for diff " << _difficulty <<  ": (";
			for (uint32_t i(1) ; i < _tuples.size() ; i++) {
				std::cout << t[i];
				if (i != _tuples.size() - 1) std::cout << " ";
			}
			std::cout << ") during " << FIXED(3) << elapsedSecs << " s" << std::endl;
			std::cout << "Tuples/s: (" << FIXED(6);
			for (uint32_t i(1) ; i < _tuples.size() ; i++) {
				std::cout << t[i]/elapsedSecs;
				if (i != _tuples.size() - 1) std::cout << " ";
			}
			std::cout << ")" << std::endl;
			std::cout << "Ratios: (" << FIXED(1);
			for (uint32_t i(2) ; i < _tuples.size() ; i++) {
				if (t[i] != 0) std::cout << ((double) t[i - 1])/((double) t[i]);
				else std::cout << "inf";
				if (i != _tuples.size() - 1) std::cout << " ";
			}
			std::cout << ")" << std::endl;
		}
		else {
			std::cout << t[4] << " shares found for diff " << _difficulty << " during " << FIXED(3) << elapsedSecs << " s -> " << FIXED(1) << 60.*((double) t[4])/elapsedSecs << " sh/min" << std::endl;
		}
	}
}

void Stats::printEstimatedTimeToBlock() const {
	const double elapsedSecs(timeSince(_lastDiffChangeTp));
	if (elapsedSecs > 1 && timeSince(_miningStartTp) > 1) {
		if (_tuplesSinceLastDiff[2] > 0) {
			const double r01(((double) _tuplesSinceLastDiff[0])/((double) _tuplesSinceLastDiff[1])),
			             s0(((double) _tuplesSinceLastDiff[0])/elapsedSecs),
			             t(std::pow(r01, _tuples.size() - 1)/(86400.*s0));
			if (_solo) {
				if (t < 1./1440.) std::cout << FIXED(2 + (86400.*t < 10.)) << " | " << 86400.*t << " s";
				else if (t < 1./24.) std::cout << FIXED(2 + (1440.*t < 10.)) << " | " << 1440.*t << " min";
				else if (t < 1.) std::cout << FIXED(2 + (24.*t < 10.)) << " | " << 24.*t << " h";
				else if (t < 365.2425) std::cout << FIXED(3) << " | " << t << " d";
				else std::cout << FIXED(3) << " | " << t/365.2425 << " y";
			}
			else
				std::cout << FIXED(2) << " | " << (50./(((double) (1 << _heightAtDiffChange/840000))))/t << " RIC/d";
		}
		std::cout << std::endl;
	}
}

void Stats::printBenchmarkResults() const {
	const double elapsedSecs(timeSince(_lastDiffChangeTp));
	if (_tuplesSinceLastDiff[2] > 0) {
		const double r12(((double) _tuplesSinceLastDiff[1])/((double) _tuplesSinceLastDiff[2])),
		             s1(((double) _tuplesSinceLastDiff[1])/elapsedSecs),
		             bpd(86400.*s1/std::pow(r12, _tuples.size() - 2));
		std::cout << "BENCHMARK RESULTS: " << FIXED(6) << s1 << " primes/s with ratio " << r12 << " -> " << bpd << " block(s)/day" << std::endl;
	}
}
