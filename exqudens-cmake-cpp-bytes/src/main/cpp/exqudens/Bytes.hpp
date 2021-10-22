#pragma once

#include <vector>

namespace exqudens {

  class Bytes {

    public:

      static std::vector<unsigned char> toUnsignedCharVector(const std::vector<long>& values);
      static std::vector<unsigned char> toUnsignedCharVector(std::vector<long>& values);
      static std::vector<unsigned char> toUnsignedCharVector(const std::vector<long>* values);
      static std::vector<unsigned char> toUnsignedCharVector(std::vector<long>* values);

      static std::vector<long> toLongVector(const std::vector<unsigned char>& values);
      static std::vector<long> toLongVector(std::vector<unsigned char>& values);
      static std::vector<long> toLongVector(const std::vector<unsigned char>* values);
      static std::vector<long> toLongVector(std::vector<unsigned char>* values);

  };

}
