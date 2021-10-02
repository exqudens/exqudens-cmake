#pragma once

#include "gtest/gtest.h"
#include "exqudens/Strings.hpp"

namespace exqudens {

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
