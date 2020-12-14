# set '${USER_HOME}'
if(WIN32)
    string(REPLACE "\\" "/" USER_HOME "$ENV{USERPROFILE}")
elseif(UNIX)
    set(USER_HOME "$ENV{HOME}")
else()
    message(FATAL_ERROR "Can't set USER_HOME")
endif()

# set install path to '${USER_HOME}/.cmake/packages'
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${USER_HOME}/.cmake/packages" CACHE PATH "..." FORCE)
    set(CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}" CACHE PATH "..." FORCE)
endif()

# define container 'EXPORT_DIRECTORIES'
set(EXPORT_DIRECTORIES)

# define macro 'export_directories'
macro(export_directories dirs)
    include_directories("${dirs}")
    list(APPEND EXPORT_DIRECTORIES "${dirs}")
    list(REMOVE_DUPLICATES EXPORT_DIRECTORIES)
endmacro()

# define container 'EXPORT_LIBRARIES'
set(EXPORT_LIBRARIES)

# define macro 'export_library'
macro(export_library name)
    list(APPEND EXPORT_LIBRARIES "${name}")
    list(REMOVE_DUPLICATES EXPORT_LIBRARIES)
endmacro()

# define container 'DEPENDENCIES'
set(DEPENDENCIES)

# define macro 'dependency'
macro(dependency name version url)
    set("DEPENDENCY_${name}_NAME" ${name})
    set("DEPENDENCY_${name}_VERSION" ${version})
    set("DEPENDENCY_${name}_URL" ${url})

    list(APPEND DEPENDENCIES "DEPENDENCY_${name}")
    list(REMOVE_DUPLICATES DEPENDENCIES)
endmacro()

# enable module 'FetchContent'
include(FetchContent)

# define macro 'dependencies'
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

        get_directory_property("${dep}_EXPORT_DIRECTORIES" DIRECTORY ${${${dep}_NAME}_SOURCE_DIR} DEFINITION EXPORT_DIRECTORIES)
        foreach(d "${${dep}_EXPORT_DIRECTORIES}")
            message(STATUS "include_directory: ${${${dep}_NAME}_SOURCE_DIR}/${d}")
            include_directories("${${${dep}_NAME}_SOURCE_DIR}/${d}")
        endforeach()

        get_directory_property("${dep}_EXPORT_LIBRARIES" DIRECTORY ${${${dep}_NAME}_SOURCE_DIR} DEFINITION EXPORT_LIBRARIES)

    endforeach()
endmacro()
