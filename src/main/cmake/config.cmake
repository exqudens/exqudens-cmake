if("$ENV{CLION_IDE}")
    cmake_path(CONVERT "$ENV{PATH}" TO_CMAKE_PATH_LIST TMP_CMAKE_ENV_PATH NORMALIZE)
    list(REMOVE_AT TMP_CMAKE_ENV_PATH 0)
    cmake_path(CONVERT "${TMP_CMAKE_ENV_PATH}" TO_NATIVE_PATH_LIST TMP_NATIVE_ENV_PATH NORMALIZE)
    set("ENV{PATH}" "${TMP_NATIVE_ENV_PATH}")
endif()

#[[if("${TOOLCHAIN}" AND "Windows" STREQUAL "${CMAKE_HOST_SYSTEM_NAME}" AND "msvc" STREQUAL "${CXX_COMPILER_NAME}")
    # do nothing
elseif(NOT "${TOOLCHAIN}" AND "Windows" STREQUAL "${CMAKE_HOST_SYSTEM_NAME}" AND "msvc" STREQUAL "${CXX_COMPILER_NAME}")
    if(
        "" STREQUAL "${${PROJECT_NAME}_MSVC_INCLUDE}"
        OR "" STREQUAL "${${PROJECT_NAME}_MSVC_LIBPATH}"
        OR "" STREQUAL "${${PROJECT_NAME}_MSVC_LIB}"
        OR "" STREQUAL "${${PROJECT_NAME}_MSVC_CL_PATH}"
        OR "" STREQUAL "${${PROJECT_NAME}_MSVC_RC_PATH}"
    )
        set_msvc_env("${PROJECT_NAME}" "" "" "${CXX_COMPILER_VERSION}" "${CXX_COMPILER_ARCH}" "${CXX_TARGET_ARCH}")
        set("${PROJECT_NAME}_MSVC_INCLUDE" "${${PROJECT_NAME}_MSVC_INCLUDE}" CACHE STRING "")
        set("${PROJECT_NAME}_MSVC_LIBPATH" "${${PROJECT_NAME}_MSVC_LIBPATH}" CACHE STRING "")
        set("${PROJECT_NAME}_MSVC_LIB" "${${PROJECT_NAME}_MSVC_LIB}" CACHE STRING "")
        set("${PROJECT_NAME}_MSVC_CL_PATH" "${${PROJECT_NAME}_MSVC_CL_PATH}" CACHE STRING "")
        set("${PROJECT_NAME}_MSVC_RC_PATH" "${${PROJECT_NAME}_MSVC_RC_PATH}" CACHE STRING "")
    endif()

    set("ENV{INCLUDE}" "${${PROJECT_NAME}_MSVC_INCLUDE}")
    set("ENV{LIBPATH}" "${${PROJECT_NAME}_MSVC_LIBPATH}")
    set("ENV{LIB}" "${${PROJECT_NAME}_MSVC_LIB}")
    set("ENV{PATH}" "${${PROJECT_NAME}_MSVC_CL_PATH}\;${${PROJECT_NAME}_MSVC_RC_PATH}\;$ENV{PATH}")

    set("CXX_INCLUDE_DIRECTORIES" "$ENV{INCLUDE}")
    set("CXX_LINK_DIRECTORIES" "$ENV{LIBPATH}" "$ENV{LIB}")
    cmake_path(CONVERT "${CXX_INCLUDE_DIRECTORIES}" TO_CMAKE_PATH_LIST CXX_INCLUDE_DIRECTORIES NORMALIZE)
    cmake_path(CONVERT "${CXX_LINK_DIRECTORIES}" TO_CMAKE_PATH_LIST CXX_LINK_DIRECTORIES NORMALIZE)

    include_directories(${CXX_INCLUDE_DIRECTORIES})
    link_directories(${CXX_LINK_DIRECTORIES})

    find_program(TMP_CMAKE_AR NAMES ${AR_NAMES} NO_CACHE)
    find_program(TMP_CMAKE_CXX_COMPILER NAMES ${CXX_COMPILER_NAMES} NO_CACHE)
    find_program(TMP_CMAKE_C_COMPILER NAMES ${C_COMPILER_NAMES} NO_CACHE)
    find_program(TMP_CMAKE_LINKER NAMES ${LINKER_NAMES} NO_CACHE)
    find_program(TMP_CMAKE_MT NAMES ${MT_NAMES} NO_CACHE)
    find_program(TMP_CMAKE_RC_COMPILER NAMES ${RC_COMPILER_NAMES} NO_CACHE)

    set("CMAKE_AR" "${TMP_CMAKE_AR}" CACHE FILEPATH "" FORCE)
    set("CMAKE_CXX_COMPILER" "${TMP_CMAKE_CXX_COMPILER}" CACHE FILEPATH "" FORCE)
    set("CMAKE_C_COMPILER" "${TMP_CMAKE_C_COMPILER}" CACHE FILEPATH "" FORCE)
    set("CMAKE_LINKER" "${TMP_CMAKE_LINKER}" CACHE FILEPATH "" FORCE)
    set("CMAKE_MT" "${TMP_CMAKE_MT}" CACHE FILEPATH "" FORCE)
    set("CMAKE_RC_COMPILER" "${TMP_CMAKE_RC_COMPILER}" CACHE FILEPATH "" FORCE)
endif()

find_program(TMP_CONAN_COMMAND NAMES "conan.exe" "conan" NO_CACHE)
find_program(TMP_DOXYGEN_COMMAND NAMES "doxygen.exe" "doxygen" NO_CACHE)

set("CONAN_COMMAND" "${TMP_CONAN_COMMAND}" CACHE FILEPATH "" FORCE)
set("DOXYGEN_COMMAND" "${TMP_DOXYGEN_COMMAND}" CACHE FILEPATH "" FORCE)]]

find_program(CONAN_COMMAND NAMES "conan.exe" "conan" REQUIRED)
find_program(DOXYGEN_COMMAND NAMES "doxygen.exe" "doxygen" REQUIRED)

enable_language("C")
enable_language("CXX")

set(CMAKE_OBJECT_PATH_MAX 1000)
set(CMAKE_SHARED_LIBRARY_PREFIX "")
set(CMAKE_SHARED_MODULE_PREFIX "")
set(CMAKE_STATIC_LIBRARY_PREFIX "")
set(CMAKE_IMPORT_LIBRARY_PREFIX "")
set(CMAKE_STAGING_PREFIX "")
set(CMAKE_FIND_LIBRARY_PREFIXES "")
set(CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH FALSE)
set(CMAKE_FIND_USE_CMAKE_SYSTEM_PATH FALSE)
set(CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH TRUE)
set(CMAKE_FIND_USE_SYSTEM_PACKAGE_REGISTRY FALSE)
set(CMAKE_FIND_USE_PACKAGE_REGISTRY FALSE)
set(CMAKE_FIND_USE_PACKAGE_ROOT_PATH FALSE)
set(CMAKE_FIND_USE_CMAKE_PATH TRUE)
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG FALSE)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS FALSE)
set(CMAKE_CXX_VISIBILITY_PRESET "hidden")
set(CMAKE_VISIBILITY_INLINES_HIDDEN TRUE)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

if("${CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT}")
    set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/cmake-install" CACHE PATH "..." FORCE)
endif()

separate_arguments(CMAKE_CXX_FLAGS NATIVE_COMMAND "${CMAKE_CXX_FLAGS}")
if(MSVC)
    if(NOT "/EHa" IN_LIST CMAKE_CXX_FLAGS AND "/EHsc" IN_LIST CMAKE_CXX_FLAGS)
        list(REMOVE_ITEM CMAKE_CXX_FLAGS "/EHsc")
        list(APPEND CMAKE_CXX_FLAGS "/EHa")
    endif()
endif()
string(JOIN " " CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

if("" STREQUAL "${CMAKE_MSVC_RUNTIME_LIBRARY}")
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded")
endif()

if("${BUILD_SHARED_LIBS}")
    set(CONAN_RELEASE_COMPILER_RUNTIME "MD")
else()
    set(CONAN_RELEASE_COMPILER_RUNTIME "MT")
    if("${MINGW}")
        set(CMAKE_CXX_STANDARD_LIBRARIES "-static-libgcc -static-libstdc++ ${CMAKE_CXX_STANDARD_LIBRARIES}")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Bstatic,--whole-archive -lwinpthread -Wl,--no-whole-archive")
    endif()
endif()

set_python_boolean(CONAN_BUILD_SHARED_LIBS "${BUILD_SHARED_LIBS}")
set_conan_msvc_compiler_runtime(CONAN_COMPILER_RUNTIME "${CMAKE_MSVC_RUNTIME_LIBRARY}")

set(CMAKE_VERBOSE_MAKEFILE TRUE CACHE BOOL "" FORCE)
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE CACHE BOOL "" FORCE)

set(TARGET_CMAKE_INSTALL_DEPENDS_ON "cmake-test")
option(SKIP_CMAKE_TEST "..." FALSE)
if(${SKIP_CMAKE_TEST})
    set(TARGET_CMAKE_INSTALL_DEPENDS_ON "${PROJECT_NAME}")
endif()
