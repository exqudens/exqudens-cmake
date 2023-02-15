include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    get_filename_component(testFileName "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    set(testFunctionName "${CMAKE_CURRENT_FUNCTION}")
    message("${testFileName}.${testFunctionName} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${testFileName}/${testFunctionName}/toolchain.cmake" expected)

    set(processor "arm")
    set(os "Generic")
    set(path "C:/gcc/bin/arm-none-eabi-gcc.exe")

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_gnu_toolchain_content(actual
        PROCESSOR "${processor}"
        OS "${os}"
        PATH "${path}"
    )

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${testFileName}/${testFunctionName}/toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/${testFileName}/${testFunctionName}/toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    get_filename_component(testFileName "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    set(testFunctionName "${CMAKE_CURRENT_FUNCTION}")
    message("${testFileName}.${testFunctionName} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${testFileName}/${testFunctionName}/toolchain.cmake" expected)

    set(processor "x86_64")
    set(os "Windows")
    set(path "C:/gcc/bin/gcc.exe")

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_gnu_toolchain_content(actual
        PROCESSOR "${processor}"
        OS "${os}"
        PATH "${path}"
    )

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${testFileName}/${testFunctionName}/toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/${testFileName}/${testFunctionName}/toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_3)
    get_filename_component(testFileName "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    set(testFunctionName "${CMAKE_CURRENT_FUNCTION}")
    message("${testFileName}.${testFunctionName} ...")

    set(processor "x86_64")
    set(os "Linux")
    set(path "/usr/bin/gcc")

    string(TOLOWER "${CMAKE_HOST_SYSTEM_NAME}" hostSystemNameLowerCase)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${testFileName}/${testFunctionName}/${hostSystemNameLowerCase}-toolchain.cmake" expected)

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_gnu_toolchain_content(actual
        PROCESSOR "${processor}"
        OS "${os}"
        PATH "${path}"
    )

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${testFileName}/${testFunctionName}/toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/${testFileName}/${testFunctionName}/toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
    test_2()
    test_3()
endfunction()

execute_test_script()
