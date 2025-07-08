cmake_minimum_required(VERSION "3.25" FATAL_ERROR)

message(STATUS "PRESET_NAME: '${PRESET_NAME}'")

set(USE_CONAN "1" CACHE BOOL "...")
set(SKIP_TEST "0" CACHE BOOL "...")

message(STATUS "USE_CONAN: '${USE_CONAN}'")
message(STATUS "SKIP_TEST: '${SKIP_TEST}'")

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/name-version.txt" INFO)
string(REPLACE ":" ";" INFO_LIST "${INFO}")
list(GET INFO_LIST 0 RAW_NAME)
list(GET INFO_LIST 1 RAW_VERSION)
string(STRIP "${RAW_NAME}" NAME)
string(STRIP "${RAW_VERSION}" VERSION)
project("${NAME}" VERSION "${VERSION}" LANGUAGES "NONE")

message(STATUS "PROJECT_NAME: '${PROJECT_NAME}'")
message(STATUS "PROJECT_VERSION: '${PROJECT_VERSION}'")
message(STATUS "PROJECT_SOURCE_DIR: '${PROJECT_SOURCE_DIR}'")
message(STATUS "PROJECT_BINARY_DIR: '${PROJECT_BINARY_DIR}'")

set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/cmake-install" CACHE PATH "..." FORCE)

message(STATUS "CMAKE_INSTALL_PREFIX: '${CMAKE_INSTALL_PREFIX}'")

include("CMakePackageConfigHelpers")

configure_package_config_file(
    "${PROJECT_SOURCE_DIR}/package-config.cmake.in"
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
    INSTALL_DESTINATION "cmake"
)
write_basic_package_version_file(
    "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY "ExactVersion"
)
install(
    FILES "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
          "${PROJECT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake"
          "${PROJECT_SOURCE_DIR}/src/main/cmake/util.cmake"
    DESTINATION "cmake"
)

if(NOT "${SKIP_TEST}")
    set(TEST_GROUP "all" CACHE STRING "...")
    set(TEST_CASE "all" CACHE STRING "...")

    if("${TEST_GROUP}" STREQUAL "all" AND "${TEST_CASE}" STREQUAL "all")
        set(TEST_REGEXP "^.+\\..+$")
    elseif(NOT "${TEST_GROUP}" STREQUAL "all" AND "${TEST_CASE}" STREQUAL "all")
        set(TEST_REGEXP "^${TEST_GROUP}\\..+$")
    elseif("${TEST_GROUP}" STREQUAL "all" AND NOT "${TEST_CASE}" STREQUAL "all")
        set(TEST_REGEXP "^.+\\.${TEST_CASE}$")
    elseif(NOT "${TEST_GROUP}" STREQUAL "all" AND NOT "${TEST_CASE}" STREQUAL "all")
        set(TEST_REGEXP "^${TEST_GROUP}\\.${TEST_CASE}$")
    endif()

    enable_testing()

    string(JSON testListJson SET "{}" "testsuites" "[]")
    file(GLOB TEST_FILES LIST_DIRECTORIES "FALSE" RELATIVE "${PROJECT_SOURCE_DIR}" "${PROJECT_SOURCE_DIR}/src/test/cmake/*.cmake")
    set(testFileIndex "0")
    foreach(testFile IN LISTS "TEST_FILES")
        execute_process(
            COMMAND "${CMAKE_COMMAND}" -P "${testFile}" "--" "list_functions"
            WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
            ERROR_VARIABLE "testFileFunctions"
            COMMAND_ERROR_IS_FATAL "ANY"
        )
        get_filename_component(testFileNameNoExt "${testFile}" NAME_WE)
        string(JSON testListJson SET "${testListJson}" "testsuites" "${testFileIndex}" "{}")
        string(JSON testListJson SET "${testListJson}" "testsuites" "${testFileIndex}" "name" "\"${testFileNameNoExt}\"")
        string(JSON testListJson SET "${testListJson}" "testsuites" "${testFileIndex}" "testsuite" "[]")
        string(STRIP "${testFileFunctions}" testFileFunctions)
        string(REPLACE "\r\n" "\n" testFileFunctions "${testFileFunctions}")
        string(REPLACE "\r" "\n" testFileFunctions "${testFileFunctions}")
        string(REPLACE "\n" ";" testFileFunctions "${testFileFunctions}")
        set(testFileFunctionIndex "0")
        foreach(testFileFunction IN LISTS "testFileFunctions")
            string(JSON testListJson SET "${testListJson}" "testsuites" "${testFileIndex}" "testsuite" "${testFileFunctionIndex}" "{}")
            string(JSON testListJson SET "${testListJson}" "testsuites" "${testFileIndex}" "testsuite" "${testFileFunctionIndex}" "name" "\"${testFileFunction}\"")
            set(testName "${testFileNameNoExt}.${testFileFunction}")
            add_test(
                NAME "${testName}"
                COMMAND "${CMAKE_COMMAND}" -P "${testFile}" "--" "${testFileFunction}"
                WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
            )
            list(APPEND TEST_NAMES "${testName}")
            math(EXPR testFileFunctionIndex "${testFileFunctionIndex} + 1")
        endforeach()
        math(EXPR testFileIndex "${testFileIndex} + 1")
    endforeach()
    file(WRITE "${PROJECT_BINARY_DIR}/tests.json" "${testListJson}")
    message(STATUS "TEST_NAMES:")
    set(TEST_COUNT "0")
    foreach(v IN LISTS "TEST_NAMES")
        message(STATUS "- ${v}")
        math(EXPR TEST_COUNT "${TEST_COUNT} + 1")
    endforeach()
    message(STATUS "TEST_COUNT: '${TEST_COUNT}'")

    add_custom_command(
        OUTPUT "${PROJECT_BINARY_DIR}/junit.xml"
        COMMAND "${CMAKE_CTEST_COMMAND}" "--build-nocmake" "--output-junit" "${PROJECT_BINARY_DIR}/junit.xml" "--preset" "${PRESET_NAME}" "-R" "${TEST_REGEXP}"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        USES_TERMINAL
        VERBATIM
    )

    add_custom_target("cmake-test"
        DEPENDS "${PROJECT_BINARY_DIR}/junit.xml"
    )

    set(TARGET_CMAKE_INSTALL_DEPENDS_ON "cmake-test")
endif()

add_custom_command(
    OUTPUT "${CMAKE_INSTALL_PREFIX}/cmake/${PROJECT_NAME}-config.cmake"
    COMMAND "${CMAKE_COMMAND}" --install "${PROJECT_BINARY_DIR}" --prefix "${CMAKE_INSTALL_PREFIX}"
    DEPENDS ${TARGET_CMAKE_INSTALL_DEPENDS_ON}
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

add_custom_target("cmake-install" ALL
    DEPENDS "${CMAKE_INSTALL_PREFIX}/cmake/${PROJECT_NAME}-config.cmake"
)

if("${USE_CONAN}")
    find_program(CONAN_COMMAND NAMES "conan.exe" "conan" PATHS ENV CONAN_PATH ENV PATH REQUIRED NO_CACHE NO_DEFAULT_PATH)

    add_custom_target("conan-export"
        COMMAND "${CONAN_COMMAND}" "export-pkg"
                "--output-folder" "${CMAKE_INSTALL_PREFIX}"
                #${CONAN_SETTINGS}
                #${CONAN_OPTIONS}
                #"--user" "gitlab-group+gitlab-sub-group+${PROJECT_NAME}"
                #"--channel" "stable"
                "${PROJECT_SOURCE_DIR}/conanfile.py"
        DEPENDS "cmake-install"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        USES_TERMINAL
        VERBATIM
    )

    add_custom_target("conan-remove"
        COMMAND "${CONAN_COMMAND}" "remove" "-c" "${PROJECT_NAME}/${PROJECT_VERSION}"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        USES_TERMINAL
        VERBATIM
    )

    add_custom_target("conan-list"
        COMMAND "${CONAN_COMMAND}" "list" "-c" "${PROJECT_NAME}/${PROJECT_VERSION}:*"
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        USES_TERMINAL
        VERBATIM
    )
endif()

set("${PROJECT_NAME}_ADDITIONAL_CLEAN_FILES"
    "${PROJECT_BINARY_DIR}/test"
)
set_directory_properties(PROPERTIES
    ADDITIONAL_CLEAN_FILES "${${PROJECT_NAME}_ADDITIONAL_CLEAN_FILES}"
)

add_custom_target("vscode"
    COMMAND "${CMAKE_COMMAND}" "-P" "cmake/util.cmake" "--" "vscode"
            SOURCE_DIR "${PROJECT_SOURCE_DIR}"
            BINARY_DIR "${PROJECT_BINARY_DIR}"
            LAUNCH_TESTS_FILE "${PROJECT_BINARY_DIR}/tests.json"
            LAUNCH_TESTS "^.+\\\\..+$"
            LAUNCH_DEFAULT_TEST "^.+\\\\..+$"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)
