include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    # TODO

    message("... PASS")
endfunction()

function(execute_script)
    test_1()
endfunction()

execute_script()
