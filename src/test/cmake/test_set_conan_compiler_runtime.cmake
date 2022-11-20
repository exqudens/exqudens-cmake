include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(expected "MT")
    set_conan_compiler_runtime(actual "MultiThreaded")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "MD")
    set_conan_compiler_runtime(actual "MultiThreadedDLL")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "MTd")
    set_conan_compiler_runtime(actual "MultiThreadedDebug")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "MDd")
    set_conan_compiler_runtime(actual "MultiThreadedDebugDLL")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
endfunction()

execute_test_script()
