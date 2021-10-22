#include <algorithm>
#include <functional>
#include <iterator>
#include <numeric>

#include "exqudens/Strings.hpp"

#define DEFINE_TO_STRING_FUNCTIONS(type)\
  std::string Strings::toString(const type& value) {\
    return toString(const_cast<type&>(value));\
  }\
  std::string Strings::toString(type& value) {\
    return toString(&value);\
  }\
  std::string Strings::toString(const type* value) {\
    return toString(const_cast<type*>(value));\
  }\
  std::string Strings::toString(type* value)

#define DEFINE_INT_TO_STRING_FUNCTIONS(type) DEFINE_TO_STRING_FUNCTIONS(type) {\
    if (nullptr == value) {\
      return "nullptr";\
    }\
    return std::to_string(*value);\
  }

#define DEFINE_VECTOR_TO_STRING_FUNCTIONS(type)  DEFINE_TO_STRING_FUNCTIONS(std::vector<type>) {\
    if (nullptr == value) {\
      return "nullptr";\
    }\
    std::vector<std::string> strings;\
    for (const type& v : *value) {\
      strings.emplace_back(toString(v));\
    }\
    return join(strings, ", ", "[", "]");\
  }

namespace exqudens {

  DEFINE_TO_STRING_FUNCTIONS(bool) {
    if (nullptr == value) {
      return "nullptr";
    }
    return *value ? "true" : "false";
  }

  DEFINE_TO_STRING_FUNCTIONS(char) {
    if (nullptr == value) {
      return "nullptr";
    }
    std::string string(1, *value);
    return string;
  }

  DEFINE_TO_STRING_FUNCTIONS(char16_t) {
    if (nullptr == value) {
      return "nullptr";
    }
    std::wstring wstring(1, *value);
    std::string string;
    std::transform(wstring.begin(), wstring.end(), std::back_inserter(string), &toChar);
    return string;
  }

  DEFINE_TO_STRING_FUNCTIONS(char32_t) {
    if (nullptr == value) {
      return "nullptr";
    }
    std::wstring wstring(1, *value);
    std::string string;
    std::transform(wstring.begin(), wstring.end(), std::back_inserter(string), &toChar);
    return string;
  }

  DEFINE_TO_STRING_FUNCTIONS(wchar_t) {
    if (nullptr == value) {
      return "nullptr";
    }
    std::wstring wstring(1, *value);
    std::string string;
    std::transform(wstring.begin(), wstring.end(), std::back_inserter(string), &toChar);
    return string;
  }

  DEFINE_INT_TO_STRING_FUNCTIONS(signed char)

  DEFINE_INT_TO_STRING_FUNCTIONS(unsigned char)

  DEFINE_INT_TO_STRING_FUNCTIONS(short)

  DEFINE_INT_TO_STRING_FUNCTIONS(unsigned short)

  DEFINE_INT_TO_STRING_FUNCTIONS(int)

  DEFINE_INT_TO_STRING_FUNCTIONS(unsigned int)

  DEFINE_INT_TO_STRING_FUNCTIONS(long)

  std::string Strings::join(
      const std::vector<std::string>& values
  ) {
    return join(
        const_cast<std::vector<std::string>&>(values)
    );
  }

  std::string Strings::join(
      std::vector<std::string>& values
  ) {
    return join(
        &values
    );
  }

  std::string Strings::join(
      const std::vector<std::string>* values
  ) {
    return join(
        const_cast<std::vector<std::string>*>(values)
    );
  }

  std::string Strings::join(
      std::vector<std::string>* values
  ) {
    return join(
        values,
        nullptr
    );
  }

  std::string Strings::join(
      const std::vector<std::string>& values,
      const std::string& delimiter
  ) {
    return join(
        const_cast<std::vector<std::string>&>(values),
        const_cast<std::string&>(delimiter)
    );
  }

  std::string Strings::join(
      std::vector<std::string>& values,
      std::string& delimiter
  ) {
    return join(
        &values,
        &delimiter
    );
  }

  std::string Strings::join(
      const std::vector<std::string>* values,
      const std::string* delimiter
  ) {
    return join(
        const_cast<std::vector<std::string>*>(values),
        const_cast<std::string*>(delimiter)
    );
  }

  std::string Strings::join(
      std::vector<std::string>* values,
      std::string* delimiter
  ) {
    return join(
        values,
        delimiter,
        nullptr,
        nullptr
    );
  }

  std::string Strings::join(
      const std::vector<std::string>& values,
      const std::string& delimiter,
      const std::string& prefix,
      const std::string& suffix
  ) {
    return join(
        const_cast<std::vector<std::string>&>(values),
        const_cast<std::string&>(delimiter),
        const_cast<std::string&>(prefix),
        const_cast<std::string&>(suffix)
    );
  }

  std::string Strings::join(
      std::vector<std::string>& values,
      std::string& delimiter,
      std::string& prefix,
      std::string& suffix
  ) {
    return join(
        &values,
        &delimiter,
        &prefix,
        &suffix
    );
  }

  std::string Strings::join(
      const std::vector<std::string>* values,
      const std::string* delimiter,
      const std::string* prefix,
      const std::string* suffix
  ) {
    return join(
        const_cast<std::vector<std::string>*>(values),
        const_cast<std::string*>(delimiter),
        const_cast<std::string*>(prefix),
        const_cast<std::string*>(suffix)
    );
  }

  std::string Strings::join(
      std::vector<std::string>* values,
      std::string* delimiter,
      std::string* prefix,
      std::string* suffix
  ) {
    if (nullptr == values) {
      return "";
    }
    std::string delimiterValue = nullptr != delimiter ? *delimiter : "";
    std::string prefixValue = nullptr != prefix ? *prefix : "";
    std::string suffixValue = nullptr != suffix ? *suffix : "";
    std::function<std::string(const std::string&, const std::string&)> function = [&delimiterValue](
        const std::string& previous,
        const std::string& next
    ) {
      return previous + (previous.length() > 0 ? delimiterValue : "") + next;
    };
    std::string accumulate = std::accumulate((*values).begin(), (*values).end(), std::string(), function);
    return prefixValue + accumulate + suffixValue;
  }

  DEFINE_VECTOR_TO_STRING_FUNCTIONS(char)

  std::vector<std::string> Strings::split(
      const std::string& value,
      const std::string& delimiter
  ) {

    std::vector<std::string> result;

    if (delimiter.empty()) {
      for (char c : value) {
        result.emplace_back(std::string(1, c));
      }
      return result;
    }

    std::string str = value;
    while (!str.empty()) {
      std::string::size_type index = str.find(delimiter);
      if (index != std::string::npos) {
        result.push_back(str.substr(0, index));
        str = str.substr(index + delimiter.size());
        if(str.empty()) {
          result.push_back(str);
        }
      } else {
        result.emplace_back(str);
        str = "";
      }
    }

    return result;
  }

  char Strings::toChar(wchar_t value) {
    return (char) value;
  }
}
