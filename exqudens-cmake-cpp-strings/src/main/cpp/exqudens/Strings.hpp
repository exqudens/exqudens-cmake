#pragma once

#include <string>
#include <vector>

namespace exqudens {

  class Strings {

    public:

      static std::vector<std::string> split(
          const std::string& value,
          const std::string& delimiter = ""
      );

      static std::string join(
          const std::vector<std::string>& values,
          const std::string& delimiter = "",
          const std::string& prefix = "",
          const std::string& suffix = ""
      );

  };

}
