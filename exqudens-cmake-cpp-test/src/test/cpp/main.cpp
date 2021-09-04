#include "exqudens/cmake/Application.hpp"

int main(int argc, char** argv) {
  int& argcRef = argc;
  int result = exqudens::cmake::Application(argcRef, argv).run();
  return result;
}
