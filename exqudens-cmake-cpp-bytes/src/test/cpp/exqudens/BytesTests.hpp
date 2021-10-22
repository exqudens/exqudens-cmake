#pragma once

#include <vector>
#include <iostream>

#include <type_traits>

#include "gtest/gtest.h"
#include "exqudens/Bytes.hpp"

namespace exqudens {

  TEST(BytesTests, longVectorConstReferenceToUnsignedCharVector) {
    const std::vector<long> expected = {123, -123, 987};
    for (size_t i = 0; i < expected.size(); i++) {
      std::cout << "expected.at(" << i << "): '" << expected.at(i) << "'" << std::endl;
    }
    const std::vector<unsigned char> bytes = Bytes::toUnsignedCharVector(expected);
    for (size_t i = 0; i < bytes.size(); i++) {
      std::cout << "bytes.at(" << i << "): '" << +bytes.at(i) << "'" << std::endl;
    }
    ASSERT_EQ(size_t(12), bytes.size());
    const std::vector<long> actual = Bytes::toLongVector(bytes);
    for (size_t i = 0; i < actual.size(); i++) {
      std::cout << "actual.at(" << i << "): '" << actual.at(i) << "'" << std::endl;
    }
    ASSERT_EQ(expected, actual);
  }

  TEST(BytesTests, longVectorReferenceToUnsignedCharVector) {
    std::vector<long> expected = {123, -123, 987};
    for (size_t i = 0; i < expected.size(); i++) {
      std::cout << "expected.at(" << i << "): '" << expected.at(i) << "'" << std::endl;
    }
    std::vector<unsigned char> bytes = Bytes::toUnsignedCharVector(expected);
    for (size_t i = 0; i < bytes.size(); i++) {
      std::cout << "bytes.at(" << i << "): '" << +bytes.at(i) << "'" << std::endl;
    }
    ASSERT_EQ(size_t(12), bytes.size());
    std::vector<long> actual = Bytes::toLongVector(bytes);
    for (size_t i = 0; i < actual.size(); i++) {
      std::cout << "actual.at(" << i << "): '" << actual.at(i) << "'" << std::endl;
    }
    ASSERT_EQ(expected, actual);
  }

  TEST(BytesTests, longVectorConstPointerToUnsignedCharVector) {
    const std::vector<long> expected = {123, -123, 987};
    for (size_t i = 0; i < expected.size(); i++) {
      std::cout << "expected.at(" << i << "): '" << expected.at(i) << "'" << std::endl;
    }
    const std::vector<long>* expectedPointer = nullptr;
    std::vector<unsigned char> bytes = Bytes::toUnsignedCharVector(expectedPointer);
    ASSERT_EQ(size_t(0), bytes.size());

    expectedPointer = &expected;
    bytes = Bytes::toUnsignedCharVector(expectedPointer);
    for (size_t i = 0; i < bytes.size(); i++) {
      std::cout << "bytes.at(" << i << "): '" << +bytes.at(i) << "'" << std::endl;
    }
    ASSERT_EQ(size_t(12), bytes.size());

    const std::vector<unsigned char>* bytesPointer = nullptr;
    std::vector<long> actual = Bytes::toLongVector(bytesPointer);
    ASSERT_EQ(size_t(0), actual.size());

    bytesPointer = &bytes;
    actual = Bytes::toLongVector(bytesPointer);
    for (size_t i = 0; i < actual.size(); i++) {
      std::cout << "actual.at(" << i << "): '" << actual.at(i) << "'" << std::endl;
    }
    ASSERT_EQ(expected, actual);
  }

  TEST(BytesTests, longVectorPointerToUnsignedCharVector) {
    std::vector<long> expected = {123, -123, 987};
    for (size_t i = 0; i < expected.size(); i++) {
      std::cout << "expected.at(" << i << "): '" << expected.at(i) << "'" << std::endl;
    }
    std::vector<long>* expectedPointer = nullptr;
    std::vector<unsigned char> bytes = Bytes::toUnsignedCharVector(expectedPointer);
    ASSERT_EQ(size_t(0), bytes.size());

    expectedPointer = &expected;
    bytes = Bytes::toUnsignedCharVector(expectedPointer);
    for (size_t i = 0; i < bytes.size(); i++) {
      std::cout << "bytes.at(" << i << "): '" << +bytes.at(i) << "'" << std::endl;
    }
    ASSERT_EQ(size_t(12), bytes.size());

    std::vector<unsigned char>* bytesPointer = nullptr;
    std::vector<long> actual = Bytes::toLongVector(bytesPointer);
    ASSERT_EQ(size_t(0), actual.size());

    bytesPointer = &bytes;
    actual = Bytes::toLongVector(bytesPointer);
    for (size_t i = 0; i < actual.size(); i++) {
      std::cout << "actual.at(" << i << "): '" << actual.at(i) << "'" << std::endl;
    }
    ASSERT_EQ(expected, actual);
  }

}
