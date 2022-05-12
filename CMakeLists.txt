cmake_minimum_required(VERSION 3.21 FATAL_ERROR)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/name-version.txt" INFO)
string(REPLACE ":" ";" INFO_LIST "${INFO}")
list(GET INFO_LIST 0 RAW_NAME)
list(GET INFO_LIST 1 RAW_VERSION)
string(STRIP "${RAW_NAME}" NAME)
string(STRIP "${RAW_VERSION}" VERSION)
if("${TOOLCHAIN}")
    execute_process(
        COMMAND "${CMAKE_COMMAND}" "-P" "src/main/cmake/util.cmake" "toolchain"
                processor "$ENV{PROCESSOR_ARCHITECTURE}"
                os "${CMAKE_HOST_SYSTEM_NAME}"
                compiler "${CXX_COMPILER_NAME}"
                version "${CXX_COMPILER_VERSION}"
                host "$ENV{PROCESSOR_ARCHITECTURE}"
                target "$ENV{PROCESSOR_ARCHITECTURE}"
                file "${CMAKE_BINARY_DIR}/toolchain.cmake"
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    )
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_BINARY_DIR}/toolchain.cmake")
endif()
project("${NAME}" VERSION "${VERSION}" LANGUAGES "NONE")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

include("src/main/cmake/util.cmake")
include("src/main/cmake/config.cmake")

#set(CMAKE_CXX_COMPILER_LAUNCHER "set INCLUDE=abc")
#message("CMAKE_CXX_COMPILER_LAUNCHER: '${CMAKE_CXX_COMPILER_LAUNCHER}'")

add_executable("${PROJECT_NAME}" "src/main/cpp/main.cpp")
set_target_properties("${PROJECT_NAME}" PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/main/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/main/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/main/bin"
    RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/main/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/main/bin"

    ARCHIVE_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/main/lib"
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/main/lib"
    ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/main/lib"
    ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/main/lib"
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/main/lib"

    LIBRARY_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/main/lib"
    LIBRARY_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/main/lib"
    LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/main/lib"
    LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/main/lib"
    LIBRARY_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/main/lib"
)

set_target_names(ALL_TARGETS "${CMAKE_CURRENT_SOURCE_DIR}")
message("all-targets:")
foreach(t ${ALL_TARGETS})
    message("  ${t}")
endforeach()

#[[find_file_in_parent(VAR1
    "vcvarsall.bat"
    "C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl.exe"
    "8"
)

message("VAR1_FILE: '${VAR1_FILE}'")
message("VAR1_FILE: '${VAR1_DIR}'")

find_file_in(VAR2
    "vcvarsall.bat"
    "C:/Program Files (x86)/Microsoft Visual Studio/2019/Community"
)

message("VAR2_FILE: '${VAR2_FILE}'")
message("VAR2_FILE: '${VAR2_DIR}'")]]
