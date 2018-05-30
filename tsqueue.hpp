/* tsqueue.hpp from https://github.com/dave-andersen/fastrie
(c) 2013 gatra (gatra@riecoin.org)
(c) 2017-2018 Pttn (https://github.com/Pttn/rieMiner) */

/*
 * Threadsafe blocking work queue implementation
 * Defined to be analogous to STL deque;	please follow STL
 * naming conventions for methods.
 */

#ifndef _TSQUEUE_H_
#define _TSQUEUE_H_

#include <thread>
#include <mutex>
#include <condition_variable>
#include <deque>

template<class T, int maxSize>
class ts_queue {
private:
	std::deque<T> _q;
	std::mutex _m;
	std::condition_variable _cv;
	std::condition_variable _cv_full;
public:
	/* Blocks iff queue size >= maxSize */
	void push_back(T item) {
		std::unique_lock<std::mutex> lock(_m);
		while (_q.size() >= maxSize)
			_cv_full.wait(lock);
		_q.push_back(item);
		_cv.notify_one();
	}

	void push_front(T item) {
		std::unique_lock<std::mutex> lock(_m);
		while (_q.size() >= maxSize)
			_cv_full.wait(lock);
		_q.push_front(item);
		_cv.notify_one();
	}


	/* Blocks until an item is available to pop */
	T pop_front() {
		std::unique_lock<std::mutex> lock(_m);
		while (_q.empty())
			_cv.wait(lock);
		/* Pop and notify sleeping inserters */
		auto r(_q.front());
		_q.pop_front();
		_cv_full.notify_one();
		return r;
	}
	
	/* Nonblocking - clears queue, returns number of items removed */
	typename std::deque<T>::size_type clear() {
		std::unique_lock<std::mutex> lock(_m);
		auto s(_q.size());
		_q.clear();
		//while (!_q.empty())
		//	_q.pop();
		_cv_full.notify_all();
		return s;
	}

	int size() {
		std::unique_lock<std::mutex> lock(_m);
		auto s(_q.size());
		return s;
	}
};

#endif /* _TSQUEUE_H_ */
