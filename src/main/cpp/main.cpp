#include <iostream>
#include <chrono>
#include <string>
#include <cstdlib>

int main(int argc, char** argv) {
  time_t time = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
  std::string stringTime = std::ctime(&time);
  stringTime.resize(stringTime.size() - 1);
  std::cout << stringTime << std::endl;
  for (int i = 0; i < argc; i++) {
    std::cout << "argv[" << i << "]: '" << argv[i] << "'" << std::endl;
  }
  return EXIT_SUCCESS;
}
