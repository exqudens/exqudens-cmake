# set install path to '${HOME}/.cmake/packages'
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    if(WIN32)
        string(REPLACE "\\" "/" USER_HOME "$ENV{USERPROFILE}")
        set(CMAKE_INSTALL_PREFIX "${USER_HOME}/.cmake/packages" CACHE PATH "..." FORCE)
        set(CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}" CACHE PATH "..." FORCE)
    elseif(UNIX)
        set(USER_HOME "$ENV{HOME}" CACHE PATH "..." FORCE)
        set(CMAKE_INSTALL_PREFIX "${USER_HOME}/.cmake/packages" CACHE PATH "..." FORCE)
        set(CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}" CACHE PATH "..." FORCE)
    endif()
endif()

# define macro 'dependency' ---

set(DEPENDENCIES "")

macro(dependency name version url)
    set("DEPENDENCY_${name}_NAME" ${name})
    set("DEPENDENCY_${name}_VERSION" ${version})
    set("DEPENDENCY_${name}_URL" ${url})
    list(APPEND DEPENDENCIES "DEPENDENCY_${name}")
endmacro()

# define macro 'dependencies' ---

include(FetchContent)

macro(dependencies)
    foreach(dep ${DEPENDENCIES})
        if(NOT EXISTS "${CMAKE_INSTALL_PREFIX}/../downloads/${${dep}_NAME}-${${dep}_VERSION}.zip")
            message(STATUS "download: ${${dep}_URL} to ${CMAKE_INSTALL_PREFIX}/../downloads/${${dep}_NAME}-${${dep}_VERSION}.zip")
            file(DOWNLOAD "${${dep}_URL}" "${CMAKE_INSTALL_PREFIX}/../downloads/${${dep}_NAME}-${${dep}_VERSION}.zip")
        endif()
        message(STATUS "link: ${${dep}_NAME}")
        FetchContent_Declare(
                "${${dep}_NAME}"
                URL "file://${CMAKE_INSTALL_PREFIX}/../downloads/${${dep}_NAME}-${${dep}_VERSION}.zip"
        )
        FetchContent_MakeAvailable("${${dep}_NAME}")
        #get_directory_property(dep_include DIRECTORY ${${dep_name}_SOURCE_DIR} DEFINITION LIBRARY_NAME)
        #message(STATUS "var_1: ${dep_include}")
        include_directories(${${${dep}_NAME}_SOURCE_DIR}/src/main/cpp)
    endforeach()
endmacro()
