#pragma once

#include <chrono>
#include <ctime>
#include <stdexcept>
#include <iostream>
#include <format>

#include <gtest/gtest.h>

#include "TestUtils.hpp"

namespace exqudens {

  class OtherTests : public testing::Test {

    protected:

      void SetUp() override {
        try {
          std::cout << std::format("{}", CALL_INFO()) << std::endl;
        } catch (...) {
          std::throw_with_nested(std::runtime_error(CALL_INFO()));
        }
      }

      void TearDown() override {
        try {
          std::cout << std::format("{}", CALL_INFO()) << std::endl;
        } catch (...) {
          std::throw_with_nested(std::runtime_error(CALL_INFO()));
        }
      }

  };

  TEST_F(OtherTests, test1) {
    try {
      TestThreadPool threadPool = TestUtils::createTestThreadPool(1);

      std::future<int> future = threadPool.submit([]() {
        time_t time = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
        char buffer[26];
        ctime_s(buffer, sizeof(buffer), &time);
        std::string stringTime(buffer);
        stringTime.resize(stringTime.size() - 1);
        std::cout << std::format("{}", stringTime) << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(1));
        return 1;
      });

      int result = future.get();

      ASSERT_EQ(1, result);
    } catch (const std::exception& e) {
      FAIL() << TestUtils::toString(e);
    }
  }

}
