#pragma once

#include <string>

namespace testnamespace::testsubnamespace {

  class TestClass1 {

    public:

      int function1(int a, int b) {
        return a + b;
      }

      std::string function2(std::string a, std::string b) {
        return a.append(b);
      }

  };

}
