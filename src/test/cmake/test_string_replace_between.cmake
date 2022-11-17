include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

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

function(execute_test_script)
    test_1()
    test_2()
    test_3()
    test_4()
    test_5()
endfunction()

execute_test_script()
