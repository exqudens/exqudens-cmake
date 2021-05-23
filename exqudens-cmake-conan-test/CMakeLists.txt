cmake_minimum_required(VERSION 3.20)
project("${CMAKE_PROJECT_NAME}-conan-test" VERSION "${CMAKE_PROJECT_VERSION}")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED "ON")

include("${CMAKE_SOURCE_DIR}/src/main/cmake/conan.cmake")

conan_settings(
    OVERWRITE
    CONAN_SETTINGS
    "${CMAKE_SYSTEM_NAME}"
    "${CMAKE_SYSTEM_PROCESSOR}"
    "${CMAKE_CXX_COMPILER_ID}"
    "${CMAKE_CXX_COMPILER_VERSION}"
    "${CMAKE_CXX_STANDARD}"
    "${CMAKE_BUILD_TYPE}"
)

conan_options(
    OVERWRITE
    CONAN_OPTIONS
    "${BUILD_SHARED_LIBS}"
    "fmt"
)

conan_install(
    NO_OVERWRITE
    "${CMAKE_CURRENT_BINARY_DIR}/conan-installed"
    "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py"
    "${CONAN_SETTINGS}"
    "${CONAN_OPTIONS}"
    "${CONAN_PROGRAM}"
)
