#include "exqudens/cmake/Procedures.hpp"

namespace exqudens::cmake {

  std::tuple<int, std::string, std::string> Procedures::create(std::string firstName, std::string lastName) {
    return {1, firstName, lastName};
  }

}
