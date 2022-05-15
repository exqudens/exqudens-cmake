#pragma once

#include <cstdlib>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <filesystem>
#include <stdexcept>

#include "TestMacros.hpp"
#include "TestConfiguration.hpp"
#include "TestThreadPool.hpp"

class TestUtils {

  public:

    static std::string getExecutableFile() {
      try {
        return TestConfiguration::getExecutableFile();
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

    static std::string getExecutableDir() {
      try {
        return TestConfiguration::getExecutableDir();
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

    static TestThreadPool createTestThreadPool() {
      try {
        return {};
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

    static TestThreadPool createTestThreadPool(size_t queueSize) {
      try {
        return TestThreadPool(queueSize);
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

    static TestThreadPool createTestThreadPool(size_t queueSize, size_t threadSize) {
      try {
        return {queueSize, threadSize};
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

    static std::optional<std::string> getEnvironmentVariable(const std::string& name) {
      try {
        std::optional<std::string> value;
#ifdef _WIN32
        char* buffer;
        size_t size;
        errno_t error = _dupenv_s(&buffer, &size, name.c_str());
        if (error) {
          return value;
        }
        if (buffer != nullptr) {
          value.emplace(std::string(buffer));
        }
#elif _WIN64
        char* buffer;
        size_t size;
        errno_t error = _dupenv_s(&buffer, &size, name.c_str());
        if (error) {
          return value;
        }
        if (buffer != nullptr) {
          value.emplace(std::string(buffer));
        }
#endif
        return value;
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

    static void setEnvironmentVariable(const std::string& name, const std::string& value) {
      try {
#ifdef _WIN32
        _putenv_s(name.c_str(), value.c_str());
#elif _WIN64
        _putenv_s(name.c_str(), value.c_str());
#endif
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

    static std::vector<std::string> toStringVector(
        const std::exception& exception,
        std::vector<std::string> previous = {}
    ) {
      previous.emplace_back(exception.what());
      try {
        std::rethrow_if_nested(exception);
        return previous;
      } catch (const std::exception& e) {
        return toStringVector(e, previous);
      } catch (...) {
        if (previous.empty()) {
          previous.emplace_back(CALL_INFO() + ": Empty stack!");
        }
        return previous;
      }
    }

    static std::vector<std::string> toStackTrace(const std::exception& exception) {
      try {
        std::vector<std::string> elements = toStringVector(exception);
        if (elements.size() > 1) {
          std::ranges::reverse(elements);
        }
        return elements;
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

    static std::string toString(const std::exception& e) {
      try {
        std::vector<std::string> stackTrace = toStackTrace(e);
        std::ostringstream out;
        for (size_t i = 0; i < stackTrace.size(); i++) {
          out << stackTrace[i];
          if (i < stackTrace.size() - 1) {
            out << std::endl;
          }
        }
        return out.str();
      } catch (...) {
        std::throw_with_nested(std::runtime_error(CALL_INFO()));
      }
    }

};
