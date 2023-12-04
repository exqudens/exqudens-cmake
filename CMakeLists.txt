cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

include("src/main/cmake/util.cmake")

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/name-version.txt" INFO)
string(REPLACE ":" ";" INFO_LIST "${INFO}")
list(GET INFO_LIST 0 RAW_NAME)
list(GET INFO_LIST 1 RAW_VERSION)
string(STRIP "${RAW_NAME}" NAME)
string(STRIP "${RAW_VERSION}" VERSION)
project("${NAME}" VERSION "${VERSION}" LANGUAGES "NONE")

set(TEST_GROUP "all" CACHE STRING "...")
set(TEST_CASE "all" CACHE STRING "...")

if("${TEST_GROUP}" STREQUAL "all" AND "${TEST_CASE}" STREQUAL "all")
    set(TEST_REGEXP "^.+\..+$")
elseif(NOT "${TEST_GROUP}" STREQUAL "all" AND "${TEST_CASE}" STREQUAL "all")
    set(TEST_REGEXP "^${TEST_GROUP}\..+$")
elseif("${TEST_GROUP}" STREQUAL "all" AND NOT "${TEST_CASE}" STREQUAL "all")
    set(TEST_REGEXP "^.+\.${TEST_CASE}$")
elseif(NOT "${TEST_GROUP}" STREQUAL "all" AND NOT "${TEST_CASE}" STREQUAL "all")
    set(TEST_REGEXP "^${TEST_GROUP}\.${TEST_CASE}$")
endif()

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

enable_testing()

message("test-names:")
file(GLOB TEST_FILES LIST_DIRECTORIES "FALSE" RELATIVE "${PROJECT_SOURCE_DIR}" "${PROJECT_SOURCE_DIR}/src/test/cmake/*.cmake")
foreach(testFile IN LISTS "TEST_FILES")
    execute_process(
        COMMAND "${CMAKE_COMMAND}" -P "${testFile}" "--" "list_functions"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        ERROR_VARIABLE "testFileFunctions"
        COMMAND_ERROR_IS_FATAL "ANY"
    )
    get_filename_component(testFileNameNoExt "${testFile}" NAME_WE)
    string(STRIP "${testFileFunctions}" testFileFunctions)
    string(REPLACE "\r\n" "\n" testFileFunctions "${testFileFunctions}")
    string(REPLACE "\r" "\n" testFileFunctions "${testFileFunctions}")
    string(REPLACE "\n" ";" testFileFunctions "${testFileFunctions}")
    foreach(testFileFunction IN LISTS "testFileFunctions")
        add_test(
            NAME "${testFileNameNoExt}.${testFileFunction}"
            COMMAND "${CMAKE_COMMAND}" -P "${testFile}" "--" "${testFileFunction}"
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        )
        message("  ${testFileNameNoExt}.${testFileFunction}")
    endforeach()
endforeach()

add_custom_target("cmake-test" ALL
    COMMAND "${CMAKE_CTEST_COMMAND}" --preset "${PRESET_NAME}" -R "${TEST_REGEXP}"
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
