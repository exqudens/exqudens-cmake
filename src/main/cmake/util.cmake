function(set_if_not_defined var)
    cmake_parse_arguments(PARSE_ARGV 1 FUNCTION "" "" "")
    if(NOT DEFINED "${var}" AND DEFINED "FUNCTION_UNPARSED_ARGUMENTS")
        set("${var}" "${FUNCTION_UNPARSED_ARGUMENTS}" PARENT_SCOPE)
    endif()
endfunction()

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

function(set_msvc_env prefix)
    set(messageMode "DEBUG")

    if("" STREQUAL ${prefix})
        message(FATAL_ERROR "Not defined or empty 'prefix': '${prefix}'.")
    endif()

    set(cmakeParseArgumentsPrefix "FUNCTION")
    set(cmakeParseArgumentsOneValueArgs
        "VSWHERE_COMMAND"
        "COMPILER_VERSION"
        "COMPILER_ARCH"
        "TARGET_ARCH"
    )
    set(cmakeParseArgumentsMultiValueArgs
        ""
    )
    set(cmakeParseArgumentsOptions
        ""
    )
    cmake_parse_arguments(
        PARSE_ARGV
        1
        "${cmakeParseArgumentsPrefix}"
        "${cmakeParseArgumentsOptions}"
        "${cmakeParseArgumentsOneValueArgs}"
        "${cmakeParseArgumentsMultiValueArgs}"
    )
    set(cmakeParseArgumentsRequired
        "COMPILER_VERSION"
        "COMPILER_ARCH"
        "TARGET_ARCH"
    )
    foreach(n ${cmakeParseArgumentsRequired})
        if(NOT DEFINED "${cmakeParseArgumentsPrefix}_${n}")
            message(FATAL_ERROR "'${n}' not defined.")
        endif()
    endforeach()

    message(${messageMode} "FUNCTION_VSWHERE_COMMAND: '${FUNCTION_VSWHERE_COMMAND}'")
    message(${messageMode} "FUNCTION_COMPILER_VERSION: '${FUNCTION_COMPILER_VERSION}'")
    message(${messageMode} "FUNCTION_COMPILER_ARCH: '${FUNCTION_COMPILER_ARCH}'")
    message(${messageMode} "FUNCTION_TARGET_ARCH: '${FUNCTION_TARGET_ARCH}'")

    if(NOT "x86" STREQUAL "${FUNCTION_COMPILER_ARCH}" AND NOT "x64" STREQUAL "${FUNCTION_COMPILER_ARCH}")
        message(FATAL_ERROR "Unsupported or not specified COMPILER_ARCH: '${FUNCTION_COMPILER_ARCH}'. Supported values 'x86' or 'x64'")
    endif()

    if(NOT "x86" STREQUAL "${FUNCTION_TARGET_ARCH}" AND NOT "x64" STREQUAL "${FUNCTION_TARGET_ARCH}")
        message(FATAL_ERROR "Unsupported or not specified TARGET_ARCH: '${FUNCTION_TARGET_ARCH}'. Supported values 'x86' or 'x64'")
    endif()

    if("${FUNCTION_COMPILER_ARCH}" STREQUAL "${FUNCTION_TARGET_ARCH}")
        set(vcvarsallBatConf "${FUNCTION_COMPILER_ARCH}")
    else()
        set(vcvarsallBatConf "${FUNCTION_COMPILER_ARCH}_${FUNCTION_TARGET_ARCH}")
    endif()

    if(
        DEFINED "${${prefix}_MSVC_INCLUDE}"
        OR DEFINED "${${prefix}_MSVC_LIBPATH}"
        OR DEFINED "${${prefix}_MSVC_LIB}"
        OR DEFINED "${${prefix}_MSVC_PATH}"
    )
        message(WARNING "Already DEFINED '${prefix}_MSVC_INCLUDE' or '${prefix}_MSVC_LIBPATH' or '${prefix}_MSVC_LIB' or '${prefix}_MSVC_PATH'")
        message(WARNING "${prefix}_MSVC_INCLUDE: '${${prefix}_MSVC_INCLUDE}'")
        message(WARNING "${prefix}_MSVC_LIBPATH: '${${prefix}_MSVC_LIBPATH}'")
        message(WARNING "${prefix}_MSVC_LIB: '${${prefix}_MSVC_LIB}'")
        message(WARNING "${prefix}_MSVC_PATH: '${${prefix}_MSVC_PATH}'")
    endif()

    if("16" STREQUAL "${FUNCTION_COMPILER_VERSION}" OR "2019" STREQUAL "${FUNCTION_COMPILER_VERSION}")
        set(vswhereVersionArgs "-version" "[16.0, 17.0)")
    elseif("15" STREQUAL "${FUNCTION_COMPILER_VERSION}" OR "2017" STREQUAL "${FUNCTION_COMPILER_VERSION}")
        set(vswhereVersionArgs "-version" "[15.0, 16.0)")
    else()
        #set(vswhereVersionArgs "-latest")
        message(FATAL_ERROR "Unsupported or not specified COMPILER_VERSION: '${FUNCTION_COMPILER_VERSION}'. Supported values ['15', '16', '2017', '2019']")
    endif()

    if(NOT "" STREQUAL "${FUNCTION_VSWHERE_COMMAND}")
        cmake_path(CONVERT "${FUNCTION_VSWHERE_COMMAND}" TO_CMAKE_PATH_LIST "FUNCTION_VSWHERE_COMMAND" NORMALIZE)
    else()
        set(FUNCTION_VSWHERE_COMMAND "C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe")
    endif()

    execute_process(
        COMMAND "${FUNCTION_VSWHERE_COMMAND}" ${vswhereVersionArgs} "-property" "installationPath"
        OUTPUT_VARIABLE "instancePath"
        COMMAND_ECHO "STDERR"
        ENCODING "UTF-8"
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    cmake_path(CONVERT "${instancePath}" TO_CMAKE_PATH_LIST "instancePath" NORMALIZE)
    string(REGEX REPLACE "[\r]" "" "instancePath" "${instancePath}")
    string(REGEX REPLACE "[\n]" ";" "instancePath" "${instancePath}")
    list(GET "instancePath" 0 "instancePath")

    file(GLOB_RECURSE "instanceFiles" "${instancePath}/*")
    set(vcvarsallBatName "vcvarsall.bat")
    foreach(file ${instanceFiles})
        get_filename_component("fileName" "${file}" NAME)
        get_filename_component("path" "${file}" DIRECTORY)
        if("${fileName}" STREQUAL "${vcvarsallBatName}")
            set(vcvarsallBatFile "${file}")
            set(vcvarsallBatPath "${path}")
            break()
        endif()
    endforeach()

    message(${messageMode} "vcvarsallBatFile: '${vcvarsallBatFile}'")
    message(${messageMode} "vcvarsallBatPath: '${vcvarsallBatPath}'")

    set(vcvarsallBatArgs
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
    execute_process(
        COMMAND "cmd" "/c" "${vcvarsallBatName}" "${vcvarsallBatConf}" ${vcvarsallBatArgs}
        WORKING_DIRECTORY "${vcvarsallBatPath}"
        OUTPUT_VARIABLE "instanceEnv"
        COMMAND_ECHO "STDERR"
        ENCODING "UTF-8"
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    message(${messageMode} "instanceEnv: '${instanceEnv}'")

    set_substring_strip("msvcInclude" "INCLUDE_START" "INCLUDE_STOP" "${instanceEnv}")
    string(REGEX REPLACE "[\r]" "" "msvcInclude" "${msvcInclude}")
    string(REGEX REPLACE "[\n]" "" "msvcInclude" "${msvcInclude}")

    set_substring_strip("msvcLibPath" "LIBPATH_START" "LIBPATH_STOP" "${instanceEnv}")
    string(REGEX REPLACE "[\r]" "" "msvcLibPath" "${msvcLibPath}")
    string(REGEX REPLACE "[\n]" "" "msvcLibPath" "${msvcLibPath}")

    set_substring_strip("msvcLibPath" "LIB_START" "LIB_STOP" "${instanceEnv}")
    string(REGEX REPLACE "[\r]" "" "msvcLibPath" "${msvcLibPath}")
    string(REGEX REPLACE "[\n]" "" "msvcLibPath" "${msvcLibPath}")

    set_substring_strip("msvcClPath" "CLPATH_START" "CLPATH_STOP" "${instanceEnv}")
    string(REGEX REPLACE "[\r]" "" "msvcClPath" "${msvcClPath}")
    string(REGEX REPLACE "[\n]" ";" "msvcClPath" "${msvcClPath}")
    list(GET "msvcClPath" 0 "msvcClPath")
    get_filename_component("msvcClPath" "${msvcClPath}" DIRECTORY)
    cmake_path(CONVERT "${msvcClPath}" TO_NATIVE_PATH_LIST "msvcClPath" NORMALIZE)

    set_substring_strip("msvcRcPath" "RCPATH_START" "RCPATH_STOP" "${instanceEnv}")
    string(REGEX REPLACE "[\r]" "" "msvcRcPath" "${msvcRcPath}")
    string(REGEX REPLACE "[\n]" ";" "msvcRcPath" "${msvcRcPath}")
    list(GET "msvcRcPath" 0 "msvcRcPath")
    get_filename_component("msvcRcPath" "${msvcRcPath}" DIRECTORY)
    cmake_path(CONVERT "${msvcRcPath}" TO_NATIVE_PATH_LIST "msvcRcPath" NORMALIZE)

    set("${prefix}_MSVC_INCLUDE" "${msvcInclude}" PARENT_SCOPE)
    set("${prefix}_MSVC_LIBPATH" "${msvcLibPath}" PARENT_SCOPE)
    set("${prefix}_MSVC_LIB" "${msvcLibPath}" PARENT_SCOPE)
    set("${prefix}_MSVC_PATH" "${msvcClPath}" "${msvcRcPath}" PARENT_SCOPE)
endfunction()

function(
    set_not_found_package_names
    variableName
)
    if("${ARGC}" GREATER_EQUAL "2")
        set("start" "1")
        math(EXPR "stop" "${ARGC} - 1")
        foreach(i RANGE "${start}" "${stop}")
            set(argument "${ARGV${i}}")
            if(NOT "${${argument}_FOUND}")
                list(APPEND value "${argument}")
            endif()
        endforeach()
    endif()
    set("${variableName}" "${value}" PARENT_SCOPE)
endfunction()

macro(
    set_targets_recursive
    targets
    dir
)
    get_property(subdirectories DIRECTORY ${dir} PROPERTY SUBDIRECTORIES)
    foreach(subdir ${subdirectories})
        set_targets_recursive(${targets} ${subdir})
    endforeach()
    get_property(current_targets DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
    list(APPEND ${targets} ${current_targets})
endmacro()

function(set_targets var)
    set(targets)
    set_targets_recursive(targets ${CMAKE_CURRENT_SOURCE_DIR})
    set(${var} ${targets} PARENT_SCOPE)
endfunction()
