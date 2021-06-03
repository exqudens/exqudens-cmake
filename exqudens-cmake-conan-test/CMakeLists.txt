cmake_minimum_required(VERSION 3.20)
project("${CMAKE_PROJECT_NAME}-conan-test" VERSION "${CMAKE_PROJECT_VERSION}")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED "ON")

include("${CMAKE_SOURCE_DIR}/src/main/cmake/conan.cmake")

set_conan_path(CONAN_PROGRAM_PATH "$ENV{PATH}")
set_conan_command(CONAN_COMMAND "${CONAN_PROGRAM_PATH}")

set_conan_settings(
    CONAN_SETTINGS
    "${CMAKE_SYSTEM_NAME}"
    "${CMAKE_SYSTEM_PROCESSOR}"
    "${CMAKE_CXX_COMPILER_ID}"
    "${CMAKE_CXX_COMPILER_VERSION}"
    "${CMAKE_MSVC_RUNTIME_LIBRARY}"
    "${CMAKE_CXX_STANDARD}"
    "${CMAKE_BUILD_TYPE}"
)

set_conan_options(
    CONAN_OPTIONS
    "${BUILD_SHARED_LIBS}"
    "fmt"
)

if(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/conan-installed")
    #file(REMOVE_RECURSE "${CMAKE_CURRENT_BINARY_DIR}/conan-installed")
endif()
conan_install(
    "${CONAN_COMMAND}"
    "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py"
    "${CMAKE_CURRENT_BINARY_DIR}/conan-installed"
    "${CONAN_SETTINGS}"
    "${CONAN_OPTIONS}"
)
