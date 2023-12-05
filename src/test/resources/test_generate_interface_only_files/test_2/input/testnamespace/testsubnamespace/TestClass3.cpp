#include <testnamespace/testsubnamespace/TestClass3.hpp>

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
