#pragma once

#include <string>
#include <vector>

namespace exqudens {

  class Strings {

    public:

      static std::string toString(const bool& value);
      static std::string toString(bool& value);
      static std::string toString(const bool* value);
      static std::string toString(bool* value);

      static std::string toString(const char& value);
      static std::string toString(char& value);
      static std::string toString(const char* value);
      static std::string toString(char* value);

      static std::string toString(const char16_t& value);
      static std::string toString(char16_t& value);
      static std::string toString(const char16_t* value);
      static std::string toString(char16_t* value);

      static std::string toString(const char32_t& value);
      static std::string toString(char32_t& value);
      static std::string toString(const char32_t* value);
      static std::string toString(char32_t* value);

      static std::string toString(const wchar_t& value);
      static std::string toString(wchar_t& value);
      static std::string toString(const wchar_t* value);
      static std::string toString(wchar_t* value);

      static std::string toString(const signed char& value);
      static std::string toString(signed char& value);
      static std::string toString(const signed char* value);
      static std::string toString(signed char* value);

      static std::string toString(const unsigned char& value);
      static std::string toString(unsigned char& value);
      static std::string toString(const unsigned char* value);
      static std::string toString(unsigned char* value);

      static std::string toString(const short& value);
      static std::string toString(short& value);
      static std::string toString(const short* value);
      static std::string toString(short* value);

      static std::string toString(const unsigned short& value);
      static std::string toString(unsigned short& value);
      static std::string toString(const unsigned short* value);
      static std::string toString(unsigned short* value);

      static std::string toString(const int& value);
      static std::string toString(int& value);
      static std::string toString(const int* value);
      static std::string toString(int* value);

      static std::string toString(const unsigned int& value);
      static std::string toString(unsigned int& value);
      static std::string toString(const unsigned int* value);
      static std::string toString(unsigned int* value);

      static std::string toString(const long& value);
      static std::string toString(long& value);
      static std::string toString(const long* value);
      static std::string toString(long* value);

      static std::string join(const std::vector<std::string>& values);
      static std::string join(std::vector<std::string>& values);
      static std::string join(const std::vector<std::string>* values);
      static std::string join(std::vector<std::string>* values);

      static std::string join(const std::vector<std::string>& values, const std::string& delimiter);
      static std::string join(std::vector<std::string>& values, std::string& delimiter);
      static std::string join(const std::vector<std::string>* values, const std::string* delimiter);
      static std::string join(std::vector<std::string>* values, std::string* delimiter);

      static std::string join(
          const std::vector<std::string>& values,
          const std::string& delimiter,
          const std::string& prefix,
          const std::string& suffix
      );
      static std::string join(
          std::vector<std::string>& values,
          std::string& delimiter,
          std::string& prefix,
          std::string& suffix
      );
      static std::string join(
          const std::vector<std::string>* values,
          const std::string* delimiter,
          const std::string* prefix,
          const std::string* suffix
      );
      static std::string join(
          std::vector<std::string>* values,
          std::string* delimiter,
          std::string* prefix,
          std::string* suffix
      );

      static std::string toString(const std::vector<char>& value);
      static std::string toString(std::vector<char>& value);
      static std::string toString(const std::vector<char>* value);
      static std::string toString(std::vector<char>* value);

      static std::vector<std::string> split(
          const std::string& value,
          const std::string& delimiter = ""
      );

    private:

      static char toChar(wchar_t value);

  };

}
