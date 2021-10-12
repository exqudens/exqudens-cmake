#pragma once

#include <string>
#include <vector>
#include <typeinfo>
#include <stdexcept>

namespace exqudens {

  class Strings {

    public:

      template <typename T>
      static std::string toString(const T& object) {
        return toString(&object);
      }

      template <typename T>
      static std::string toString(T& object) {
        return toString(&object);
      }

      template <typename T>
      static std::string toString(T* object) {
        if (object == nullptr) {
          return "nullptr";
        }
        T value = *object;
        if (typeid(bool) == typeid(value)) {
          bool v = (bool) value;
          return v ? "true" : "false";
        } else if (std::is_integral<decltype(value)>::value) {
          return std::to_string(value);
        } else if (std::is_floating_point<decltype(value)>::value) {
          return std::to_string(value);
        } else {
          throw std::invalid_argument(std::string("Unsupported type: ") + typeid(value).name());
        }
      }

      template <typename T>
      static std::string toString(const std::vector<T>& objects) {
        return toString(&objects);
      }

      template <typename T>
      static std::string toString(std::vector<T>& objects) {
        return toString(&objects);
      }

      template <typename T>
      static std::string toString(std::vector<T>* objects) {
        if (objects == nullptr) {
          return "nullptr";
        }
        std::vector<T> values = *objects;
        std::vector<std::string> stringVector;
        for (const T& object : values) {
          stringVector.emplace_back(toString(object));
        }
        return join(stringVector, ", ", "[", "]");
      }

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
