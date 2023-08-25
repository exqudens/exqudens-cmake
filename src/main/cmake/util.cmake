cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

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

function(set_if_not_defined var)
    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
        endif()
    endforeach()
    if("${${var}}" STREQUAL "" AND NOT "${ARGN}" STREQUAL "")
        set("${var}" "${ARGN}" PARENT_SCOPE)
    endif()
endfunction()

function(substring_from var input fromExclusive)
    set(result "")
    block(PROPAGATE result)
        foreach(i var input fromExclusive)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()
        string(FIND "${input}" "${fromExclusive}" fromStartIndex)
        if("-1" STREQUAL "${fromStartIndex}")
            message(FATAL_ERROR "Can't find 'fromExclusive' in 'input'")
        endif()
        string(LENGTH "${input}" inputLength)
        string(LENGTH "${fromExclusive}" "fromLength")
        math(EXPR fromEndIndex "${fromStartIndex} + ${fromLength}")
        math(EXPR substringLength "${inputLength} - ${fromEndIndex}")
        string(SUBSTRING "${input}" "${fromEndIndex}" "${substringLength}" result)
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(substring_to var input toExclusive)
    set(result "")
    block(PROPAGATE result)
        foreach(i var input toExclusive)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()
        string(FIND "${input}" "${toExclusive}" toStartIndex)
        if("-1" STREQUAL "${toStartIndex}")
            message(FATAL_ERROR "Can't find 'toExclusive' in 'input'")
        endif()
        string(LENGTH "${input}" inputLength)
        string(SUBSTRING "${input}" 0 "${toStartIndex}" result)
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(string_replace_between prefix input fromExclusive toExclusive)
    set(result "")
    set(resultBetween "")
    set(resultReplaced "")
    foreach(i prefix input fromExclusive toExclusive)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

    set(options
        "RESULT_ONLY"
        "REPLACED_ONLY"
        "BETWEEN_ONLY"
    )
    set(oneValueKeywords
        "WITH"
    )
    set(multiValueKeywords)
    cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
    endif()

    if("" STREQUAL "${${currentFunctionName}_WITH}")
        set(value "")
    else()
        set(value "${${currentFunctionName}_WITH}")
    endif()

    if("${${currentFunctionName}_REPLACED_ONLY}")
        substring_from(resultBetween "${input}" "${fromExclusive}")
        substring_to(resultBetween "${resultBetween}" "${toExclusive}")

        string(CONCAT resultReplaced "${fromExclusive}" "${resultBetween}" "${toExclusive}")

        set("${prefix}" "${resultReplaced}" PARENT_SCOPE)
    elseif("${${currentFunctionName}_BETWEEN_ONLY}")
        substring_from(resultBetween "${input}" "${fromExclusive}")
        substring_to(resultBetween "${resultBetween}" "${toExclusive}")

        set("${prefix}" "${resultBetween}" PARENT_SCOPE)
    else()
        if("${${currentFunctionName}_RESULT_ONLY}")
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
    block(PROPAGATE result resultDir)
        foreach(i prefix)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

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
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        set(required "${${currentFunctionName}_REQUIRED}")
        set(maxParentLevel "${${currentFunctionName}_MAX_PARENT_LEVEL}")
        set(paths "${${currentFunctionName}_PATHS}")
        set(names "${${currentFunctionName}_NAMES}")

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
            message(FATAL_ERROR "File not found names: '${names}' paths: '${paths}'")
        endif()
    endblock()
    set("${prefix}_FILE" "${result}" PARENT_SCOPE)
    set("${prefix}_DIR" "${resultDir}" PARENT_SCOPE)
    unset(result)
    unset(resultDir)
endfunction()

function(find_file_in prefix)
    set(result "")
    set(resultDir "")
    block(PROPAGATE result resultDir)
        foreach(i prefix)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

        set(options
            "REQUIRED"
        )
        set(oneValueKeywords)
        set(multiValueKeywords
            "NAMES"
            "PATHS"
        )
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        set(required "${${currentFunctionName}_REQUIRED}")
        set(paths "${${currentFunctionName}_PATHS}")
        set(names "${${currentFunctionName}_NAMES}")

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
            message(FATAL_ERROR "File not found names: '${names}' paths: '${paths}'")
        endif()
    endblock()
    set("${prefix}_FILE" "${result}" PARENT_SCOPE)
    set("${prefix}_DIR" "${resultDir}" PARENT_SCOPE)
    unset(result)
    unset(resultDir)
endfunction()

function(set_msvc_path var)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

        set(options)
        set(oneValueKeywords
            "COMMAND"
            "VERSION"
            "PROPERTY"
        )
        set(multiValueKeywords
            "PRODUCTS"
        )
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        set(command "${${currentFunctionName}_COMMAND}")
        set(version "${${currentFunctionName}_VERSION}")
        set(property "${${currentFunctionName}_PROPERTY}")
        set(products "${${currentFunctionName}_PRODUCTS}")

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
            message(FATAL_ERROR "Empty result from: '${command}'.")
        endif()

        cmake_path(CONVERT "${result}" TO_CMAKE_PATH_LIST result NORMALIZE)
        string(REGEX REPLACE "[\r]" "" result "${result}")
        string(REGEX REPLACE "[\n]" ";" result "${result}")
        list(GET result 0 result)
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_msvc_env prefix)
    set(resultMsvcInclude "")
    set(resultMsvcLibPath "")
    set(resultMsvcLib "")
    set(resultMsvcClPath "")
    set(resultMsvcRcPath "")
    block(PROPAGATE resultMsvcInclude resultMsvcLibPath resultMsvcLib resultMsvcClPath resultMsvcRcPath)
        foreach(i prefix)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

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
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        set(command "${${currentFunctionName}_COMMAND}")
        set(version "${${currentFunctionName}_VERSION}")
        set(property "${${currentFunctionName}_PROPERTY}")
        set(host "${${currentFunctionName}_HOST}")
        set(target "${${currentFunctionName}_TARGET}")
        set(path "${${currentFunctionName}_PATH}")
        set(products "${${currentFunctionName}_PRODUCTS}")

        if(NOT "" STREQUAL "${path}")
            if(NOT EXISTS "${path}")
                message(FATAL_ERROR "Not exists: '${path}'")
            elseif(IS_DIRECTORY "${path}")
                message(FATAL_ERROR "Is directory: '${path}'")
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
            message(FATAL_ERROR "${errorMessage}")
        endif()

        if(NOT "x86" STREQUAL "${target}" AND NOT "x64" STREQUAL "${target}")
            string(JOIN " " errorMessage
                "Unsupported or not specified 'target': '${target}'."
                "Supported values [ 'x86', 'x64' ]."
            )
            message(FATAL_ERROR "${errorMessage}")
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
                message(FATAL_ERROR "Not found '${vcvarsallBatName}' in '${msvcPath}'")
            endif()
        elseif(NOT "" STREQUAL "${path}")
            if(NOT EXISTS "${path}")
                message(FATAL_ERROR "Not exists 'path': '${path}'")
            endif()
            find_file_in_parent(vcvarsall MAX_PARENT_LEVEL "9" NAMES "${vcvarsallBatName}" PATHS "${path}" REQUIRED)
            if("" STREQUAL "${vcvarsall_DIR}")
                message(FATAL_ERROR "Not found '${vcvarsallBatName}' in '8' parent dirs of '${path}'")
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
    endblock()
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
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

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
        )
        set(multiValueKeywords
            "PRODUCTS"
        )
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        set(command "${${currentFunctionName}_COMMAND}")
        set(version "${${currentFunctionName}_VERSION}")
        set(property "${${currentFunctionName}_PROPERTY}")
        set(host "${${currentFunctionName}_HOST}")
        set(target "${${currentFunctionName}_TARGET}")
        set(path "${${currentFunctionName}_PATH}")
        set(processor "${${currentFunctionName}_PROCESSOR}")
        set(os "${${currentFunctionName}_OS}")
        set(products "${${currentFunctionName}_PRODUCTS}")
        set(outputFile "${${currentFunctionName}_OUTPUT_FILE}")
        set(noCache "${${currentFunctionName}_NO_CACHE}")

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

        string(JOIN "\n" result
            "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})"
            "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})"
            ""
            "set(MSVC_CL_PATH \"${func_cl_cmake}\"${cacheInstructions})"
            "set(MSVC_RC_PATH \"${func_rc_cmake}\"${cacheInstructions})"
            ""
            "set(CMAKE_C_COMPILER   \"\${MSVC_CL_PATH}/cl.exe\"${cacheInstructions})"
            "set(CMAKE_CXX_COMPILER \"\${MSVC_CL_PATH}/cl.exe\"${cacheInstructions})"
            "set(CMAKE_AR           \"\${MSVC_CL_PATH}/lib.exe\"${cacheInstructions})"
            "set(CMAKE_LINKER       \"\${MSVC_CL_PATH}/link.exe\"${cacheInstructions})"
            "set(CMAKE_RC_COMPILER  \"\${MSVC_RC_PATH}/rc.exe\"${cacheInstructions})"
            "set(CMAKE_MT           \"\${MSVC_RC_PATH}/mt.exe\"${cacheInstructions})"
            ""
            "set(ENV{INCLUDE} \"${func_include}\")"
            "set(ENV{LIBPATH} \"${func_libpath}\")"
            "set(ENV{LIB} \"${func_lib}\")"
            "set(ENV{PATH} \"${func_path}\")"
            ""
            "set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES \"${func_include_cmake}\"${cacheInstructions})"
            "set(CMAKE_C_STANDARD_LINK_DIRECTORIES \"${func_libpath_cmake}\"${cacheInstructions})"
            ""
            "set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES \"${func_cmake_include}\"${cacheInstructions})"
            "set(CMAKE_CXX_STANDARD_LINK_DIRECTORIES \"${func_cmake_libpath}\"${cacheInstructions})"
            ""
            "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER${cacheInstructions})"
            "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY${cacheInstructions})"
            "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY${cacheInstructions})"
            "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY${cacheInstructions})"
            ""
            "link_directories(\"\${CMAKE_CXX_STANDARD_LINK_DIRECTORIES}\") # remove when CMAKE_CXX_STANDARD_LINK_DIRECTORIES is supported"
            ""
        )

        if(NOT "${outputFile}" STREQUAL "" AND NOT EXISTS "${outputFile}")
            file(WRITE "${outputFile}" "${result}")
        endif()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_gnu_toolchain var)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

        set(options)
        set(oneValueKeywords
            "PATH"
            "PROCESSOR"
            "OS"
            "OUTPUT_FILE"
            "NO_CACHE"
        )
        set(multiValueKeywords)
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        set(path "${${currentFunctionName}_PATH}")
        set(processor "${${currentFunctionName}_PROCESSOR}")
        set(os "${${currentFunctionName}_OS}")
        set(outputFile "${${currentFunctionName}_OUTPUT_FILE}")
        set(noCache "${${currentFunctionName}_NO_CACHE}")

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

        if("${compilerFileNameExt}" STREQUAL ".exe" AND ("${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" OR "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++"))
            string(JOIN "\n" result
                "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})"
                "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})"
                ""
                "set(COMPILER_PATH \"${compilerDir}\"${cacheInstructions})"
                ""
                "set(CMAKE_C_COMPILER   \"\${COMPILER_PATH}/arm-none-eabi-gcc.exe\"${cacheInstructions})"
                "set(CMAKE_CXX_COMPILER \"\${COMPILER_PATH}/arm-none-eabi-g++.exe\"${cacheInstructions})"
                "set(CMAKE_ASM_COMPILER \"\${COMPILER_PATH}/arm-none-eabi-gcc.exe\"${cacheInstructions})"
                "set(CMAKE_SIZE         \"\${COMPILER_PATH}/arm-none-eabi-size.exe\"${cacheInstructions})"
                ""
                "set(ENV{PATH} \"${envPathNative}\")"
                ""
                "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY${cacheInstructions})"
                ""
                "set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY${cacheInstructions})"
                ""
            )
        elseif("${os}" STREQUAL "Windows" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++")
            string(JOIN "\n" result
                "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})"
                "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})"
                ""
                "set(COMPILER_PATH \"${compilerDir}\"${cacheInstructions})"
                ""
                "set(CMAKE_C_COMPILER   \"\${COMPILER_PATH}/gcc.exe\"${cacheInstructions})"
                "set(CMAKE_CXX_COMPILER \"\${COMPILER_PATH}/g++.exe\"${cacheInstructions})"
                "set(CMAKE_AR           \"\${COMPILER_PATH}/ar.exe\"${cacheInstructions})"
                "set(CMAKE_LINKER       \"\${COMPILER_PATH}/ld.exe\"${cacheInstructions})"
                "set(CMAKE_RC_COMPILER  \"\${COMPILER_PATH}/windres.exe\"${cacheInstructions})"
                ""
                "set(ENV{PATH} \"${envPathNative}\")"
                ""
                "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY${cacheInstructions})"
                ""
            )
        elseif(("${os}" STREQUAL "Linux" OR "${os}" STREQUAL "Darwin") AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++")
            string(JOIN "\n" result
                "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})"
                "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})"
                ""
                "set(COMPILER_PATH \"${compilerDir}\"${cacheInstructions})"
                ""
                "set(CMAKE_C_COMPILER   \"\${COMPILER_PATH}/gcc\"${cacheInstructions})"
                "set(CMAKE_CXX_COMPILER \"\${COMPILER_PATH}/g++\"${cacheInstructions})"
                ""
                "set(ENV{PATH} \"${envPathNative}\")"
                ""
                "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY${cacheInstructions})"
                "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY${cacheInstructions})"
                ""
            )
        endif()

        if(NOT "${outputFile}" STREQUAL "" AND NOT EXISTS "${outputFile}")
            file(WRITE "${outputFile}" "${result}")
        endif()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_clang_toolchain var)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

        set(options)
        set(oneValueKeywords
            "PATH"
            "PROCESSOR"
            "OS"
            "TARGET"
            "OUTPUT_FILE"
            "NO_CACHE"
        )
        set(multiValueKeywords)
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        set(path "${${currentFunctionName}_PATH}")
        set(processor "${${currentFunctionName}_PROCESSOR}")
        set(os "${${currentFunctionName}_OS}")
        set(target "${${currentFunctionName}_TARGET}")
        set(outputFile "${${currentFunctionName}_OUTPUT_FILE}")
        set(noCache "${${currentFunctionName}_NO_CACHE}")

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

        string(JOIN "\n" result
            "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\"${cacheInstructions})"
            "set(CMAKE_SYSTEM_NAME \"${os}\"${cacheInstructions})"
            ""
            "set(COMPILER_PATH \"${compilerDir}\"${cacheInstructions})"
            ""
            "set(CMAKE_C_COMPILER          \"\${COMPILER_PATH}/clang.exe\"${cacheInstructions})"
            "set(CMAKE_C_COMPILER_TARGET   \"${target}\"${cacheInstructions})"
            "set(CMAKE_CXX_COMPILER        \"\${COMPILER_PATH}/clang++.exe\"${cacheInstructions})"
            "set(CMAKE_CXX_COMPILER_TARGET \"${target}\"${cacheInstructions})"
            ""
            "set(ENV{PATH} \"${envPathNative}\")"
            ""
            "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER${cacheInstructions})"
            "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY${cacheInstructions})"
            "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY${cacheInstructions})"
            "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY${cacheInstructions})"
            ""
        )

        if(NOT "${outputFile}" STREQUAL "" AND NOT EXISTS "${outputFile}")
            file(WRITE "${outputFile}" "${result}")
        endif()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_python_boolean var cmakeBoolean)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        if("${cmakeBoolean}")
            set(result "True")
        else()
            set(result "False")
        endif()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_architecture var cmakeSystemProcessor)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        if("x64" STREQUAL "${cmakeSystemProcessor}" OR "AMD64" STREQUAL "${cmakeSystemProcessor}" OR "IA64" STREQUAL "${cmakeSystemProcessor}")
            set(result "x86_64")
        elseif("x86" STREQUAL "${cmakeSystemProcessor}")
            set(result "x86")
        else()
            set(result "${cmakeSystemProcessor}")
        endif()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_compiler var cmakeCxxCompilerId)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        if("MSVC" STREQUAL "${cmakeCxxCompilerId}")
            set(result "Visual Studio")
        elseif("GNU" STREQUAL "${cmakeCxxCompilerId}")
            set(result "gcc")
        elseif("Clang" STREQUAL "${cmakeCxxCompilerId}")
            set(result "clang")
        else()
            set(result "${cmakeCxxCompilerId}")
        endif()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_compiler_version var cmakeCxxCompilerId cmakeCxxCompilerVersion)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

        set(options)
        set(oneValueKeywords
            "DELIMITER"
            "MAX_ELEMENTS"
        )
        set(multiValueKeywords)
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        if("${${currentFunctionName}_DELIMITER}" STREQUAL "")
            set(delimiter ".")
        else()
            set(delimiter "${${currentFunctionName}_DELIMITER}")
        endif()

        if("${${currentFunctionName}_MAX_ELEMENTS}" STREQUAL "")
            set(maxElements "-1")
        else()
            set(maxElements "${${currentFunctionName}_MAX_ELEMENTS}")
        endif()

        if("MSVC" STREQUAL "${cmakeCxxCompilerId}")
            if("${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "19.30" AND "${cmakeCxxCompilerVersion}" VERSION_LESS "19.40")
                set(result "17")
            elseif("${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "19.20" AND "${cmakeCxxCompilerVersion}" VERSION_LESS "19.30")
                set(result "16")
            elseif("${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "19.10" AND "${cmakeCxxCompilerVersion}" VERSION_LESS "19.20")
                set(result "15")
            else()
                set(result "${cmakeCxxCompilerVersion}")
            endif()
        else()
            string(REPLACE "${delimiter}" ";" cmakeCxxCompilerVersionElements "${cmakeCxxCompilerVersion}")
            list(LENGTH cmakeCxxCompilerVersionElements cmakeCxxCompilerVersionElementsLength)
            if("${maxElements}" GREATER "${cmakeCxxCompilerVersionElementsLength}")
                message(FATAL_ERROR "MAX_ELEMENTS: '${maxElements}' greater than cmakeCxxCompilerVersionElementsLength: '${cmakeCxxCompilerVersionElementsLength}'")
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
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_compiler_runtime var cmakeMsvcRuntimeLibrary)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        if("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreaded")
            set(result "MT")
        elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDLL")
            set(result "MD")
        elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDebug")
            set(result "MTd")
        elseif("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDebugDLL")
            set(result "MDd")
        else()
            set(result "${cmakeMsvcRuntimeLibrary}")
        endif()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_settings var)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
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
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_conan_options var)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
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
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_not_found_package_names var)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        if(NOT "" STREQUAL "${ARGN}")
            foreach(arg ${ARGN})
                if(NOT "${${arg}_FOUND}")
                    list(APPEND result "${arg}")
                endif()
            endforeach()
        endif()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(set_target_names var dir)
    set(result "")
    block(PROPAGATE result)
        foreach(i var dir)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
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
    endblock()
    set(${var} "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(generate_interface_only_files var)
    set(result "")
    block(PROPAGATE result)
        foreach(i var)
            if("" STREQUAL "${${i}}")
                message(FATAL_ERROR "Empty value not supported for '${i}'.")
            endif()
        endforeach()

        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

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
        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        set(srcDirectory "${${currentFunctionName}_SRC_DIRECTORY}")
        set(srcBaseDirectory "${${currentFunctionName}_SRC_BASE_DIRECTORY}")
        set(dstBaseDirectory "${${currentFunctionName}_DST_BASE_DIRECTORY}")
        set(headerFiles "${${currentFunctionName}_HEADER_FILES}")
        set(headerFilesExpressions "${${currentFunctionName}_HEADER_FILES_EXPRESSIONS}")
        set(sourceFiles "${${currentFunctionName}_SOURCE_FILES}")
        set(sourceFilesExpressions "${${currentFunctionName}_SOURCE_FILES_EXPRESSIONS}")
        set(headerSourceMaps "${${currentFunctionName}_HEADER_SOURCE_MAPS}")

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
            message(FATAL_ERROR "${message}")
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
            message(FATAL_ERROR "${message}")
        endif()

        foreach(map IN LISTS headerSourceMaps)
            string(FIND "${map}" ">" index)
            if("${index}" LESS "0")
                message(FATAL_ERROR "Invalid HEADER_SOURCE_MAP: '${map}' should contain '>'")
            endif()
            string(REPLACE ">" ";" parts "${map}")
            list(GET "parts" "0" key)
            list(GET "parts" "1" value)
            if("${key}" STREQUAL "" OR "${value}" STREQUAL "")
                message(FATAL_ERROR "Invalid HEADER_SOURCE_MAP: '${map}' key or value empty")
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
        foreach(header source IN ZIP_LISTS pairedHeaderFiles pairedSourceFiles)
            file(READ "${header}" headerContent)
            file(READ "${source}" sourceContent)

            string_replace_between(sourcePart1 "${sourceContent}" "\n" "namespace " BETWEEN_ONLY)
            substring_from(sourcePart2 "${sourceContent}" "namespace ")
            string(PREPEND sourcePart2 "namespace ")
            string(STRIP "${headerContent}" headerContent)
            string(STRIP "${sourcePart1}" sourcePart1)
            string(STRIP "${sourcePart2}" sourcePart2)
            set(newHeaderContent "")
            string(APPEND newHeaderContent "${headerContent}" "\n" "\n")
            if(NOT "" STREQUAL "${sourcePart1}")
                string(APPEND newHeaderContent "${sourcePart1}" "\n" "\n")
            endif()
            string(APPEND newHeaderContent "${sourcePart2}" "\n")
            cmake_path(RELATIVE_PATH header BASE_DIRECTORY "${srcBaseDirectory}" OUTPUT_VARIABLE newHeaderPath)
            set(newHeaderPath "${dstBaseDirectory}/${newHeaderPath}")
            cmake_path(RELATIVE_PATH newHeaderPath BASE_DIRECTORY "${srcDirectory}" OUTPUT_VARIABLE newHeaderRelativePath)

            file(WRITE "${newHeaderPath}" "${newHeaderContent}")

            if(NOT "${newHeaderRelativePath}" IN_LIST result)
                list(APPEND result "${newHeaderRelativePath}")
            endif()
        endforeach()
    endblock()
    set("${var}" "${result}" PARENT_SCOPE)
    unset(result)
endfunction()

function(doxygen)
    block()
        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")

        set(options)
        set(oneValueKeywords
            "VERBOSE"
            "CLEAN"
            "SOURCE_BASE_DIR"
            "SOURCE_DIR"
            "OUTPUT_DIR"
            "DOXYFILE"
        )
        set(multiValueKeywords
            "FILE_PATTERNS"
            "EXCLUDES"
        )

        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        if("${${currentFunctionName}_VERBOSE}")
            set(verbose "TRUE")
        else()
            set(verbose "FALSE")
        endif()

        if("${${currentFunctionName}_CLEAN}")
            set(clean "TRUE")
        else()
            set(clean "FALSE")
        endif()

        if("${${currentFunctionName}_SOURCE_BASE_DIR}" STREQUAL "")
            message(FATAL_ERROR "Not set SOURCE_BASE_DIR: '${${currentFunctionName}_SOURCE_BASE_DIR}'")
        elseif(NOT EXISTS "${${currentFunctionName}_SOURCE_BASE_DIR}")
            message(FATAL_ERROR "Not exists SOURCE_BASE_DIR: '${${currentFunctionName}_SOURCE_BASE_DIR}'")
        elseif(NOT IS_DIRECTORY "${${currentFunctionName}_SOURCE_BASE_DIR}")
            message(FATAL_ERROR "Not directory SOURCE_BASE_DIR: '${${currentFunctionName}_SOURCE_BASE_DIR}'")
        else()
            set(sourceBaseDir "${${currentFunctionName}_SOURCE_BASE_DIR}")
            cmake_path(APPEND sourceBaseDir "DIR")
            cmake_path(GET "sourceBaseDir" PARENT_PATH sourceBaseDir)
        endif()

        if("${${currentFunctionName}_SOURCE_DIR}" STREQUAL "")
            set(sourceDirRelative "src/main/cpp")
        else()
            set(sourceDirRelative "${${currentFunctionName}_SOURCE_DIR}")
            cmake_path(APPEND sourceDirRelative "DIR")
            cmake_path(GET "sourceDirRelative" PARENT_PATH sourceDirRelative)
        endif()

        if("${${currentFunctionName}_OUTPUT_DIR}" STREQUAL "")
            set(outputDirRelative "build/doxygen/main")
        else()
            set(outputDirRelative "${${currentFunctionName}_OUTPUT_DIR}")
            cmake_path(APPEND outputDirRelative "DIR")
            cmake_path(GET "outputDirRelative" PARENT_PATH outputDirRelative)
        endif()

        if("${${currentFunctionName}_DOXYFILE}" STREQUAL "")
            set(doxyFileRelative "${outputDirRelative}/Doxyfile")
        else()
            set(doxyFileRelative "${${currentFunctionName}_DOXYFILE}")
            cmake_path(APPEND doxyFileRelative "DIR")
            cmake_path(GET "doxyFileRelative" PARENT_PATH doxyFileRelative)
        endif()

        if("${${currentFunctionName}_FILE_PATTERNS}" STREQUAL "")
            set(filePatterns "*.h" "*.c" "*.hpp" "*.cpp")
        else()
            set(filePatterns "${${currentFunctionName}_FILE_PATTERNS}")
        endif()

        if("${${currentFunctionName}_EXCLUDES}" STREQUAL "")
            set(excludesRaw "")
        else()
            set(excludesRaw "")
            foreach(excludeRaw IN LISTS "${currentFunctionName}_EXCLUDES")
                cmake_path(APPEND excludeRaw "DIR")
                cmake_path(GET "excludeRaw" PARENT_PATH excludeRaw)
                list(APPEND excludesRaw "${excludeRaw}")
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
                string(JOIN "\n" doxygenFileContent
                    "PROJECT_NAME = \"${currentFunctionName}\""
                    "OUTPUT_DIRECTORY = \"${outputDirRelative}\""
                    "RECURSIVE = YES"
                    "INPUT = \"${sourceDirRelative}\""
                    "ENABLE_PREPROCESSING = YES"
                    "GENERATE_XML = YES"
                    "GENERATE_HTML = NO"
                    "GENERATE_LATEX = NO"
                    ""
                )
                if(NOT "${filePatterns}" STREQUAL "")
                    string(JOIN "\", \"" filePatternsContent ${filePatterns})
                    set(filePatternsContent "FILE_PATTERNS = \"${filePatternsContent}\"")
                    string(APPEND doxygenFileContent "${filePatternsContent}\n")
                endif()
                if(NOT "${excludesRaw}" STREQUAL "")
                    string(JOIN "\", \"" excludeContent ${excludesRaw})
                    set(excludeContent "EXCLUDE = \"${excludeContent}\"")
                    string(APPEND doxygenFileContent "${excludeContent}\n")
                endif()
                if(NOT "${verbose}")
                    string(APPEND doxygenFileContent "QUIET = YES\n")
                endif()
                file(WRITE "${sourceBaseDir}/${doxyFileRelative}" "${doxygenFileContent}")
            endif()

            find_program(DOXYGEN_COMMAND NAMES "doxygen.exe" "doxygen" PATHS ENV CONAN_PATH ENV PATH REQUIRED NO_CACHE NO_DEFAULT_PATH)
            file(MAKE_DIRECTORY "${sourceBaseDir}/${outputDirRelative}")
            execute_process(
                COMMAND "${DOXYGEN_COMMAND}" "${sourceBaseDir}/${doxyFileRelative}"
                WORKING_DIRECTORY "${sourceBaseDir}"
                COMMAND_ECHO "STDOUT"
                COMMAND_ERROR_IS_FATAL "ANY"
            )
            if("${verbose}")
                string(TIMESTAMP currentDateTime "%Y-%m-%d %H:%M:%S")
                message(STATUS "currentDateTime: '${currentDateTime}'")
            endif()
        endif()
    endblock()
endfunction()

function(sphinx)
    block()
        set(currentFunctionName "${CMAKE_CURRENT_FUNCTION}")
        string(JOIN "\n" requirementsFileContent
            "Sphinx==6.2.1"
            "linuxdoc==20230506"
            "breathe==4.35.0"
            "mlx.traceability==10.0.0"
            "docxbuilder==1.2.0"
            "rst2pdf==0.100"
            ""
        )

        set(options)
        set(oneValueKeywords
            "VERBOSE"
            "SSL"
            "WARNINGS_TO_ERRORS"
            "CLEAN"
            "TOCTREE_MAXDEPTH"
            "TOCTREE_CAPTION"
            "SOURCE_BASE_DIR"
            "SOURCE_DIR"
            "BUILD_DIR"
            "REQUIREMENTS_FILE"
            "ENV_DIR"
            "TITLE"
            "OUTPUT_DIR"
        )
        set(multiValueKeywords
            "FILES"
            "EXTRA_FILES"
            "ENV_VARS"
            "BUILDERS"
        )

        cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${${currentFunctionName}_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${${currentFunctionName}_UNPARSED_ARGUMENTS}'")
        endif()

        if("${${currentFunctionName}_VERBOSE}" STREQUAL "")
            set(verbose "FALSE")
        else()
            if("${${currentFunctionName}_VERBOSE}")
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

        if("${${currentFunctionName}_SSL}" STREQUAL "")
            set(ssl "TRUE")
        else()
            if("${${currentFunctionName}_SSL}")
                set(ssl "TRUE")
            else()
                set(ssl "FALSE")
            endif()
        endif()

        if("${${currentFunctionName}_WARNINGS_TO_ERRORS}" STREQUAL "")
            set(warningsToErrors "TRUE")
        else()
            if("${${currentFunctionName}_WARNINGS_TO_ERRORS}")
                set(warningsToErrors "TRUE")
            else()
                set(warningsToErrors "FALSE")
            endif()
        endif()

        if("${${currentFunctionName}_CLEAN}")
            set(clean "TRUE")
        else()
            set(clean "FALSE")
        endif()

        if("${${currentFunctionName}_TOCTREE_MAXDEPTH}" STREQUAL "")
            set(toctreeMaxdepth "2")
        else()
            set(toctreeMaxdepth "${${currentFunctionName}_TOCTREE_MAXDEPTH}")
        endif()

        if("${${currentFunctionName}_TOCTREE_CAPTION}" STREQUAL "")
            set(toctreeCaption "Contents:")
        else()
            set(toctreeCaption "${${currentFunctionName}_TOCTREE_CAPTION}")
        endif()

        if("${${currentFunctionName}_SOURCE_BASE_DIR}" STREQUAL "")
            message(FATAL_ERROR "Not set SOURCE_BASE_DIR: '${${currentFunctionName}_SOURCE_BASE_DIR}'")
        elseif(NOT EXISTS "${${currentFunctionName}_SOURCE_BASE_DIR}")
            message(FATAL_ERROR "Not exists SOURCE_BASE_DIR: '${${currentFunctionName}_SOURCE_BASE_DIR}'")
        elseif(NOT IS_DIRECTORY "${${currentFunctionName}_SOURCE_BASE_DIR}")
            message(FATAL_ERROR "Not directory SOURCE_BASE_DIR: '${${currentFunctionName}_SOURCE_BASE_DIR}'")
        else()
            set(sourceBaseDir "${${currentFunctionName}_SOURCE_BASE_DIR}")
            cmake_path(APPEND sourceBaseDir "DIR")
            cmake_path(GET "sourceBaseDir" PARENT_PATH sourceBaseDir)
        endif()

        if("${${currentFunctionName}_SOURCE_DIR}" STREQUAL "")
            set(sourceDirRelative "doc")
        else()
            set(sourceDirRelative "${${currentFunctionName}_SOURCE_DIR}")
            cmake_path(APPEND sourceDirRelative "DIR")
            cmake_path(GET "sourceDirRelative" PARENT_PATH sourceDirRelative)
        endif()

        if("${${currentFunctionName}_BUILD_DIR}" STREQUAL "")
            set(buildDirRelative "build/${currentFunctionName}")
        else()
            set(buildDirRelative "${${currentFunctionName}_BUILD_DIR}")
            cmake_path(APPEND buildDirRelative "DIR")
            cmake_path(GET "buildDirRelative" PARENT_PATH buildDirRelative)
        endif()

        if("${${currentFunctionName}_REQUIREMENTS_FILE}" STREQUAL "")
            set(requirementsFileRelative "${buildDirRelative}/requirements.txt")
        else()
            set(requirementsFileRelative "${${currentFunctionName}_REQUIREMENTS_FILE}")
            cmake_path(APPEND requirementsFileRelative "DIR")
            cmake_path(GET "requirementsFileRelative" PARENT_PATH requirementsFileRelative)
        endif()

        if("${${currentFunctionName}_ENV_DIR}" STREQUAL "")
            set(envDirRelative "${buildDirRelative}/py-env")
        else()
            set(envDirRelative "${${currentFunctionName}_ENV_DIR}")
            cmake_path(APPEND envDirRelative "DIR")
            cmake_path(GET "envDirRelative" PARENT_PATH envDirRelative)
        endif()

        if("${${currentFunctionName}_TITLE}" STREQUAL "")
            set(title "documentation")
            set(titleFileName "${title}")
        else()
            set(title "${${currentFunctionName}_TITLE}")
            string(REPLACE " " "_" titleFileName "${title}")
        endif()

        if("${${currentFunctionName}_OUTPUT_DIR}" STREQUAL "")
            set(outputDirRelative "build/doc/${titleFileName}")
        else()
            set(outputDirRelative "${${currentFunctionName}_OUTPUT_DIR}")
            cmake_path(APPEND outputDirRelative "DIR")
            cmake_path(GET "outputDirRelative" PARENT_PATH outputDirRelative)
        endif()

        if("${${currentFunctionName}_BUILDERS}" STREQUAL "")
            set(builders "html" "docx" "pdf")
        else()
            set(builders "${${currentFunctionName}_BUILDERS}")
        endif()

        if("${${currentFunctionName}_FILES}" STREQUAL "")
            set(files "")
        else()
            set(files "")
            foreach(file IN LISTS "${currentFunctionName}_FILES")
                set(fileRelative "${file}")
                cmake_path(APPEND fileRelative "DIR")
                cmake_path(GET "fileRelative" PARENT_PATH fileRelative)
                list(APPEND files "${fileRelative}")
            endforeach()
        endif()

        if("${${currentFunctionName}_EXTRA_FILES}" STREQUAL "")
            set(extraFiles "")
        else()
            set(extraFiles "${${currentFunctionName}_EXTRA_FILES}")
        endif()

        if("${${currentFunctionName}_ENV_VARS}" STREQUAL "")
            set(envVars "")
        else()
            set(envVars "${${currentFunctionName}_ENV_VARS}")
        endif()

        find_program(SPHINX_BUILD_COMMAND
            NAMES "sphinx-build.exe" "sphinx-build"
            PATHS "${sourceBaseDir}/${envDirRelative}/Scripts"
                  "${sourceBaseDir}/${envDirRelative}/bin"
            NO_CACHE
            NO_DEFAULT_PATH
        )

        # create sphinx env
        if("${SPHINX_BUILD_COMMAND}" STREQUAL "SPHINX_BUILD_COMMAND-NOTFOUND")
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
            find_program(SPHINX_BUILD_COMMAND
                NAMES "sphinx-build.exe" "sphinx-build"
                PATHS "${sourceBaseDir}/${envDirRelative}/Scripts"
                      "${sourceBaseDir}/${envDirRelative}/bin"
                NO_CACHE
                REQUIRED
                NO_DEFAULT_PATH
            )
        endif()

        # create structure
        if("${verbose}")
            message(STATUS "create structure")
        endif()
        if(EXISTS "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}")
            file(REMOVE_RECURSE "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}")
        endif()
        string(JOIN "\n" indexRstContent
            ".. toctree::"
            "   :maxdepth: ${toctreeMaxdepth}"
            "   :caption: ${toctreeCaption}"
            ""
            ""
        )
        foreach(file IN LISTS "files")
            cmake_path(GET "file" PARENT_PATH fileDir)
            cmake_path(GET "file" FILENAME fileName)
            cmake_path(GET "fileName" STEM fileNameNoExt)
            if("${fileDir}" STREQUAL "")
                string(APPEND indexRstContent "   ${fileNameNoExt}" "\n")
                file(COPY "${sourceBaseDir}/${sourceDirRelative}/${file}" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}")
            else()
                string(APPEND indexRstContent "   ${fileDir}/${fileNameNoExt}" "\n")
                file(MAKE_DIRECTORY "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}/${fileDir}")
                file(COPY "${sourceBaseDir}/${sourceDirRelative}/${file}" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}/${fileDir}")
            endif()
        endforeach()
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
                file(COPY "${fileSrc}" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}")
            else()
                file(MAKE_DIRECTORY "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}/${fileDir}")
                file(COPY "${fileSrc}" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}/${fileDir}")
            endif()

        endforeach()
        file(WRITE "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}/index.rst" "${indexRstContent}")
        file(COPY "${sourceBaseDir}/${sourceDirRelative}/conf.py" DESTINATION "${sourceBaseDir}/${buildDirRelative}/${sourceDirRelative}/${titleFileName}")

        foreach(builder IN LISTS "builders")

            # build
            if("${verbose}")
                message(STATUS "build ${builder}")
            endif()
            if("${clean}" AND EXISTS "${sourceBaseDir}/${outputDirRelative}/${builder}")
                file(REMOVE_RECURSE "${sourceBaseDir}/${outputDirRelative}/${builder}")
            endif()
            set(flags "")
            if("${verbose}")
                list(APPEND flags "-v" "-v" "-v")
            else()
                if("${warningsToErrors}")
                    list(APPEND flags "-q")
                else()
                    list(APPEND flags "-Q")
                endif()
            endif()
            if("${warningsToErrors}")
                list(APPEND "flags" "-W")
            endif()
            list(APPEND "flags"
                "-E"
            )
            execute_process(
                COMMAND "${CMAKE_COMMAND}"
                        "-E"
                        "env"
                        ${envVars}
                        "--"
                        "${SPHINX_BUILD_COMMAND}"
                        ${flags}
                        "-b"
                        "${builder}"
                        "${buildDirRelative}/${sourceDirRelative}/${titleFileName}"
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
    endblock()
endfunction()

block()
    if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
        set(args "")
        set(argsStarted "FALSE")
        math(EXPR argIndexMax "${CMAKE_ARGC} - 1")
        foreach(i RANGE "0" "${argIndexMax}")
            if("${argsStarted}")
                list(APPEND args "${CMAKE_ARGV${i}}")
            elseif(NOT "${argsStarted}" AND "${CMAKE_ARGV${i}}" STREQUAL "--")
                set(argsStarted "TRUE")
            endif()
        endforeach()
        list(POP_FRONT args func)
        cmake_language(EVAL CODE "${func}(${args})")
    endif()
endblock()

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
endif()
