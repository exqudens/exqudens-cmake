cmake_policy(PUSH)
cmake_policy(SET CMP0054 NEW)
cmake_policy(PUSH)
cmake_policy(SET CMP0007 NEW)
cmake_policy(PUSH)
cmake_policy(SET CMP0012 NEW)
cmake_policy(PUSH)
cmake_policy(SET CMP0057 NEW)

function(set_if_not_defined var)
    set(result "")
    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
        endif()
    endforeach()
    if("" STREQUAL "${${var}}" AND NOT "" STREQUAL "${ARGN}")
        set(result "${ARGN}")
        set("${var}" "${result}" PARENT_SCOPE)
    endif()
endfunction()

function(substring_from var input fromExclusive)
    set(result "")
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
    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(substring_to var input toExclusive)
    set(result "")
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
    set("${var}" "${result}" PARENT_SCOPE)
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

    set(options
        "RESULT_ONLY"
        "REPLACED_ONLY"
        "BETWEEN_ONLY"
    )
    set(oneValueKeywords
        "WITH"
    )
    set(multiValueKeywords)
    cmake_parse_arguments("string_replace_between" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${string_replace_between_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${string_replace_between_UNPARSED_ARGUMENTS}'")
    endif()

    if("" STREQUAL "${string_replace_between_WITH}")
        set(value "")
    else()
        set(value "${string_replace_between_WITH}")
    endif()

    if("${string_replace_between_REPLACED_ONLY}")
        substring_from(resultBetween "${input}" "${fromExclusive}")
        substring_to(resultBetween "${resultBetween}" "${toExclusive}")

        string(CONCAT resultReplaced "${fromExclusive}" "${resultBetween}" "${toExclusive}")

        set("${prefix}" "${resultReplaced}" PARENT_SCOPE)
    elseif("${string_replace_between_BETWEEN_ONLY}")
        substring_from(resultBetween "${input}" "${fromExclusive}")
        substring_to(resultBetween "${resultBetween}" "${toExclusive}")

        set("${prefix}" "${resultBetween}" PARENT_SCOPE)
    else()
        if("${string_replace_between_RESULT_ONLY}")
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
endfunction()

function(find_file_in_parent prefix)
    set(result "")
    set(resultDir "")
    foreach(i prefix)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
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
    cmake_parse_arguments("find_file_in_parent" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${find_file_in_parent_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${find_file_in_parent_UNPARSED_ARGUMENTS}'")
    endif()

    set(required "${find_file_in_parent_REQUIRED}")
    set(maxParentLevel "${find_file_in_parent_MAX_PARENT_LEVEL}")
    set(paths "${find_file_in_parent_PATHS}")
    set(names "${find_file_in_parent_NAMES}")

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

    set("${prefix}_FILE" "${result}" PARENT_SCOPE)
    set("${prefix}_DIR" "${resultDir}" PARENT_SCOPE)
endfunction()

function(find_file_in prefix)
    set(result "")
    set(resultDir "")
    foreach(i prefix)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
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
    cmake_parse_arguments("find_file_in" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${find_file_in_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${find_file_in_UNPARSED_ARGUMENTS}'")
    endif()

    set(required "${find_file_in_REQUIRED}")
    set(paths "${find_file_in_PATHS}")
    set(names "${find_file_in_NAMES}")

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

    set("${prefix}_FILE" "${result}" PARENT_SCOPE)
    set("${prefix}_DIR" "${resultDir}" PARENT_SCOPE)
endfunction()

function(set_msvc_path var)
    set(result "")
    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
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
    cmake_parse_arguments("set_msvc_path" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${set_msvc_path_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${set_msvc_path_UNPARSED_ARGUMENTS}'")
    endif()

    set(command "${set_msvc_path_COMMAND}")
    set(version "${set_msvc_path_VERSION}")
    set(property "${set_msvc_path_PROPERTY}")
    set(products "${set_msvc_path_PRODUCTS}")

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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_msvc_env prefix)
    set(resultMsvcInclude "")
    set(resultMsvcLibPath "")
    set(resultMsvcLib "")
    set(resultMsvcClPath "")
    set(resultMsvcRcPath "")
    foreach(i prefix)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
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
    cmake_parse_arguments("set_msvc_env" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${set_msvc_env_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${set_msvc_env_UNPARSED_ARGUMENTS}'")
    endif()

    set(command "${set_msvc_env_COMMAND}")
    set(version "${set_msvc_env_VERSION}")
    set(property "${set_msvc_env_PROPERTY}")
    set(host "${set_msvc_env_HOST}")
    set(target "${set_msvc_env_TARGET}")
    set(path "${set_msvc_env_PATH}")
    set(products "${set_msvc_env_PRODUCTS}")

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

    set("${prefix}_MSVC_INCLUDE" "${resultMsvcInclude}" PARENT_SCOPE)
    set("${prefix}_MSVC_LIBPATH" "${resultMsvcLibPath}" PARENT_SCOPE)
    set("${prefix}_MSVC_LIB" "${resultMsvcLib}" PARENT_SCOPE)
    set("${prefix}_MSVC_CL_PATH" "${resultMsvcClPath}" PARENT_SCOPE)
    set("${prefix}_MSVC_RC_PATH" "${resultMsvcRcPath}" PARENT_SCOPE)
endfunction()

function(set_msvc_toolchain_content var)
    set(result "")
    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
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
    )
    set(multiValueKeywords
        "PRODUCTS"
    )
    cmake_parse_arguments("set_msvc_toolchain_content" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${set_msvc_toolchain_content_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${set_msvc_toolchain_content_UNPARSED_ARGUMENTS}'")
    endif()

    set(command "${set_msvc_toolchain_content_COMMAND}")
    set(version "${set_msvc_toolchain_content_VERSION}")
    set(property "${set_msvc_toolchain_content_PROPERTY}")
    set(host "${set_msvc_toolchain_content_HOST}")
    set(target "${set_msvc_toolchain_content_TARGET}")
    set(path "${set_msvc_toolchain_content_PATH}")
    set(processor "${set_msvc_toolchain_content_PROCESSOR}")
    set(os "${set_msvc_toolchain_content_OS}")
    set(products "${set_msvc_toolchain_content_PRODUCTS}")

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
        "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\")"
        "set(CMAKE_SYSTEM_NAME \"${os}\")"
        ""
        "set(MSVC_CL_PATH \"${func_cl_cmake}\")"
        "set(MSVC_RC_PATH \"${func_rc_cmake}\")"
        ""
        "set(CMAKE_C_COMPILER   \"\${MSVC_CL_PATH}/cl.exe\")"
        "set(CMAKE_CXX_COMPILER \"\${MSVC_CL_PATH}/cl.exe\")"
        "set(CMAKE_AR           \"\${MSVC_CL_PATH}/lib.exe\")"
        "set(CMAKE_LINKER       \"\${MSVC_CL_PATH}/link.exe\")"
        "set(CMAKE_RC_COMPILER  \"\${MSVC_RC_PATH}/rc.exe\")"
        "set(CMAKE_MT           \"\${MSVC_RC_PATH}/mt.exe\")"
        ""
        "set(ENV{INCLUDE} \"${func_include}\")"
        "set(ENV{LIBPATH} \"${func_libpath}\")"
        "set(ENV{LIB} \"${func_lib}\")"
        "set(ENV{PATH} \"${func_path}\")"
        ""
        "set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES \"${func_include_cmake}\")"
        "set(CMAKE_C_STANDARD_LINK_DIRECTORIES \"${func_libpath_cmake}\")"
        ""
        "set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES \"${func_cmake_include}\")"
        "set(CMAKE_CXX_STANDARD_LINK_DIRECTORIES \"${func_cmake_libpath}\")"
        ""
        "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)"
        ""
        "link_directories(\"\${CMAKE_CXX_STANDARD_LINK_DIRECTORIES}\") # remove when CMAKE_CXX_STANDARD_LINK_DIRECTORIES is supported"
        ""
    )
    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_gnu_toolchain_content var)
    set(result "")
    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "PATH"
        "PROCESSOR"
        "OS"
    )
    set(multiValueKeywords)
    cmake_parse_arguments("set_gnu_toolchain_content" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${set_gnu_toolchain_content_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${set_gnu_toolchain_content_UNPARSED_ARGUMENTS}'")
    endif()

    set(path "${set_gnu_toolchain_content_PATH}")
    set(processor "${set_gnu_toolchain_content_PROCESSOR}")
    set(os "${set_gnu_toolchain_content_OS}")

    cmake_path(CONVERT "${path}" TO_CMAKE_PATH_LIST path NORMALIZE)
    get_filename_component(compilerFileNameNoExt "${path}" NAME_WE)
    get_filename_component(compilerDir "${path}" DIRECTORY)

    set(envPath "${compilerDir}")
    list(APPEND envPath "\$ENV{PATH}")
    list(FILTER envPath EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES envPath)
    cmake_path(CONVERT "${envPath}" TO_NATIVE_PATH_LIST envPathNative NORMALIZE)

    string(REPLACE "\\" "\\\\" envPathNative "${envPathNative}")

    if("${os}" STREQUAL "Windows" AND ("${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" OR "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++"))
        string(JOIN "\n" result
            "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\")"
            "set(CMAKE_SYSTEM_NAME \"${os}\")"
            ""
            "set(COMPILER_PATH \"${compilerDir}\")"
            ""
            "set(CMAKE_C_COMPILER   \"\${COMPILER_PATH}/arm-none-eabi-gcc.exe\")"
            "set(CMAKE_CXX_COMPILER \"\${COMPILER_PATH}/arm-none-eabi-g++.exe\")"
            "set(CMAKE_ASM_COMPILER \"\${COMPILER_PATH}/arm-none-eabi-gcc.exe\")"
            "set(CMAKE_SIZE         \"\${COMPILER_PATH}/arm-none-eabi-size.exe\")"
            ""
            "set(ENV{PATH} \"${envPathNative}\")"
            ""
            "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)"
            ""
            "set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)"
            ""
        )
    elseif("${os}" STREQUAL "Windows" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++")
        string(JOIN "\n" result
            "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\")"
            "set(CMAKE_SYSTEM_NAME \"${os}\")"
            ""
            "set(COMPILER_PATH \"${compilerDir}\")"
            ""
            "set(CMAKE_C_COMPILER   \"\${COMPILER_PATH}/gcc.exe\")"
            "set(CMAKE_CXX_COMPILER \"\${COMPILER_PATH}/g++.exe\")"
            "set(CMAKE_AR           \"\${COMPILER_PATH}/ar.exe\")"
            "set(CMAKE_LINKER       \"\${COMPILER_PATH}/ld.exe\")"
            "set(CMAKE_RC_COMPILER  \"\${COMPILER_PATH}/windres.exe\")"
            ""
            "set(ENV{PATH} \"${envPathNative}\")"
            ""
            "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)"
            ""
        )
    elseif("${os}" STREQUAL "Linux" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-gcc" AND NOT "${compilerFileNameNoExt}" STREQUAL "arm-none-eabi-g++")
        string(JOIN "\n" result
            "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\")"
            "set(CMAKE_SYSTEM_NAME \"${os}\")"
            ""
            "set(COMPILER_PATH \"${compilerDir}\")"
            ""
            "set(CMAKE_C_COMPILER   \"\${COMPILER_PATH}/gcc\")"
            "set(CMAKE_CXX_COMPILER \"\${COMPILER_PATH}/g++\")"
            ""
            "set(ENV{PATH} \"${envPathNative}\")"
            ""
            "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)"
            "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)"
            ""
        )
    endif()
    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_clang_toolchain_content var)
    set(result "")
    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "PATH"
        "PROCESSOR"
        "OS"
        "TARGET"
    )
    set(multiValueKeywords)
    cmake_parse_arguments("set_clang_toolchain_content" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${set_clang_toolchain_content_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${set_clang_toolchain_content_UNPARSED_ARGUMENTS}'")
    endif()

    set(path "${set_clang_toolchain_content_PATH}")
    set(processor "${set_clang_toolchain_content_PROCESSOR}")
    set(os "${set_clang_toolchain_content_OS}")
    set(target "${set_clang_toolchain_content_TARGET}")

    cmake_path(CONVERT "${path}" TO_CMAKE_PATH_LIST path NORMALIZE)

    get_filename_component(compilerDir "${path}" DIRECTORY)

    set(envPath "${compilerDir}")
    list(APPEND envPath "\$ENV{PATH}")
    list(FILTER envPath EXCLUDE REGEX "^$")
    list(REMOVE_DUPLICATES envPath)
    cmake_path(CONVERT "${envPath}" TO_NATIVE_PATH_LIST envPathNative NORMALIZE)

    string(REPLACE "\\" "\\\\" envPathNative "${envPathNative}")

    string(JOIN "\n" result
        "set(CMAKE_SYSTEM_PROCESSOR \"${processor}\")"
        "set(CMAKE_SYSTEM_NAME \"${os}\")"
        ""
        "set(COMPILER_PATH \"${compilerDir}\")"
        ""
        "set(CMAKE_C_COMPILER          \"\${COMPILER_PATH}/clang.exe\")"
        "set(CMAKE_C_COMPILER_TARGET   \"${target}\")"
        "set(CMAKE_CXX_COMPILER        \"\${COMPILER_PATH}/clang++.exe\")"
        "set(CMAKE_CXX_COMPILER_TARGET \"${target}\")"
        ""
        "set(ENV{PATH} \"${envPathNative}\")"
        ""
        "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)"
        "set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)"
        ""
    )
    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_conan_architecture var cmakeSystemProcessor)
    set(result "")
    foreach(i var cmakeSystemProcessor)
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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_conan_compiler var cmakeCxxCompilerId)
    set(result "")
    foreach(i var cmakeCxxCompilerId)
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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_conan_compiler_version var cmakeCxxCompilerId cmakeCxxCompilerVersion)
    set(result "")
    foreach(i var cmakeCxxCompilerId cmakeCxxCompilerVersion)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
        endif()
    endforeach()

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
    elseif("GNU" STREQUAL "${cmakeCxxCompilerId}")
        string(REPLACE "." ";" cmakeCxxCompilerVersionElements "${cmakeCxxCompilerVersion}")
        list(LENGTH cmakeCxxCompilerVersionElements cmakeCxxCompilerVersionElementsLength)
        set(majorVersion "0")
        set(minorVersion "0")
        set(patchVersion "0")
        if("${cmakeCxxCompilerVersionElementsLength}" GREATER_EQUAL "3")
            list(GET cmakeCxxCompilerVersionElements 0 majorVersion)
            list(GET cmakeCxxCompilerVersionElements 1 minorVersion)
            list(GET cmakeCxxCompilerVersionElements 2 patchVersion)
        elseif("${cmakeCxxCompilerVersionElementsLength}" EQUAL "2")
            list(GET cmakeCxxCompilerVersionElements 0 majorVersion)
            list(GET cmakeCxxCompilerVersionElements 1 minorVersion)
        elseif("${cmakeCxxCompilerVersionElementsLength}" EQUAL "1")
            list(GET cmakeCxxCompilerVersionElements 0 majorVersion)
        endif()
        if("${minorVersion}" EQUAL "0" AND "${patchVersion}" EQUAL "0")
            set(result "${majorVersion}")
        elseif(NOT "${minorVersion}" EQUAL "0" AND "${patchVersion}" EQUAL "0")
            set(result "${majorVersion}.${minorVersion}")
        else()
            set(result "${cmakeCxxCompilerVersion}")
        endif()
    elseif("Clang" STREQUAL "${cmakeCxxCompilerId}")
        string(REPLACE "." ";" cmakeCxxCompilerVersionElements "${cmakeCxxCompilerVersion}")
        list(LENGTH cmakeCxxCompilerVersionElements cmakeCxxCompilerVersionElementsLength)
        set(majorVersion "0")
        set(minorVersion "0")
        set(patchVersion "0")
        if("${cmakeCxxCompilerVersionElementsLength}" GREATER_EQUAL "3")
            list(GET cmakeCxxCompilerVersionElements 0 majorVersion)
            list(GET cmakeCxxCompilerVersionElements 1 minorVersion)
            list(GET cmakeCxxCompilerVersionElements 2 patchVersion)
        elseif("${cmakeCxxCompilerVersionElementsLength}" EQUAL "2")
            list(GET cmakeCxxCompilerVersionElements 0 majorVersion)
            list(GET cmakeCxxCompilerVersionElements 1 minorVersion)
        elseif("${cmakeCxxCompilerVersionElementsLength}" EQUAL "1")
            list(GET cmakeCxxCompilerVersionElements 0 majorVersion)
        endif()
        if("${minorVersion}" EQUAL "0" AND "${patchVersion}" EQUAL "0")
            set(result "${majorVersion}")
        elseif(NOT "${minorVersion}" EQUAL "0" AND "${patchVersion}" EQUAL "0")
            set(result "${majorVersion}.${minorVersion}")
        else()
            set(result "${cmakeCxxCompilerVersion}")
        endif()
    else()
        set(result "${cmakeCxxCompilerVersion}")
    endif()

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_conan_compiler_runtime var cmakeMsvcRuntimeLibrary)
    set(result "")
    foreach(i var cmakeMsvcRuntimeLibrary)
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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_conan_settings var)
    set(result "")
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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_python_boolean var cmakeBoolean)
    set(result "")
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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_conan_options var)
    set(result "")
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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_not_found_package_names var)
    set(result "")
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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(set_target_names var dir)
    foreach(i var dir)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
        endif()
    endforeach()

    get_property(subdirectories DIRECTORY "${dir}" PROPERTY SUBDIRECTORIES)
    foreach(subdir ${subdirectories})
        set_target_names(subTargets "${subdir}")
    endforeach()
    if(NOT "${subTargets}" STREQUAL "")
        list(APPEND targets "${subTargets}")
    endif()
    get_property(currentTargets DIRECTORY "${dir}" PROPERTY BUILDSYSTEM_TARGETS)
    if(NOT "${currentTargets}" STREQUAL "")
        list(APPEND targets "${currentTargets}")
    endif()
    list(APPEND targets
        "all"
        "help"
        "clean"
        "test"
        "install"
        "package"
        "package_source"
    )
    set(${var} "${targets}" PARENT_SCOPE)
endfunction()

function(generate_interface_only_files var)
    set(result "")
    foreach(i var)
        if("" STREQUAL "${${i}}")
            message(FATAL_ERROR "Empty value not supported for '${i}'.")
        endif()
    endforeach()

    set(options)
    set(oneValueKeywords
        "SRC_DIRECTORY"
        "SRC_BASE_DIRECTORY"
        "DST_BASE_DIRECTORY"
        "HEADER_FILES_EXPRESSION"
        "SOURCE_FILES_EXPRESSION"
    )
    set(multiValueKeywords)
    cmake_parse_arguments("generate_interface_only_files" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${generate_interface_only_files_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${generate_interface_only_files_UNPARSED_ARGUMENTS}'")
    endif()

    set(srcDirectory "${generate_interface_only_files_SRC_DIRECTORY}")
    set(srcBaseDirectory "${generate_interface_only_files_SRC_BASE_DIRECTORY}")
    set(dstBaseDirectory "${generate_interface_only_files_DST_BASE_DIRECTORY}")
    set(headerFilesExpression "${generate_interface_only_files_HEADER_FILES_EXPRESSION}")
    set(sourceFilesExpression "${generate_interface_only_files_SOURCE_FILES_EXPRESSION}")

    if(
        "${srcDirectory}" STREQUAL ""
        OR "${srcBaseDirectory}" STREQUAL ""
        OR "${dstBaseDirectory}" STREQUAL ""
        OR "${headerFilesExpression}" STREQUAL ""
        OR "${sourceFilesExpression}" STREQUAL ""
    )
        string(JOIN " " message
            "Invalid set of arguments:"
            "srcDirectory: '${srcDirectory}'"
            "srcBaseDirectory: '${srcBaseDirectory}'"
            "dstBaseDirectory: '${dstBaseDirectory}'"
            "headerFilesExpression: '${headerFilesExpression}'"
            "sourceFilesExpression: '${sourceFilesExpression}'"
        )
        message(FATAL_ERROR "${message}")
    endif()

    cmake_path(RELATIVE_PATH dstBaseDirectory BASE_DIRECTORY "${srcDirectory}" OUTPUT_VARIABLE dstRelativePath)

    file(GLOB_RECURSE headerFiles "${srcBaseDirectory}/${headerFilesExpression}")
    file(GLOB_RECURSE sourceFiles "${srcBaseDirectory}/${sourceFilesExpression}")

    list(SORT headerFiles)
    list(SORT sourceFiles)
    set(singleHeaderFiles "")
    set(pairedHeaderFiles "")
    set(pairedSourceFiles "")
    set(result "")
    foreach(header ${headerFiles})
        set(singleHeader "TRUE")
        get_filename_component(headerFileDir "${header}" DIRECTORY)
        get_filename_component(headerFileName "${header}" NAME_WE)
        foreach(source ${sourceFiles})
            get_filename_component(sourceFileDir "${source}" DIRECTORY)
            get_filename_component(sourceFileName "${source}" NAME_WE)
            if("${headerFileDir}" STREQUAL "${sourceFileDir}" AND "${headerFileName}" STREQUAL "${sourceFileName}")
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
    foreach(header ${singleHeaderFiles})
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

    set("${var}" "${result}" PARENT_SCOPE)
endfunction()

function(execute_script)
    set(result "")
    set(options
        "help"
        "toolchain"
    )
    set(oneValueKeywords
        "processor"
        "os"
        "compiler"
        "version"
        "host"
        "target"
        "path"
        "file"
    )
    set(multiValueKeywords
        "products"
    )
    cmake_parse_arguments("execute_script" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(
        "${execute_script_toolchain}"
        AND "${execute_script_compiler}" STREQUAL "msvc"
        AND (NOT "${execute_script_path}" STREQUAL "" AND EXISTS "${execute_script_path}" AND NOT IS_DIRECTORY "${execute_script_path}")
    )
        set_msvc_toolchain_content(result
            PROCESSOR "${execute_script_processor}"
            OS "${execute_script_os}"
            PATH "${execute_script_path}"
        )
        file(WRITE "${execute_script_file}" "${result}")
        return()
    elseif(
        "${execute_script_toolchain}"
        AND "${execute_script_compiler}" STREQUAL "msvc"
        AND "${execute_script_path}" STREQUAL ""
        AND NOT "${execute_script_version}" STREQUAL ""
        AND NOT "${execute_script_host}" STREQUAL ""
        AND NOT "${execute_script_target}" STREQUAL ""
    )
        set_msvc_toolchain_content(result
            PROCESSOR "${execute_script_processor}"
            OS "${execute_script_os}"
            VERSION "${execute_script_version}"
            HOST "${execute_script_host}"
            TARGET "${execute_script_target}"
            PRODUCTS "${execute_script_products}"
        )
        file(WRITE "${execute_script_file}" "${result}")
        return()
    elseif(
        "${execute_script_toolchain}"
        AND "${execute_script_compiler}" STREQUAL "gnu"
        AND (NOT "${execute_script_path}" STREQUAL "" AND EXISTS "${execute_script_path}" AND NOT IS_DIRECTORY "${execute_script_path}")
    )
        set_gnu_toolchain_content(result
            PROCESSOR "${execute_script_processor}"
            OS "${execute_script_os}"
            PATH "${execute_script_path}"
        )
        file(WRITE "${execute_script_file}" "${result}")
        return()
    elseif(
        "${execute_script_toolchain}"
        AND "${execute_script_compiler}" STREQUAL "clang"
        AND (NOT "${execute_script_path}" STREQUAL "" AND EXISTS "${execute_script_path}" AND NOT IS_DIRECTORY "${execute_script_path}")
        AND NOT "${execute_script_target}" STREQUAL ""
    )
        set_clang_toolchain_content(result
            PROCESSOR "${execute_script_processor}"
            OS "${execute_script_os}"
            PATH "${execute_script_path}"
            TARGET "${execute_script_target}"
        )
        file(WRITE "${execute_script_file}" "${result}")
        return()
    elseif("${execute_script_help}")
        get_filename_component(execute_script_current_file_name "${CMAKE_CURRENT_LIST_FILE}" NAME)

        string(JOIN " " execute_script_usage_1 "cmake" "-P" "${execute_script_current_file_name}" "help")
        string(JOIN " " execute_script_usage_2 "cmake" "-P" "${execute_script_current_file_name}" "toolchain"
            "processor" "'<value>'"
            "os" "'Windows'"
            "compiler" "'msvc'"
            "version" "'16 (i.e. Visual Studio 2019)|17 (i.e. Visual Studio 2022)'"
            "host" "'x86|x64'"
            "target" "'x86|x64'"
            "["
                "products"
                    "Microsoft.VisualStudio.Product.Enterprise"
                    "|"
                    "Microsoft.VisualStudio.Product.Professional"
                    "|"
                    "Microsoft.VisualStudio.Product.Community"
                    "|"
                    "Microsoft.VisualStudio.Product.BuildTools"
            "]"
            "file" "'toolchain.cmake|build/toolchain.cmake'"
        )
        string(JOIN " " execute_script_usage_3 "cmake" "-P" "${execute_script_current_file_name}" "toolchain"
            "processor" "'<value>'"
            "os" "'Windows'"
            "compiler" "'msvc|gnu'"
            "path" "'path/to/cl.exe|path/to/gcc.exe'"
            "file" "'toolchain.cmake|build/toolchain.cmake'"
        )
        string(JOIN " " execute_script_usage_4 "cmake" "-P" "${execute_script_current_file_name}" "toolchain"
            "processor" "'<value>'"
            "os" "'Windows'"
            "compiler" "'clang'"
            "path" "'path/to/clang.exe'"
            "target" "'x86_64-pc-windows-msvc'"
            "file" "'toolchain.cmake|build/toolchain.cmake'"
        )

        string(JOIN "\n" execute_script_content
            "Usage:"
            "  ${execute_script_usage_1}"
            "  ${execute_script_usage_2}"
            "  ${execute_script_usage_3}"
            "  ${execute_script_usage_4}"
        )
        message("${execute_script_content}")
    endif()
endfunction()

math(EXPR MAX "${CMAKE_ARGC} - 1")
foreach(i RANGE "${MAX}")
    list(APPEND ARGS "${CMAKE_ARGV${i}}")
endforeach()
execute_script("${ARGS}")

cmake_policy(POP)
cmake_policy(POP)
cmake_policy(POP)
cmake_policy(POP)
