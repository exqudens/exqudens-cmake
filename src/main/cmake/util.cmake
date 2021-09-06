function(set_if_not_defined var)
    cmake_parse_arguments(PARSE_ARGV 1 FUNCTION "" "" "")
    if(NOT DEFINED "${var}" AND DEFINED "FUNCTION_UNPARSED_ARGUMENTS")
        set("${var}" "${FUNCTION_UNPARSED_ARGUMENTS}" PARENT_SCOPE)
    endif()
endfunction()

function(string_substring_from var input fromExclusive)
    if("" STREQUAL "${fromExclusive}")
        message(FATAL_ERROR "Empty value not supported for 'fromExclusive'.")
    endif()
    string(FIND "${input}" "${fromExclusive}" fromStartIndex)
    if("-1" STREQUAL "${fromStartIndex}")
        message(FATAL_ERROR "Can't find 'fromExclusive' in 'input'")
    endif()
    string(LENGTH "${input}" inputLength)
    string(LENGTH "${fromExclusive}" "fromLength")
    math(EXPR fromEndIndex "${fromStartIndex} + ${fromLength}")
    math(EXPR substringLength "${inputLength} - ${fromEndIndex}")
    string(SUBSTRING "${input}" "${fromEndIndex}" "${substringLength}" result)
    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(string_substring_to var input toExclusive)
    if("" STREQUAL "${toExclusive}")
        message(FATAL_ERROR "Empty value not supported for 'toExclusive'.")
    endif()
    string(FIND "${input}" "${toExclusive}" toStartIndex)
    if("-1" STREQUAL "${toStartIndex}")
        message(FATAL_ERROR "Can't find 'toExclusive' in 'input'")
    endif()
    string(LENGTH "${input}" inputLength)
    string(SUBSTRING "${input}" 0 "${toStartIndex}" result)
    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(string_substring_between var input fromExclusive toExclusive)
    string_substring_from(result "${input}" "${fromExclusive}")
    string_substring_to(result "${result}" "${toExclusive}")
    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_msvc_path var vswhereCommand compilerVersion)
    foreach(name var compilerVersion)
        if("" STREQUAL "${${name}}")
            message(FATAL_ERROR "'${name}' is required and not defined.")
        endif()
    endforeach()

    if(NOT "" STREQUAL "${vswhereCommand}")
        cmake_path(CONVERT "${vswhereCommand}" TO_CMAKE_PATH_LIST vswhereCommand NORMALIZE)
    else()
        set(vswhereCommand "C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe")
    endif()

    if("16" STREQUAL "${compilerVersion}" OR "2019" STREQUAL "${compilerVersion}")
        set(vswhereVersionArgs "-version" "[16.0, 17.0)")
    elseif("15" STREQUAL "${compilerVersion}" OR "2017" STREQUAL "${compilerVersion}")
        set(vswhereVersionArgs "-version" "[15.0, 16.0)")
    else()
        #set(vswhereVersionArgs "-latest")
        string(JOIN " " errorMessage
            "Unsupported or not specified 'compilerVersion': '${compilerVersion}'."
            "Supported values ['15', '16', '2017', '2019']."
        )
        message(FATAL_ERROR "${errorMessage}")
    endif()

    execute_process(
        COMMAND "${vswhereCommand}" ${vswhereVersionArgs} "-property" "installationPath"
        OUTPUT_VARIABLE "result"
        COMMAND_ECHO "STDERR"
        ENCODING "UTF-8"
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    cmake_path(CONVERT "${result}" TO_CMAKE_PATH_LIST result NORMALIZE)
    string(REGEX REPLACE "[\r]" "" result "${result}")
    string(REGEX REPLACE "[\n]" ";" result "${result}")
    list(GET result 0 result)

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_msvc_env prefix vswhereCommand compilerVersion compilerArch targetArch)
    foreach(name prefix compilerVersion compilerArch targetArch)
        if("" STREQUAL "${${name}}")
            message(FATAL_ERROR "'${name}' is required and not defined.")
        endif()
    endforeach()

    if(NOT "x86" STREQUAL "${compilerArch}" AND NOT "x64" STREQUAL "${compilerArch}")
        string(JOIN " " errorMessage
            "Unsupported or not specified 'compilerArch': '${compilerArch}'."
            "Supported values ['x86', 'x64']."
        )
        message(FATAL_ERROR "${errorMessage}")
    endif()

    if(NOT "x86" STREQUAL "${targetArch}" AND NOT "x64" STREQUAL "${targetArch}")
        string(JOIN " " errorMessage
            "Unsupported or not specified 'targetArch': '${targetArch}'."
            "Supported values [ 'x86', 'x64' ]."
        )
        message(FATAL_ERROR "${errorMessage}")
    endif()

    if("${compilerArch}" STREQUAL "${targetArch}")
        set(vcvarsallBatConf "${compilerArch}")
    else()
        set(vcvarsallBatConf "${compilerArch}_${targetArch}")
    endif()

    set_msvc_path(msvcPath "${vswhereCommand}" "${compilerVersion}")

    file(GLOB_RECURSE msvcFiles "${msvcPath}/*")
    set(vcvarsallBatName "vcvarsall.bat")
    foreach(file IN LISTS msvcFiles)
        get_filename_component(fileName "${file}" NAME)
        get_filename_component(path "${file}" DIRECTORY)
        if("${fileName}" STREQUAL "${vcvarsallBatName}")
            set(vcvarsallBatFile "${file}")
            set(vcvarsallBatPath "${path}")
            break()
        endif()
    endforeach()

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
        OUTPUT_VARIABLE "msvcEnv"
        COMMAND_ECHO "STDERR"
        ENCODING "UTF-8"
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    string_substring_between(msvcInclude "${msvcEnv}" "INCLUDE_START" "INCLUDE_STOP")
    string(STRIP "${msvcInclude}" msvcInclude)
    string(REGEX REPLACE "[\r]" "" msvcInclude "${msvcInclude}")
    string(REGEX REPLACE "[\n]" "" msvcInclude "${msvcInclude}")

    string_substring_between(msvcLibPath "${msvcEnv}" "LIBPATH_START" "LIBPATH_STOP")
    string(STRIP "${msvcLibPath}" msvcLibPath)
    string(REGEX REPLACE "[\r]" "" msvcLibPath "${msvcLibPath}")
    string(REGEX REPLACE "[\n]" "" msvcLibPath "${msvcLibPath}")

    string_substring_between(msvcLib "${msvcEnv}" "LIB_START" "LIB_STOP")
    string(STRIP "${msvcLib}" msvcLib)
    string(REGEX REPLACE "[\r]" "" msvcLib "${msvcLib}")
    string(REGEX REPLACE "[\n]" "" msvcLib "${msvcLib}")

    string_substring_between(msvcClPath "${msvcEnv}" "CLPATH_START" "CLPATH_STOP")
    string(STRIP "${msvcClPath}" msvcClPath)
    string(REGEX REPLACE "[\r]" "" msvcClPath "${msvcClPath}")
    string(REGEX REPLACE "[\n]" ";" msvcClPath "${msvcClPath}")
    list(GET msvcClPath 0 msvcClPath)
    get_filename_component(msvcClPath "${msvcClPath}" DIRECTORY)
    cmake_path(CONVERT "${msvcClPath}" TO_NATIVE_PATH_LIST msvcClPath NORMALIZE)

    string_substring_between(msvcRcPath "${msvcEnv}" "RCPATH_START" "RCPATH_STOP")
    string(STRIP "${msvcRcPath}" msvcRcPath)
    string(REGEX REPLACE "[\r]" "" msvcRcPath "${msvcRcPath}")
    string(REGEX REPLACE "[\n]" ";" msvcRcPath "${msvcRcPath}")
    list(GET msvcRcPath 0 msvcRcPath)
    get_filename_component(msvcRcPath "${msvcRcPath}" DIRECTORY)
    cmake_path(CONVERT "${msvcRcPath}" TO_NATIVE_PATH_LIST msvcRcPath NORMALIZE)

    set("${prefix}_MSVC_INCLUDE" "${msvcInclude}" PARENT_SCOPE)
    set("${prefix}_MSVC_LIBPATH" "${msvcLibPath}" PARENT_SCOPE)
    set("${prefix}_MSVC_LIB" "${msvcLib}" PARENT_SCOPE)
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
