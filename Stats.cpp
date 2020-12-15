// (c) 2017-2020 Pttn (https://github.com/Pttn/rieMiner)

#include "Stats.hpp"

std::string Stats::formattedCounts(const uint64_t m) const {
	std::ostringstream oss;
	oss << "(";
	for (uint64_t i(m) ; i < _counts.size() ; i++) {
		oss << _counts[i];
		if (i != _counts.size() - 1) oss << " ";
	}
	oss << ")";
	return oss.str();
}
std::string Stats::formattedRates(const uint64_t m) const {
	std::ostringstream oss;
	oss << "(" << FIXED(6);
	for (uint64_t i(m) ; i < _counts.size() ; i++) {
		if (_duration > 0.) oss << static_cast<double>(_counts[i])/_duration;
		else oss << "-.------";
		if (i != _counts.size() - 1) oss << " ";
	}
	oss << ")";
	return oss.str();
}
std::string Stats::formattedRatios() const {
	std::ostringstream oss;
	oss << "(" << FIXED(6);
	for (uint64_t i(1) ; i < _counts.size() ; i++) {
		if (_counts[i] > 0) oss << static_cast<double>(_counts[i - 1])/static_cast<double>(_counts[i]);
		else oss << "-.------";
		if (i != _counts.size() - 1) oss << " ";
	}
	oss << ")";
	return oss.str();
}
std::string Stats::formattedTime(const double &time) {
	std::ostringstream oss;
	const uint32_t timeInt(time*1000.);
	oss << "[" << timeInt/86400000 << ":" << leading0s(2) << (timeInt/3600000) % 24 << ":" << leading0s(2) << (timeInt/60000) % 60 << ":" << leading0s(2) << (timeInt/1000) % 60 << "." << (timeInt/100) % 10 << "]";
	return oss.str();
}
std::string Stats::formattedClockTimeNow() {
	const auto now(std::chrono::system_clock::now());
	const auto seconds(std::chrono::time_point_cast<std::chrono::seconds>(now));
	const auto milliseconds(std::chrono::duration_cast<std::chrono::milliseconds>(now - seconds));
	const std::time_t timeT(std::chrono::system_clock::to_time_t(now));
	const std::tm *timeTm(std::localtime(&timeT));
	std::ostringstream oss;
	oss << "[" << std::put_time(timeTm, "%H:%M:%S") << "." << static_cast<uint32_t>(std::floor(milliseconds.count()))/100 << "]";
	return oss.str();
}
std::string Stats::formattedDuration(const double &duration) {
	std::ostringstream oss;
	if (duration < 0.001) oss << std::round(1000000.*duration) << " us";
	else if (duration < 1.) oss << std::round(1000.*duration) << " ms";
	else if (duration < 60.) oss << FIXED(2 + (duration < 10.)) << duration << " s";
	else if (duration < 3600.) oss << FIXED(2 + (duration/60. < 10.)) << duration/60. << " min";
	else if (duration < 86400.) oss << FIXED(2 + (duration/3600. < 10.)) << duration/3600. << " h";
	else if (duration < 31556952.) oss << FIXED(3) << duration/86400. << " d";
	else oss << FIXED(3) << duration/31556952. << " y";
	return oss.str();
}

void StatManager::start(const uint64_t tupleSize) {
	_tupleSize = tupleSize;
	_nBlocks = 0;
	_countsRecentEntryPos = 0;
	_countsSinceStart = Counts(_tupleSize);
	_countsRecent = std::vector<Counts>(countsRecentEntries, Counts(_tupleSize));
}

void StatManager::newBlock() {
	_nBlocks++;
	_countsRecentEntryPos = (_countsRecentEntryPos + 1) % countsRecentEntries;
	_countsRecent[_countsRecentEntryPos] = Counts(_tupleSize);
}

void StatManager::addCounts(const std::vector<uint64_t> &counts) {
	_countsLock.lock();
	std::transform(_countsSinceStart.counts.begin(), _countsSinceStart.counts.end(), counts.begin(), _countsSinceStart.counts.begin(), std::plus<uint64_t>());
	std::transform(_countsRecent[_countsRecentEntryPos].counts.begin(), _countsRecent[_countsRecentEntryPos].counts.end(), counts.begin(), _countsRecent[_countsRecentEntryPos].counts.begin(), std::plus<uint64_t>());
	_countsLock.unlock();
}

Stats StatManager::stats(const bool sinceStart) const {
	if (sinceStart)
		return Stats(_countsSinceStart.counts, timeSince(_countsSinceStart.startTp));
	else {
		std::vector<uint64_t> counts(_tupleSize + 1, 0);
		double duration(0.);
		for (const auto &blockCounts : _countsRecent) {
			if (timeSince(blockCounts.startTp) > duration)
				duration = timeSince(blockCounts.startTp);
			std::transform(counts.begin(), counts.end(), blockCounts.counts.begin(), counts.begin(), std::plus<uint64_t>());
		}
		return Stats(counts, duration);
	}
}
