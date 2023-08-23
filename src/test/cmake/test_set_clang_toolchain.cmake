include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/clang-x64-toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(path "C:/Program Files/LLVM/bin/clang.exe")
    set(target "x86_64-pc-windows-msvc")

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_clang_toolchain(actual
        PROCESSOR "${processor}"
        OS "${os}"
        PATH "${path}"
        TARGET "${target}"
    )

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/clang-x64-toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/clang-x64-toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
endfunction()

execute_test_script()
