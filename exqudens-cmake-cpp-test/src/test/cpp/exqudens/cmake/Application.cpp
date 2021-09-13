#include <iostream>

#include "exqudens/cmake/Application.hpp"
#include "exqudens/cmake/Procedures.hpp"

namespace exqudens::cmake {

  Application::Application(int& argc, char** argv) {
    std::cout << "Application::Application(int& argc, char** argv)" << std::endl;
    for (int i = 0; i < argc; i++) {
      arguments.emplace_back(std::string(argv[i]));
    }
  }

  int Application::run() {
    std::cout << "Application::run()" << std::endl;
    for (int i = 0; i < arguments.size(); i++) {
      std::cout << "arguments[" << i << "]='" << arguments.at(i) << "'" << std::endl;
    }
    std::cout << "---" << std::endl;
    std::tuple<int, std::string, std::string> created = Procedures::create("John", "Smith");
    std::cout << "created: '[" << std::get<0>(created) << ", " << std::get<1>(created) << ", " << std::get<2>(created) << "]'" << std::endl;
    std::cout << "---" << std::endl;
    return 0;
  }

  Application::~Application() {
    std::cout << "Application::~Application()" << std::endl;
  }

}
