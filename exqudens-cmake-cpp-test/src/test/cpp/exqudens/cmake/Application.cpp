#include <iostream>

#include "exqudens/cmake/Application.hpp"

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
    return 0;
  }

  Application::~Application() {
    std::cout << "Application::~Application()" << std::endl;
  }

}
