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

    string_replace_between(actual "${input}" "/*" "*/" "// single-line comments...")

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

function(execute_test_script)
    test_1()
endfunction()

execute_test_script()
