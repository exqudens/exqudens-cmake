cmake_minimum_required(VERSION 3.21 FATAL_ERROR)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/name-version.txt" INFO)
string(REPLACE ":" ";" INFO_LIST "${INFO}")
list(GET INFO_LIST 0 RAW_NAME)
list(GET INFO_LIST 1 RAW_VERSION)
string(STRIP "${RAW_NAME}" NAME)
string(STRIP "${RAW_VERSION}" VERSION)
project("${NAME}" VERSION "${VERSION}" LANGUAGES "NONE")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

include("src/main/cmake/util.cmake")
include("src/main/cmake/config.cmake")

#set(CMAKE_CXX_COMPILER_LAUNCHER "set INCLUDE=abc")
#message("CMAKE_CXX_COMPILER_LAUNCHER: '${CMAKE_CXX_COMPILER_LAUNCHER}'")

add_custom_target("echo-env-home"
    COMMAND "echo" "%HOME%"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    VERBATIM
)

add_custom_target("echo-env-include"
    COMMAND "echo" "%INCLUDE%"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    VERBATIM
)

set_target_names(ALL_TARGETS "${CMAKE_CURRENT_SOURCE_DIR}")
message("all-targets:")
foreach(t ${ALL_TARGETS})
    message("  ${t}")
endforeach()
