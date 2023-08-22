#pragma once

#include <string>

namespace exqudens {

  /*!

    @brief Utility class for strings.

  */
  class Strings {

    public:

      /*!

        @brief Remove all spaces from begin of the string.

      */
      static std::string ltrim(const std::string& value);

      /*!

        @brief Remove all spaces from end of the string.

      */
      static std::string rtrim(const std::string& value);

      /*!

        @brief Remove all spaces from begin and end of the string.

      */
      static std::string trim(const std::string& value);

  };

}
