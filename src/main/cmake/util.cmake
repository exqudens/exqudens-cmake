cmake_minimum_required(VERSION "3.25" FATAL_ERROR)

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(PUSH)
    cmake_policy(SET CMP0007 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0010 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0012 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0054 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0057 NEW)
endif()

function(set_if_empty var)
    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    if("${${var}}" STREQUAL "" AND NOT "${ARGN}" STREQUAL "")
        set("${var}" "${ARGN}" PARENT_SCOPE)
    endif()
endfunction()

function(substring_from var input fromExclusive)
    set(result "")

    foreach(i var input fromExclusive)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    string(FIND "${input}" "${fromExclusive}" fromStartIndex)

    if("-1" STREQUAL "${fromStartIndex}")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Can't find 'fromExclusive' in 'input'")
    endif()

    string(LENGTH "${input}" inputLength)
    string(LENGTH "${fromExclusive}" "fromLength")
    math(EXPR fromEndIndex "${fromStartIndex} + ${fromLength}")
    math(EXPR substringLength "${inputLength} - ${fromEndIndex}")
    string(SUBSTRING "${input}" "${fromEndIndex}" "${substringLength}" result)
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(substring_to var input toExclusive)
    set(result "")

    foreach(i var input toExclusive)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    string(FIND "${input}" "${toExclusive}" toStartIndex)

    if("-1" STREQUAL "${toStartIndex}")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Can't find 'toExclusive' in 'input'")
    endif()

    string(LENGTH "${input}" inputLength)
    string(SUBSTRING "${input}" 0 "${toStartIndex}" result)
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(string_replace_between prefix input fromExclusive toExclusive)
    set(result "")
    set(resultBetween "")
    set(resultReplaced "")

    foreach(i prefix input fromExclusive toExclusive)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options
        "RESULT_ONLY"
        "REPLACED_ONLY"
        "BETWEEN_ONLY"
    )
    set(oneValueKeywords
        "WITH"
    )
    set(multiValueKeywords)

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    if(NOT DEFINED "_WITH")
        set(value "")
    else()
        set(value "${_WITH}")
    endif()

    if("${_REPLACED_ONLY}")
        substring_from(resultBetween "${input}" "${fromExclusive}")
        substring_to(resultBetween "${resultBetween}" "${toExclusive}")

        string(CONCAT resultReplaced "${fromExclusive}" "${resultBetween}" "${toExclusive}")

        set("${prefix}" "${resultReplaced}" PARENT_SCOPE)
    elseif("${_BETWEEN_ONLY}")
        substring_from(resultBetween "${input}" "${fromExclusive}")
        substring_to(resultBetween "${resultBetween}" "${toExclusive}")

        set("${prefix}" "${resultBetween}" PARENT_SCOPE)
    else()
        if("${_RESULT_ONLY}")
            substring_to(part1 "${input}" "${fromExclusive}")
            substring_from(part2 "${input}" "${toExclusive}")
            string(CONCAT result "${part1}" "${value}" "${part2}")

            set("${prefix}" "${result}" PARENT_SCOPE)
        else()
            substring_to(part1 "${input}" "${fromExclusive}")
            substring_from(part2 "${input}" "${toExclusive}")
            string(CONCAT result "${part1}" "${value}" "${part2}")

            substring_from(resultBetween "${input}" "${fromExclusive}")
            substring_to(resultBetween "${resultBetween}" "${toExclusive}")

            string(CONCAT resultReplaced "${fromExclusive}" "${resultBetween}" "${toExclusive}")

            set("${prefix}" "${result}" PARENT_SCOPE)
            set("${prefix}_BETWEEN" "${resultBetween}" PARENT_SCOPE)
            set("${prefix}_REPLACED" "${resultReplaced}" PARENT_SCOPE)
        endif()
    endif()

    unset(result)
    unset(resultBetween)
    unset(resultReplaced)
endfunction()

function(find_file_in_parent prefix)
    set(result "")
    set(resultDir "")

    foreach(i prefix)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options
        "REQUIRED"
    )
    set(oneValueKeywords
        "MAX_PARENT_LEVEL"
    )
    set(multiValueKeywords
        "NAMES"
        "PATHS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(required "${_REQUIRED}")
    set(maxParentLevel "${_MAX_PARENT_LEVEL}")
    set(paths "${_PATHS}")
    set(names "${_NAMES}")
    set(func_max "${maxParentLevel}")

    if("" STREQUAL "${func_max}")
        set(func_max "1")
    endif()

    foreach(path ${paths})
        if(NOT "${result}" STREQUAL "" AND NOT "${resultDir}" STREQUAL "")
            break()
        endif()
        set(func_path "${path}")
        foreach(name ${names})
            if(NOT "${result}" STREQUAL "" AND NOT "${resultDir}" STREQUAL "")
                break()
            endif()
            set(func_name "${name}")
            cmake_path(GET func_path ROOT_NAME func_path_root_name)
            cmake_path(GET func_path ROOT_DIRECTORY func_path_root_dir)
            set(func_path_root "${func_path_root_name}${func_path_root_dir}")
            foreach(i RANGE "1" "${func_max}")
                if(
                    "${func_path_root}" STREQUAL "${func_path}"
                    OR (NOT "${result}" STREQUAL "" AND NOT "${resultDir}" STREQUAL "")
                )
                    break()
                endif()
                cmake_path(GET func_path PARENT_PATH func_path)
                file(GLOB_RECURSE func_files LIST_DIRECTORIES "TRUE" "${func_path}/*")
                foreach(func_file IN LISTS func_files)
                    get_filename_component(func_file_name "${func_file}" NAME)
                    if("${func_file_name}" STREQUAL "${func_name}")
                        set(result "${func_file}")
                        get_filename_component(resultDir "${result}" DIRECTORY)
                        set(func_path "${func_path_root}")
                        break()
                    endif()
                endforeach()
            endforeach()
        endforeach()
    endforeach()

    if("${required}" AND ("${result}" STREQUAL "" OR "${resultDir}" STREQUAL ""))
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] File not found names: '${names}' paths: '${paths}'")
    endif()

    set("${prefix}_FILE" "${result}" PARENT_SCOPE)
    set("${prefix}_DIR" "${resultDir}" PARENT_SCOPE)
    unset(result)
    unset(resultDir)
endfunction()

function(find_file_in prefix)
    set(result "")
    set(resultDir "")

    foreach(i prefix)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options
        "REQUIRED"
    )
    set(oneValueKeywords)
    set(multiValueKeywords
        "NAMES"
        "PATHS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(required "${_REQUIRED}")
    set(paths "${_PATHS}")
    set(names "${_NAMES}")

    foreach(path ${paths})
        if(NOT "${result}" STREQUAL "" AND NOT "${resultDir}" STREQUAL "")
            break()
        endif()
        foreach(name ${names})
            if(NOT "${result}" STREQUAL "" AND NOT "${resultDir}" STREQUAL "")
                break()
            endif()
            file(GLOB_RECURSE func_files LIST_DIRECTORIES "TRUE" "${path}/*")
            foreach(func_file IN LISTS func_files)
                get_filename_component(func_file_name "${func_file}" NAME)
                if("${func_file_name}" STREQUAL "${name}")
                    set(result "${func_file}")
                    get_filename_component(resultDir "${result}" DIRECTORY)
                    break()
                endif()
            endforeach()
        endforeach()
    endforeach()

    if("${required}" AND ("${result}" STREQUAL "" OR "${resultDir}" STREQUAL ""))
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] File not found names: '${names}' paths: '${paths}'")
    endif()

    set("${prefix}_FILE" "${result}" PARENT_SCOPE)
    set("${prefix}_DIR" "${resultDir}" PARENT_SCOPE)
    unset(result)
    unset(resultDir)
endfunction()

function(set_msvc_path var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "COMMAND"
        "VERSION"
        "PROPERTY"
    )
    set(multiValueKeywords
        "PRODUCTS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(command "${_COMMAND}")
    set(version "${_VERSION}")
    set(property "${_PROPERTY}")
    set(products "${_PRODUCTS}")

    if("" STREQUAL "${command}")
        set(command "C:/Program Files (x86)/Microsoft Visual Studio/Installer/vswhere.exe")
    endif()

    if("" STREQUAL "${version}")
        set(version "-latest")
    endif()

    if("" STREQUAL "${property}")
        set(property "installationPath")
    endif()

    if("" STREQUAL "${products}")
        set(products
            "Microsoft.VisualStudio.Product.Enterprise"
            "Microsoft.VisualStudio.Product.Professional"
            "Microsoft.VisualStudio.Product.Community"
            "Microsoft.VisualStudio.Product.BuildTools"
            #"Microsoft.VisualStudio.Product.TeamExplorer"
            #"Microsoft.VisualStudio.Product.TestAgent"
            #"Microsoft.VisualStudio.Product.TestController"
        )
    endif()

    cmake_path(CONVERT "${command}" TO_CMAKE_PATH_LIST command NORMALIZE)

    if("17" STREQUAL "${version}" OR "2022" STREQUAL "${version}")
        set(versionArgs "-version" "[17.0, 18.0)")
    elseif("16" STREQUAL "${version}" OR "2019" STREQUAL "${version}")
        set(versionArgs "-version" "[16.0, 17.0)")
    elseif("15" STREQUAL "${version}" OR "2017" STREQUAL "${version}")
        set(versionArgs "-version" "[15.0, 16.0)")
    elseif("latest" STREQUAL "${version}" OR "-latest" STREQUAL "${version}")
        set(versionArgs "-latest")
    else()
        set(versionArgs "-version" "${version}")
    endif()

    set(propertyArgs "-property" "${property}")
    set(result "")

    foreach(i ${products})
        set(productsArgs "-products" "${i}")
        execute_process(
            COMMAND "${command}" ${versionArgs} ${productsArgs} ${propertyArgs}
            OUTPUT_VARIABLE "result"
            COMMAND_ECHO "STDERR"
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ENCODING "UTF-8"
            COMMAND_ERROR_IS_FATAL ANY
        )
        if(NOT "" STREQUAL "${result}")
            break()
        endif()
    endforeach()

    if("" STREQUAL "${result}")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty result from: '${command}'.")
    endif()

    cmake_path(CONVERT "${result}" TO_CMAKE_PATH_LIST result NORMALIZE)
    string(REGEX REPLACE "[\r]" "" result "${result}")
    string(REGEX REPLACE "[\n]" ";" result "${result}")
    list(GET result 0 result)
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_msvc_env prefix)
    set(resultMsvcInclude "")
    set(resultMsvcLibPath "")
    set(resultMsvcLib "")
    set(resultMsvcClPath "")
    set(resultMsvcRcPath "")

    foreach(i prefix)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "COMMAND"
        "VERSION"
        "PROPERTY"
        "HOST"
        "TARGET"
        "PATH"
    )
    set(multiValueKeywords
        "PRODUCTS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(command "${_COMMAND}")
    set(version "${_VERSION}")
    set(property "${_PROPERTY}")
    set(host "${_HOST}")
    set(target "${_TARGET}")
    set(path "${_PATH}")
    set(products "${_PRODUCTS}")

    if(NOT "" STREQUAL "${path}")
        if(NOT EXISTS "${path}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not exists: '${path}'")
        elseif(IS_DIRECTORY "${path}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Is directory: '${path}'")
        endif()
    endif()

    if("" STREQUAL "${target}")
        get_filename_component(compilerDir "${path}" DIRECTORY)
        get_filename_component(compilerDirName "${compilerDir}" NAME)
        string(TOLOWER "${compilerDirName}" compilerDirNameLower)
        if("x86" STREQUAL "${compilerDirNameLower}")
            set(target "x86")
        elseif("x64" STREQUAL "${compilerDirNameLower}")
            set(target "x64")
        endif()
    endif()

    if("" STREQUAL "${host}" AND NOT "" STREQUAL "${compilerDir}")
        get_filename_component(compilerDirParent "${compilerDir}" DIRECTORY)
        get_filename_component(compilerDirParentName "${compilerDirParent}" NAME)
        string(TOLOWER "${compilerDirParentName}" compilerDirParentNameLower)
        if("hostx86" STREQUAL "${compilerDirParentNameLower}")
            set(host "x86")
        elseif("hostx64" STREQUAL "${compilerDirParentNameLower}")
            set(host "x64")
        endif()
    endif()

    if(NOT "x86" STREQUAL "${host}" AND NOT "x64" STREQUAL "${host}")
        string(JOIN " " errorMessage
            "Unsupported or not specified 'host': '${host}'."
            "Supported values ['x86', 'x64']."
        )
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] ${errorMessage}")
    endif()

    if(NOT "x86" STREQUAL "${target}" AND NOT "x64" STREQUAL "${target}")
        string(JOIN " " errorMessage
            "Unsupported or not specified 'target': '${target}'."
            "Supported values [ 'x86', 'x64' ]."
        )
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] ${errorMessage}")
    endif()

    if("${host}" STREQUAL "${target}")
        set(vcvarsallBatConf "${host}")
    else()
        set(vcvarsallBatConf "${host}_${target}")
    endif()

    set(vcvarsallBatName "vcvarsall.bat")

    if("" STREQUAL "${path}")
        set_msvc_path(msvcPath COMMAND "${command}" VERSION "${version}" PROPERTY "${property}" PRODUCTS "${products}")
        find_file_in(vcvarsall NAMES "${vcvarsallBatName}" PATHS "${msvcPath}" REQUIRED)
        if("" STREQUAL "${vcvarsall_DIR}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not found '${vcvarsallBatName}' in '${msvcPath}'")
        endif()
    elseif(NOT "" STREQUAL "${path}")
        if(NOT EXISTS "${path}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not exists 'path': '${path}'")
        endif()
        find_file_in_parent(vcvarsall MAX_PARENT_LEVEL "9" NAMES "${vcvarsallBatName}" PATHS "${path}" REQUIRED)
        if("" STREQUAL "${vcvarsall_DIR}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not found '${vcvarsallBatName}' in '8' parent dirs of '${path}'")
        endif()
    endif()

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
        WORKING_DIRECTORY "${vcvarsall_DIR}"
        OUTPUT_VARIABLE "msvcEnv"
        COMMAND_ECHO "STDERR"
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ENCODING "UTF-8"
        COMMAND_ERROR_IS_FATAL ANY
    )

    string_replace_between(resultMsvcInclude "${msvcEnv}" "INCLUDE_START" "INCLUDE_STOP" BETWEEN_ONLY)
    string(STRIP "${resultMsvcInclude}" resultMsvcInclude)
    string(REGEX REPLACE "[\r]" "" resultMsvcInclude "${resultMsvcInclude}")
    string(REGEX REPLACE "[\n]" "" resultMsvcInclude "${resultMsvcInclude}")

    string_replace_between(resultMsvcLibPath "${msvcEnv}" "LIBPATH_START" "LIBPATH_STOP" BETWEEN_ONLY)
    string(STRIP "${resultMsvcLibPath}" resultMsvcLibPath)
    string(REGEX REPLACE "[\r]" "" resultMsvcLibPath "${resultMsvcLibPath}")
    string(REGEX REPLACE "[\n]" "" resultMsvcLibPath "${resultMsvcLibPath}")

    string_replace_between(resultMsvcLib "${msvcEnv}" "LIB_START" "LIB_STOP" BETWEEN_ONLY)
    string(STRIP "${resultMsvcLib}" resultMsvcLib)
    string(REGEX REPLACE "[\r]" "" resultMsvcLib "${resultMsvcLib}")
    string(REGEX REPLACE "[\n]" "" resultMsvcLib "${resultMsvcLib}")

    string_replace_between(resultMsvcClPath "${msvcEnv}" "CLPATH_START" "CLPATH_STOP" BETWEEN_ONLY)
    string(STRIP "${resultMsvcClPath}" resultMsvcClPath)
    string(REGEX REPLACE "[\r]" "" resultMsvcClPath "${resultMsvcClPath}")
    string(REGEX REPLACE "[\n]" ";" resultMsvcClPath "${resultMsvcClPath}")
    list(GET resultMsvcClPath 0 resultMsvcClPath)
    get_filename_component(resultMsvcClPath "${resultMsvcClPath}" DIRECTORY)
    cmake_path(CONVERT "${resultMsvcClPath}" TO_NATIVE_PATH_LIST resultMsvcClPath NORMALIZE)

    string_replace_between(resultMsvcRcPath "${msvcEnv}" "RCPATH_START" "RCPATH_STOP" BETWEEN_ONLY)
    string(STRIP "${resultMsvcRcPath}" resultMsvcRcPath)
    string(REGEX REPLACE "[\r]" "" resultMsvcRcPath "${resultMsvcRcPath}")
    string(REGEX REPLACE "[\n]" ";" resultMsvcRcPath "${resultMsvcRcPath}")
    list(GET resultMsvcRcPath 0 resultMsvcRcPath)
    get_filename_component(resultMsvcRcPath "${resultMsvcRcPath}" DIRECTORY)
    cmake_path(CONVERT "${resultMsvcRcPath}" TO_NATIVE_PATH_LIST resultMsvcRcPath NORMALIZE)

    set("${prefix}_MSVC_INCLUDE" "${resultMsvcInclude}" PARENT_SCOPE)
    set("${prefix}_MSVC_LIBPATH" "${resultMsvcLibPath}" PARENT_SCOPE)
    set("${prefix}_MSVC_LIB" "${resultMsvcLib}" PARENT_SCOPE)
    set("${prefix}_MSVC_CL_PATH" "${resultMsvcClPath}" PARENT_SCOPE)
    set("${prefix}_MSVC_RC_PATH" "${resultMsvcRcPath}" PARENT_SCOPE)

    unset(resultMsvcInclude)
    unset(resultMsvcLibPath)
    unset(resultMsvcLib)
    unset(resultMsvcClPath)
    unset(resultMsvcRcPath)
endfunction()

function(set_msvc_toolchain var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "COMMAND"
        "VERSION"
        "PROPERTY"
        "HOST"
        "TARGET"
        "PATH"
        "PROCESSOR"
        "OS"
        "OUTPUT_FILE"
        "NO_CACHE"
        "SET_CMAKE_SYSTEM_PROCESSOR"
        "SET_CMAKE_SYSTEM_NAME"
    )
    set(multiValueKeywords
        "PRODUCTS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(command "${_COMMAND}")
    set(version "${_VERSION}")
    set(property "${_PROPERTY}")
    set(host "${_HOST}")
    set(target "${_TARGET}")
    set(path "${_PATH}")
    set(processor "${_PROCESSOR}")
    set(os "${_OS}")
    set(products "${_PRODUCTS}")
    set(outputFile "${_OUTPUT_FILE}")
    set(noCache "${_NO_CACHE}")
    set(setCmakeSystemProcessor "${_SET_CMAKE_SYSTEM_PROCESSOR}")
    set(setCmakeSystemName "${_SET_CMAKE_SYSTEM_NAME}")

    if("${noCache}" STREQUAL "" OR "${noCache}")
        set(cacheInstructions "")
    else()
        set(cacheInstructions " CACHE INTERNAL \"...\" FORCE")
    endif()

    set_msvc_env("func"
        COMMAND "${command}"
        VERSION "${version}"
        PROPERTY "${property}"
        HOST "${host}"
        TARGET "${target}"
        PATH "${path}"
        PRODUCTS "${products}"
    )

    cmake_path(CONVERT "${func_MSVC_INCLUDE}" TO_CMAKE_PATH_LIST func_include NORMALIZE)
    list(FILTER func_include EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES func_include)
    set(func_include_cmake "${func_include}")
    cmake_path(CONVERT "${func_include}" TO_NATIVE_PATH_LIST func_include NORMALIZE)

    cmake_path(CONVERT "${func_MSVC_LIBPATH}" TO_CMAKE_PATH_LIST func_libpath NORMALIZE)
    list(FILTER func_libpath EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES func_libpath)
    set(func_libpath_cmake "${func_libpath}")
    cmake_path(CONVERT "${func_libpath}" TO_NATIVE_PATH_LIST func_libpath NORMALIZE)

    cmake_path(CONVERT "${func_MSVC_LIB}" TO_CMAKE_PATH_LIST func_lib NORMALIZE)
    list(FILTER func_lib EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES func_lib)
    cmake_path(CONVERT "${func_lib}" TO_NATIVE_PATH_LIST func_lib NORMALIZE)

    cmake_path(CONVERT "${func_MSVC_CL_PATH}" TO_CMAKE_PATH_LIST func_cl_cmake NORMALIZE)
    cmake_path(CONVERT "${func_MSVC_RC_PATH}" TO_CMAKE_PATH_LIST func_rc_cmake NORMALIZE)
    set(func_path "")
    list(PREPEND func_path "${func_rc_cmake}")
    list(PREPEND func_path "${func_cl_cmake}")
    list(APPEND func_path "\$ENV{PATH}")
    list(FILTER func_path EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES func_path)
    cmake_path(CONVERT "${func_path}" TO_NATIVE_PATH_LIST func_path NORMALIZE)

    string(REPLACE "\\" "\\\\" func_include "${func_include}")
    string(REPLACE "\\" "\\\\" func_libpath "${func_libpath}")
    string(REPLACE "\\" "\\\\" func_lib "${func_lib}")
    string(REPLACE "\\" "\\\\" func_path "${func_path}")

    cmake_path(CONVERT "${func_MSVC_INCLUDE}" TO_CMAKE_PATH_LIST func_cmake_include NORMALIZE)

    set(func_cmake_libpath "${func_MSVC_LIBPATH}" "${func_MSVC_LIB}")
    cmake_path(CONVERT "${func_cmake_libpath}" TO_CMAKE_PATH_LIST func_cmake_libpath NORMALIZE)

    set(result "")

    if("${setCmakeSystemProcessor}" STREQUAL "" OR "${setCmakeSystemProcessor}")
        string(APPEND result "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})" "\n")
    endif()
    if("${setCmakeSystemName}" STREQUAL "" OR "${setCmakeSystemName}")
        string(APPEND result "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})" "\n")
    endif()
    string(APPEND result "" "\n")
    string(APPEND result "set(CMAKE_C_COMPILER   \"${func_cl_cmake}/cl.exe\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_CXX_COMPILER \"${func_cl_cmake}/cl.exe\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_AR           \"${func_cl_cmake}/lib.exe\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_LINKER       \"${func_cl_cmake}/link.exe\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_RC_COMPILER  \"${func_rc_cmake}/rc.exe\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_MT           \"${func_rc_cmake}/mt.exe\"${cacheInstructions})" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "set(ENV{INCLUDE} \"${func_include}\")" "\n")
    string(APPEND result "set(ENV{LIBPATH} \"${func_libpath}\")" "\n")
    string(APPEND result "set(ENV{LIB} \"${func_lib}\")" "\n")
    string(APPEND result "set(ENV{PATH} \"${func_path}\")" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES \"${func_include_cmake}\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_C_STANDARD_LINK_DIRECTORIES \"${func_libpath_cmake}\"${cacheInstructions})" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES \"${func_cmake_include}\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_CXX_STANDARD_LINK_DIRECTORIES \"${func_cmake_libpath}\"${cacheInstructions})" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY${cacheInstructions})" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "link_directories(\"\${CMAKE_C_STANDARD_LINK_DIRECTORIES}\") # remove when CMAKE_C_STANDARD_LINK_DIRECTORIES is supported" "\n")
    string(APPEND result "link_directories(\"\${CMAKE_CXX_STANDARD_LINK_DIRECTORIES}\") # remove when CMAKE_CXX_STANDARD_LINK_DIRECTORIES is supported" "\n")

    if(NOT "${outputFile}" STREQUAL "" AND NOT EXISTS "${outputFile}")
        file(WRITE "${outputFile}" "${result}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_gnu_toolchain var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "PATH"
        "PROCESSOR"
        "OS"
        "OUTPUT_FILE"
        "NO_CACHE"
        "SET_CMAKE_SYSTEM_PROCESSOR"
        "SET_CMAKE_SYSTEM_NAME"
    )
    set(multiValueKeywords)

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(path "${_PATH}")
    set(processor "${_PROCESSOR}")
    set(os "${_OS}")
    set(outputFile "${_OUTPUT_FILE}")
    set(noCache "${_NO_CACHE}")
    set(setCmakeSystemProcessor "${_SET_CMAKE_SYSTEM_PROCESSOR}")
    set(setCmakeSystemName "${_SET_CMAKE_SYSTEM_NAME}")

    if("${noCache}" STREQUAL "" OR "${noCache}")
        set(cacheInstructions "")
    else()
        set(cacheInstructions " CACHE INTERNAL \"...\" FORCE")
    endif()

    cmake_path(CONVERT "${path}" TO_CMAKE_PATH_LIST path NORMALIZE)
    get_filename_component(compilerFileNameExt "${path}" EXT)
    get_filename_component(compilerFileNameNoExt "${path}" NAME_WE)
    get_filename_component(compilerDir "${path}" DIRECTORY)

    set(envPath "${compilerDir}")
    list(APPEND envPath "\$ENV{PATH}")
    list(FILTER envPath EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES envPath)
    cmake_path(CONVERT "${envPath}" TO_NATIVE_PATH_LIST envPathNative NORMALIZE)

    string(REPLACE "\\" "\\\\" envPathNative "${envPathNative}")

    set(result "")

    if("${setCmakeSystemProcessor}" STREQUAL "" OR "${setCmakeSystemProcessor}")
        string(APPEND result "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})" "\n")
    endif()
    if("${setCmakeSystemName}" STREQUAL "" OR "${setCmakeSystemName}")
        string(APPEND result "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})" "\n")
    endif()
    string(APPEND result "" "\n")
    if("${compilerFileNameExt}" STREQUAL ".exe" AND ("${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" OR "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++"))
        string(APPEND result "set(CMAKE_C_COMPILER   \"${compilerDir}/arm-none-eabi-gcc.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_CXX_COMPILER \"${compilerDir}/arm-none-eabi-g++.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_ASM_COMPILER \"${compilerDir}/arm-none-eabi-gcc.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_SIZE         \"${compilerDir}/arm-none-eabi-size.exe\"${cacheInstructions})" "\n")
        string(APPEND result "" "\n")
        string(APPEND result "set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY${cacheInstructions})" "\n")
    elseif("${os}" STREQUAL "Windows" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++")
        string(APPEND result "set(CMAKE_C_COMPILER   \"${compilerDir}/gcc.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_CXX_COMPILER \"${compilerDir}/g++.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_AR           \"${compilerDir}/ar.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_LINKER       \"${compilerDir}/ld.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_RC_COMPILER  \"${compilerDir}/windres.exe\"${cacheInstructions})" "\n")
    elseif(("${os}" STREQUAL "Linux" OR "${os}" STREQUAL "Darwin") AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++")
        string(APPEND result "set(CMAKE_C_COMPILER   \"${compilerDir}/gcc\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_CXX_COMPILER \"${compilerDir}/g++\"${cacheInstructions})" "\n")
    endif()
    string(APPEND result "" "\n")
    string(APPEND result "set(ENV{PATH} \"${envPathNative}\")" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY${cacheInstructions})" "\n")

    if(NOT "${outputFile}" STREQUAL "" AND NOT EXISTS "${outputFile}")
        file(WRITE "${outputFile}" "${result}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_clang_toolchain var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "PATH"
        "PROCESSOR"
        "OS"
        "TARGET"
        "OUTPUT_FILE"
        "NO_CACHE"
        "SET_CMAKE_SYSTEM_PROCESSOR"
        "SET_CMAKE_SYSTEM_NAME"
    )
    set(multiValueKeywords)

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(path "${_PATH}")
    set(processor "${_PROCESSOR}")
    set(os "${_OS}")
    set(target "${_TARGET}")
    set(outputFile "${_OUTPUT_FILE}")
    set(noCache "${_NO_CACHE}")
    set(setCmakeSystemProcessor "${_SET_CMAKE_SYSTEM_PROCESSOR}")
    set(setCmakeSystemName "${_SET_CMAKE_SYSTEM_NAME}")

    if("${noCache}" STREQUAL "" OR "${noCache}")
        set(cacheInstructions "")
    else()
        set(cacheInstructions " CACHE INTERNAL \"...\" FORCE")
    endif()

    cmake_path(CONVERT "${path}" TO_CMAKE_PATH_LIST path NORMALIZE)

    get_filename_component(compilerDir "${path}" DIRECTORY)

    set(envPath "${compilerDir}")
    list(APPEND envPath "\$ENV{PATH}")
    list(FILTER envPath EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES envPath)
    cmake_path(CONVERT "${envPath}" TO_NATIVE_PATH_LIST envPathNative NORMALIZE)

    string(REPLACE "\\" "\\\\" envPathNative "${envPathNative}")

    set(result "")

    if("${setCmakeSystemProcessor}" STREQUAL "" OR "${setCmakeSystemProcessor}")
        string(APPEND result "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})" "\n")
    endif()
    if("${setCmakeSystemName}" STREQUAL "" OR "${setCmakeSystemName}")
        string(APPEND result "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})" "\n")
    endif()
    string(APPEND result "" "\n")
    string(APPEND result "set(CMAKE_C_COMPILER          \"${compilerDir}/clang.exe\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_C_COMPILER_TARGET   \"${target}\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_CXX_COMPILER        \"${compilerDir}/clang++.exe\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_CXX_COMPILER_TARGET \"${target}\"${cacheInstructions})" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "set(ENV{PATH} \"${envPathNative}\")" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY${cacheInstructions})" "\n")

    if(NOT "${outputFile}" STREQUAL "" AND NOT EXISTS "${outputFile}")
        file(WRITE "${outputFile}" "${result}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_iar_toolchain var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "PATH"
        "PROCESSOR"
        "OS"
        "OUTPUT_FILE"
        "NO_CACHE"
        "SET_CMAKE_SYSTEM_PROCESSOR"
        "SET_CMAKE_SYSTEM_NAME"
    )
    set(multiValueKeywords)

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(path "${_PATH}")
    set(processor "${_PROCESSOR}")
    set(os "${_OS}")
    set(outputFile "${_OUTPUT_FILE}")
    set(noCache "${_NO_CACHE}")
    set(setCmakeSystemProcessor "${_SET_CMAKE_SYSTEM_PROCESSOR}")
    set(setCmakeSystemName "${_SET_CMAKE_SYSTEM_NAME}")

    if("${noCache}" STREQUAL "" OR "${noCache}")
        set(cacheInstructions "")
    else()
        set(cacheInstructions " CACHE INTERNAL \"...\" FORCE")
    endif()

    cmake_path(CONVERT "${path}" TO_CMAKE_PATH_LIST path NORMALIZE)
    get_filename_component(compilerFileNameExt "${path}" EXT)
    get_filename_component(compilerFileNameNoExt "${path}" NAME_WE)
    get_filename_component(compilerDir "${path}" DIRECTORY)

    set(envPath "${compilerDir}")
    list(APPEND envPath "\$ENV{PATH}")
    list(FILTER envPath EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES envPath)
    cmake_path(CONVERT "${envPath}" TO_NATIVE_PATH_LIST envPathNative NORMALIZE)

    string(REPLACE "\\" "\\\\" envPathNative "${envPathNative}")

    set(result "")

    if("${setCmakeSystemProcessor}" STREQUAL "" OR "${setCmakeSystemProcessor}")
        string(APPEND result "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})" "\n")
    endif()
    if("${setCmakeSystemName}" STREQUAL "" OR "${setCmakeSystemName}")
        string(APPEND result "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})" "\n")
    endif()
    string(APPEND result "" "\n")
    #string(APPEND result "set(COMPILER_PATH \"${compilerDir}\"${cacheInstructions})" "\n")
    #string(APPEND result "" "\n")
    if("${compilerFileNameExt}" STREQUAL ".exe" AND "${compilerFileNameNoExt}" STREQUAL "iccarm")
        string(APPEND result "set(CMAKE_ASM_COMPILER \"${compilerDir}/iasmarm.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_C_COMPILER   \"${compilerDir}/iccarm.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_CXX_COMPILER \"${compilerDir}/iccarm.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_AR           \"${compilerDir}/iarchive.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_LINKER       \"${compilerDir}/ilinkarm.exe\"${cacheInstructions})" "\n")
        string(APPEND result "set(CMAKE_RC_COMPILER  \"\"${cacheInstructions})" "\n")
        string(APPEND result "" "\n")
        string(APPEND result "set(CMAKE_TRY_COMPILE_TARGET_TYPE \"STATIC_LIBRARY\"${cacheInstructions})" "\n")
    else()
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unsupported 'compilerFileNameExt': '${compilerFileNameExt}' 'compilerFileNameNoExt': '${compilerFileNameNoExt}'")
    endif()
    string(APPEND result "" "\n")
    string(APPEND result "set(ENV{PATH} \"${envPathNative}\")" "\n")
    string(APPEND result "" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM \"NEVER\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY \"ONLY\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE \"ONLY\"${cacheInstructions})" "\n")
    string(APPEND result "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE \"ONLY\"${cacheInstructions})" "\n")

    if(NOT "${outputFile}" STREQUAL "" AND NOT EXISTS "${outputFile}")
        file(WRITE "${outputFile}" "${result}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_python_boolean var cmakeBoolean)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    if("${cmakeBoolean}")
        set(result "True")
    else()
        set(result "False")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_architecture var cmakeSystemProcessor)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    if("x64" STREQUAL "${cmakeSystemProcessor}" OR "AMD64" STREQUAL "${cmakeSystemProcessor}" OR "IA64" STREQUAL "${cmakeSystemProcessor}")
        set(result "x86_64")
    elseif("x86" STREQUAL "${cmakeSystemProcessor}")
        set(result "x86")
    else()
        set(result "${cmakeSystemProcessor}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_compiler var cmakeCxxCompilerId)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    if("MSVC" STREQUAL "${cmakeCxxCompilerId}")
        set(result "msvc")
    elseif("GNU" STREQUAL "${cmakeCxxCompilerId}")
        set(result "gcc")
    elseif("Clang" STREQUAL "${cmakeCxxCompilerId}")
        set(result "clang")
    else()
        set(result "${cmakeCxxCompilerId}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_compiler_version var cmakeCxxCompilerId cmakeCxxCompilerVersion)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "DELIMITER"
        "MAX_ELEMENTS"
    )
    set(multiValueKeywords)

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    if("${_DELIMITER}" STREQUAL "")
        set(delimiter ".")
    else()
        set(delimiter "${_DELIMITER}")
    endif()

    if("${_MAX_ELEMENTS}" STREQUAL "")
        set(maxElements "-1")
    else()
        set(maxElements "${_MAX_ELEMENTS}")
    endif()

    if("MSVC" STREQUAL "${cmakeCxxCompilerId}")
        if("${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "19.40" AND "${cmakeCxxCompilerVersion}" VERSION_LESS "19.50")
            set(result "194")
        elseif("${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "19.30" AND "${cmakeCxxCompilerVersion}" VERSION_LESS "19.40")
            set(result "193")
        elseif("${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "19.20" AND "${cmakeCxxCompilerVersion}" VERSION_LESS "19.30")
            set(result "192")
        elseif("${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "19.10" AND "${cmakeCxxCompilerVersion}" VERSION_LESS "19.20")
            set(result "191")
        else()
            set(result "${cmakeCxxCompilerVersion}")
        endif()
    else()
        string(REPLACE "${delimiter}" ";" cmakeCxxCompilerVersionElements "${cmakeCxxCompilerVersion}")
        list(LENGTH cmakeCxxCompilerVersionElements cmakeCxxCompilerVersionElementsLength)
        if("${maxElements}" GREATER "${cmakeCxxCompilerVersionElementsLength}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] MAX_ELEMENTS: '${maxElements}' greater than cmakeCxxCompilerVersionElementsLength: '${cmakeCxxCompilerVersionElementsLength}'")
        elseif("${maxElements}" GREATER "0")
            math(EXPR cmakeCxxCompilerVersionElementsMax "${maxElements} - 1")
        else()
            math(EXPR cmakeCxxCompilerVersionElementsMax "${cmakeCxxCompilerVersionElementsLength} - 1")
        endif()
        set(versionElements "")
        foreach(i RANGE 0 "${cmakeCxxCompilerVersionElementsMax}")
            list(GET cmakeCxxCompilerVersionElements "${i}" element)
            list(APPEND versionElements "${element}")
        endforeach()
        string(JOIN "${delimiter}" result ${versionElements})
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_compiler_runtime var cmakeMsvcRuntimeLibrary)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    if("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreaded")
        set(result "static")
    elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDLL")
        set(result "dynamic")
    elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDebug")
        set(result "static")
    elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDebugDLL")
        set(result "dynamic")
    else()
        set(result "${cmakeMsvcRuntimeLibrary}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_compiler_runtime_type var cmakeMsvcRuntimeLibrary)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    if("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreaded")
        set(result "Release")
    elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDLL")
        set(result "Release")
    elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDebug")
        set(result "Debug")
    elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDebugDLL")
        set(result "Debug")
    else()
        set(result "${cmakeMsvcRuntimeLibrary}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_settings var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    # all settings
    if(NOT "" STREQUAL "${ARGN}")
        foreach(arg ${ARGN})
            if(NOT "${arg}" STREQUAL "" AND NOT "${arg}" IN_LIST result)
                string(REPLACE "=" ";" argElements "${arg}")
                set(argValue "")
                list(GET argElements 1 argValue)
                if(NOT "${argValue}" STREQUAL "" AND NOT "${argValue}" STREQUAL "\"\"" AND NOT "${argValue}" STREQUAL "''")
                    list(APPEND result "--settings" "${arg}")
                endif()
            endif()
        endforeach()
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_options var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    # all options
    if(NOT "" STREQUAL "${ARGN}")
        foreach(arg ${ARGN})
            if(NOT "${arg}" STREQUAL "" AND NOT "${arg}" IN_LIST result)
                string(REPLACE "=" ";" argElements "${arg}")
                set(argValue "")
                list(GET argElements 1 argValue)
                if(NOT "${argValue}" STREQUAL "" AND NOT "${argValue}" STREQUAL "\"\"" AND NOT "${argValue}" STREQUAL "''")
                    list(APPEND result "--options" "${arg}")
                endif()
            endif()
        endforeach()
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_not_found_package_names var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    if(NOT "" STREQUAL "${ARGN}")
        foreach(arg ${ARGN})
            if(NOT "${${arg}_FOUND}")
                list(APPEND result "${arg}")
            endif()
        endforeach()
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_target_names var dir)
    set(result "")

    foreach(i var dir)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    list(APPEND result
        "all"
        "help"
        "clean"
        "test"
        "install"
        "package"
        "package_source"
    )

    set(subDirectories "${dir}")

    while(NOT "${subDirectories}" STREQUAL "")
        list(POP_BACK subDirectories subDir)
        get_property(targets DIRECTORY "${subDir}" PROPERTY BUILDSYSTEM_TARGETS)

        if(NOT "${targets}" STREQUAL "")
            list(APPEND result "${targets}")
        endif()

        get_property(subSubDirs DIRECTORY "${subDir}" PROPERTY SUBDIRECTORIES)

        if(NOT "${subSubDirs}" STREQUAL "")
            list(APPEND subDirectories "${subSubDirs}")
        endif()
    endwhile()

    set(${var} "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(generate_interface_only_files var)
    set(result "")

    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "SRC_DIRECTORY"
        "SRC_BASE_DIRECTORY"
        "DST_BASE_DIRECTORY"
    )
    set(multiValueKeywords
        "HEADER_FILES"
        "HEADER_FILES_EXPRESSIONS"
        "SOURCE_FILES"
        "SOURCE_FILES_EXPRESSIONS"
        "HEADER_SOURCE_MAPS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    set(srcDirectory "${_SRC_DIRECTORY}")
    set(srcBaseDirectory "${_SRC_BASE_DIRECTORY}")
    set(dstBaseDirectory "${_DST_BASE_DIRECTORY}")
    set(headerFiles "${_HEADER_FILES}")
    set(headerFilesExpressions "${_HEADER_FILES_EXPRESSIONS}")
    set(sourceFiles "${_SOURCE_FILES}")
    set(sourceFilesExpressions "${_SOURCE_FILES_EXPRESSIONS}")
    set(headerSourceMaps "${_HEADER_SOURCE_MAPS}")

    cmake_path(NORMAL_PATH srcDirectory)
    cmake_path(NORMAL_PATH srcBaseDirectory)
    cmake_path(NORMAL_PATH dstBaseDirectory)

    if(
        "${srcDirectory}" STREQUAL ""
        OR "${srcBaseDirectory}" STREQUAL ""
        OR "${dstBaseDirectory}" STREQUAL ""
        OR ("${headerFiles}" STREQUAL "" AND "${headerFilesExpressions}" STREQUAL "")
        OR ("${sourceFiles}" STREQUAL "" AND "${sourceFilesExpressions}" STREQUAL "")
    )
        string(JOIN " " message
            "Invalid set of arguments:"
            "srcDirectory: '${srcDirectory}'"
            "srcBaseDirectory: '${srcBaseDirectory}'"
            "dstBaseDirectory: '${dstBaseDirectory}'"
            "headerFiles: '${headerFiles}'"
            "headerFilesExpressions: '${headerFilesExpressions}'"
            "sourceFiles: '${sourceFiles}'"
            "sourceFilesExpressions: '${sourceFilesExpressions}'"
        )
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] ${message}")
    endif()

    if(
        (NOT "${headerFiles}" STREQUAL "" AND NOT "${headerFilesExpressions}" STREQUAL "")
        OR (NOT "${sourceFiles}" STREQUAL "" AND NOT "${sourceFilesExpressions}" STREQUAL "")
    )
        string(JOIN " " message
            "Invalid set of arguments:"
            "headerFiles: '${headerFiles}'"
            "headerFilesExpressions: '${headerFilesExpressions}'"
            "sourceFiles: '${sourceFiles}'"
            "sourceFilesExpressions: '${sourceFilesExpressions}'"
        )
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] ${message}")
    endif()

    foreach(map IN LISTS headerSourceMaps)
        string(FIND "${map}" ">" index)
        if("${index}" LESS "0")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Invalid HEADER_SOURCE_MAP: '${map}' should contain '>'")
        endif()
        string(REPLACE ">" ";" parts "${map}")
        list(GET "parts" "0" key)
        list(GET "parts" "1" value)
        if("${key}" STREQUAL "" OR "${value}" STREQUAL "")
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Invalid HEADER_SOURCE_MAP: '${map}' key or value empty")
        endif()
    endforeach()

    cmake_path(RELATIVE_PATH dstBaseDirectory BASE_DIRECTORY "${srcDirectory}" OUTPUT_VARIABLE dstRelativePath)

    foreach(expression IN LISTS headerFilesExpressions)
        file(GLOB_RECURSE files "${srcBaseDirectory}/${expression}")
        foreach(file IN LISTS files)
            list(APPEND headerFilesFound "${file}")
        endforeach()
    endforeach()

    foreach(expression IN LISTS sourceFilesExpressions)
        file(GLOB_RECURSE files "${srcBaseDirectory}/${expression}")
        foreach(file IN LISTS files)
            list(APPEND sourceFilesFound "${file}")
        endforeach()
    endforeach()

    foreach(file IN LISTS headerFiles)
        list(APPEND headerFilesFound "${srcDirectory}/${file}")
    endforeach()

    foreach(file IN LISTS sourceFiles)
        list(APPEND sourceFilesFound "${srcDirectory}/${file}")
    endforeach()

    list(SORT headerFilesFound)
    list(SORT sourceFilesFound)
    set(singleHeaderFiles "")
    set(pairedHeaderFiles "")
    set(pairedSourceFiles "")
    set(result "")

    foreach(header IN LISTS headerFilesFound)
        set(singleHeader "TRUE")
        get_filename_component(headerFileDir "${header}" DIRECTORY)
        get_filename_component(headerFileName "${header}" NAME_WE)
        foreach(source IN LISTS sourceFilesFound)
            set(match "FALSE")
            get_filename_component(sourceFileDir "${source}" DIRECTORY)
            get_filename_component(sourceFileName "${source}" NAME_WE)
            if("${headerFileDir}" STREQUAL "${sourceFileDir}")
                if("${headerFileName}" STREQUAL "${sourceFileName}")
                    set(match "TRUE")
                else()
                    foreach(map IN LISTS headerSourceMaps)
                        if("${match}")
                            break()
                        endif()
                        string(REPLACE ">" ";" parts "${map}")
                        list(GET "parts" "0" key)
                        list(GET "parts" "1" value)
                        if("${headerFileName}" STREQUAL "${key}" AND "${sourceFileName}" STREQUAL "${value}")
                            set(match "TRUE")
                        endif()
                    endforeach()
                endif()
            else()
                foreach(map IN LISTS headerSourceMaps)
                    if("${match}")
                        break()
                    endif()
                    string(REPLACE ">" ";" parts "${map}")
                    list(GET "parts" "0" key)
                    list(GET "parts" "1" value)
                    if("${headerFileName}" STREQUAL "${key}" AND "${sourceFileName}" STREQUAL "${value}")
                        set(match "TRUE")
                    endif()
                endforeach()
            endif()
            if("${match}")
                set(singleHeader "FALSE")
                if(NOT "${header}" IN_LIST pairedHeaderFiles)
                    list(APPEND pairedHeaderFiles "${header}")
                    list(APPEND pairedSourceFiles "${source}")
                endif()
            endif()
        endforeach()
        if("${singleHeader}" AND NOT "${header}" IN_LIST singleHeaderFiles)
            list(APPEND singleHeaderFiles "${header}")
        endif()
    endforeach()

    foreach(header IN LISTS singleHeaderFiles)
        cmake_path(RELATIVE_PATH header BASE_DIRECTORY "${srcBaseDirectory}" OUTPUT_VARIABLE newHeaderRelativePath)
        get_filename_component(newHeaderRelativeDir "${newHeaderRelativePath}" DIRECTORY)
        set(newHeaderDir "${dstBaseDirectory}/${newHeaderRelativeDir}")

        file(COPY "${header}" DESTINATION "${newHeaderDir}")

        if(NOT "${dstRelativePath}/${newHeaderRelativePath}" IN_LIST result)
            list(APPEND result "${dstRelativePath}/${newHeaderRelativePath}")
        endif()
    endforeach()

    set(semicolon "<semicolon_${timestamp}>")
    set(squareBracketOpen "<squareBracketOpen_${timestamp}>")
    set(squareBracketClose "<squareBracketClose_${timestamp}>")

    foreach(header source IN ZIP_LISTS pairedHeaderFiles pairedSourceFiles)
        file(READ "${header}" headerContent)
        file(READ "${source}" sourceContent)

        cmake_path(RELATIVE_PATH header BASE_DIRECTORY "${srcBaseDirectory}" OUTPUT_VARIABLE headerIncludePath)
        get_filename_component(headerIncludeFile "${headerIncludePath}" NAME)

        set(newHeaderContent "")
        string(STRIP "${headerContent}" headerContentStrip)
        string(APPEND newHeaderContent "${headerContentStrip}" "\n")

        string(STRIP "${sourceContent}" sourceLines)

        string(REPLACE ";" "${semicolon}" sourceLines "${sourceLines}")
        string(REPLACE "[" "${squareBracketOpen}" sourceLines "${sourceLines}")
        string(REPLACE "]" "${squareBracketClose}" sourceLines "${sourceLines}")

        string(REPLACE "\r\n" "\n" sourceLines "${sourceLines}")
        string(REPLACE "\r" "\n" sourceLines "${sourceLines}")
        string(REPLACE "\n" ";" sourceLines "${sourceLines}")

        foreach(sourceLine IN LISTS sourceLines)
            string(REPLACE "${semicolon}" ";" sourceLine "${sourceLine}")
            string(REPLACE "${squareBracketOpen}" "[" sourceLine "${sourceLine}")
            string(REPLACE "${squareBracketClose}" "]" sourceLine "${sourceLine}")

            string(STRIP "${sourceLine}" sourceLineStrip)

            if(
                "${sourceLineStrip}" MATCHES "^#include[^\"]+\"${headerIncludePath}\"$"
                OR "${sourceLineStrip}" MATCHES "^#include[^<]+<${headerIncludePath}>$"
                OR "${sourceLineStrip}" MATCHES "^#include[^\"]+\"${headerIncludeFile}\"$"
                OR "${sourceLineStrip}" MATCHES "^#include[^<]+<${headerIncludeFile}>$"
            )
                continue()
            else()
                string(APPEND newHeaderContent "${sourceLine}" "\n")
            endif()
        endforeach()

        cmake_path(RELATIVE_PATH header BASE_DIRECTORY "${srcBaseDirectory}" OUTPUT_VARIABLE newHeaderPath)
        set(newHeaderPath "${dstBaseDirectory}/${newHeaderPath}")
        cmake_path(RELATIVE_PATH newHeaderPath BASE_DIRECTORY "${srcDirectory}" OUTPUT_VARIABLE newHeaderRelativePath)

        file(WRITE "${newHeaderPath}" "${newHeaderContent}")

        if(NOT "${newHeaderRelativePath}" IN_LIST result)
            list(APPEND result "${newHeaderRelativePath}")
        endif()
    endforeach()

    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(doxygen)
    set(options)
    set(oneValueKeywords
        "VERBOSE"
        "CLEAN"
        "SOURCE_BASE_DIR"
        "SOURCE_DIR"
        "OUTPUT_DIR"
        "DOXYGEN_COMMAND"
        "DOXYFILE"
    )
    set(multiValueKeywords
        "DOXYGEN_TAGS"
        "DOXYGEN_ADD_TAGS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    if("${_VERBOSE}")
        set(verbose "TRUE")
    else()
        set(verbose "FALSE")
    endif()

    if("${_CLEAN}")
        set(clean "TRUE")
    else()
        set(clean "FALSE")
    endif()

    if("${_SOURCE_BASE_DIR}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not set SOURCE_BASE_DIR: '${_SOURCE_BASE_DIR}'")
    elseif(NOT EXISTS "${_SOURCE_BASE_DIR}")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not exists SOURCE_BASE_DIR: '${_SOURCE_BASE_DIR}'")
    elseif(NOT IS_DIRECTORY "${_SOURCE_BASE_DIR}")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not directory SOURCE_BASE_DIR: '${_SOURCE_BASE_DIR}'")
    else()
        set(sourceBaseDir "${_SOURCE_BASE_DIR}")
        cmake_path(APPEND sourceBaseDir "DIR")
        cmake_path(GET "sourceBaseDir" PARENT_PATH sourceBaseDir)
    endif()

    if("${_SOURCE_DIR}" STREQUAL "")
        set(sourceDirRelative "src/main/cpp")
    else()
        set(sourceDirRelative "${_SOURCE_DIR}")
        cmake_path(APPEND sourceDirRelative "DIR")
        cmake_path(GET "sourceDirRelative" PARENT_PATH sourceDirRelative)
    endif()

    if("${_OUTPUT_DIR}" STREQUAL "")
        set(outputDirRelative "build/doxygen/main")
    else()
        set(outputDirRelative "${_OUTPUT_DIR}")
        cmake_path(APPEND outputDirRelative "DIR")
        cmake_path(GET "outputDirRelative" PARENT_PATH outputDirRelative)
    endif()

    if("${_DOXYGEN_COMMAND}" STREQUAL "")
        set(doxygenCommand "")
    else()
        set(doxygenCommand "${_DOXYGEN_COMMAND}")
        cmake_path(APPEND doxygenCommand "DIR")
        cmake_path(GET "doxygenCommand" PARENT_PATH doxygenCommand)
    endif()

    if("${_DOXYFILE}" STREQUAL "")
        set(doxyFileRelative "${outputDirRelative}/Doxyfile")
    else()
        set(doxyFileRelative "${_DOXYFILE}")
        cmake_path(APPEND doxyFileRelative "DIR")
        cmake_path(GET "doxyFileRelative" PARENT_PATH doxyFileRelative)
    endif()

    if("${_DOXYGEN_TAGS}" STREQUAL "")
        set(doxygenTags
            "PROJECT_NAME="
            "OUTPUT_DIRECTORY=${outputDirRelative}"
            "RECURSIVE=YES"
            "INPUT=${sourceDirRelative}"
            "ENABLE_PREPROCESSING=YES"
            "GENERATE_XML=YES"
            "GENERATE_HTML=NO"
            "GENERATE_LATEX=NO"
            "FILE_PATTERNS=*.h *.c *.hpp *.cpp"
        )
        if(NOT "${verbose}")
            list(APPEND doxygenTags "QUIET=YES")
        endif()
    else()
        set(doxygenTags "${_DOXYGEN_TAGS}")
    endif()

    if(NOT "${_DOXYGEN_ADD_TAGS}" STREQUAL "")
        foreach(doxygenAddTag IN LISTS "_DOXYGEN_ADD_TAGS")
            list(APPEND doxygenTags "${doxygenAddTag}")
        endforeach()
    endif()

    # clean run doxygen
    if("${clean}" AND EXISTS "${sourceBaseDir}/${outputDirRelative}")
        if("${verbose}")
            string(TIMESTAMP currentDateTime "%Y-%m-%d %H:%M:%S")
            message(STATUS "timestamp: '${currentDateTime}' file: '${CMAKE_CURRENT_LIST_FILE}' clean run doxygen")
        endif()
        file(REMOVE_RECURSE "${sourceBaseDir}/${outputDirRelative}")
    endif()

    # run doxygen
    if(NOT EXISTS "${sourceBaseDir}/${outputDirRelative}")
        if("${verbose}")
            string(TIMESTAMP currentDateTime "%Y-%m-%d %H:%M:%S")
            message(STATUS "timestamp: '${currentDateTime}' file: '${CMAKE_CURRENT_LIST_FILE}' run doxygen")
        endif()
        if(NOT EXISTS "${doxyFileRelative}")
            set(doxygenFileContent "")
            if(NOT "${doxygenTags}" STREQUAL "")
                string(TIMESTAMP timestamp)
                set(semicolon "<semicolon_${timestamp}>")
                set(squareBracketOpen "<squareBracketOpen_${timestamp}>")
                set(squareBracketClose "<squareBracketClose_${timestamp}>")
                foreach(doxygenTag IN LISTS "doxygenTags")
                    string(REPLACE ";" "${semicolon}" doxygenTag "${doxygenTag}")
                    string(REPLACE "[" "${squareBracketOpen}" doxygenTag "${doxygenTag}")
                    string(REPLACE "]" "${squareBracketClose}" doxygenTag "${doxygenTag}")

                    string(REPLACE "=" ";" value "${doxygenTag}")
                    list(POP_FRONT "value" key)
                    string(REPLACE ";" "=" value "${value}")

                    string(REPLACE "${semicolon}" ";" key "${key}")
                    string(REPLACE "${squareBracketOpen}" "[" key "${key}")
                    string(REPLACE "${squareBracketClose}" "]" key "${key}")

                    string(REPLACE "${semicolon}" ";" value "${value}")
                    string(REPLACE "${squareBracketOpen}" "[" value "${value}")
                    string(REPLACE "${squareBracketClose}" "]" value "${value}")

                    string(APPEND doxygenFileContent "${key} = ${value}\n")
                endforeach()
                string(APPEND doxygenFileContent "\n")
            endif()
            file(WRITE "${sourceBaseDir}/${doxyFileRelative}" "${doxygenFileContent}")
        endif()

        if("${doxygenCommand}" STREQUAL "")
            find_program(doxygenCommandFound NAMES "doxygen.exe" "doxygen" PATHS ENV DOXYGEN_PATH ENV PATH REQUIRED NO_CACHE NO_DEFAULT_PATH)
        else()
            set(doxygenCommandFound "${doxygenCommand}")
        endif()

        file(MAKE_DIRECTORY "${sourceBaseDir}/${outputDirRelative}")
        execute_process(
            COMMAND "${doxygenCommandFound}" "${sourceBaseDir}/${doxyFileRelative}"
            WORKING_DIRECTORY "${sourceBaseDir}"
            COMMAND_ECHO "STDOUT"
            COMMAND_ERROR_IS_FATAL "ANY"
        )

        if("${verbose}")
            string(TIMESTAMP currentDateTime "%Y-%m-%d %H:%M:%S")
            message(STATUS "currentDateTime: '${currentDateTime}'")
        endif()
    endif()
endfunction()

function(sphinx)
    string(JOIN "\n" requirementsFileContent
        "Sphinx==6.2.1"
        "linuxdoc==20230506"
        "breathe==4.35.0"
        "mlx.traceability==10.0.0"
        "docxbuilder==1.2.0"
        "docxbuilder[math]"
        "rst2pdf==0.100"
        ""
    )

    set(options)
    set(oneValueKeywords
        "VERBOSE"
        "SPHINX_VERBOSE"
        "SPHINX_QUIET"
        "SSL"
        "WARNINGS_TO_ERRORS"
        "CLEAN"
        "TOCTREE_MAXDEPTH"
        "TOCTREE_CAPTION"
        "TOCTREE_HIDDEN"
        "SOURCE_BASE_DIR"
        "SOURCE_DIR"
        "BUILD_DIR"
        "REQUIREMENTS_FILE"
        "ENV_DIR"
        "TYPE"
        "CONF_JSON_FILE"
        "OUTPUT_DIR"
        "SPHINX_COMMAND"
        "SPHINX_WARNINGS_ERRORS_FILE"
    )
    set(multiValueKeywords
        "FILES"
        "EXTRA_FILES"
        "CONF_JSON_VARS"
        "BUILDERS"
        "SPHINX_FLAGS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    if("${_VERBOSE}" STREQUAL "")
        set(verbose "FALSE")
    else()
        if("${_VERBOSE}")
            set(verbose "TRUE")
        else()
            set(verbose "FALSE")
        endif()
    endif()

    if("${verbose}")
        message(STATUS "execute file: '${CMAKE_CURRENT_LIST_FILE}'")
        string(TIMESTAMP currentDateTime "%Y-%m-%d %H:%M:%S")
        message(STATUS "currentDateTime: '${currentDateTime}'")
    endif()

    if("${_SPHINX_VERBOSE}" STREQUAL "")
        set(sphinxVerbose "0")
    else()
        set(sphinxVerbose "${_SPHINX_VERBOSE}")
        if("${sphinxVerbose}" GREATER "0" AND "${sphinxVerbose}" LESS_EQUAL "3")
            set(sphinxVerbose "${sphinxVerbose}")
        else()
            set(sphinxVerbose "0")
        endif()
    endif()

    if("${_SPHINX_QUIET}" STREQUAL "")
        set(sphinxQuiet "FALSE")
    else()
        if("${_SPHINX_QUIET}")
            set(sphinxQuiet "TRUE")
        else()
            set(sphinxQuiet "FALSE")
        endif()
    endif()

    if("${_SSL}" STREQUAL "")
        set(ssl "TRUE")
    else()
        if("${_SSL}")
            set(ssl "TRUE")
        else()
            set(ssl "FALSE")
        endif()
    endif()

    if("${_WARNINGS_TO_ERRORS}" STREQUAL "")
        set(warningsToErrors "TRUE")
    else()
        if("${_WARNINGS_TO_ERRORS}")
            set(warningsToErrors "TRUE")
        else()
            set(warningsToErrors "FALSE")
        endif()
    endif()

    if("${_CLEAN}")
        set(clean "TRUE")
    else()
        set(clean "FALSE")
    endif()

    if("${_TOCTREE_MAXDEPTH}" STREQUAL "")
        set(toctreeMaxdepth "2")
    else()
        set(toctreeMaxdepth "${_TOCTREE_MAXDEPTH}")
    endif()

    if("${_TOCTREE_CAPTION}" STREQUAL "")
        set(toctreeCaption "Contents:")
    else()
        set(toctreeCaption "${_TOCTREE_CAPTION}")
    endif()

    if("${_TOCTREE_HIDDEN}")
        set(toctreeHidden "TRUE")
    else()
        set(toctreeHidden "FALSE")
    endif()

    if("${_SOURCE_BASE_DIR}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not set SOURCE_BASE_DIR: '${_SOURCE_BASE_DIR}'")
    elseif(NOT EXISTS "${_SOURCE_BASE_DIR}")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not exists SOURCE_BASE_DIR: '${_SOURCE_BASE_DIR}'")
    elseif(NOT IS_DIRECTORY "${_SOURCE_BASE_DIR}")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not directory SOURCE_BASE_DIR: '${_SOURCE_BASE_DIR}'")
    else()
        set(sourceBaseDir "${_SOURCE_BASE_DIR}")
        cmake_path(APPEND sourceBaseDir "DIR")
        cmake_path(GET "sourceBaseDir" PARENT_PATH sourceBaseDir)
    endif()

    if("${_SOURCE_DIR}" STREQUAL "")
        set(sourceDirRelative "doc")
    else()
        set(sourceDirRelative "${_SOURCE_DIR}")
        cmake_path(APPEND sourceDirRelative "DIR")
        cmake_path(GET "sourceDirRelative" PARENT_PATH sourceDirRelative)
    endif()

    if("${_BUILD_DIR}" STREQUAL "")
        set(buildDirRelative "build/")
    else()
        set(buildDirRelative "${_BUILD_DIR}")
        cmake_path(APPEND buildDirRelative "DIR")
        cmake_path(GET "buildDirRelative" PARENT_PATH buildDirRelative)
    endif()

    if("${_REQUIREMENTS_FILE}" STREQUAL "")
        set(requirementsFileRelative "${buildDirRelative}/requirements.txt")
    else()
        set(requirementsFileRelative "${_REQUIREMENTS_FILE}")
        cmake_path(APPEND requirementsFileRelative "DIR")
        cmake_path(GET "requirementsFileRelative" PARENT_PATH requirementsFileRelative)
    endif()

    if("${_ENV_DIR}" STREQUAL "")
        set(envDirRelative "${buildDirRelative}/py-env")
    else()
        set(envDirRelative "${_ENV_DIR}")
        cmake_path(APPEND envDirRelative "DIR")
        cmake_path(GET "envDirRelative" PARENT_PATH envDirRelative)
    endif()

    if("${_TYPE}" STREQUAL "")
        set(type "documentation")
    else()
        set(type "${_TYPE}")
        string(REPLACE " " "_" type "${type}")
    endif()

    if("${_OUTPUT_DIR}" STREQUAL "")
        set(outputDirRelative "build/doc/${type}")
    else()
        set(outputDirRelative "${_OUTPUT_DIR}")
        cmake_path(APPEND outputDirRelative "DIR")
        cmake_path(GET "outputDirRelative" PARENT_PATH outputDirRelative)
    endif()

    if("${_SPHINX_COMMAND}" STREQUAL "")
        set(sphinxCommand "")
    else()
        set(sphinxCommand "${_SPHINX_COMMAND}")
        cmake_path(APPEND sphinxCommand "DIR")
        cmake_path(GET "sphinxCommand" PARENT_PATH sphinxCommand)
    endif()

    if("${_SPHINX_WARNINGS_ERRORS_FILE}" STREQUAL "")
        set(sphinxWarningsErrorsFile "NONE")
    else()
        set(sphinxWarningsErrorsFile "${_SPHINX_WARNINGS_ERRORS_FILE}")
        cmake_path(APPEND sphinxWarningsErrorsFile "DIR")
        cmake_path(GET "sphinxWarningsErrorsFile" PARENT_PATH sphinxWarningsErrorsFile)
    endif()

    if("${_CONF_JSON_VARS}" STREQUAL "")
        set(confJsonVars "sourceBaseDir=${sourceBaseDir}")
    else()
        set(confJsonVars "${_CONF_JSON_VARS}")
    endif()

    if("${_BUILDERS}" STREQUAL "")
        set(builders "html" "docx" "pdf")
    else()
        set(builders "${_BUILDERS}")
    endif()

    if("${_SPHINX_FLAGS}" STREQUAL "")
        set(sphinxFlags "")
    else()
        set(sphinxFlags "${_SPHINX_FLAGS}")
    endif()

    if("${_FILES}" STREQUAL "")
        set(files "")
    else()
        set(files "")
        foreach(file IN LISTS "_FILES")
            set(fileRelative "${file}")
            cmake_path(APPEND fileRelative "DIR")
            cmake_path(GET "fileRelative" PARENT_PATH fileRelative)
            list(APPEND files "${fileRelative}")
        endforeach()
    endif()

    if("${_EXTRA_FILES}" STREQUAL "")
        set(extraFiles "")
    else()
        set(extraFiles "${_EXTRA_FILES}")
    endif()

    if("${_CONF_JSON_FILE}" STREQUAL "")
        set(confJsonFileRelative "${sourceDirRelative}/conf.json")
    else()
        set(confJsonFileRelative "${_CONF_JSON_FILE}")
        cmake_path(APPEND confJsonFileRelative "DIR")
        cmake_path(GET "confJsonFileRelative" PARENT_PATH confJsonFileRelative)
    endif()

    if("${sphinxCommand}" STREQUAL "")
        find_program(sphinxCommandFound
            NAMES "sphinx-build.exe" "sphinx-build"
            PATHS "${sourceBaseDir}/${envDirRelative}/Scripts"
                  "${sourceBaseDir}/${envDirRelative}/bin"
            NO_CACHE
            NO_DEFAULT_PATH
        )

        # create sphinx env
        if("${sphinxCommandFound}" STREQUAL "sphinxCommandFound-NOTFOUND")
            if("${verbose}")
                message(STATUS "create sphinx env")
            endif()
            if(NOT EXISTS "${sourceBaseDir}/${requirementsFileRelative}")
                file(WRITE "${sourceBaseDir}/${requirementsFileRelative}" "${requirementsFileContent}")
            endif()
            find_program(PYTHON_COMMAND NAMES "py.exe" "py" "python.exe" "python" NO_CACHE REQUIRED)
            execute_process(
                COMMAND "${PYTHON_COMMAND}" "-m" "venv" "${envDirRelative}"
                WORKING_DIRECTORY "${sourceBaseDir}"
                COMMAND_ECHO "STDOUT"
                COMMAND_ERROR_IS_FATAL "ANY"
            )
            find_program(PIP_COMMAND
                NAMES "pip.exe" "pip"
                PATHS "${sourceBaseDir}/${envDirRelative}/Scripts"
                "${sourceBaseDir}/${envDirRelative}/bin"
                NO_CACHE
                REQUIRED
                NO_DEFAULT_PATH
            )
            set(command "${PIP_COMMAND}" "install")
            if(NOT "${ssl}")
                list(APPEND command
                    "--trusted-host" "pypi.org"
                    "--trusted-host" "pypi.python.org"
                    "--trusted-host" "files.pythonhosted.org"
                    "-r" "${requirementsFileRelative}"
                )
            endif()
            list(APPEND command "-r" "${requirementsFileRelative}")
            execute_process(
                COMMAND ${command}
                WORKING_DIRECTORY "${sourceBaseDir}"
                COMMAND_ECHO "STDOUT"
                COMMAND_ERROR_IS_FATAL "ANY"
            )
            find_program(sphinxCommandFound
                NAMES "sphinx-build.exe" "sphinx-build"
                PATHS "${sourceBaseDir}/${envDirRelative}/Scripts"
                      "${sourceBaseDir}/${envDirRelative}/bin"
                NO_CACHE
                REQUIRED
                NO_DEFAULT_PATH
            )
        endif()
    else()
        set(sphinxCommandFound "${sphinxCommand}")
    endif()

    # create structure
    if("${verbose}")
        message(STATUS "create structure")
    endif()
    if(EXISTS "${sourceBaseDir}/${buildDirRelative}/${type}")
        file(REMOVE_RECURSE "${sourceBaseDir}/${buildDirRelative}/${type}")
    endif()
    set(indexRstContent "")
    string(APPEND indexRstContent ".. toctree::" "\n")
    string(APPEND indexRstContent "   :maxdepth: ${toctreeMaxdepth}" "\n")
    string(APPEND indexRstContent "   :caption: ${toctreeCaption}" "\n")
    if("${toctreeHidden}")
        string(APPEND indexRstContent "   :hidden:" "\n")
    endif()
    string(APPEND indexRstContent "\n")
    if(NOT "${files}" STREQUAL "")
        foreach(file IN LISTS "files")
            set(fileSrc "${file}")
            set(fileFlag "NONE")
            string(FIND "${file}" ">" delimiterIndex)
            if(NOT "${delimiterIndex}" EQUAL "-1")
                string(REPLACE ">" ";" fileParts "${file}")
                list(GET "fileParts" "0" fileSrc)
                list(GET "fileParts" "1" fileFlag)
                if(NOT "${fileFlag}" STREQUAL "TOCTREE_ONLY")
                    message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed fileFlag: '${fileFlag}'")
                endif()
            endif()

            cmake_path(GET "fileSrc" PARENT_PATH fileDir)
            cmake_path(GET "fileSrc" FILENAME fileName)
            cmake_path(GET "fileName" STEM fileNameNoExt)
            if("${fileDir}" STREQUAL "")
                string(APPEND indexRstContent "   ${fileNameNoExt}" "\n")
                if(NOT "${fileFlag}" STREQUAL "TOCTREE_ONLY")
                    file(COPY "${sourceBaseDir}/${sourceDirRelative}/${fileSrc}" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${type}/${sourceDirRelative}")
                endif()
            else()
                string(APPEND indexRstContent "   ${fileDir}/${fileNameNoExt}" "\n")
                if(NOT "${fileFlag}" STREQUAL "TOCTREE_ONLY")
                    file(MAKE_DIRECTORY "${sourceBaseDir}/${buildDirRelative}/${type}/${sourceDirRelative}/${fileDir}")
                    file(COPY "${sourceBaseDir}/${sourceDirRelative}/${fileSrc}" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${type}/${sourceDirRelative}/${fileDir}")
                endif()
            endif()
        endforeach()
    endif()
    if(NOT "${extraFiles}" STREQUAL "")
        foreach(file IN LISTS "extraFiles")
            string(FIND "${file}" ">" delimiterIndex)
            if("${delimiterIndex}" EQUAL "-1")
                set(fileSrc "${sourceBaseDir}/${sourceDirRelative}/${file}")
                set(fileDst "${file}")
            else()
                string(REPLACE ">" ";" fileParts "${file}")
                list(GET "fileParts" "0" fileSrc)
                list(GET "fileParts" "1" fileDst)
                cmake_path(RELATIVE_PATH "fileSrc" BASE_DIRECTORY "${sourceBaseDir}" OUTPUT_VARIABLE fileSrc)
            endif()

            cmake_path(GET "fileDst" PARENT_PATH fileDir)
            if("${fileDir}" STREQUAL "")
                file(COPY "${fileSrc}" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${type}/${sourceDirRelative}")
            else()
                file(MAKE_DIRECTORY "${sourceBaseDir}/${buildDirRelative}/${type}/${sourceDirRelative}/${fileDir}")
                file(COPY "${fileSrc}" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${type}/${sourceDirRelative}/${fileDir}")
            endif()
        endforeach()
    endif()
    if(NOT "${confJsonVars}" STREQUAL "")
        if(NOT EXISTS "${sourceBaseDir}/${confJsonFileRelative}")
            set(confJsonContent "{}")
        else()
            file(READ "${sourceBaseDir}/${confJsonFileRelative}" confJsonContent)
        endif()
        string(TIMESTAMP timestamp)
        set(semicolon "<semicolon_${timestamp}>")
        set(squareBracketOpen "<squareBracketOpen_${timestamp}>")
        set(squareBracketClose "<squareBracketClose_${timestamp}>")
        foreach(confJsonVar IN LISTS "confJsonVars")
            string(REPLACE ";" "${semicolon}" confJsonVar "${confJsonVar}")
            string(REPLACE "[" "${squareBracketOpen}" confJsonVar "${confJsonVar}")
            string(REPLACE "]" "${squareBracketClose}" confJsonVar "${confJsonVar}")

            string(REPLACE "=" ";" value "${confJsonVar}")
            list(POP_FRONT "value" key)
            string(REPLACE ";" "=" value "${value}")

            string(REPLACE "${semicolon}" ";" key "${key}")
            string(REPLACE "${squareBracketOpen}" "[" key "${key}")
            string(REPLACE "${squareBracketClose}" "]" key "${key}")

            string(REPLACE "${semicolon}" ";" value "${value}")
            string(REPLACE "${squareBracketOpen}" "[" value "${value}")
            string(REPLACE "${squareBracketClose}" "]" value "${value}")

            string(JSON confJsonContent SET "${confJsonContent}" "${key}" "\"${value}\"")
        endforeach()
        cmake_path(GET "confJsonFileRelative" PARENT_PATH confJsonDirRelative)
        if(NOT "${confJsonDirRelative}" STREQUAL "")
            file(MAKE_DIRECTORY "${sourceBaseDir}/${buildDirRelative}/${type}/${confJsonDirRelative}")
        endif()
        file(WRITE "${sourceBaseDir}/${buildDirRelative}/${type}/${confJsonFileRelative}" "${confJsonContent}")
    endif()
    file(WRITE "${sourceBaseDir}/${buildDirRelative}/${type}/${sourceDirRelative}/index.rst" "${indexRstContent}")
    file(COPY "${sourceBaseDir}/${sourceDirRelative}/conf.py" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${type}/${sourceDirRelative}")

    foreach(builder IN LISTS "builders")

        # build
        if("${verbose}")
            message(STATUS "build ${builder}")
        endif()
        if("${clean}" AND EXISTS "${sourceBaseDir}/${outputDirRelative}/${builder}")
            file(REMOVE_RECURSE "${sourceBaseDir}/${outputDirRelative}/${builder}")
        endif()
        set(flags "${sphinxFlags}")
        if("${sphinxQuiet}")
            if("${warningsToErrors}" AND NOT "-q" IN_LIST flags)
                list(APPEND flags "-q")
            elseif(NOT "${warningsToErrors}" AND NOT "-Q" IN_LIST flags)
                list(APPEND flags "-Q")
            endif()
        else()
            if("${sphinxVerbose}" GREATER "0" AND "${sphinxVerbose}" LESS_EQUAL "3")
                foreach(i RANGE "1" "${sphinxVerbose}")
                    list(APPEND flags "-v")
                endforeach()
            endif()
        endif()
        if("${warningsToErrors}")
            if(NOT "-W" IN_LIST flags)
                list(APPEND "flags" "-W")
            endif()
            if(NOT "--keep-going" IN_LIST flags)
                list(APPEND "flags" "--keep-going")
            endif()
        endif()
        if(NOT "-E" IN_LIST flags)
            list(APPEND "flags" "-E")
        endif()
        if(NOT "${sphinxWarningsErrorsFile}" STREQUAL "NONE")
            list(APPEND "flags" "-w" "${sphinxWarningsErrorsFile}")
        endif()
        execute_process(
            COMMAND "${sphinxCommandFound}"
                    ${flags}
                    "-b"
                    "${builder}"
                    "${buildDirRelative}/${type}/${sourceDirRelative}"
                    "${outputDirRelative}/${builder}"
            WORKING_DIRECTORY "${sourceBaseDir}"
            COMMAND_ECHO "STDOUT"
            COMMAND_ERROR_IS_FATAL "ANY"
        )

    endforeach()

    if("${verbose}")
        string(TIMESTAMP currentDateTime "%Y-%m-%d %H:%M:%S")
        message(STATUS "currentDateTime: '${currentDateTime}'")
    endif()
endfunction()

block()
    if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
        set(args)
        set(argsStarted "FALSE")
        math(EXPR argIndexMax "${CMAKE_ARGC} - 1")

        foreach(i RANGE "0" "${argIndexMax}")
            if("${argsStarted}")
                list(APPEND args "${CMAKE_ARGV${i}}")
            elseif(NOT "${argsStarted}" AND "${CMAKE_ARGV${i}}" STREQUAL "--")
                set(argsStarted "TRUE")
            endif()
        endforeach()

        set(noEscapeBackslashOption "--no-escape-backslash")

        if("${args}" STREQUAL "")
            cmake_path(GET CMAKE_CURRENT_LIST_FILE FILENAME fileName)
            message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Usage: cmake -P ${fileName} -- [${noEscapeBackslashOption}] function_name args...")
        endif()

        list(POP_FRONT args firstArg)
        set(escapeBackslash "TRUE")

        if("${firstArg}" STREQUAL "${noEscapeBackslashOption}")
            set(escapeBackslash "FALSE")
            list(POP_FRONT args func)
        else()
            set(func "${firstArg}")
        endif()

        set(wrappedArgs "")

        if(NOT "${args}" STREQUAL "")
            foreach(arg IN LISTS args)
                set(wrappedArg "${arg}")
                string(FIND "${wrappedArg}" " " firstIndexOfSpace)

                if(NOT "${firstIndexOfSpace}" EQUAL "-1")
                    set(wrappedArg "\"${wrappedArg}\"")
                endif()

                if("${escapeBackslash}")
                    string(REPLACE "\\" "\\\\" wrappedArg "${wrappedArg}")
                endif()

                if("${wrappedArgs}" STREQUAL "")
                    string(APPEND wrappedArgs "${wrappedArg}")
                else()
                    string(APPEND wrappedArgs " ${wrappedArg}")
                endif()
            endforeach()
        endif()

        cmake_language(EVAL CODE "${func}(${wrappedArgs})")
    endif()
endblock()

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
endif()
