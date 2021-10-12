#pragma once

#include <vector>
#include <iostream>

#include <type_traits>

#include "gtest/gtest.h"
#include "exqudens/Strings.hpp"

namespace exqudens {

  TEST(StringsTests, toString) {
    std::string expectedToStringResult = "[1, 22, 333]";
    std::vector<bool> stringVector = {true, false, true};
    std::string actualToStringResult = Strings::toString(stringVector);
    ASSERT_EQ(expectedToStringResult, actualToStringResult);
  }

  TEST(StringsTests, testSplit) {
    std::vector<std::string> expectedSplitResult = {"a", "bb", "ccc"};
    std::vector<std::string> actualSplitResult = Strings::split("a<:>bb<:>ccc", "<:>");
    ASSERT_EQ(expectedSplitResult, actualSplitResult);
  }

  TEST(StringsTests, testJoin) {
    std::string expectedJoinResult = "[a, bb, ccc]";
    std::string actualJoinResult = Strings::join({"a", "bb", "ccc"}, ", ", "[", "]");
    ASSERT_EQ(expectedJoinResult, actualJoinResult);
  }

}
