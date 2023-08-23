include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(path "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl.exe")

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_msvc_toolchain(actual
        PROCESSOR "${processor}"
        OS "${os}"
        PATH "${path}"
    )

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(version "16")
    set(host "x64")
    set(target "x64")
    set(products "Microsoft.VisualStudio.Product.BuildTools")

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_msvc_toolchain(actual
        PROCESSOR "${processor}"
        OS "${os}"
        VERSION "${version}"
        HOST "${host}"
        TARGET "${target}"
        PRODUCTS "${products}"
    )

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_3)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(version "16")
    set(host "x64")
    set(target "x64")
    set(products "Microsoft.VisualStudio.Product.BuildTools")

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_msvc_toolchain(actual
        PROCESSOR "${processor}"
        OS "${os}"
        VERSION "${version}"
        HOST "${host}"
        TARGET "${target}"
        PRODUCTS "${products}"
        NO_CACHE "FALSE"
    )

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-16-x64-toolchain.cmake" actual)

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