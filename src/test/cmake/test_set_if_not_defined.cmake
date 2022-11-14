include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(expected "ABC_abc !")
    set_if_not_defined(actual "${expected}")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(expected "_")
    set(actual "_")
    set_if_not_defined(actual "ABC_abc !")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_script)
    test_1()
    test_2()
endfunction()

execute_script()
