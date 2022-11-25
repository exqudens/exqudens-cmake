#include "testnamespace/testsubnamespace/TestClass2.hpp"

#include <iostream>

namespace testnamespace::testsubnamespace {

  int TestClass2::function1(int a, int b) {
    std::cout << "a: '" << a << "'" << std::endl;
    std::cout << "b: '" << b << "'" << std::endl;
    return a + b;
  }

  std::string TestClass2::function2(std::string a, std::string b) {
    std::cout << "a: '" << a << "'" << std::endl;
    std::cout << "b: '" << b << "'" << std::endl;
    return a.append(b);
  }

}
