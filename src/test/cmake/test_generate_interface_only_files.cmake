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
    message("test_3")
endfunction()

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")
    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass1.hpp" expected1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass2.hpp" expected2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass3.hpp" expected3)

    set(srcDirectory "${CMAKE_CURRENT_LIST_DIR}/../../..")
    set(dstBaseDirectory "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")

    cmake_path(NORMAL_PATH srcDirectory)
    cmake_path(APPEND srcDirectory DIR)
    cmake_path(GET srcDirectory PARENT_PATH srcDirectory)
    cmake_path(NORMAL_PATH dstBaseDirectory)

    generate_interface_only_files(actual4
        SRC_DIRECTORY "${srcDirectory}"
        SRC_BASE_DIRECTORY "${srcDirectory}/src/test/resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/input"
        DST_BASE_DIRECTORY "${dstBaseDirectory}"
        HEADER_FILES_EXPRESSIONS "**/*.hpp"
        SOURCE_FILES_EXPRESSIONS "**/*.cpp"
    )

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp" actual1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp" actual2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp" actual3)
    set(expected4
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp"
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp"
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp"
    )

    if(NOT "${expected1}" STREQUAL "${actual1}")
        message(FATAL_ERROR "'expected1': '${expected1}' != 'actual1': '${actual1}'")
    endif()

    if(NOT "${expected2}" STREQUAL "${actual2}")
        message(FATAL_ERROR "'expected2': '${expected2}' != 'actual2': '${actual2}'")
    endif()

    if(NOT "${expected3}" STREQUAL "${actual3}")
        message(FATAL_ERROR "'expected3': '${expected3}' != 'actual3': '${actual3}'")
    endif()

    if(NOT "${expected4}" STREQUAL "${actual4}")
        message(FATAL_ERROR "'expected4': '${expected4}' != 'actual4': '${actual4}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")
    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass1.hpp" expected1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass2.hpp" expected2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass3.hpp" expected3)

    set(srcDirectory "${CMAKE_CURRENT_LIST_DIR}/../../..")
    set(dstBaseDirectory "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")

    cmake_path(NORMAL_PATH srcDirectory)
    cmake_path(APPEND srcDirectory DIR)
    cmake_path(GET srcDirectory PARENT_PATH srcDirectory)
    cmake_path(NORMAL_PATH dstBaseDirectory)

    generate_interface_only_files(actual4
        SRC_DIRECTORY "${srcDirectory}"
        SRC_BASE_DIRECTORY "${srcDirectory}/src/test/resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/input"
        DST_BASE_DIRECTORY "${dstBaseDirectory}"
        HEADER_FILES "src/test/resources/${currentFileNameNoExt}/test_2/input/testnamespace/testsubnamespace/TestClass1.hpp"
                     "src/test/resources/${currentFileNameNoExt}/test_2/input/testnamespace/testsubnamespace/TestClass2.hpp"
                     "src/test/resources/${currentFileNameNoExt}/test_2/input/testnamespace/testsubnamespace/TestClass3.hpp"
        SOURCE_FILES "src/test/resources/${currentFileNameNoExt}/test_2/input/testnamespace/testsubnamespace/TestClass2.cpp"
                     "src/test/resources/${currentFileNameNoExt}/test_2/input/testnamespace/testsubnamespace/TestClass3.cpp"
    )

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp" actual1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp" actual2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp" actual3)
    set(expected4
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp"
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp"
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp"
    )

    if(NOT "${expected1}" STREQUAL "${actual1}")
        message(FATAL_ERROR "'expected1': '${expected1}' != 'actual1': '${actual1}'")
    endif()

    if(NOT "${expected2}" STREQUAL "${actual2}")
        message(FATAL_ERROR "'expected2': '${expected2}' != 'actual2': '${actual2}'")
    endif()

    if(NOT "${expected3}" STREQUAL "${actual3}")
        message(FATAL_ERROR "'expected3': '${expected3}' != 'actual3': '${actual3}'")
    endif()

    if(NOT "${expected4}" STREQUAL "${actual4}")
        message(FATAL_ERROR "'expected4': '${expected4}' != 'actual4': '${actual4}'")
    endif()

    message("... PASS")
endfunction()

function(test_3)
    message("${CMAKE_CURRENT_FUNCTION} ...")
    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass1.hpp" expected1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass2.hpp" expected2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass3.hpp" expected3)

    set(srcDirectory "${CMAKE_CURRENT_LIST_DIR}/../../..")
    set(dstBaseDirectory "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")

    cmake_path(NORMAL_PATH srcDirectory)
    cmake_path(APPEND srcDirectory DIR)
    cmake_path(GET srcDirectory PARENT_PATH srcDirectory)
    cmake_path(NORMAL_PATH dstBaseDirectory)

    generate_interface_only_files(actual4
        SRC_DIRECTORY "${srcDirectory}"
        SRC_BASE_DIRECTORY "${srcDirectory}/src/test/resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/input"
        DST_BASE_DIRECTORY "${dstBaseDirectory}"
        HEADER_FILES_EXPRESSIONS "**/*.hpp"
        SOURCE_FILES_EXPRESSIONS "**/*.cpp"
        HEADER_SOURCE_MAPS "TestClass3>WindowsTestClass3"
    )

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp" actual1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp" actual2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp" actual3)
    set(expected4
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp"
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp"
        "build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp"
    )

    if(NOT "${expected1}" STREQUAL "${actual1}")
        message(FATAL_ERROR "'expected1': '${expected1}' != 'actual1': '${actual1}'")
    endif()

    if(NOT "${expected2}" STREQUAL "${actual2}")
        message(FATAL_ERROR "'expected2': '${expected2}' != 'actual2': '${actual2}'")
    endif()

    if(NOT "${expected3}" STREQUAL "${actual3}")
        message(FATAL_ERROR "'expected3': '${expected3}' != 'actual3': '${actual3}'")
    endif()

    if(NOT "${expected4}" STREQUAL "${actual4}")
        message(FATAL_ERROR "'expected4': '${expected4}' != 'actual4': '${actual4}'")
    endif()

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
