cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(PUSH)
    cmake_policy(SET CMP0007 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0010 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0012 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0054 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0057 NEW)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(list_functions)
    message("test_1")
    message("test_2")
    message("test_3")
endfunction()

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(path "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.44.35207/bin/Hostx64/x64/cl.exe")

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_msvc_toolchain(actual
        PROCESSOR "${processor}"
        OS "${os}"
        PATH "${path}"
    )

    file(WRITE "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(version "17")
    set(host "x64")
    set(target "x64")
    set(products
        "Microsoft.VisualStudio.Product.Enterprise"
        "Microsoft.VisualStudio.Product.Professional"
        "Microsoft.VisualStudio.Product.Community"
        "Microsoft.VisualStudio.Product.BuildTools"
    )

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_msvc_toolchain(actual
        PROCESSOR "${processor}"
        OS "${os}"
        VERSION "${version}"
        HOST "${host}"
        TARGET "${target}"
        PRODUCTS "${products}"
    )

    file(WRITE "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(test_3)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" expected)

    set(processor "AMD64")
    set(os "Windows")
    set(version "17")
    set(host "x64")
    set(target "x64")
    set(products
        "Microsoft.VisualStudio.Product.Enterprise"
        "Microsoft.VisualStudio.Product.Professional"
        "Microsoft.VisualStudio.Product.Community"
        "Microsoft.VisualStudio.Product.BuildTools"
    )

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

    file(WRITE "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" "${actual}")
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/test/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}/msvc-17-x64-toolchain.cmake" actual)

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

block()
    if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
        set(args)
        set(argsStarted "FALSE")
        math(EXPR argIndexMax "${CMAKE_ARGC} - 1")

        foreach(i RANGE "0" "${argIndexMax}")
            if("${argsStarted}")
                list(APPEND args "${CMAKE_ARGV${i}}")
            elseif(NOT "${argsStarted}" AND "${CMAKE_ARGV${i}}" STREQUAL "--")
                set(argsStarted "TRUE")
            endif()
        endforeach()

        set(noEscapeBackslashOption "--no-escape-backslash")

        if("${args}" STREQUAL "")
            cmake_path(GET CMAKE_CURRENT_LIST_FILE FILENAME fileName)
            message(FATAL_ERROR "Usage: cmake -P ${fileName} -- [${noEscapeBackslashOption}] function_name args...")
        endif()

        list(POP_FRONT args firstArg)
        set(escapeBackslash "TRUE")

        if("${firstArg}" STREQUAL "${noEscapeBackslashOption}")
            set(escapeBackslash "FALSE")
            list(POP_FRONT args func)
        else()
            set(func "${firstArg}")
        endif()

        set(wrappedArgs "")

        if(NOT "${args}" STREQUAL "")
            foreach(arg IN LISTS args)
                set(wrappedArg "${arg}")
                string(FIND "${wrappedArg}" " " firstIndexOfSpace)

                if(NOT "${firstIndexOfSpace}" EQUAL "-1")
                    set(wrappedArg "\"${wrappedArg}\"")
                endif()

                if("${escapeBackslash}")
                    string(REPLACE "\\" "\\\\" wrappedArg "${wrappedArg}")
                endif()

                if("${wrappedArgs}" STREQUAL "")
                    string(APPEND wrappedArgs "${wrappedArg}")
                else()
                    string(APPEND wrappedArgs " ${wrappedArg}")
                endif()
            endforeach()
        endif()

        cmake_language(EVAL CODE "${func}(${wrappedArgs})")
    endif()
endblock()

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
endif()
