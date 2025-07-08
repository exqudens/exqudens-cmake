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
    message("test_4")
    message("test_5")
endfunction()

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    string(JOIN "\n" expected
        "AAA;"
        "BBB;"
        "// single-line comments..."
        "CCC;"
        "DDD;"
    )
    string(JOIN "\n" expected_BETWEEN
        ""
        "* multi-line comments..."
        ""
    )
    string(JOIN "\n" expected_REPLACED
        "/*"
        "* multi-line comments..."
        "*/"
    )

    string(JOIN "\n" input
        "AAA;"
        "BBB;"
        "/*"
        "* multi-line comments..."
        "*/"
        "CCC;"
        "DDD;"
    )

    string_replace_between(actual "${input}" "/*" "*/" WITH "// single-line comments...")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    if(NOT "${expected_BETWEEN}" STREQUAL "${actual_BETWEEN}")
        message(FATAL_ERROR "'expected_BETWEEN': '${expected_BETWEEN}' != 'actual_REPLACED': '${actual_BETWEEN}'")
    endif()

    if(NOT "${expected_REPLACED}" STREQUAL "${actual_REPLACED}")
        message(FATAL_ERROR "'expected_REPLACED': '${expected_REPLACED}' != 'actual_REPLACED': '${actual_REPLACED}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    string(JOIN "\n" expected
        "AAA;"
        "BBB;"
        "// single-line comments..."
        "CCC;"
        "DDD;"
    )
    string(JOIN "\n" expected_BETWEEN
        " comment-2"
        "* multi-line comments..."
        ""
    )
    string(JOIN "\n" expected_REPLACED
        "/* comment-2"
        "* multi-line comments..."
        "*/"
    )

    string(JOIN "\n" input
        "AAA;"
        "/* comment-1"
        "* multi-line comments..."
        "*/"
        "BBB;"
        "/* comment-2"
        "* multi-line comments..."
        "*/"
        "CCC;"
        "/* comment-3"
        "* multi-line comments..."
        "*/"
        "DDD;"
    )

    string_replace_between(actual1 "${input}" "/*" "*/\n")
    string_replace_between(actual2 "${actual1}" "/*" "*/" WITH "// single-line comments...")
    string_replace_between(actual3 "${actual2}" "/*" "*/\n")
    set(actual "${actual3}")
    set(actual_BETWEEN "${actual2_BETWEEN}")
    set(actual_REPLACED "${actual2_REPLACED}")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    if(NOT "${expected_BETWEEN}" STREQUAL "${actual_BETWEEN}")
        message(FATAL_ERROR "'expected_BETWEEN': '${expected_BETWEEN}' != 'actual_REPLACED': '${actual_BETWEEN}'")
    endif()

    if(NOT "${expected_REPLACED}" STREQUAL "${actual_REPLACED}")
        message(FATAL_ERROR "'expected_REPLACED': '${expected_REPLACED}' != 'actual_REPLACED': '${actual_REPLACED}'")
    endif()

    message("... PASS")
endfunction()

function(test_3)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    string(JOIN "\n" expected
        "AAA;"
        "BBB;"
        "// single-line comments..."
        "CCC;"
        "DDD;"
    )
    set(expected_BETWEEN "")
    set(expected_REPLACED "")

    string(JOIN "\n" input
        "AAA;"
        "/* comment-1"
        "* multi-line comments..."
        "*/"
        "BBB;"
        "/* comment-2"
        "* multi-line comments..."
        "*/"
        "CCC;"
        "/* comment-3"
        "* multi-line comments..."
        "*/"
        "DDD;"
    )

    string_replace_between(actual1 "${input}" "/*" "*/\n" RESULT_ONLY)
    string_replace_between(actual2 "${actual1}" "/*" "*/" WITH "// single-line comments..." RESULT_ONLY)
    string_replace_between(actual3 "${actual2}" "/*" "*/\n" RESULT_ONLY)
    set(actual "${actual3}")
    set(actual_BETWEEN "${actual2_BETWEEN}")
    set(actual_REPLACED "${actual2_REPLACED}")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    if(NOT "${expected_BETWEEN}" STREQUAL "${actual_BETWEEN}")
        message(FATAL_ERROR "'expected_BETWEEN': '${expected_BETWEEN}' != 'actual_REPLACED': '${actual_BETWEEN}'")
    endif()

    if(NOT "${expected_REPLACED}" STREQUAL "${actual_REPLACED}")
        message(FATAL_ERROR "'expected_REPLACED': '${expected_REPLACED}' != 'actual_REPLACED': '${actual_REPLACED}'")
    endif()

    message("... PASS")
endfunction()

function(test_4)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    string(JOIN "\n" expected
        "/* comment-2"
        "* multi-line comments..."
        "*/"
    )

    string(JOIN "\n" input
        "AAA;"
        "/* comment-1"
        "* multi-line comments..."
        "*/"
        "BBB;"
        "/* comment-2"
        "* multi-line comments..."
        "*/"
        "CCC;"
        "/* comment-3"
        "* multi-line comments..."
        "*/"
        "DDD;"
    )

    string_replace_between(actual1 "${input}" "/*" "*/\n")
    string_replace_between(actual "${actual1}" "/*" "*/" REPLACED_ONLY)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_5)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    string(JOIN "\n" expected
        " comment-2"
        "* multi-line comments..."
        ""
    )

    string(JOIN "\n" input
        "AAA;"
        "/* comment-1"
        "* multi-line comments..."
        "*/"
        "BBB;"
        "/* comment-2"
        "* multi-line comments..."
        "*/"
        "CCC;"
        "/* comment-3"
        "* multi-line comments..."
        "*/"
        "DDD;"
    )

    string_replace_between(actual1 "${input}" "/*" "*/\n")
    string_replace_between(actual "${actual1}" "/*" "*/" BETWEEN_ONLY)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
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
