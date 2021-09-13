cmake_minimum_required(VERSION 3.21 FATAL_ERROR)
project("${CMAKE_PROJECT_NAME}-cpp-test" VERSION "${CMAKE_PROJECT_VERSION}" LANGUAGES "C" "CXX")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

if(MSVC)
    set("${PROJECT_NAME}_CXX_IMPLICIT_INCLUDE_DIRECTORIES" "${${CMAKE_PROJECT_NAME}_CXX_IMPLICIT_INCLUDE_DIRECTORIES}")
    set("${PROJECT_NAME}_CXX_IMPLICIT_LINK_DIRECTORIES" "${${CMAKE_PROJECT_NAME}_CXX_IMPLICIT_LINK_DIRECTORIES}")
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

set("${PROJECT_NAME}_CMAKE_INSTALL_PREFIX" "${PROJECT_BINARY_DIR}/cmake-install")

if(NOT "" STREQUAL "${CONAN_COMMAND}")
    set("${PROJECT_NAME}_CONAN_INSTALL_PREFIX" "${PROJECT_BINARY_DIR}/conan-install")

    set_conan_settings(CONAN_SETTINGS
        "${CMAKE_SYSTEM_NAME}"
        "${CXX_TARGET_ARCH}"
        "${CMAKE_CXX_COMPILER_ID}"
        "${CMAKE_CXX_COMPILER_VERSION}"
        "${CMAKE_MSVC_RUNTIME_LIBRARY}"
        "${CMAKE_CXX_STANDARD}"
        "${CMAKE_BUILD_TYPE}"
    )

    set_conan_options(CONAN_OPTIONS
        "shared=${CONAN_BUILD_SHARED_LIBS}"
        "exqudens-cpp-test-lib:shared=${CONAN_BUILD_SHARED_LIBS}"
        "gtest:shared=${CONAN_BUILD_SHARED_LIBS}"
    )

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

add_library("${PROJECT_NAME}-lib"
    "src/test/cpp/exqudens/cmake/Application.hpp"
    "src/test/cpp/exqudens/cmake/Application.cpp"
    "src/test/cpp/exqudens/cmake/Procedures.hpp"
    "src/test/cpp/exqudens/cmake/Procedures.cpp"
)
target_include_directories("${PROJECT_NAME}-lib" PUBLIC
    "$<BUILD_INTERFACE:${${PROJECT_NAME}_CXX_IMPLICIT_INCLUDE_DIRECTORIES}>"
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src/test/cpp>"
    "$<INSTALL_INTERFACE:include>"
)
target_link_directories("${PROJECT_NAME}-lib" PUBLIC
    "${${PROJECT_NAME}_CXX_IMPLICIT_LINK_DIRECTORIES}"
)

add_executable("${PROJECT_NAME}-executable" "src/test/cpp/main.cpp")
target_link_libraries("${PROJECT_NAME}-executable" PRIVATE
    "${PROJECT_NAME}-lib"
)
