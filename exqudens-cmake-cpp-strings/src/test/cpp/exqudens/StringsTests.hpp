#pragma once

#include <vector>
#include <iostream>

#include <type_traits>

#include "gtest/gtest.h"
#include "exqudens/Strings.hpp"

namespace exqudens {

  TEST(StringsTests, toStringConstBoolReference) {
    const bool c1 = true;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("true"), s1);
  }

  TEST(StringsTests, toStringBoolReference) {
    bool c1 = false;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("false"), s1);
  }

  TEST(StringsTests, toStringConstBoolPointer) {
    const bool* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const bool c = true;
    const bool* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("true"), s2) << s2;
  }

  TEST(StringsTests, toStringBoolPointer) {
    bool* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    bool c = false;
    bool* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("false"), s2) << s2;
  }

  TEST(StringsTests, toStringConstCharReference) {
    const char c1 = 'c';
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("c"), s1);
  }

  TEST(StringsTests, toStringCharReference) {
    char c1 = 'c';
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("c"), s1);
  }

  TEST(StringsTests, toStringConstCharPointer) {
    const char* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const char c = 'a';
    const char* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("a"), s2) << s2;
  }

  TEST(StringsTests, toStringCharPointer) {
    char* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    char c = 'b';
    char* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("b"), s2) << s2;
  }

  TEST(StringsTests, toStringConstChar16Reference) {
    const char16_t c1 = 'c';
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("c"), s1);
  }

  TEST(StringsTests, toStringChar16Reference) {
    char16_t c1 = 'c';
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("c"), s1);
  }

  TEST(StringsTests, toStringConstChar16Pointer) {
    const char16_t* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const char16_t c = 'a';
    const char16_t* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("a"), s2) << s2;
  }

  TEST(StringsTests, toStringChar16Pointer) {
    char16_t* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    char16_t c = 'a';
    char16_t* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("a"), s2) << s2;
  }

  TEST(StringsTests, toStringConstChar32Reference) {
    const char32_t c1 = 'c';
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("c"), s1);
  }

  TEST(StringsTests, toStringChar32Reference) {
    char32_t c1 = 'c';
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("c"), s1);
  }

  TEST(StringsTests, toStringConstChar32Pointer) {
    const char32_t* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const char32_t c = 'a';
    const char32_t* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("a"), s2) << s2;
  }

  TEST(StringsTests, toStringChar32Pointer) {
    char32_t* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    char32_t c = 'a';
    char32_t* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("a"), s2) << s2;
  }

  TEST(StringsTests, toStringConstWCharReference) {
    const wchar_t c1 = 'c';
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("c"), s1);
  }

  TEST(StringsTests, toStringWCharReference) {
    wchar_t c1 = 'c';
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("c"), s1);
  }

  TEST(StringsTests, toStringConstWCharPointer) {
    const wchar_t* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const wchar_t c = 'a';
    const wchar_t* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("a"), s2) << s2;
  }

  TEST(StringsTests, toStringWCharPointer) {
    wchar_t* c1 = nullptr;
    std::string s1 = Strings::toString(c1);
    ASSERT_EQ(std::string("nullptr"), s1);

    wchar_t c = 'a';
    wchar_t* c2 = &c;
    std::string s2 = Strings::toString(c2);
    ASSERT_EQ(std::string("a"), s2) << s2;
  }

  TEST(StringsTests, toStringConstSignedCharReference) {
    const signed char v1 = 3;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("3"), s1);
  }

  TEST(StringsTests, toStringSignedCharReference) {
    signed char v1 = 4;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("4"), s1);
  }

  TEST(StringsTests, toStringConstSignedCharPointer) {
    const signed char* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const signed char v = 1;
    const signed char* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("1"), s2) << s2;
  }

  TEST(StringsTests, toStringSignedCharPointer) {
    signed char* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    signed char v = 2;
    signed char* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("2"), s2) << s2;
  }

  TEST(StringsTests, toStringConstUnsignedCharReference) {
    const unsigned char v1 = 3;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("3"), s1);
  }

  TEST(StringsTests, toStringUnsignedCharReference) {
    unsigned char v1 = 4;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("4"), s1);
  }

  TEST(StringsTests, toStringConstUnsignedCharPointer) {
    const unsigned char* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const unsigned char v = 1;
    const unsigned char* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("1"), s2) << s2;
  }

  TEST(StringsTests, toStringUnsignedCharPointer) {
    unsigned char* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    unsigned char v = 2;
    unsigned char* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("2"), s2) << s2;
  }

  TEST(StringsTests, toStringConstShortReference) {
    const short v1 = 3;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("3"), s1);
  }

  TEST(StringsTests, toStringShortReference) {
    short v1 = 4;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("4"), s1);
  }

  TEST(StringsTests, toStringConstShortPointer) {
    const short* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const short v = 1;
    const short* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("1"), s2) << s2;
  }

  TEST(StringsTests, toStringShortPointer) {
    short* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    short v = 2;
    short* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("2"), s2) << s2;
  }

  TEST(StringsTests, toStringConstUnsignedShortReference) {
    const unsigned short v1 = 3;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("3"), s1);
  }

  TEST(StringsTests, toStringUnsignedShortReference) {
    unsigned short v1 = 4;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("4"), s1);
  }

  TEST(StringsTests, toStringConstUnsignedShortPointer) {
    const unsigned short* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const unsigned short v = 1;
    const unsigned short* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("1"), s2) << s2;
  }

  TEST(StringsTests, toStringUnsignedShortPointer) {
    unsigned short* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    unsigned short v = 2;
    unsigned short* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("2"), s2) << s2;
  }

  TEST(StringsTests, toStringConstIntReference) {
    const int v1 = 3;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("3"), s1);
  }

  TEST(StringsTests, toStringIntReference) {
    int v1 = 4;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("4"), s1);
  }

  TEST(StringsTests, toStringConstIntPointer) {
    const int* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const int v = 1;
    const int* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("1"), s2) << s2;
  }

  TEST(StringsTests, toStringIntPointer) {
    int* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    int v = 2;
    int* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("2"), s2) << s2;
  }

  TEST(StringsTests, toStringConstUnsignedIntReference) {
    const unsigned int v1 = 3;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("3"), s1);
  }

  TEST(StringsTests, toStringUnsignedIntReference) {
    unsigned int v1 = 4;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("4"), s1);
  }

  TEST(StringsTests, toStringConstUnsignedIntPointer) {
    const unsigned int* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const unsigned int v = 1;
    const unsigned int* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("1"), s2) << s2;
  }

  TEST(StringsTests, toStringUnsignedIntPointer) {
    unsigned int* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    unsigned int v = 2;
    unsigned int* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("2"), s2) << s2;
  }

  TEST(StringsTests, toStringConstLongReference) {
    const long v1 = 3;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("3"), s1);
  }

  TEST(StringsTests, toStringLongReference) {
    long v1 = 4;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("4"), s1);
  }

  TEST(StringsTests, toStringConstLongPointer) {
    const long* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    const long v = 1;
    const long* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("1"), s2) << s2;
  }

  TEST(StringsTests, toStringLongPointer) {
    long* v1 = nullptr;
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("nullptr"), s1);

    long v = 2;
    long* v2 = &v;
    std::string s2 = Strings::toString(v2);
    ASSERT_EQ(std::string("2"), s2) << s2;
  }

  TEST(StringsTests, testJoin) {
    std::string expectedJoinResult = "[a, bb, ccc]";
    std::string actualJoinResult = Strings::join({"a", "bb", "ccc"}, ", ", "[", "]");
    ASSERT_EQ(expectedJoinResult, actualJoinResult);
  }

  TEST(StringsTests, toStringConstVectorCharReference) {
    const std::vector<char> v1 = { 'a', 'b', 'c', '1', '2', '3' };
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("[a, b, c, 1, 2, 3]"), s1);
  }

  TEST(StringsTests, toStringVectorCharReference) {
    std::vector<char> v1 = { 'a', 'b', 'c', '1', '2', '3' };
    std::string s1 = Strings::toString(v1);
    ASSERT_EQ(std::string("[a, b, c, 1, 2, 3]"), s1);
  }

  TEST(StringsTests, toStringConstVectorCharPointer) {
    const std::vector<char> v1 = { 'a', 'b', 'c', '1', '2', '3' };
    const std::vector<char>* v2 = nullptr;
    std::string s1 = Strings::toString(v2);
    ASSERT_EQ(std::string("nullptr"), s1);
    v2 = &v1;
    s1 = Strings::toString(v2);
    ASSERT_EQ(std::string("[a, b, c, 1, 2, 3]"), s1);
  }

  TEST(StringsTests, toStringVectorCharPointer) {
    std::vector<char> v1 = { 'a', 'b', 'c', '1', '2', '3' };
    std::vector<char>* v2 = nullptr;
    std::string s1 = Strings::toString(v2);
    ASSERT_EQ(std::string("nullptr"), s1);
    v2 = &v1;
    s1 = Strings::toString(v2);
    ASSERT_EQ(std::string("[a, b, c, 1, 2, 3]"), s1);
  }

  /*TEST(StringsTests, toString) {
    std::string expectedToStringResult = "[1, 22, 333]";
    std::vector<bool> stringVector = {true, false, true};
    std::string actualToStringResult = Strings::toString(stringVector);
    ASSERT_EQ(expectedToStringResult, actualToStringResult);
  }*/

  TEST(StringsTests, testSplit) {
    std::vector<std::string> expectedSplitResult = {"a", "bb", "ccc"};
    std::vector<std::string> actualSplitResult = Strings::split("a<:>bb<:>ccc", "<:>");
    ASSERT_EQ(expectedSplitResult, actualSplitResult);
  }

}
