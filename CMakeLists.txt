cmake_minimum_required(VERSION 3.21 FATAL_ERROR)
get_filename_component(RAW_NAME "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
string(REPLACE " " "_" NAME "${RAW_NAME}")
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/version.txt" RAW_VERSION)
string(STRIP "${RAW_VERSION}" VERSION)
project("${NAME}" VERSION "${VERSION}" LANGUAGES "NONE")

if("${CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT}")
    set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/cmake-install" CACHE PATH "..." FORCE)
endif()

include("src/main/cmake/util.cmake")

set_if_not_defined(MESSAGE_MODE "NOTICE")

message("${MESSAGE_MODE}" "project: '${PROJECT_NAME}-${PROJECT_VERSION}'")
message("${MESSAGE_MODE}" "CMAKE_COMMAND: '${CMAKE_COMMAND}'")
message("${MESSAGE_MODE}" "CMAKE_VERSION: '${CMAKE_VERSION}'")

if("Windows" STREQUAL "${CMAKE_HOST_SYSTEM_NAME}" AND "msvc" STREQUAL "${COMPILER_NAME}" AND NOT DEFINED "ENV{INCLUDE}")
    if(
        "" STREQUAL "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_INCLUDE}"
        OR "" STREQUAL "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_LIBPATH}"
        OR "" STREQUAL "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_LIB}"
        OR "" STREQUAL "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_PATH}"
    )
        set_msvc_env("${CMAKE_PROJECT_NAME}-cpp-test" COMPILER_VERSION "${COMPILER_VERSION}" COMPILER_ARCH "${COMPILER_ARCH}" TARGET_ARCH "${TARGET_ARCH}")
        set("${CMAKE_PROJECT_NAME}-cpp-test_MSVC_INCLUDE" "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_INCLUDE}" CACHE STRING "")
        set("${CMAKE_PROJECT_NAME}-cpp-test_MSVC_LIBPATH" "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_LIBPATH}" CACHE STRING "")
        set("${CMAKE_PROJECT_NAME}-cpp-test_MSVC_LIB" "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_LIB}" CACHE STRING "")
        set("${CMAKE_PROJECT_NAME}-cpp-test_MSVC_PATH" "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_PATH}" CACHE STRING "")
    endif()
    set("ENV{INCLUDE}" "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_INCLUDE}")
    set("ENV{LIBPATH}" "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_LIBPATH}")
    set("ENV{LIB}" "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_LIB}")
    set("ENV{PATH}" "${${CMAKE_PROJECT_NAME}-cpp-test_MSVC_PATH}\;$ENV{PATH}")
endif()

enable_language("C")
enable_language("CXX")

add_subdirectory("${PROJECT_NAME}-cpp-test")
#add_subdirectory("${PROJECT_NAME}-conan-test")
#add_subdirectory("${PROJECT_NAME}-extension-test")
#add_subdirectory("${PROJECT_NAME}-test")

set_targets("${PROJECT_NAME}_TARGETS")

add_custom_target("targets"
    COMMAND "${CMAKE_COMMAND}" -E echo ${${PROJECT_NAME}_TARGETS}
    VERBATIM
)
