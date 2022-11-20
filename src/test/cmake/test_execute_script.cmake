include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_execute_script/${CMAKE_CURRENT_FUNCTION}/toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(compiler "msvc")
    set(path "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl.exe")
    set(file "${CMAKE_CURRENT_BINARY_DIR}/test_execute_script/${CMAKE_CURRENT_FUNCTION}/toolchain.cmake")

    execute_script(toolchain
        processor "${processor}"
        os "${os}"
        compiler "${compiler}"
        path "${path}"
        file "${file}"
    )
    file(READ "${file}" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_execute_script/${CMAKE_CURRENT_FUNCTION}/toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(compiler "msvc")
    set(version "16")
    set(host "x64")
    set(target "x64")
    set(products "Microsoft.VisualStudio.Product.BuildTools")
    set(file "${CMAKE_CURRENT_BINARY_DIR}/test_execute_script/${CMAKE_CURRENT_FUNCTION}/toolchain.cmake")

    execute_script(toolchain
        processor "${processor}"
        os "${os}"
        compiler "${compiler}"
        version "${version}"
        host "${host}"
        target "${target}"
        products "${products}"
        file "${file}"
    )
    file(READ "${file}" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_3)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_execute_script/${CMAKE_CURRENT_FUNCTION}/toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(compiler "gnu")
    set(path "C:/Program Files/JetBrains/CLion 2022.2.1/bin/mingw/bin/gcc.exe")
    set(file "${CMAKE_CURRENT_BINARY_DIR}/test_execute_script/${CMAKE_CURRENT_FUNCTION}/toolchain.cmake")

    execute_script(toolchain
        processor "${processor}"
        os "${os}"
        compiler "${compiler}"
        path "${path}"
        file "${file}"
    )
    file(READ "${file}" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_4)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_execute_script/${CMAKE_CURRENT_FUNCTION}/toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(compiler "clang")
    set(path "C:/Program Files/LLVM/bin/clang.exe")
    set(target "x86_64-pc-windows-msvc")
    set(file "${CMAKE_CURRENT_BINARY_DIR}/test_execute_script/${CMAKE_CURRENT_FUNCTION}/toolchain.cmake")

    execute_script(toolchain
        processor "${processor}"
        os "${os}"
        compiler "${compiler}"
        path "${path}"
        target "${target}"
        file "${file}"
    )
    file(READ "${file}" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
    test_2()
    test_3()
    test_4()
endfunction()

execute_test_script()
