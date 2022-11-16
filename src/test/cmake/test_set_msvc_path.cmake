include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(expected "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools")
    set_msvc_path(actual VERSION "latest" PRODUCTS "Microsoft.VisualStudio.Product.BuildTools")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
endfunction()

execute_test_script()
