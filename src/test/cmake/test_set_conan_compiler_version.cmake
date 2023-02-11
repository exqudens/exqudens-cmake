include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(expected "17")
    set_conan_compiler_version(actual "MSVC" "19.30")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "16")
    set_conan_compiler_version(actual "MSVC" "19.20")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "15")
    set_conan_compiler_version(actual "MSVC" "19.10")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "8")
    set_conan_compiler_version(actual "GNU" "8")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "7")
    set_conan_compiler_version(actual "Clang" "7")

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "7.0")
    set_conan_compiler_version(actual "Clang" "7.0" MAX_ELEMENTS 2)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "7")
    set_conan_compiler_version(actual "Clang" "7.0" MAX_ELEMENTS 1)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "7.0")
    set_conan_compiler_version(actual "Clang" "7.0.1" MAX_ELEMENTS 2)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    set(expected "7")
    set_conan_compiler_version(actual "Clang" "7.0.1" MAX_ELEMENTS 1)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
endfunction()

execute_test_script()
