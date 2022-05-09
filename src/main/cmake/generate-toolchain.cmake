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

    set("${prefix}_include" "${msvcInclude}" PARENT_SCOPE)
    set("${prefix}_libpath" "${msvcLibPath}" PARENT_SCOPE)
    set("${prefix}_lib" "${msvcLib}" PARENT_SCOPE)
    set("${prefix}_cl_path" "${msvcClPath}" PARENT_SCOPE)
    set("${prefix}_rc_path" "${msvcRcPath}" PARENT_SCOPE)
endfunction()

function(script_execute args)
    set(oneValueKeywords
        "processor"
        "os"
        "compiler"
        "version"
        "host"
        "target"
        "file"
    )
    cmake_parse_arguments("func" "" "${oneValueKeywords}" "" "${args}")

    if(
        NOT "" STREQUAL "${func_processor}"
        AND "Windows" STREQUAL "${func_os}"
        AND ("Visual Studio" STREQUAL "${func_compiler}" OR "vs" STREQUAL "${func_compiler}")
        AND NOT "" STREQUAL "${func_version}"
        AND NOT "" STREQUAL "${func_host}"
        AND NOT "" STREQUAL "${func_target}"
        AND (NOT "" STREQUAL "${func_file}" AND NOT EXISTS "${func_file}")
    )
        message("processor: '${func_processor}'")
        message("os: '${func_os}'")
        message("compiler: '${func_compiler}'")
        message("version: '${func_version}'")
        message("host: '${func_host}'")
        message("target: '${func_target}'")
        message("file: '${func_file}'")

        set_msvc_env("func" "" "${func_version}" "${func_host}" "${func_target}")

        cmake_path(CONVERT "${func_cl_path}" TO_CMAKE_PATH_LIST func_cl_cmake_path NORMALIZE)
        cmake_path(CONVERT "${func_rc_path}" TO_CMAKE_PATH_LIST func_rc_cmake_path NORMALIZE)

        string(REPLACE "\\" "\\\\" func_include_escaped "${func_include}")
        string(REPLACE ";" "\\;" func_include_escaped "${func_include_escaped}")

        string(REPLACE "\\" "\\\\" func_libpath_escaped "${func_libpath}")
        string(REPLACE ";" "\\;" func_libpath_escaped "${func_libpath_escaped}")

        string(REPLACE "\\" "\\\\" func_lib_escaped "${func_lib}")
        string(REPLACE ";" "\\;" func_lib_escaped "${func_lib_escaped}")

        cmake_path(CONVERT "${func_include}" TO_CMAKE_PATH_LIST func_cmake_include NORMALIZE)
        set(func_cmake_libpath "${func_libpath}" "${func_lib}")
        cmake_path(CONVERT "${func_cmake_libpath}" TO_CMAKE_PATH_LIST func_cmake_libpath NORMALIZE)

        string(JOIN "\n" func_content
            "set(CMAKE_SYSTEM_PROCESSOR \"${func_processor}\")"
            "set(CMAKE_SYSTEM_NAME \"${func_os}\")"
            ""
            "set(MSVC_CL_PATH \"${func_cl_cmake_path}\")"
            "set(MSVC_RC_PATH \"${func_rc_cmake_path}\")"
            ""
            "set(CMAKE_C_COMPILER   \"\${MSVC_CL_PATH}/cl.exe\")"
            "set(CMAKE_CXX_COMPILER \"\${MSVC_CL_PATH}/cl.exe\")"
            "set(CMAKE_AR           \"\${MSVC_CL_PATH}/lib.exe\")"
            "set(CMAKE_LINKER       \"\${MSVC_CL_PATH}/link.exe\")"
            "set(CMAKE_RC_COMPILER  \"\${MSVC_RC_PATH}/rc.exe\")"
            "set(CMAKE_MT           \"\${MSVC_RC_PATH}/mt.exe\")"
            ""
            "set(ENV{INCLUDE} \"${func_include_escaped}\")"
            "set(ENV{LIBPATH} \"${func_libpath_escaped}\")"
            "set(ENV{LIB} \"${func_lib_escaped}\")"
            ""
            "set(C_INCLUDE_DIRECTORIES \"${func_cmake_include}\")"
            "set(C_LINK_DIRECTORIES \"${func_cmake_libpath}\")"
            ""
            "set(CXX_INCLUDE_DIRECTORIES \"${func_cmake_include}\")"
            "set(CXX_LINK_DIRECTORIES \"${func_cmake_libpath}\")"
            ""
            "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)"
            ""
        )
        file(WRITE "${func_file}" "${func_content}")
    endif()
endfunction()

math(EXPR max "${CMAKE_ARGC} - 1")
foreach(i RANGE "${max}")
    list(APPEND args "${CMAKE_ARGV${i}}")
endforeach()
script_execute("${args}")
