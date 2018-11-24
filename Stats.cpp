// (c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner)

#include "Stats.hpp"

Stats::Stats(uint8_t tupleLength) {
	_totalTuples = std::vector<std::vector<uint64_t>>();
	for (uint8_t i(0) ; i <= tupleLength ; i++) {
		_tuples.push_back(0);
		_tuplesSinceLastDiff.push_back(0);
	}
	_height = 0;
	_difficulty = 1;
	_heightAtDiffChange = 0;
	_rejectedShares = 0;
	_lastDiffChangeTp = std::chrono::system_clock::now();
	_solo = true;
	_saveTuplesCounts = false;
}

void Stats::startTimer() {
	_miningStartTp = std::chrono::system_clock::now();
	_lastDiffChangeTp = std::chrono::system_clock::now();
}

#define leading0s(x) std::setw(x) << std::setfill('0')
#define FIXED(x) std::fixed << std::setprecision(x)

void Stats::updateHeight(const uint32_t height) {
	if (_inited()) {
		printTime();
		if (height - _heightAtDiffChange != 0) {
			std::cout << " Blockheight " << height << ", average "
				      << FIXED(1) << timeSince(_lastDiffChangeTp)/(height - _heightAtDiffChange)
				      << " s, difficulty " << _difficulty << std::endl;
		}
		else std::cout << " Blockheight " << height << ", new difficulty " << _difficulty << std::endl;
	}
}

void Stats::updateTotalTuplesCounts() {
	bool found(false);
	for (std::vector<std::vector<uint64_t>>::size_type i(0) ; i < _totalTuples.size() ; i++) {
		if (_totalTuples[i][0] == _difficulty) {
			found = true;
			for (std::vector<uint64_t>::size_type j(1) ; j < _totalTuples[i].size() ; j++) {
				_totalTuples[i][j] += _tuplesSinceLastDiff[j];
				_tuplesSinceLastDiff[j] = 0;
			}
		}
	}
	if (!found && _inited()) {
		_totalTuples.push_back(_tuplesSinceLastDiff);
		for (std::vector<uint64_t>::size_type i(0) ; i < _tuplesSinceLastDiff.size() ; i++)
			_tuplesSinceLastDiff[i] = 0;
		_totalTuples[_totalTuples.size() - 1][0] = _difficulty;
	}
	std::sort(_totalTuples.begin(), _totalTuples.end(), _tuplesDiffSortComp);
}

void Stats::updateDifficulty(const uint32_t newDifficulty, const uint32_t height) {
	if (_difficulty != newDifficulty) {
		printTuplesStats();
		updateTotalTuplesCounts();
		_difficulty = newDifficulty;
		_heightAtDiffChange = height;
		_lastDiffChangeTp = std::chrono::system_clock::now();
	}
}

void Stats::printTime() const {
	const double elapsedSecs(timeSince(_miningStartTp));
	const uint32_t elapsedSecsInt(elapsedSecs);
	std::cout << "[" << leading0s(4) << (elapsedSecsInt/3600) % 10000 << ":" << leading0s(2) << (elapsedSecsInt/60) % 60 << ":" << leading0s(2) << elapsedSecsInt % 60 << "]";
}

void Stats::printStats() const {
	const double elapsedSecs(timeSince(_lastDiffChangeTp));
	if (elapsedSecs > 1 && timeSince(_miningStartTp) > 1) {
		printTime();
		if (_solo) {
			std::cout << " (1-3t/s) = (" << FIXED(1) << _tuplesSinceLastDiff[1]/elapsedSecs << " " << FIXED(2) << _tuplesSinceLastDiff[2]/elapsedSecs << " " << FIXED(3) << _tuplesSinceLastDiff[3]/elapsedSecs << ") ; ";
			std::cout << "(2-" << _tuples.size() - 1 << "t) = (";
			for (uint32_t i(2) ; i < _tuples.size() ; i++) {
				std::cout << _tuples[i];
				if (i != _tuples.size() - 1) std::cout << " ";
			}
			std::cout << ")";
		}
		else {
			std::cout << " Shares: " << _tuples[4] - _rejectedShares << "/" << _tuples[4];
			if (_tuples[4] > 0) std::cout << " (" << FIXED(1) << 100.*((double) _tuples[4] - _rejectedShares)/((double) _tuples[4]) << "%)";
			std::cout << ", sh/min = " << FIXED(1) << 60.*((double) _tuples[4])/elapsedSecs;
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
		if (_solo) {
			if (_tuplesSinceLastDiff[3] > 0) {
				const double r12(((double) _tuplesSinceLastDiff[1])/((double) _tuplesSinceLastDiff[2])),
				             s1(((double) _tuplesSinceLastDiff[1])/elapsedSecs),
				             t(r12*r12*r12*r12*r12/(86400.*s1));
				if (t < 1./1440.) std::cout << FIXED(1 + (86400.*t < 10.)) << " | " << 86400.*t << " s";
				else if (t < 1./24.) std::cout << FIXED(1 + (1440.*t < 10.)) << " | " << 1440.*t << " min";
				else if (t < 1.) std::cout << FIXED(1 + (24.*t < 10.)) << " | " << 24.*t << " h";
				else if (t < 365.2425) std::cout << FIXED(2) << " | " << t << " d";
				else std::cout << FIXED(2) << " | " << t/365.2425 << " y";
			}
		}
		std::cout << std::endl;
	}
}

void Stats::printBenchmarkResults() const {
	const double elapsedSecs(timeSince(_lastDiffChangeTp));
	if (_tuplesSinceLastDiff[2] > 0) {
		const double r12(((double) _tuplesSinceLastDiff[1])/((double) _tuplesSinceLastDiff[2])),
		             s1(((double) _tuplesSinceLastDiff[1])/elapsedSecs),
		             bpd(86400.*s1/(r12*r12*r12*r12*r12));
		std::cout << "BENCHMARK RESULTS: " << FIXED(6) << s1 << " primes/s with ratio " << r12 << " -> " << bpd << " block(s)/day" << std::endl;
	}
}

void Stats::loadTuplesCounts(const std::string &tcFilename) {
	if (tcFilename != "None" && _solo) {
		std::ifstream tcfile(tcFilename, std::ios::in);
		std::cout << "Opening tuples counts file " << tcFilename << "..." << std::endl;
		if (tcfile) {
			std::cout << "Success! Loading data..." << std::endl;
			_saveTuplesCounts = true;
			std::string lineStr;
			while (std::getline(tcfile, lineStr)) {
				std::stringstream line(lineStr);
				std::vector<uint64_t> tupleCount;
				uint64_t tmp;
				if (!(line >> tmp))
					std::cerr << "Unable to read the tuples count difficulty :|" << std::endl;
				else {
					tupleCount.push_back(tmp);
					bool ok(true);
					for (uint16_t i(1) ; i < _tuples.size() ; i++) {
						if (!(line >> tmp)) {
							std::cerr << "Unable to read the " << i << "-tuples count for difficulty " << tupleCount[0] << " :|" << std::endl;
							ok = false;
							break;
						}
						else tupleCount.push_back(tmp);
					}
					if (ok) _totalTuples.push_back(tupleCount);
				}
			}
		}
		else {
			std::cout << "Not found or unreadable, creating... ";
			std::ofstream tcFile2(tcFilename);
			if (tcFile2) {
				std::cout << "Done!" << std::endl;
				_saveTuplesCounts = true;
			}
			else std::cerr << "Failure :|" << std::endl;
		}
	}
}

void Stats::saveTuplesCounts(const std::string &tcFilename) {
	if (_saveTuplesCounts && _inited()) {
		updateTotalTuplesCounts();
		std::ofstream tcfile(tcFilename, std::ofstream::out | std::ofstream::trunc);
		if (tcfile) {
			for (std::vector<std::vector<uint64_t>>::size_type i(0) ; i < _totalTuples.size() ; i++) {
				for (std::vector<uint64_t>::size_type j(0) ; j < _totalTuples[i].size() ; j++) {
					tcfile << _totalTuples[i][j];
					if (j < _totalTuples[i].size() - 1) tcfile << " ";
				}
				tcfile << std::endl;
			}
			std::cout << "Tuples counts saved." << std::endl;
		}
		else std::cerr << "Unable to open or write to the tuples counts file :|" << std::endl;
	}
}
