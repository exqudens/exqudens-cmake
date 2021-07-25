cmake_policy(SET CMP0009 NEW)

function(set_substring_strip var startAnchor stopAnchor input)
    string(LENGTH "${startAnchor}" "startAnchorLength")
    string(FIND "${input}" "${startAnchor}" startIndex)
    string(FIND "${input}" "${stopAnchor}" stopIndex)

    if("-1" STREQUAL "${startIndex}" OR "-1" STREQUAL "${stopIndex}")
        message(FATAL_ERROR "Can't find 'startAnchor' or 'stopAnchor' in 'input'")
    endif()

    math(EXPR startIndex "${startIndex} + ${startAnchorLength}")
    math(EXPR substringLength "${stopIndex} - ${startIndex}")
    string(SUBSTRING "${input}" "${startIndex}" "${substringLength}" result)
    string(STRIP "${result}" result)
    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_cmd_path var startAnchor stopAnchor input)
    set_substring_strip(resultString "${startAnchor}" "${stopAnchor}" "${input}")
    string(REGEX REPLACE "[\r]" "" resultString "${resultString}")
    string(REGEX REPLACE "[\n]" ";" resultList "${resultString}")

    foreach(p ${resultList})
        get_filename_component(value "${p}" DIRECTORY)
        cmake_path(CONVERT "${value}" TO_NATIVE_PATH_LIST value NORMALIZE)
        list(APPEND result "${value}")
    endforeach()

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_bash_path var input)
    foreach(p ${input})
        cmake_path(CONVERT "${p}" TO_CMAKE_PATH_LIST path NORMALIZE)
        cmake_path(GET path ROOT_NAME rootName)
        string(REPLACE ":" "" rootName "${rootName}")
        string(TOLOWER "${rootName}" rootName)
        cmake_path(GET path RELATIVE_PART relativePath)
        list(APPEND result "/${rootName}/${relativePath}")
        string(REPLACE ";" ":" result "${result}")
    endforeach()

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

set(SCRIPT_VSWHERE_EXE_CMD_DIR_PATH "C:\\Program Files (x86)\\Microsoft Visual Studio\\Installer")
set(SCRIPT_VSWHERE_EXE_FILE_NAME "vswhere.exe")
set(SCRIPT_VCVARSALL_BAT_FILE_NAME "vcvarsall.bat")
set(SCRIPT_CMD_COMMAND_SUFFIX
    "&&" "call" "echo" "INCLUDE_START"
    "&&" "call" "echo" "%INCLUDE%"
    "&&" "call" "echo" "INCLUDE_STOP"
    "&&" "call" "echo" "LIBPATH_START"
    "&&" "call" "echo" "%LIBPATH%"
    "&&" "call" "echo" "LIBPATH_STOP"
    "&&" "call" "echo" "LIB_START"
    "&&" "call" "echo" "%LIB%"
    "&&" "call" "echo" "LIB_STOP"
    "&&" "call" "echo" "CLPATH_START"
    "&&" "call" "where" "cl"
    "&&" "call" "echo" "CLPATH_STOP"
    "&&" "call" "echo" "RCPATH_START"
    "&&" "call" "where" "rc"
    "&&" "call" "echo" "RCPATH_STOP"
)

cmake_path(CONVERT "${SCRIPT_VSWHERE_EXE_CMD_DIR_PATH}" TO_CMAKE_PATH_LIST "SCRIPT_VSWHERE_EXE_CMAKE_DIR_PATH" NORMALIZE)

find_file(SCRIPT_VSWHERE_EXE_CMD_FILE_PATH "${SCRIPT_VSWHERE_EXE_FILE_NAME}" "${SCRIPT_VSWHERE_EXE_CMAKE_DIR_PATH}")

if(NOT EXISTS "${SCRIPT_VSWHERE_EXE_CMD_FILE_PATH}")
    message(FATAL_ERROR "'${SCRIPT_VSWHERE_EXE_FILE_NAME}' not exists in '${SCRIPT_VSWHERE_EXE_CMAKE_DIR_PATH}'")
endif()

if("${CMAKE_ARGV3}" STREQUAL "2019" OR "${CMAKE_ARGV3}" STREQUAL "16")
    execute_process(
        COMMAND "${SCRIPT_VSWHERE_EXE_FILE_NAME}"
        "-version" "[16.0, 17.0)"
        "-property" "installationPath"
        WORKING_DIRECTORY "${SCRIPT_VSWHERE_EXE_CMAKE_DIR_PATH}"
        OUTPUT_VARIABLE "SCRIPT_MSVC_INSTANCE_CMD_DIR_PATH"
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
elseif("${CMAKE_ARGV3}" STREQUAL "2017" OR "${CMAKE_ARGV3}" STREQUAL "15")
    execute_process(
        COMMAND "${SCRIPT_VSWHERE_EXE_FILE_NAME}"
        "-version" "[15.0, 16.0)"
        "-property" "installationPath"
        WORKING_DIRECTORY "${SCRIPT_VSWHERE_EXE_CMAKE_DIR_PATH}"
        OUTPUT_VARIABLE "SCRIPT_MSVC_INSTANCE_CMD_DIR_PATH"
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
else()
    execute_process(
        COMMAND "${SCRIPT_VSWHERE_EXE_FILE_NAME}"
        "-latest"
        "-property" "installationPath"
        WORKING_DIRECTORY "${SCRIPT_VSWHERE_EXE_CMAKE_DIR_PATH}"
        OUTPUT_VARIABLE "SCRIPT_MSVC_INSTANCE_CMD_DIR_PATH"
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

if("" STREQUAL "${SCRIPT_MSVC_INSTANCE_CMD_DIR_PATH}")
    message(FATAL_ERROR "'SCRIPT_MSVC_INSTANCE_CMD_DIR_PATH' not found")
endif()

cmake_path(CONVERT "${SCRIPT_MSVC_INSTANCE_CMD_DIR_PATH}" TO_CMAKE_PATH_LIST "SCRIPT_MSVC_INSTANCE_CMAKE_DIR_PATH" NORMALIZE)

file(GLOB_RECURSE "SCRIPT_MSVC_INSTANCE_CMAKE_FILE_PATHS" "${SCRIPT_MSVC_INSTANCE_CMAKE_DIR_PATH}/*")

set(SCRIPT_VCVARSALL_BAT_CMAKE_FILE_PATH "")

foreach(SCRIPT_P ${SCRIPT_MSVC_INSTANCE_CMAKE_FILE_PATHS})
    get_filename_component("SCRIPT_N" "${SCRIPT_P}" NAME)
    if("${SCRIPT_N}" STREQUAL "${SCRIPT_VCVARSALL_BAT_FILE_NAME}")
        set(SCRIPT_VCVARSALL_BAT_CMAKE_FILE_PATH "${SCRIPT_P}")
        break()
    endif()
endforeach()

get_filename_component("SCRIPT_VCVARSALL_BAT_CMAKE_DIR_PATH" "${SCRIPT_VCVARSALL_BAT_CMAKE_FILE_PATH}" DIRECTORY)

execute_process(
    COMMAND "cmd" "/c" "${SCRIPT_VCVARSALL_BAT_FILE_NAME}" "x86" ${SCRIPT_CMD_COMMAND_SUFFIX}
    WORKING_DIRECTORY "${SCRIPT_VCVARSALL_BAT_CMAKE_DIR_PATH}"
    OUTPUT_VARIABLE "SCRIPT_MSVC_X86_CMD_ENV"
    #COMMAND_ECHO "STDOUT"
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set_substring_strip(SCRIPT_MSVC_X86_CMD_INCLUDE "INCLUDE_START" "INCLUDE_STOP" "${SCRIPT_MSVC_X86_CMD_ENV}")
set_substring_strip(SCRIPT_MSVC_X86_CMD_LIBPATH "LIBPATH_START" "LIBPATH_STOP" "${SCRIPT_MSVC_X86_CMD_ENV}")
set_substring_strip(SCRIPT_MSVC_X86_CMD_LIB "LIB_START" "LIB_STOP" "${SCRIPT_MSVC_X86_CMD_ENV}")
set_cmd_path(SCRIPT_MSVC_X86_CMD_CLPATH "CLPATH_START" "CLPATH_STOP" "${SCRIPT_MSVC_X86_CMD_ENV}")
set_cmd_path(SCRIPT_MSVC_X86_CMD_RCPATH "RCPATH_START" "RCPATH_STOP" "${SCRIPT_MSVC_X86_CMD_ENV}")
set_bash_path(SCRIPT_MSVC_X86_BASH_CLPATH "${SCRIPT_MSVC_X86_CMD_CLPATH}")
set_bash_path(SCRIPT_MSVC_X86_BASH_RCPATH "${SCRIPT_MSVC_X86_CMD_RCPATH}")

message("X86_ENV_START")

message(INCLUDE_START)
message("${SCRIPT_MSVC_X86_CMD_INCLUDE}")
message("INCLUDE_STOP")

message(LIBPATH_START)
message("${SCRIPT_MSVC_X86_CMD_LIBPATH}")
message(LIBPATH_STOP)

message(LIB_START)
message("${SCRIPT_MSVC_X86_CMD_LIB}")
message(LIB_STOP)

message(CMD_CLPATH_START)
message("${SCRIPT_MSVC_X86_CMD_CLPATH}")
message(CMD_CLPATH_STOP)

message(CMD_RCPATH_START)
message("${SCRIPT_MSVC_X86_CMD_RCPATH}")
message(CMD_RCPATH_STOP)

message(BASH_CLPATH_START)
message("${SCRIPT_MSVC_X86_BASH_CLPATH}")
message(BASH_CLPATH_STOP)

message(BASH_RCPATH_START)
message("${SCRIPT_MSVC_X86_BASH_RCPATH}")
message(BASH_RCPATH_STOP)

message("X86_ENV_STOP")

execute_process(
    COMMAND "cmd" "/c" "${SCRIPT_VCVARSALL_BAT_FILE_NAME}" "x64_x86" ${SCRIPT_CMD_COMMAND_SUFFIX}
    WORKING_DIRECTORY "${SCRIPT_VCVARSALL_BAT_CMAKE_DIR_PATH}"
    OUTPUT_VARIABLE "SCRIPT_MSVC_X64_X86_CMD_ENV"
    #COMMAND_ECHO "STDOUT"
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set_substring_strip(SCRIPT_MSVC_X64_X86_CMD_INCLUDE "INCLUDE_START" "INCLUDE_STOP" "${SCRIPT_MSVC_X64_X86_CMD_ENV}")
set_substring_strip(SCRIPT_MSVC_X64_X86_CMD_LIBPATH "LIBPATH_START" "LIBPATH_STOP" "${SCRIPT_MSVC_X64_X86_CMD_ENV}")
set_substring_strip(SCRIPT_MSVC_X64_X86_CMD_LIB "LIB_START" "LIB_STOP" "${SCRIPT_MSVC_X64_X86_CMD_ENV}")
set_cmd_path(SCRIPT_MSVC_X64_X86_CMD_CLPATH "CLPATH_START" "CLPATH_STOP" "${SCRIPT_MSVC_X64_X86_CMD_ENV}")
set_cmd_path(SCRIPT_MSVC_X64_X86_CMD_RCPATH "RCPATH_START" "RCPATH_STOP" "${SCRIPT_MSVC_X64_X86_CMD_ENV}")
set_bash_path(SCRIPT_MSVC_X64_X86_BASH_CLPATH "${SCRIPT_MSVC_X64_X86_CMD_CLPATH}")
set_bash_path(SCRIPT_MSVC_X64_X86_BASH_RCPATH "${SCRIPT_MSVC_X64_X86_CMD_RCPATH}")

message("X64_X86_ENV_START")

message(INCLUDE_START)
message("${SCRIPT_MSVC_X64_X86_CMD_INCLUDE}")
message("INCLUDE_STOP")

message(LIBPATH_START)
message("${SCRIPT_MSVC_X64_X86_CMD_LIBPATH}")
message(LIBPATH_STOP)

message(LIB_START)
message("${SCRIPT_MSVC_X64_X86_CMD_LIB}")
message(LIB_STOP)

message(CMD_CLPATH_START)
message("${SCRIPT_MSVC_X64_X86_CMD_CLPATH}")
message(CMD_CLPATH_STOP)

message(CMD_RCPATH_START)
message("${SCRIPT_MSVC_X64_X86_CMD_RCPATH}")
message(CMD_RCPATH_STOP)

message(BASH_CLPATH_START)
message("${SCRIPT_MSVC_X64_X86_BASH_CLPATH}")
message(BASH_CLPATH_STOP)

message(BASH_RCPATH_START)
message("${SCRIPT_MSVC_X64_X86_BASH_RCPATH}")
message(BASH_RCPATH_STOP)

message("X64_X86_ENV_STOP")

execute_process(
    COMMAND "cmd" "/c" "${SCRIPT_VCVARSALL_BAT_FILE_NAME}" "x64" ${SCRIPT_CMD_COMMAND_SUFFIX}
    WORKING_DIRECTORY "${SCRIPT_VCVARSALL_BAT_CMAKE_DIR_PATH}"
    OUTPUT_VARIABLE "SCRIPT_MSVC_X64_CMD_ENV"
    #COMMAND_ECHO "STDOUT"
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set_substring_strip(SCRIPT_MSVC_X64_CMD_INCLUDE "INCLUDE_START" "INCLUDE_STOP" "${SCRIPT_MSVC_X64_CMD_ENV}")
set_substring_strip(SCRIPT_MSVC_X64_CMD_LIBPATH "LIBPATH_START" "LIBPATH_STOP" "${SCRIPT_MSVC_X64_CMD_ENV}")
set_substring_strip(SCRIPT_MSVC_X64_CMD_LIB "LIB_START" "LIB_STOP" "${SCRIPT_MSVC_X64_CMD_ENV}")
set_cmd_path(SCRIPT_MSVC_X64_CMD_CLPATH "CLPATH_START" "CLPATH_STOP" "${SCRIPT_MSVC_X64_CMD_ENV}")
set_cmd_path(SCRIPT_MSVC_X64_CMD_RCPATH "RCPATH_START" "RCPATH_STOP" "${SCRIPT_MSVC_X64_CMD_ENV}")
set_bash_path(SCRIPT_MSVC_X64_BASH_CLPATH "${SCRIPT_MSVC_X64_CMD_CLPATH}")
set_bash_path(SCRIPT_MSVC_X64_BASH_RCPATH "${SCRIPT_MSVC_X64_CMD_RCPATH}")

message("X64_ENV_START")

message(INCLUDE_START)
message("${SCRIPT_MSVC_X64_CMD_INCLUDE}")
message("INCLUDE_STOP")

message(LIBPATH_START)
message("${SCRIPT_MSVC_X64_CMD_LIBPATH}")
message(LIBPATH_STOP)

message(LIB_START)
message("${SCRIPT_MSVC_X64_CMD_LIB}")
message(LIB_STOP)

message(CMD_CLPATH_START)
message("${SCRIPT_MSVC_X64_CMD_CLPATH}")
message(CMD_CLPATH_STOP)

message(CMD_RCPATH_START)
message("${SCRIPT_MSVC_X64_CMD_RCPATH}")
message(CMD_RCPATH_STOP)

message(BASH_CLPATH_START)
message("${SCRIPT_MSVC_X64_BASH_CLPATH}")
message(BASH_CLPATH_STOP)

message(BASH_RCPATH_START)
message("${SCRIPT_MSVC_X64_BASH_RCPATH}")
message(BASH_RCPATH_STOP)

message("X64_ENV_STOP")

execute_process(
    COMMAND "cmd" "/c" "${SCRIPT_VCVARSALL_BAT_FILE_NAME}" "x86_x64" ${SCRIPT_CMD_COMMAND_SUFFIX}
    WORKING_DIRECTORY "${SCRIPT_VCVARSALL_BAT_CMAKE_DIR_PATH}"
    OUTPUT_VARIABLE "SCRIPT_MSVC_X86_X64_CMD_ENV"
    #COMMAND_ECHO "STDOUT"
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set_substring_strip(SCRIPT_MSVC_X86_X64_CMD_INCLUDE "INCLUDE_START" "INCLUDE_STOP" "${SCRIPT_MSVC_X86_X64_CMD_ENV}")
set_substring_strip(SCRIPT_MSVC_X86_X64_CMD_LIBPATH "LIBPATH_START" "LIBPATH_STOP" "${SCRIPT_MSVC_X86_X64_CMD_ENV}")
set_substring_strip(SCRIPT_MSVC_X86_X64_CMD_LIB "LIB_START" "LIB_STOP" "${SCRIPT_MSVC_X86_X64_CMD_ENV}")
set_cmd_path(SCRIPT_MSVC_X86_X64_CMD_CLPATH "CLPATH_START" "CLPATH_STOP" "${SCRIPT_MSVC_X86_X64_CMD_ENV}")
set_cmd_path(SCRIPT_MSVC_X86_X64_CMD_RCPATH "RCPATH_START" "RCPATH_STOP" "${SCRIPT_MSVC_X86_X64_CMD_ENV}")
set_bash_path(SCRIPT_MSVC_X86_X64_BASH_CLPATH "${SCRIPT_MSVC_X86_X64_CMD_CLPATH}")
set_bash_path(SCRIPT_MSVC_X86_X64_BASH_RCPATH "${SCRIPT_MSVC_X86_X64_CMD_RCPATH}")

message("X86_X64_ENV_START")

message(INCLUDE_START)
message("${SCRIPT_MSVC_X86_X64_CMD_INCLUDE}")
message("INCLUDE_STOP")

message(LIBPATH_START)
message("${SCRIPT_MSVC_X86_X64_CMD_LIBPATH}")
message(LIBPATH_STOP)

message(LIB_START)
message("${SCRIPT_MSVC_X86_X64_CMD_LIB}")
message(LIB_STOP)

message(CMD_CLPATH_START)
message("${SCRIPT_MSVC_X86_X64_CMD_CLPATH}")
message(CMD_CLPATH_STOP)

message(CMD_RCPATH_START)
message("${SCRIPT_MSVC_X86_X64_CMD_RCPATH}")
message(CMD_RCPATH_STOP)

message(BASH_CLPATH_START)
message("${SCRIPT_MSVC_X86_X64_BASH_CLPATH}")
message(BASH_CLPATH_STOP)

message(BASH_RCPATH_START)
message("${SCRIPT_MSVC_X86_X64_BASH_RCPATH}")
message(BASH_RCPATH_STOP)

message("X86_X64_ENV_STOP")
