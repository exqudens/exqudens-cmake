include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set_msvc_env(actual)

    if(NOT "${expected_MSVC_INCLUDE}" STREQUAL "${actual_MSVC_INCLUDE}")
        message(FATAL_ERROR "'expected_MSVC_INCLUDE': '${expected_MSVC_INCLUDE}' != 'actual_MSVC_INCLUDE': '${actual_MSVC_INCLUDE}'")
    endif()

    message("... PASS")
endfunction()

function(execute_script)
    test_1()
endfunction()

execute_script()
