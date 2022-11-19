include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(expected
        "--settings" "arch=x86_64"
        "--settings" "os=Windows"
        "--settings" "compiler=Visual Studio"
        "--settings" "compiler.version=16"
        "--settings" "compiler.runtime=MD"
        "--settings" "build_type=Debug"
        "--settings" "vulkan:build_type=Release"
        "--settings" "vulkan:compiler.runtime=MD"
    )
    set_conan_settings(actual
        "arch=x86_64"
        "os=Windows"
        "compiler=Visual Studio"
        "compiler.version=16"
        "compiler.runtime=MD"
        "build_type=Debug"
        "vulkan:build_type=Release"
        "vulkan:compiler.runtime=MD"
    )

    if(NOT "${expected}" STREQUAL "${actual}")
        message(FATAL_ERROR "'expected': '${expected}' != 'actual': '${actual}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
endfunction()

execute_test_script()
