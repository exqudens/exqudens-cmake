include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(expected_MSVC_INCLUDE
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/include"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/ucrt"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/shared"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/um"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/winrt"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/cppwinrt"
    )
    set(expected_MSVC_LIBPATH
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x64"
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x86/store/references"
        "C:/Program Files (x86)/Windows Kits/10/UnionMetadata/10.0.19041.0"
        "C:/Program Files (x86)/Windows Kits/10/References/10.0.19041.0"
        "C:/Windows/Microsoft.NET/Framework64/v4.0.30319"
    )
    set(expected_MSVC_LIB
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x64"
        "C:/Program Files (x86)/Windows Kits/10/lib/10.0.19041.0/ucrt/x64"
        "C:/Program Files (x86)/Windows Kits/10/lib/10.0.19041.0/um/x64"
    )
    set(expected_MSVC_CL_PATH
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64"
    )
    set(expected_MSVC_RC_PATH
        "C:/Program Files (x86)/Windows Kits/10/bin/10.0.19041.0/x64"
    )

    cmake_path(CONVERT "${expected_MSVC_INCLUDE}" TO_NATIVE_PATH_LIST expected_MSVC_INCLUDE NORMALIZE)
    cmake_path(CONVERT "${expected_MSVC_LIBPATH}" TO_NATIVE_PATH_LIST expected_MSVC_LIBPATH NORMALIZE)
    cmake_path(CONVERT "${expected_MSVC_LIB}" TO_NATIVE_PATH_LIST expected_MSVC_LIB NORMALIZE)
    cmake_path(CONVERT "${expected_MSVC_CL_PATH}" TO_NATIVE_PATH_LIST expected_MSVC_CL_PATH NORMALIZE)
    cmake_path(CONVERT "${expected_MSVC_RC_PATH}" TO_NATIVE_PATH_LIST expected_MSVC_RC_PATH NORMALIZE)

    set(path "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl.exe")

    cmake_path(CONVERT "${path}" TO_NATIVE_PATH_LIST path NORMALIZE)

    set_msvc_env(actual
        PATH "${path}"
    )

    if(NOT "${expected_MSVC_INCLUDE}" STREQUAL "${actual_MSVC_INCLUDE}")
        message(FATAL_ERROR "'expected_MSVC_INCLUDE': '${expected_MSVC_INCLUDE}' != 'actual_MSVC_INCLUDE': '${actual_MSVC_INCLUDE}'")
    endif()

    if(NOT "${expected_MSVC_LIBPATH}" STREQUAL "${actual_MSVC_LIBPATH}")
        message(FATAL_ERROR "'expected_MSVC_LIBPATH': '${expected_MSVC_LIBPATH}' != 'actual_MSVC_LIBPATH': '${actual_MSVC_LIBPATH}'")
    endif()

    if(NOT "${expected_MSVC_LIB}" STREQUAL "${actual_MSVC_LIB}")
        message(FATAL_ERROR "'expected_MSVC_LIB': '${expected_MSVC_LIB}' != 'actual_MSVC_LIB': '${actual_MSVC_LIB}'")
    endif()

    if(NOT "${expected_MSVC_CL_PATH}" STREQUAL "${actual_MSVC_CL_PATH}")
        message(FATAL_ERROR "'expected_MSVC_CL_PATH': '${expected_MSVC_CL_PATH}' != 'actual_MSVC_CL_PATH': '${actual_MSVC_CL_PATH}'")
    endif()

    if(NOT "${expected_MSVC_RC_PATH}" STREQUAL "${actual_MSVC_RC_PATH}")
        message(FATAL_ERROR "'expected_MSVC_RC_PATH': '${expected_MSVC_RC_PATH}' != 'actual_MSVC_RC_PATH': '${actual_MSVC_RC_PATH}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(expected_MSVC_INCLUDE
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/include"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/ucrt"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/shared"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/um"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/winrt"
        "C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/cppwinrt"
    )
    set(expected_MSVC_LIBPATH
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x64"
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x86/store/references"
        "C:/Program Files (x86)/Windows Kits/10/UnionMetadata/10.0.19041.0"
        "C:/Program Files (x86)/Windows Kits/10/References/10.0.19041.0"
        "C:/Windows/Microsoft.NET/Framework64/v4.0.30319"
    )
    set(expected_MSVC_LIB
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x64"
        "C:/Program Files (x86)/Windows Kits/10/lib/10.0.19041.0/ucrt/x64"
        "C:/Program Files (x86)/Windows Kits/10/lib/10.0.19041.0/um/x64"
    )
    set(expected_MSVC_CL_PATH
        "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64"
    )
    set(expected_MSVC_RC_PATH
        "C:/Program Files (x86)/Windows Kits/10/bin/10.0.19041.0/x64"
    )

    cmake_path(CONVERT "${expected_MSVC_INCLUDE}" TO_NATIVE_PATH_LIST expected_MSVC_INCLUDE NORMALIZE)
    cmake_path(CONVERT "${expected_MSVC_LIBPATH}" TO_NATIVE_PATH_LIST expected_MSVC_LIBPATH NORMALIZE)
    cmake_path(CONVERT "${expected_MSVC_LIB}" TO_NATIVE_PATH_LIST expected_MSVC_LIB NORMALIZE)
    cmake_path(CONVERT "${expected_MSVC_CL_PATH}" TO_NATIVE_PATH_LIST expected_MSVC_CL_PATH NORMALIZE)
    cmake_path(CONVERT "${expected_MSVC_RC_PATH}" TO_NATIVE_PATH_LIST expected_MSVC_RC_PATH NORMALIZE)

    set(version "16")
    set(host "x64")
    set(target "x64")
    set(products "Microsoft.VisualStudio.Product.BuildTools")

    set_msvc_env(actual
        COMMAND ""
        PATH ""
        VERSION "${version}"
        HOST "${host}"
        TARGET "${target}"
        PRODUCTS "${products}"
    )

    if(NOT "${expected_MSVC_INCLUDE}" STREQUAL "${actual_MSVC_INCLUDE}")
        message(FATAL_ERROR "'expected_MSVC_INCLUDE': '${expected_MSVC_INCLUDE}' != 'actual_MSVC_INCLUDE': '${actual_MSVC_INCLUDE}'")
    endif()

    if(NOT "${expected_MSVC_LIBPATH}" STREQUAL "${actual_MSVC_LIBPATH}")
        message(FATAL_ERROR "'expected_MSVC_LIBPATH': '${expected_MSVC_LIBPATH}' != 'actual_MSVC_LIBPATH': '${actual_MSVC_LIBPATH}'")
    endif()

    if(NOT "${expected_MSVC_LIB}" STREQUAL "${actual_MSVC_LIB}")
        message(FATAL_ERROR "'expected_MSVC_LIB': '${expected_MSVC_LIB}' != 'actual_MSVC_LIB': '${actual_MSVC_LIB}'")
    endif()

    if(NOT "${expected_MSVC_CL_PATH}" STREQUAL "${actual_MSVC_CL_PATH}")
        message(FATAL_ERROR "'expected_MSVC_CL_PATH': '${expected_MSVC_CL_PATH}' != 'actual_MSVC_CL_PATH': '${actual_MSVC_CL_PATH}'")
    endif()

    if(NOT "${expected_MSVC_RC_PATH}" STREQUAL "${actual_MSVC_RC_PATH}")
        message(FATAL_ERROR "'expected_MSVC_RC_PATH': '${expected_MSVC_RC_PATH}' != 'actual_MSVC_RC_PATH': '${actual_MSVC_RC_PATH}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
    test_2()
endfunction()

execute_test_script()
