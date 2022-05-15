#pragma once

#include <vector>
#include <queue>
#include <memory>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <future>
#include <functional>
#include <stdexcept>
#include <type_traits>

#include "TestMacros.hpp"

class TestThreadPool {

  private:

    size_t queueSize;
    std::queue<std::function<void()>> queue;
    std::vector<std::thread> threads;
    std::mutex mutex;
    std::condition_variable condition;
    bool stop;

  public:

    TestThreadPool();

    explicit TestThreadPool(
        size_t queueSize
    );

    TestThreadPool(
        size_t queueSize,
        size_t threadSize
    );

    template<class F, class... ARGS>
    auto submit(F&& f, ARGS&&... args) -> std::future<typename std::invoke_result<F, ARGS...>::type>;

    ~TestThreadPool();
};

TestThreadPool::TestThreadPool(
):
    TestThreadPool(
        std::thread::hardware_concurrency()
    )
{
}

TestThreadPool::TestThreadPool(
    size_t queueSize
):
    TestThreadPool(
        queueSize,
        queueSize
    )
{
}

TestThreadPool::TestThreadPool(
    size_t queueSize,
    size_t threadSize
):
    queueSize(queueSize),
    stop(false)
{
  try {
    if (queueSize == 0) {
      throw std::invalid_argument(CALL_INFO() + ": 'queueSize' is zero");
    }
    if (threadSize == 0) {
      throw std::invalid_argument(CALL_INFO() + ": 'threadSize' is zero");
    }
    for(size_t i = 0; i < threadSize; i++) {
      threads.emplace_back([this]{
        while(true) {
          std::function<void()> task;
          {
            std::unique_lock<std::mutex> lock(this->mutex);
            this->condition.wait(lock, [this]{ return this->stop || !this->queue.empty(); });
            if(this->stop && this->queue.empty()) {
              return;
            }
            task = std::move(this->queue.front());
            this->queue.pop();
          }
          task();
        }
      });
    }
  } catch (...) {
    std::throw_with_nested(std::runtime_error(CALL_INFO()));
  }
}

template<class F, class... ARGS>
auto TestThreadPool::submit(F&& f, ARGS&&... args) -> std::future<typename std::invoke_result<F, ARGS...>::type> {
  try {
    if (queue.size() >= queueSize) {
      throw std::runtime_error(CALL_INFO() + ": queue overflow");
    }
    using return_type = typename std::invoke_result<F, ARGS...>::type;
    auto task = std::make_shared<std::packaged_task<return_type()>>(std::bind(std::forward<F>(f), std::forward<ARGS>(args)...));
    std::future<return_type> res = task->get_future();
    {
      std::unique_lock<std::mutex> lock(mutex);
      if(stop) {
        throw std::runtime_error(CALL_INFO() + ": submitted on stopped 'ThreadPool'");
      }
      queue.emplace([task] { (*task)(); });
    }
    condition.notify_one();
    return res;
  } catch (...) {
    std::throw_with_nested(std::runtime_error(CALL_INFO()));
  }
}

TestThreadPool::~TestThreadPool() {
  {
    std::unique_lock<std::mutex> lock(mutex);
    stop = true;
  }
  condition.notify_all();
  for(std::thread& thread : threads) {
    thread.join();
  }
}
