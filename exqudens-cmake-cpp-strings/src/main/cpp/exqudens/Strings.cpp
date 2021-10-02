#include <functional>
#include <numeric>

#include "exqudens/Strings.hpp"

namespace exqudens {

  std::vector<std::string> Strings::split(
      const std::string& value,
      const std::string& delimiter
  ) {

    std::vector<std::string> result;

    if (delimiter.empty()) {
      for (std::string::size_type i = 0; i < value.size(); i++) {
        result.emplace_back(std::string(1, value.at(i)));
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

  std::string Strings::join(
      const std::vector<std::string>& values,
      const std::string& delimiter,
      const std::string& prefix,
      const std::string& suffix
  ) {
    std::function<std::string(const std::string&, const std::string&)> function = [&delimiter](
        const std::string& previous,
        const std::string& next
    ) {
      return previous + (previous.length() > 0 ? delimiter : "") + next;
    };

    std::string accumulate = std::accumulate(values.begin(), values.end(), std::string(), function);

    return prefix + accumulate + suffix;
  }
}
