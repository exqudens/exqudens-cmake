#include <cstring>

#include "exqudens/Bytes.hpp"

#define DEFINE_METHODS(type, class, name, varType1, varName1)\
  type class::name(const varType1& varName1) {\
    return name(const_cast<varType1&>(varName1));\
  }\
  type class::name(varType1& varName1) {\
    return name(&varName1);\
  }\
  type class::name(const varType1* varName1) {\
    return name(const_cast<varType1*>(varName1));\
  }\
  type class::name(varType1* varName1)

namespace exqudens {

  DEFINE_METHODS(std::vector<unsigned char>, Bytes, toUnsignedCharVector, std::vector<long>, values) {
    if (nullptr == values) {
      return {};
    }
    std::vector<unsigned char> results;
    long* data = values->data();
    const size_t size = sizeof(long);
    for (size_t i = 0; i < values->size(); i++) {
      unsigned char buffer[size];
      std::memcpy(buffer, data, size);
      for (unsigned char result : buffer) {
        results.emplace_back(result);
      }
      data++;
    }
    return results;
  }

  DEFINE_METHODS(std::vector<long>, Bytes, toLongVector, std::vector<unsigned char>, values) {
    const size_t size = sizeof(long);
    if (nullptr == values || values->empty() || values->size() % size > 0) {
      return {};
    }
    std::vector<long> results;
    unsigned char* data = values->data();
    for (size_t i = 0; i < values->size(); i+=size) {
      long buffer = 0;
      std::memcpy(&buffer, data, size);
      results.emplace_back(buffer);
      data+=size;
    }
    return results;
  }

}
