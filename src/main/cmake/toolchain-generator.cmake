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
            message(FATAL_ERROR "Empty value not supported for '${name}'.")
        endif()
    endforeach()

    if(NOT "" STREQUAL "${vswhereCommand}")
        cmake_path(CONVERT "${vswhereCommand}" TO_CMAKE_PATH_LIST vswhereCommand NORMALIZE)
    else()
        set(vswhereCommand "C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe")
    endif()

    if("17" STREQUAL "${compilerVersion}" OR "2022" STREQUAL "${compilerVersion}")
        set(vswhereVersionArgs "-version" "[17.0, 18.0)")
    elseif("16" STREQUAL "${compilerVersion}" OR "2019" STREQUAL "${compilerVersion}")
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
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ENCODING "UTF-8"
        COMMAND_ERROR_IS_FATAL ANY
    )

    if("" STREQUAL "${result}")
        execute_process(
            COMMAND "${vswhereCommand}" ${vswhereVersionArgs} "-products" "Microsoft.VisualStudio.Product.BuildTools" "-property" "installationPath"
            OUTPUT_VARIABLE "result"
            COMMAND_ECHO "STDERR"
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ENCODING "UTF-8"
            COMMAND_ERROR_IS_FATAL ANY
        )
    endif()

    if("" STREQUAL "${result}")
        message(FATAL_ERROR "Empty result from: '${vswhereCommand}'.")
    endif()

    cmake_path(CONVERT "${result}" TO_CMAKE_PATH_LIST result NORMALIZE)
    string(REGEX REPLACE "[\r]" "" result "${result}")
    string(REGEX REPLACE "[\n]" ";" result "${result}")
    list(GET result 0 result)

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_msvc_env prefix vswhereCommand compilerVersion compilerArch targetArch)
    foreach(name prefix compilerVersion compilerArch targetArch)
        if("" STREQUAL "${${name}}")
            message(FATAL_ERROR "Empty value not supported for '${name}'.")
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
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ENCODING "UTF-8"
        COMMAND_ERROR_IS_FATAL ANY
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
    set("${prefix}_MSVC_CL_PATH" "${msvcClPath}" PARENT_SCOPE)
    set("${prefix}_MSVC_RC_PATH" "${msvcRcPath}" PARENT_SCOPE)
endfunction()

if("${CMAKE_ARGC}" GREATER "3")
    if(
        "AMD64" STREQUAL "${CMAKE_ARGV3}"
    )
        set(SCRIPT_PROCESSOR "${CMAKE_ARGV3}")
    endif()
endif()

if("${CMAKE_ARGC}" GREATER "4")
    if(
        "Windows" STREQUAL "${CMAKE_ARGV4}"
        OR "Linux" STREQUAL "${CMAKE_ARGV4}"
        OR "Darwin" STREQUAL "${CMAKE_ARGV4}"
    )
        set(SCRIPT_OS_NAME "${CMAKE_ARGV4}")
    endif()
endif()

if("${CMAKE_ARGC}" GREATER "5")
    if(
        "vs" STREQUAL "${CMAKE_ARGV5}"
        OR "gcc" STREQUAL "${CMAKE_ARGV5}"
    )
        set(SCRIPT_COMPILER_NAME "${CMAKE_ARGV5}")
    endif()
endif()

if("${CMAKE_ARGC}" GREATER "6")
    if(
        ("17" STREQUAL "${CMAKE_ARGV6}" OR "2022" STREQUAL "${CMAKE_ARGV6}")
        OR ("16" STREQUAL "${CMAKE_ARGV6}" OR "2019" STREQUAL "${CMAKE_ARGV6}")
    )
        set(SCRIPT_COMPILER_VERSION "${CMAKE_ARGV6}")
    endif()
endif()

if("${CMAKE_ARGC}" GREATER "7")
    if(
        "x86" STREQUAL "${CMAKE_ARGV7}"
        OR "x64" STREQUAL "${CMAKE_ARGV7}"
    )
        set(SCRIPT_COMPILER_ARCH "${CMAKE_ARGV7}")
    endif()
endif()

if("${CMAKE_ARGC}" GREATER "8")
    if(
        "x86" STREQUAL "${CMAKE_ARGV8}"
        OR "x64" STREQUAL "${CMAKE_ARGV8}"
    )
        set(SCRIPT_TARGET_ARCH "${CMAKE_ARGV8}")
    endif()
endif()

if("${CMAKE_ARGC}" GREATER "9")
    if(
        NOT "" STREQUAL "${CMAKE_ARGV9}"
        AND NOT EXISTS "${CMAKE_ARGV9}"
    )
        set(SCRIPT_FILE "${CMAKE_ARGV9}")
    endif()
endif()

if(
    NOT "" STREQUAL "${SCRIPT_PROCESSOR}"
    AND "Windows" STREQUAL "${SCRIPT_OS_NAME}"
    AND "vs" STREQUAL "${SCRIPT_COMPILER_NAME}"
    AND NOT "" STREQUAL "${SCRIPT_COMPILER_VERSION}"
    AND NOT "" STREQUAL "${SCRIPT_COMPILER_ARCH}"
    AND NOT "" STREQUAL "${SCRIPT_TARGET_ARCH}"
    AND NOT "" STREQUAL "${SCRIPT_FILE}"
)

    set_msvc_env("SCRIPT" "" "${SCRIPT_COMPILER_VERSION}" "${SCRIPT_COMPILER_ARCH}" "${SCRIPT_TARGET_ARCH}")

    cmake_path(CONVERT "${SCRIPT_MSVC_CL_PATH}" TO_CMAKE_PATH_LIST SCRIPT_MSVC_CL_CMAKE_PATH NORMALIZE)
    cmake_path(CONVERT "${SCRIPT_MSVC_RC_PATH}" TO_CMAKE_PATH_LIST SCRIPT_MSVC_RC_CMAKE_PATH NORMALIZE)

    string(REPLACE "\\" "\\\\" SCRIPT_MSVC_INCLUDE_ESCAPED "${SCRIPT_MSVC_INCLUDE}")
    string(REPLACE ";" "\\;" SCRIPT_MSVC_INCLUDE_ESCAPED "${SCRIPT_MSVC_INCLUDE_ESCAPED}")

    string(REPLACE "\\" "\\\\" SCRIPT_MSVC_LIBPATH_ESCAPED "${SCRIPT_MSVC_LIBPATH}")
    string(REPLACE ";" "\\;" SCRIPT_MSVC_LIBPATH_ESCAPED "${SCRIPT_MSVC_LIBPATH_ESCAPED}")

    string(REPLACE "\\" "\\\\" SCRIPT_MSVC_LIB_ESCAPED "${SCRIPT_MSVC_LIB}")
    string(REPLACE ";" "\\;" SCRIPT_MSVC_LIB_ESCAPED "${SCRIPT_MSVC_LIB_ESCAPED}")

    string(JOIN "\n" content
        "set(CMAKE_SYSTEM_PROCESSOR \"${SCRIPT_PROCESSOR}\")"
        "set(CMAKE_SYSTEM_NAME \"${SCRIPT_OS_NAME}\")"
        ""
        "set(MSVC_CL_PATH \"${SCRIPT_MSVC_CL_CMAKE_PATH}\")"
        "set(MSVC_RC_PATH \"${SCRIPT_MSVC_RC_CMAKE_PATH}\")"
        ""
        "set(CMAKE_C_COMPILER   \"\${MSVC_CL_PATH}/cl.exe\")"
        "set(CMAKE_CXX_COMPILER \"\${MSVC_CL_PATH}/cl.exe\")"
        "set(CMAKE_AR           \"\${MSVC_CL_PATH}/lib.exe\")"
        "set(CMAKE_LINKER       \"\${MSVC_CL_PATH}/link.exe\")"
        "set(CMAKE_RC_COMPILER  \"\${MSVC_RC_PATH}/rc.exe\")"
        "set(CMAKE_MT           \"\${MSVC_RC_PATH}/mt.exe\")"
        ""
        "set(ENV{INCLUDE} \"${SCRIPT_MSVC_INCLUDE_ESCAPED}\")"
        "set(ENV{LIBPATH} \"${SCRIPT_MSVC_LIBPATH_ESCAPED}\")"
        "set(ENV{LIB} \"${SCRIPT_MSVC_LIB_ESCAPED}\")"
        ""
        "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)"
        ""
    )
    file(WRITE "${SCRIPT_FILE}" "${content}")

    return()

endif()

string(JOIN " " error
    "Unsupported:"
    "processor: '${SCRIPT_PROCESSOR}'"
    "os: '${SCRIPT_OS_NAME}'"
    "compiler: '${SCRIPT_COMPILER_NAME}'"
    "version: '${SCRIPT_COMPILER_VERSION}'"
    "host_arch: '${SCRIPT_COMPILER_ARCH}'"
    "target_arch: '${SCRIPT_TARGET_ARCH}'"
    "file: '${SCRIPT_FILE}'"
    "Usage: <processor> <os> <compiler> <version> <host_arch> <target_arch> <file>"
)
message(FATAL_ERROR "${error}")
