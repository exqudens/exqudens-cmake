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
        "LAUNCH_TEMPLATE_FILE"
        "LAUNCH_TEST_LIST_FILE"
        "LAUNCH_FILE"
        "LAUNCH_GENERATE"
        "LAUNCH_FILE_OVERWRITE"
    )
    set(multiValueKeywords)

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        set("_${v}" "")
    endforeach()

    cmake_parse_arguments("${currentFunctionName}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "_UNPARSED_ARGUMENTS: '${_UNPARSED_ARGUMENTS}'")
    endif()

    if("${_SOURCE_DIR}" STREQUAL "")
        cmake_path(GET "CMAKE_CURRENT_FUNCTION_LIST_DIR" PARENT_PATH _SOURCE_DIR)
    endif()

    if("${_BINARY_DIR}" STREQUAL "")
        set(_BINARY_DIR "${_SOURCE_DIR}/build")
    endif()

    if("${_LAUNCH_TEMPLATE_FILE}" STREQUAL "")
        set(_LAUNCH_TEMPLATE_FILE "${_SOURCE_DIR}/src/test/resources/.vscode/launch.json")
    endif()

    if("${_LAUNCH_TEST_LIST_FILE}" STREQUAL "")
        set(_LAUNCH_TEST_LIST_FILE "${_BINARY_DIR}/test-list.json")
    endif()

    if("${_LAUNCH_FILE}" STREQUAL "")
        set(_LAUNCH_FILE "${_SOURCE_DIR}/.vscode/launch.json")
    endif()

    if("${_LAUNCH_GENERATE}" STREQUAL "")
        set(_LAUNCH_GENERATE "true")
    endif()

    if("${_LAUNCH_FILE_OVERWRITE}" STREQUAL "")
        set(_LAUNCH_FILE_OVERWRITE "true")
    endif()

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        message(STATUS "${v}: '${_${v}}'")
    endforeach()

    if(NOT "${_LAUNCH_GENERATE}" OR (EXISTS "${_LAUNCH_FILE}" AND NOT "${_LAUNCH_FILE_OVERWRITE}"))
        return()
    endif()

    if(NOT EXISTS "${_LAUNCH_TEST_LIST_FILE}")
        message(FATAL_ERROR "Not exists: '${_LAUNCH_TEST_LIST_FILE}'")
    endif()

    set(testCaseNames "^.+\\\\..+$")
    file(READ "${_LAUNCH_TEST_LIST_FILE}" json)
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
                    if(NOT "^${testGroupName}\\\\..+$" IN_LIST "testCaseNames")
                        list(APPEND testCaseNames "^${testGroupName}\\\\..+$")
                    endif()
                    if(NOT "^${testGroupName}.${testCaseName}$" IN_LIST "testCaseNames")
                        list(APPEND testCaseNames "^${testGroupName}\\\\.${testCaseName}$")
                    endif()
                endforeach()
            endif()
        endforeach()
    endif()

    list(GET "testCaseNames" "0" "launch.inputs.pick-test.default")
    string(JOIN "\",\n                \"" "launch.inputs.pick-test.options" ${testCaseNames})

    message(STATUS "==================================================")
    message(STATUS "substitutions")
    message(STATUS "==================================================")
    message(STATUS "'@launch.inputs.pick-test.default@': '${launch.inputs.pick-test.default}'")
    message(STATUS "'@launch.inputs.pick-test.options@': '${launch.inputs.pick-test.options}'")
    message(STATUS "==================================================")

    configure_file("${_LAUNCH_TEMPLATE_FILE}" "${_LAUNCH_FILE}" @ONLY)
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
