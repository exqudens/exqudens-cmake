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
    message("test_2")
endfunction()

function(test_1)
    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    set(currentResourcesDir "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")
    cmake_path(NORMAL_PATH currentResourcesDir)
    set(currentOutputDir "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")

    if(EXISTS "${currentOutputDir}/src" AND IS_DIRECTORY "${currentOutputDir}/src")
        file(REMOVE_RECURSE "${currentOutputDir}/src")
    endif()

    file(COPY "${currentResourcesDir}/" DESTINATION "${currentOutputDir}")

    if(EXISTS "${currentOutputDir}/build")
        file(REMOVE_RECURSE "${currentOutputDir}/build")
    endif()

    doxygen(
        SOURCE_BASE_DIR "${currentOutputDir}"
    )

    if(NOT EXISTS "${currentOutputDir}/build/doxygen/main/xml/index.xml")
        message(FATAL_ERROR "Not exists '${currentOutputDir}/build/doxygen/main/xml/index.xml'")
    endif()
endfunction()

function(test_2)
    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    set(currentResourcesDir "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")
    cmake_path(NORMAL_PATH currentResourcesDir)
    set(currentOutputDir "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")

    if(EXISTS "${currentOutputDir}/src" AND IS_DIRECTORY "${currentOutputDir}/src")
        file(REMOVE_RECURSE "${currentOutputDir}/src")
    endif()

    file(COPY "${currentResourcesDir}/" DESTINATION "${currentOutputDir}")

    if(EXISTS "${currentOutputDir}/build")
        file(REMOVE_RECURSE "${currentOutputDir}/build")
    endif()

    set(scriptFile "${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")
    cmake_path(NORMAL_PATH scriptFile)

    execute_process(
        COMMAND "${CMAKE_COMMAND}" "-P" "${scriptFile}" "--" "doxygen"
                SOURCE_BASE_DIR "${currentOutputDir}"
        WORKING_DIRECTORY "${currentOutputDir}"
        COMMAND_ECHO "STDOUT"
        COMMAND_ERROR_IS_FATAL "ANY"
    )

    if(NOT EXISTS "${currentOutputDir}/build/doxygen/main/xml/index.xml")
        message(FATAL_ERROR "Not exists '${currentOutputDir}/build/doxygen/main/xml/index.xml'")
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
