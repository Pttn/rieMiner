/* tsqueue.hpp from https://github.com/dave-andersen/fastrie
(c) 2013 gatra (gatra@riecoin.org) */

/*
 * Threadsafe blocking work queue implementation
 * Defined to be analogous to STL deque;  please follow STL
 * naming conventions for methods.
 */

#ifndef _TSQUEUE_H_
#define _TSQUEUE_H_

#define InitializeConditionVariable(cv) pthread_cond_init(cv, NULL)
#define SleepConditionVariableCS(cv, Section, dwMilliseconds)  pthread_cond_wait(cv, Section)
#define WakeConditionVariable(cv) pthread_cond_signal(cv)
#define WakeAllConditionVariable(cv) pthread_cond_broadcast(cv)

#include <pthread.h>
#include <deque>

template<class T, int maxSize>
class ts_queue {
private:
  std::deque<T> _q;
  pthread_mutex_t _m;
  pthread_cond_t _cv;
  pthread_cond_t _cv_full;

public:
  ts_queue() {
    pthread_mutex_init(&_m, NULL);
    InitializeConditionVariable(&_cv);
    InitializeConditionVariable(&_cv_full);
  }

  /* Blocks iff queue size >= maxSize */
  void push_back(T item) {
    pthread_mutex_lock(&_m);
    while (_q.size() >= maxSize) {
      SleepConditionVariableCS(&_cv_full, &_m, 2000);
    }
    _q.push_back(item);
    pthread_mutex_unlock(&_m);
    WakeConditionVariable(&_cv);
  }

  void push_front(T item) {
    pthread_mutex_lock(&_m);
    while (_q.size() >= maxSize) {
      SleepConditionVariableCS(&_cv_full, &_m, 2000);
    }
    _q.push_front(item);
    pthread_mutex_unlock(&_m);
    WakeConditionVariable(&_cv);
  }


  /* Blocks until an item is available to pop */
  T pop_front() {
    pthread_mutex_lock(&_m);
    while (_q.empty()) {
      SleepConditionVariableCS(&_cv, &_m, 2000);
    }
    /* Pop and notify sleeping inserters */
    auto r = _q.front();
    _q.pop_front();
    pthread_mutex_unlock(&_m);
    WakeConditionVariable(&_cv_full);
    return r;
  }
  
  /* Nonblocking - clears queue, returns number of items removed */
  typename std::deque<T>::size_type clear() {
    pthread_mutex_lock(&_m);
    auto s = _q.size();
    _q.clear();
    //while (!_q.empty()) {
    //_q.pop();
    //}
    pthread_mutex_unlock(&_m);
    WakeAllConditionVariable(&_cv_full);
    return s;
  }

  int size() {
    pthread_mutex_lock(&_m);
    auto s = _q.size();
    pthread_mutex_unlock(&_m);
    return s;
  }
};

#endif /* _TSQUEUE_H_ */
