#pragma once

#include <string>

namespace testnamespace::testsubnamespace {

  class TestClass3 {

    public:

      int function1(int a, int b);

      std::string function2(std::string a, std::string b);

  };

}

#include <iostream>

namespace testnamespace::testsubnamespace {

  int TestClass3::function1(int a, int b) {
    std::cout << "a: '" << a << "'" << std::endl;
    std::cout << "b: '" << b << "'" << std::endl;
    return a + b;
  }

  std::string TestClass3::function2(std::string a, std::string b) {
    std::cout << "a: '" << a << "'" << std::endl;
    std::cout << "b: '" << b << "'" << std::endl;
    return a.append(b);
  }

}
