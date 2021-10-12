cmake_minimum_required(VERSION 3.21 FATAL_ERROR)
get_filename_component(RAW_NAME "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
string(REPLACE " " "_" NAME "${RAW_NAME}")
project("${NAME}" VERSION "${CMAKE_PROJECT_VERSION}" LANGUAGES "C" "CXX")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

set("${PROJECT_NAME}_CMAKE_INSTALL_PREFIX" "${PROJECT_BINARY_DIR}/cmake-install")

if(NOT "" STREQUAL "${CONAN_COMMAND}")
    set_conan_settings(CONAN_SETTINGS
        "${CMAKE_SYSTEM_NAME}"
        "${CXX_TARGET_ARCH}"
        "${CMAKE_CXX_COMPILER_ID}"
        "${CMAKE_CXX_COMPILER_VERSION}"
        "${CMAKE_MSVC_RUNTIME_LIBRARY}"
        "${CMAKE_CXX_STANDARD}"
        "${CMAKE_BUILD_TYPE}"
        #"gtest:compiler.runtime=MT" # error with 'shared' preset
    )

    set_conan_options(CONAN_OPTIONS
        "type=${CONAN_PACKAGE_TYPE}"
        #"gtest:shared=False" # error with 'shared' preset
        "gtest:shared=${CONAN_BUILD_SHARED_LIBS}"
    )

    set("${PROJECT_NAME}_CONAN_INSTALL_PREFIX" "${PROJECT_BINARY_DIR}/conan-install")

    if(NOT EXISTS "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}")
        execute_process(
            COMMAND "${CONAN_COMMAND}"
                    install
                    "${PROJECT_SOURCE_DIR}/conanfile.py"
                    --install-folder
                    "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}"
                    ${CONAN_SETTINGS}
                    ${CONAN_OPTIONS}
            COMMAND_ECHO "STDERR"
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ENCODING "UTF-8"
            COMMAND_ERROR_IS_FATAL ANY
        )
    endif()

    if(NOT EXISTS "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}/conan-packages.cmake")
        message(FATAL_ERROR "Not exists: '${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}/conan-packages.cmake'!")
    endif()

    include("${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}/conan-packages.cmake")

    set(CMAKE_MODULE_PATH "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}")

    foreach(
        conanPackageName
        cmakePackageName
        cmakePackageVersion
        cmakePackageFindType
        cmakePackagePaths
        IN ZIP_LISTS
        "${PROJECT_NAME}_CONAN_PACKAGE_NAMES"
        "${PROJECT_NAME}_CMAKE_PACKAGE_NAMES"
        "${PROJECT_NAME}_CMAKE_PACKAGE_VERSIONS"
        "${PROJECT_NAME}_CMAKE_PACKAGE_FIND_TYPES"
        "${PROJECT_NAME}_CMAKE_PACKAGE_PATHS"
    )
        if(
            "" STREQUAL "${conanPackageName}"
            OR "" STREQUAL "${cmakePackageName}"
            OR "" STREQUAL "${cmakePackageVersion}"
            OR "" STREQUAL "${cmakePackageFindType}"
            OR "" STREQUAL "${cmakePackagePaths}"
        )
            string(JOIN " " errorMessage
                "Empty value 'conanPackageName': '${conanPackageName}'"
                "or 'cmakePackageName': '${cmakePackageName}'"
                "or 'cmakePackageVersion': '${cmakePackageVersion}'"
                "or 'cmakePackageFindType': '${cmakePackageFindType}'"
                "or 'cmakePackagePaths': '${cmakePackagePaths}'!"
            )
            message(FATAL_ERROR "${errorMessage}")
        endif()

        string(REPLACE "<sep>" ";" tmpCmakePackagePaths "${cmakePackagePaths}")

        foreach(cmakePackagePath ${tmpCmakePackagePaths})
            if(NOT IS_DIRECTORY "${cmakePackagePath}")
                message(FATAL_ERROR "Not is directory 'cmakePackagePath': '${cmakePackagePath}'!")
            endif()
            list(APPEND CMAKE_PREFIX_PATH "${cmakePackagePath}")
        endforeach()

        if("<ignore>" STREQUAL "${cmakePackageVersion}" AND "MODULE" STREQUAL "${cmakePackageFindType}")
            find_package("${cmakePackageName}" QUIET)
        elseif(NOT "<ignore>" STREQUAL "${cmakePackageVersion}" AND "MODULE" STREQUAL "${cmakePackageFindType}")
            find_package("${cmakePackageName}" "${cmakePackageVersion}" EXACT QUIET)
        elseif("<ignore>" STREQUAL "${cmakePackageVersion}" AND NOT "MODULE" STREQUAL "${cmakePackageFindType}")
            find_package("${cmakePackageName}" QUIET CONFIG)
        elseif(NOT "<ignore>" STREQUAL "${cmakePackageVersion}" AND NOT "MODULE" STREQUAL "${cmakePackageFindType}")
            find_package("${cmakePackageName}" "${cmakePackageVersion}" EXACT QUIET CONFIG)
        endif()

    endforeach()

    set_not_found_package_names(NOT_FOUND_PACKAGE_NAMES ${${PROJECT_NAME}_CMAKE_PACKAGE_NAMES})

    if(NOT "" STREQUAL "${NOT_FOUND_PACKAGE_NAMES}")
        foreach(package ${NOT_FOUND_PACKAGE_NAMES})
            message(WARNING "${package}_FOUND: '${${package}_FOUND}'")
        endforeach()
        return()
    endif()

endif()

add_library("${PROJECT_NAME}"
    "src/main/cpp/exqudens/Strings.hpp"
    "src/main/cpp/exqudens/Strings.cpp"
)
target_include_directories("${PROJECT_NAME}" PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src/main/cpp>"
    "$<INSTALL_INTERFACE:include>"
)
set_target_properties("${PROJECT_NAME}" PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/main/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/main/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/main/bin"
    RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/main/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/main/bin"

    ARCHIVE_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/main/lib"
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/main/lib"
    ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/main/lib"
    ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/main/lib"
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/main/lib"

    LIBRARY_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/main/lib"
    LIBRARY_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/main/lib"
    LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/main/lib"
    LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/main/lib"
    LIBRARY_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/main/lib"
)

add_library("${PROJECT_NAME}-test-lib" INTERFACE
    "src/test/cpp/exqudens/TestApplication.hpp"
    "src/test/cpp/exqudens/StringsTests.hpp"
)
target_include_directories("${PROJECT_NAME}-test-lib" INTERFACE
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src/test/cpp>"
    "$<INSTALL_INTERFACE:include>"
)
target_link_libraries("${PROJECT_NAME}-test-lib" INTERFACE
    "${PROJECT_NAME}"
    "GTest::gtest"
    "GTest::gtest_main"
)

add_executable("${PROJECT_NAME}-test-app" "src/test/cpp/main.cpp")
target_link_libraries("${PROJECT_NAME}-test-app" PRIVATE
    "${PROJECT_NAME}-test-lib"
)
set_target_properties("${PROJECT_NAME}-test-app" PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/test/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/test/bin"
    RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/test/bin"
    RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/test/bin"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/test/bin"

    ARCHIVE_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/test/lib"
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/test/lib"
    ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/test/lib"
    ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/test/lib"
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/test/lib"

    LIBRARY_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/test/lib"
    LIBRARY_OUTPUT_DIRECTORY_RELEASE        "${PROJECT_BINARY_DIR}/test/lib"
    LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${PROJECT_BINARY_DIR}/test/lib"
    LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL     "${PROJECT_BINARY_DIR}/test/lib"
    LIBRARY_OUTPUT_DIRECTORY_DEBUG          "${PROJECT_BINARY_DIR}/test/lib"
)
add_custom_command(TARGET "${PROJECT_NAME}-test-app"
    POST_BUILD
    COMMAND "${CMAKE_COMMAND}"
    ARGS -E copy_directory "${PROJECT_BINARY_DIR}/main/bin" "$<TARGET_PROPERTY:${PROJECT_NAME}-test-app,RUNTIME_OUTPUT_DIRECTORY>"
    COMMAND "${CMAKE_COMMAND}"
    ARGS -E copy_directory "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}/bin" "$<TARGET_PROPERTY:${PROJECT_NAME}-test-app,RUNTIME_OUTPUT_DIRECTORY>"
    VERBATIM
)

add_custom_target("${PROJECT_NAME}-test-app-clean"
    COMMAND "${CMAKE_COMMAND}" -E rm -f "$<TARGET_PROPERTY:${PROJECT_NAME}-test-app,RUNTIME_OUTPUT_DIRECTORY>/*"
    VERBATIM
)

add_dependencies("${PROJECT_NAME}-test-app" "${PROJECT_NAME}-test-app-clean")

#[[set("${PROJECT_NAME}_TESTS_PATH"
    "${PROJECT_BINARY_DIR}/main/bin"
    "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}/bin"
)
add_custom_target("${PROJECT_NAME}-tests"
    COMMAND "${CMAKE_COMMAND}"
            -E
            env
            "PATH=${${PROJECT_NAME}_TESTS_PATH}"
            "$<TARGET_FILE:${PROJECT_NAME}-test-app>"
            #--gtest_filter=StringsTests.*
            --gtest_filter=*
    WORKING_DIRECTORY "$<TARGET_PROPERTY:${PROJECT_NAME}-test-app,RUNTIME_OUTPUT_DIRECTORY>"
    COMMENT "custom-target: '${PROJECT_NAME}-tests'"
    VERBATIM
)]]
