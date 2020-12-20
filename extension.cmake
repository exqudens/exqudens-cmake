# define macro 'message_status'
macro(message_status string)
    message(STATUS "${string}")
endmacro()

# define macro 'message_fatal_error'
macro(message_fatal_error string)
    message(FATAL_ERROR "${string}")
endmacro()

# define macro 'set_home_prefix'
macro(set_home_prefix)
    if(${ARGC} EQUAL 0)
        if(WIN32)
            string(REPLACE "\\" "/" HOME_PREFIX "$ENV{USERPROFILE}")
        elseif(UNIX)
            set(HOME_PREFIX "$ENV{HOME}")
        else()
            message_fatal_error("Can't set HOME_PREFIX")
        endif()
    elseif("${ARGV0}" MATCHES "^$")
        set(HOME_PREFIX "")
    elseif("${ARGV0}" MATCHES "^[ \t\r\n]+.")
        message_status("Path starts with whitespace: '${ARGV0}'")
    elseif(NOT EXISTS "${ARGV0}")
        message_status("Not exists: '${ARGV0}'")
    elseif(NOT IS_DIRECTORY "${ARGV0}")
        message_status("Not is directory: '${ARGV0}'")
    else()
        set(HOME_PREFIX "${ARGV0}")
    endif()
endmacro()

# define macro 'set_packages_prefix'
macro(set_packages_prefix)
    if(NOT DEFINED "${DEFAULT_INSTALL_PREFIX}")
        set(
            DEFAULT_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}"
            CACHE
            PATH
            "Default CMAKE_INSTALL_PREFIX"
            FORCE
        )
    endif()
    if(${ARGC} EQUAL 0)
        set(CMAKE_INSTALL_PREFIX "${DEFAULT_INSTALL_PREFIX}")
    elseif("${ARGV0}" MATCHES "^$")
        set(CMAKE_INSTALL_PREFIX "")
    elseif("${ARGV0}" MATCHES "^[ \t\r\n]+.")
        message_status("Path starts with whitespace: '${ARGV0}'")
    elseif(NOT EXISTS "${ARGV0}")
        message_status("Not exists: '${ARGV0}'")
    elseif(NOT IS_DIRECTORY "${ARGV0}")
        message_status("Not is directory: '${ARGV0}'")
    else()
        set(CMAKE_INSTALL_PREFIX "${ARGV0}")
    endif()
endmacro()

# define macro 'set_downloads_prefix'
macro(set_downloads_prefix)
    if(${ARGC} EQUAL 0)
        set(DOWNLOADS_PREFIX "")
    elseif("${ARGV0}" MATCHES "^$")
        set(DOWNLOADS_PREFIX "")
    elseif("${ARGV0}" MATCHES "^[ \t\r\n]+.")
        message_status("Path starts with whitespace: '${ARGV0}'")
    elseif(NOT EXISTS "${ARGV0}")
        message_status("Not exists: '${ARGV0}'")
    elseif(NOT IS_DIRECTORY "${ARGV0}")
        message_status("Not is directory: '${ARGV0}'")
    else()
        set(DOWNLOADS_PREFIX "${ARGV0}")
    endif()
endmacro()

# define macro 'init'
macro(init)
    if(${ARGC} EQUAL 0)
        set_home_prefix()
        set_packages_prefix(${HOME_PREFIX}/.cmake/packages)
        set_downloads_prefix(${HOME_PREFIX}/.cmake/downloads)
    elseif("${ARGV0}" MATCHES "^$")
        set_home_prefix("")
        set_packages_prefix(${HOME_PREFIX}/.cmake/packages)
        set_downloads_prefix(${HOME_PREFIX}/.cmake/downloads)
    elseif("${ARGV0}" MATCHES "^[ \t\r\n]+.")
        message_status("Path starts with whitespace: '${ARGV0}'")
    elseif(NOT EXISTS "${ARGV0}")
        message_status("Not exists: '${ARGV0}'")
    elseif(NOT IS_DIRECTORY "${ARGV0}")
        message_status("Not is directory: '${ARGV0}'")
    else()
        set_home_prefix("${ARGV0}")
        set_packages_prefix(${HOME_PREFIX}/.cmake/packages)
        set_downloads_prefix(${HOME_PREFIX}/.cmake/downloads)
    endif()
endmacro()

# define macro 'download'
macro(download file_name url)
    if(NOT EXISTS "${DOWNLOADS_PREFIX}/${file_name}")
        file(DOWNLOAD "${url}" "${DOWNLOADS_PREFIX}/${file_name}")
    endif()
endmacro()

# define container 'EXPORT_DIRECTORIES'
#set(EXPORT_DIRECTORIES)

# define macro 'export_directories'
#macro(export_directories dirs)
#    include_directories("${dirs}")
#    list(APPEND EXPORT_DIRECTORIES "${dirs}")
#    list(REMOVE_DUPLICATES EXPORT_DIRECTORIES)
#endmacro()

# define container 'EXPORT_LIBRARIES'
#set(EXPORT_LIBRARIES)

# define macro 'export_libraries'
#macro(export_libraries names)
#    list(APPEND EXPORT_LIBRARIES "${names}")
#    list(REMOVE_DUPLICATES EXPORT_LIBRARIES)
#endmacro()

# define container 'DEPENDENCIES'
#set(DEPENDENCIES)

# define macro 'dependency'
#macro(dependency name version url)
#    set("DEPENDENCY_${name}_NAME" ${name})
#    set("DEPENDENCY_${name}_VERSION" ${version})
#    set("DEPENDENCY_${name}_URL" ${url})
#
#    list(APPEND DEPENDENCIES "DEPENDENCY_${name}")
#    list(REMOVE_DUPLICATES DEPENDENCIES)
#endmacro()

# enable module 'FetchContent'
#include(FetchContent)

# define macro 'dependencies'
#macro(dependencies)
#    foreach(dep ${DEPENDENCIES})
#
#        if(NOT EXISTS "${CMAKE_INSTALL_PREFIX}/../downloads/${${dep}_NAME}-${${dep}_VERSION}.zip")
#            message(STATUS "download: ${${dep}_URL} to ${CMAKE_INSTALL_PREFIX}/../downloads/${${dep}_NAME}-${${dep}_VERSION}.zip")
#            file(DOWNLOAD "${${dep}_URL}" "${CMAKE_INSTALL_PREFIX}/../downloads/${${dep}_NAME}-${${dep}_VERSION}.zip")
#        endif()
#
#        message(STATUS "link: ${${dep}_NAME}")
#
#        FetchContent_Declare(
#                "${${dep}_NAME}"
#                URL "file://${CMAKE_INSTALL_PREFIX}/../downloads/${${dep}_NAME}-${${dep}_VERSION}.zip"
#        )
#        FetchContent_MakeAvailable("${${dep}_NAME}")
#
#        get_directory_property("${dep}_EXPORT_DIRECTORIES" DIRECTORY ${${${dep}_NAME}_SOURCE_DIR} DEFINITION EXPORT_DIRECTORIES)
#        foreach(d "${${dep}_EXPORT_DIRECTORIES}")
#            message(STATUS "include_directory: ${${${dep}_NAME}_SOURCE_DIR}/${d}")
#            include_directories("${${${dep}_NAME}_SOURCE_DIR}/${d}")
#        endforeach()
#
#        get_directory_property("${dep}_EXPORT_LIBRARIES" DIRECTORY ${${${dep}_NAME}_SOURCE_DIR} DEFINITION EXPORT_LIBRARIES)
#
#    endforeach()
#endmacro()
