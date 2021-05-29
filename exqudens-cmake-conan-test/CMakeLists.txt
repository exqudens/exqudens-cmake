cmake_minimum_required(VERSION 3.20)
project("${CMAKE_PROJECT_NAME}-conan-test" VERSION "${CMAKE_PROJECT_VERSION}")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

if(NOT DEFINED "CONAN_COMMAND")
    cmake_path(
        CONVERT "$ENV{PATH}"
        TO_CMAKE_PATH_LIST "${PROJECT_NAME}_CMAKE_PATH_LIST"
        NORMALIZE
    )
    foreach(pathDir ${${PROJECT_NAME}_CMAKE_PATH_LIST})
        file(GLOB pathDirFileNames RELATIVE "${pathDir}" "${pathDir}/*")
        foreach(pathFileName ${pathDirFileNames})
            if("conan" STREQUAL "${pathFileName}" OR "conan.exe" STREQUAL "${pathFileName}")
                set(CONAN_COMMAND "${pathDir}/${pathFileName}" CACHE FILEPATH "..." FORCE)
            endif()
        endforeach()
    endforeach()
    if(NOT DEFINED "CONAN_COMMAND")
        message(FATAL_ERROR "No 'conan' or 'conan.exe' in 'ENV{PATH}'")
    endif()
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED "ON")

include("${CMAKE_SOURCE_DIR}/src/main/cmake/conan.cmake")

conan_settings(
    CONAN_SETTINGS
    "${CMAKE_SYSTEM_NAME}"
    "${CMAKE_SYSTEM_PROCESSOR}"
    "${CMAKE_CXX_COMPILER_ID}"
    "${CMAKE_CXX_COMPILER_VERSION}"
    "${CMAKE_MSVC_RUNTIME_LIBRARY}"
    "${CMAKE_CXX_STANDARD}"
    "${CMAKE_BUILD_TYPE}"
)

conan_options(
    CONAN_OPTIONS
    "${BUILD_SHARED_LIBS}"
    "fmt"
)

if(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/conan-installed")
    #file(REMOVE_RECURSE "${CMAKE_CURRENT_BINARY_DIR}/conan-installed")
endif()
conan_install(
    "${CONAN_COMMAND}"
    "${CMAKE_CURRENT_SOURCE_DIR}/conanfile.py"
    "${CMAKE_CURRENT_BINARY_DIR}/conan-installed"
    "${CONAN_SETTINGS}"
    "${CONAN_OPTIONS}"
)
