#pragma once

#include <vector>
#include <string>

namespace exqudens::cmake {

  class Application {

    private:

      std::vector<std::string> arguments;

    public:

      Application(int& argc, char** argv);

      int run();

      ~Application();

  };

}
