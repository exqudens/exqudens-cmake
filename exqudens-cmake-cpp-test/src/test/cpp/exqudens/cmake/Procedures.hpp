#pragma once

#include <tuple>
#include <string>

namespace exqudens::cmake {

  class Procedures {

    public:

      static std::tuple<int, std::string, std::string> create(std::string firstName, std::string lastName);

  };

}
