include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    string(JOIN "\n" input
        "AAA"
        "BBB"
        "AAA"
        "BBB"
        "CCC"
        ";"
    )
    string(JOIN "\n" expected
        "AAA"
        "BBB"
        "CCC"
        ";"
    )
    substring_from(actual "${input}" "AAA\nBBB\n")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_script)
    test_1()
endfunction()

execute_script()
