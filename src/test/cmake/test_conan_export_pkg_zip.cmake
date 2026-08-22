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

include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(list_functions)
    message("test_1")
endfunction()

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    cmake_path(CONVERT "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}" TO_CMAKE_PATH_LIST currentOutputDir NORMALIZE)
    if(EXISTS "${currentOutputDir}")
        file(REMOVE_RECURSE "${currentOutputDir}")
    endif()
    file(MAKE_DIRECTORY "${currentOutputDir}")

    string(TIMESTAMP currentTimestamp)
    set(expected "${currentTimestamp} Test.")

    file(MAKE_DIRECTORY "${currentOutputDir}/package")
    file(WRITE "${currentOutputDir}/package/1.txt" "${expected}")
    file(ARCHIVE_CREATE OUTPUT "${currentOutputDir}/package.zip" PATHS "${currentOutputDir}/package/1.txt" FORMAT "zip" WORKING_DIRECTORY "${currentOutputDir}/package")
    file("MD5" "${currentOutputDir}/package.zip" currentMd5)
    file(MAKE_DIRECTORY "${currentOutputDir}/build")
    set(currentName "exqudens-cmake-test-package")
    set(currentVersion "1.0.0")
    set(currentUser "exqudens")
    set(currentChannel "development")
    find_program(conanCommand NAMES "conan.exe" "conan" PATHS ENV CONAN_PATH ENV PATH REQUIRED NO_CACHE NO_DEFAULT_PATH)
    conan_export_pkg_zip(
        SOURCE_DIR "${currentOutputDir}"
        BINARY_DIR "${currentOutputDir}/build"

        ZIP_FILE_URL "file:///${currentOutputDir}/package.zip"
        EXPECTED_MD5 "${currentMd5}"
        CHECK_FILE "1.txt"
        NAME "${currentName}"
        VERSION "${currentVersion}"
        USER "${currentUser}"
        CHANNEL "${currentChannel}"
        CONAN_COMMAND "${conanCommand}"
    )
    execute_process(
        COMMAND "${conanCommand}" "install"
                "--tool-requires=${currentName}/${currentVersion}@${currentUser}/${currentChannel}"
                "--deployer" "direct_deploy"
                "--deployer-folder" "${currentOutputDir}/build/dependencies"
        WORKING_DIRECTORY "${currentOutputDir}"
        COMMAND_ECHO "STDOUT"
        ENCODING "UTF-8"
        COMMAND_ERROR_IS_FATAL "ANY"
    )

    if(NOT EXISTS "${currentOutputDir}/build/dependencies/direct_deploy/${currentName}/1.txt")
        message(FATAL_ERROR "not exists: '${currentOutputDir}/build/dependencies/direct_deploy/${currentName}/1.txt'")
    endif()

    file(READ "${currentOutputDir}/build/dependencies/direct_deploy/${currentName}/1.txt" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    execute_process(
        COMMAND "${conanCommand}" "remove" "-c" "${currentName}"
        WORKING_DIRECTORY "${_SOURCE_DIR}"
        COMMAND_ECHO "STDOUT"
        ENCODING "UTF-8"
        COMMAND_ERROR_IS_FATAL "ANY"
    )

    message("... PASS")
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
            message(FATAL_ERROR "Usage: cmake -P ${fileName} -- [${noEscapeBackslashOption}] function_name args...")
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
