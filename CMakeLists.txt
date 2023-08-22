cmake_minimum_required(VERSION 3.25 FATAL_ERROR)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/name-version.txt" INFO)
string(REPLACE ":" ";" INFO_LIST "${INFO}")
list(GET INFO_LIST 0 RAW_NAME)
list(GET INFO_LIST 1 RAW_VERSION)
string(STRIP "${RAW_NAME}" NAME)
string(STRIP "${RAW_VERSION}" VERSION)
project("${NAME}" VERSION "${VERSION}" LANGUAGES "NONE")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

include("src/main/cmake/util.cmake")
enable_testing()

add_test(
    NAME "test_set_if_not_defined"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_if_not_defined.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_substring_from"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_substring_from.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_substring_to"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_substring_to.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_string_replace_between"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_string_replace_between.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_find_file_in_parent"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_find_file_in_parent.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_find_file_in"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_find_file_in.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_msvc_path"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_msvc_path.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_msvc_env"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_msvc_env.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_msvc_toolchain_content"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_msvc_toolchain_content.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_gnu_toolchain_content"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_gnu_toolchain_content.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_clang_toolchain_content"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_clang_toolchain_content.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_python_boolean"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_python_boolean.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_conan_architecture"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_conan_architecture.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_conan_compiler"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_conan_compiler.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_conan_compiler_version"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_conan_compiler_version.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_conan_compiler_runtime"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_conan_compiler_runtime.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_conan_settings"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_conan_settings.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_conan_options"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_conan_options.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_set_not_found_package_names"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_set_not_found_package_names.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_generate_interface_only_files"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_generate_interface_only_files.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_test(
    NAME "test_doxygen"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/src/test/cmake/test_doxygen.cmake"
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}"
)

add_custom_target("cmake-test"
    COMMAND "${CMAKE_CTEST_COMMAND}"
            --preset "${PRESET_NAME}"
            #-R "test_doxygen"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

set_target_names(ALL_TARGETS "${CMAKE_CURRENT_SOURCE_DIR}")
message("all-targets:")
foreach(t ${ALL_TARGETS})
    message("  ${t}")
endforeach()

set(EXPECTED_ALL_TARGETS
    "all"
    "help"
    "clean"
    "test"
    "install"
    "package"
    "package_source"
    "cmake-test"
)

if(NOT "${EXPECTED_ALL_TARGETS}" STREQUAL "${ALL_TARGETS}")
    message(FATAL_ERROR "'EXPECTED_ALL_TARGETS': '${EXPECTED_ALL_TARGETS}' != 'ALL_TARGETS': '${ALL_TARGETS}'")
endif()
