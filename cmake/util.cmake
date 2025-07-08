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

function(vscode)
    set(options)
    set(oneValueKeywords
        "SOURCE_DIR"
        "BINARY_DIR"
        "LAUNCH_GENERATE"
        "LAUNCH_FILE_OVERWRITE"
        "LAUNCH_TEMPLATE_FILE"
        "LAUNCH_FILE"
        "LAUNCH_TESTS_FILE"
        "LAUNCH_DEFAULT_TEST"
    )
    set(multiValueKeywords
        "LAUNCH_TESTS"
    )

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Unparsed arguments: '${_UNPARSED_ARGUMENTS}'")
    endif()

    if(NOT DEFINED "_SOURCE_DIR")
        cmake_path(GET "CMAKE_CURRENT_FUNCTION_LIST_DIR" PARENT_PATH "_SOURCE_DIR")
    endif()

    if(NOT DEFINED "_BINARY_DIR")
        set(_BINARY_DIR "${_SOURCE_DIR}/build")
    endif()

    # launch vars
    if(NOT DEFINED "_LAUNCH_GENERATE")
        set(_LAUNCH_GENERATE "1")
    endif()

    if(NOT DEFINED "_LAUNCH_FILE_OVERWRITE")
        set(_LAUNCH_FILE_OVERWRITE "1")
    endif()

    if(NOT DEFINED "_LAUNCH_TEMPLATE_FILE")
        set(_LAUNCH_TEMPLATE_FILE "${_SOURCE_DIR}/src/test/resources/vscode/launch.json")
    endif()

    if(NOT DEFINED "_LAUNCH_FILE")
        set(_LAUNCH_FILE "${_SOURCE_DIR}/.vscode/launch.json")
    endif()

    if(NOT DEFINED "_LAUNCH_TESTS_FILE")
        set(_LAUNCH_TESTS_FILE "${_BINARY_DIR}/tests.json")
    endif()
    if(DEFINED "_LAUNCH_TESTS_FILE" AND NOT EXISTS "${_LAUNCH_TESTS_FILE}")
        message(FATAL_ERROR "[${CMAKE_CURRENT_FUNCTION}] Not exists LAUNCH_TESTS_FILE: '${_LAUNCH_TESTS_FILE}'")
    endif()

    if(NOT DEFINED "_LAUNCH_DEFAULT_TEST" OR "${_LAUNCH_DEFAULT_TEST}" STREQUAL "")
        set(_LAUNCH_DEFAULT_TEST "ALL")
    endif()

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        if(DEFINED "_${v}")
            list(LENGTH "_${v}" l)
            if("${l}" GREATER "1")
                message(STATUS "[${CMAKE_CURRENT_FUNCTION}] ${v}:")
                foreach(i IN LISTS "_${v}")
                    message(STATUS "[${CMAKE_CURRENT_FUNCTION}] - '${i}'")
                endforeach()
            else()
                message(STATUS "[${CMAKE_CURRENT_FUNCTION}] ${v}: '${_${v}}'")
            endif()
        endif()
    endforeach()

    # launch gen
    if("${_LAUNCH_GENERATE}" AND (NOT EXISTS "${_LAUNCH_FILE}" OR "${_LAUNCH_FILE_OVERWRITE}"))
        message(STATUS "[${CMAKE_CURRENT_FUNCTION}] generate: '${_LAUNCH_FILE}' ...")

        if(EXISTS "${_LAUNCH_TESTS_FILE}")
            file(READ "${_LAUNCH_TESTS_FILE}" json)
            string(JSON testGroups GET "${json}" "testsuites")
            string(JSON testGroupsLength LENGTH "${testGroups}")
            if("${testGroupsLength}" GREATER "0")
                math(EXPR testGroupMaxIndex "${testGroupsLength} - 1")
                foreach(testGroupIndex RANGE "0" "${testGroupMaxIndex}")
                    string(JSON testGroup GET "${testGroups}" "${testGroupIndex}")
                    string(JSON testGroupName GET "${testGroup}" "name")
                    string(JSON testCases GET "${testGroup}" "testsuite")
                    string(JSON testCasesLength LENGTH "${testCases}")
                    if("${testCasesLength}" GREATER "0")
                        math(EXPR testCaseMaxIndex "${testCasesLength} - 1")
                        foreach(testCaseIndex RANGE "0" "${testCaseMaxIndex}")
                            string(JSON testCase GET "${testCases}" "${testCaseIndex}")
                            string(JSON testCaseName GET "${testCase}" "name")
                            if(NOT "^${testGroupName}\\\\..+$" IN_LIST "_LAUNCH_TESTS")
                                list(APPEND "_LAUNCH_TESTS" "^${testGroupName}\\\\..+$")
                            endif()
                            if(NOT "^${testGroupName}\\\\.${testCaseName}$" IN_LIST "_LAUNCH_TESTS")
                                list(APPEND "_LAUNCH_TESTS" "^${testGroupName}\\\\.${testCaseName}$")
                            endif()
                        endforeach()
                    endif()
                endforeach()
            endif()
        endif()

        if(NOT DEFINED "_LAUNCH_DEFAULT_TEST")
            list(GET "_LAUNCH_TESTS" "0" "_LAUNCH_DEFAULT_TEST")
        endif()

        string(JOIN "\",\n                \"" "_LAUNCH_TESTS" ${_LAUNCH_TESTS})

        configure_file("${_LAUNCH_TEMPLATE_FILE}" "${_LAUNCH_FILE}" @ONLY)

        message(STATUS "[${CMAKE_CURRENT_FUNCTION}] generate: '${_LAUNCH_FILE}' ... done")
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
