#include <iostream>
#include <cstdlib>

int main(int argc, char** argv) {
  for (int i = 0; i < argc; i++) {
    std::cout << "argv[" << i << "]: '" << argv[i] << "'" << std::endl;
  }
  return EXIT_SUCCESS;
}
