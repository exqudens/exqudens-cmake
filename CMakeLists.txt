cmake_minimum_required(VERSION 3.17)
project(exqudens_cmake)

# extensions
include(src/main/cmake/get_home_prefix.cmake)

# variables
set(BUILD_HOME_PREFIX "${CMAKE_CURRENT_BINARY_DIR}")
get_home_prefix(BUILD_HOME_PREFIX)
get_home_prefix(HOME_PREFIX)

# test_1
if(NOT "${BUILD_HOME_PREFIX}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
    message(
        FATAL_ERROR
        "'BUILD_HOME_PREFIX' not equal to 'CMAKE_CURRENT_BINARY_DIR' '${BUILD_HOME_PREFIX}' / '${CMAKE_CURRENT_BINARY_DIR}'"
    )
endif()

# test_2
if("${BUILD_HOME_PREFIX}" STREQUAL "${HOME_PREFIX}")
    message(
        FATAL_ERROR
        "'BUILD_HOME_PREFIX' equal to 'HOME_PREFIX' '${BUILD_HOME_PREFIX}' / '${HOME_PREFIX}'"
    )
endif()
