# set include once
include_guard()

# enable extensions
include(FindPkgConfig)
include(FetchContent)

# set variables
set(LOAD_DEPENDENCY_DEFAULT_CONFIGURE_COMMAND ${CMAKE_COMMAND})
set(LOAD_DEPENDENCY_DEFAULT_CONFIGURE_COMMAND_ARGS
    "-DCMAKE_PREFIX_PATH={{{PREFIX_PATH}}}"
    "-DCMAKE_INSTALL_PREFIX={{{PACKAGES_PREFIX}}}/{{{PACKAGE_DIRECTORY_NAME}}}"
    "-G"
    "{{{GENERATOR}}}"
    "-S"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_DIRECTORY_NAME}}}/src"
    "-B"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_DIRECTORY_NAME}}}/build"
)
set(LOAD_DEPENDENCY_DEFAULT_BUILD_COMMAND ${CMAKE_COMMAND})
set(LOAD_DEPENDENCY_DEFAULT_BUILD_COMMAND_ARGS
    "--build"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_DIRECTORY_NAME}}}/build"
    "--target"
    "all"
    "--"
    "-j"
    "3"
)
set(LOAD_DEPENDENCY_DEFAULT_TEST_COMMAND ${CMAKE_COMMAND})
set(LOAD_DEPENDENCY_DEFAULT_TEST_COMMAND_ARGS
    "--build"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_DIRECTORY_NAME}}}/build"
    "--target"
    "test"
    "--"
    "-j"
    "3"
)
set(LOAD_DEPENDENCY_DEFAULT_INSTALL_COMMAND ${CMAKE_COMMAND})
set(LOAD_DEPENDENCY_DEFAULT_INSTALL_COMMAND_ARGS
    "--build"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_DIRECTORY_NAME}}}/build"
    "--target"
    "install"
    "--"
    "-j"
    "3"
)

# define macro 'set_home_prefix'
macro(set_home_prefix)
    if(${ARGC} EQUAL 0)
        if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
            string(REPLACE "\\" "/" HOME_PREFIX "$ENV{USERPROFILE}")
        elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
            set(HOME_PREFIX "$ENV{HOME}")
        elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
            set(HOME_PREFIX "$ENV{HOME}")
        else()
            message(
                FATAL_ERROR
                "Can't set 'HOME_PREFIX' for CMAKE_HOST_SYSTEM_NAME: '${CMAKE_HOST_SYSTEM_NAME}'"
            )
        endif()
    elseif("" STREQUAL "${ARGV0}")
        message(FATAL_ERROR "Empty value: '${ARGV0}'")
    elseif("${ARGV0}" MATCHES "^[ \t\r\n]+.")
        message(FATAL_ERROR "Path starts with whitespace: '${ARGV0}'")
    elseif(NOT EXISTS "${ARGV0}")
        message(FATAL_ERROR "Not exists: '${ARGV0}'")
    elseif(NOT IS_DIRECTORY "${ARGV0}")
        message(FATAL_ERROR "Not is directory: '${ARGV0}'")
    else()
        set(HOME_PREFIX "${ARGV0}")
    endif()
endmacro()

# define macro 'set_downloads_prefix'
macro(set_downloads_prefix)
    if(${ARGC} EQUAL 0)
        message(FATAL_ERROR "Not allowed without arguments!")
    elseif("" STREQUAL "${ARGV0}")
        message(FATAL_ERROR "Empty value: '${ARGV0}'")
    elseif("${ARGV0}" MATCHES "^[ \t\r\n]+.")
        message(FATAL_ERROR "Path starts with whitespace: '${ARGV0}'")
    elseif(NOT EXISTS "${ARGV0}")
        message(FATAL_ERROR "Not exists: '${ARGV0}'")
    elseif(NOT IS_DIRECTORY "${ARGV0}")
        message(FATAL_ERROR "Not is directory: '${ARGV0}'")
    else()
        set(DOWNLOADS_PREFIX "${ARGV0}")
    endif()
endmacro()

# define macro 'set_packages_prefix'
macro(set_packages_prefix)
    if(${ARGC} EQUAL 0)
        message(FATAL_ERROR "Not allowed without arguments!")
    elseif("" STREQUAL "${ARGV0}")
        message(FATAL_ERROR "Empty value: '${ARGV0}'")
    elseif("${ARGV0}" MATCHES "^[ \t\r\n]+.")
        message(FATAL_ERROR "Path starts with whitespace: '${ARGV0}'")
    elseif(NOT EXISTS "${ARGV0}")
        message(FATAL_ERROR "Not exists: '${ARGV0}'")
    elseif(NOT IS_DIRECTORY "${ARGV0}")
        message(FATAL_ERROR "Not is directory: '${ARGV0}'")
    else()
        set(PACKAGES_PREFIX "${ARGV0}")
    endif()
endmacro()

# define macro 'init'
macro(init)
    if(${ARGC} EQUAL 0)
        set_home_prefix()
        set_packages_prefix(${HOME_PREFIX}/.cmake/packages)
        set_downloads_prefix(${HOME_PREFIX}/.cmake/downloads)
    elseif(${ARGC} EQUAL 3)
        set_home_prefix("${ARGV0}")
        set_packages_prefix("${ARGV1}")
        set_downloads_prefix("${ARGV2}")
    elseif("" STREQUAL "${ARGV0}")
        set_home_prefix("")
        set_packages_prefix(${HOME_PREFIX}/.cmake/packages)
        set_downloads_prefix(${HOME_PREFIX}/.cmake/downloads)
    elseif("${ARGV0}" MATCHES "^[ \t\r\n]+.")
        message(STATUS "Path starts with whitespace: '${ARGV0}'")
    elseif(NOT EXISTS "${ARGV0}")
        message(STATUS "Not exists: '${ARGV0}'")
    elseif(NOT IS_DIRECTORY "${ARGV0}")
        message(STATUS "Not is directory: '${ARGV0}'")
    else()
        set_home_prefix("${ARGV0}")
        set_packages_prefix(${HOME_PREFIX}/.cmake/packages)
        set_downloads_prefix(${HOME_PREFIX}/.cmake/downloads)
    endif()
endmacro()

# define function 'dependency'
function(dependency)
    list(APPEND CMAKE_MESSAGE_CONTEXT "dependency")

    set(options OPTIONAL)
    set(oneValueArgs
        NAME
        VERSION
        PACKAGE_DIRECTORY_NAME
        PACKAGE_NAME
        PACKAGE_VERSION
        DOWNLOADS_PREFIX
        PACKAGES_PREFIX
        URL_SCHEMA
        URL_HOST
        URL_MD5
        DOWNLOAD_DIRECTORY_NAME
        DOWNLOAD_FILE_NAME
        PRE_COMMAND_0
        PRE_COMMAND_1
        PRE_COMMAND_2
        PRE_COMMAND_3
        PRE_COMMAND_4
        PRE_COMMAND_5
        PRE_COMMAND_6
        PRE_COMMAND_7
        PRE_COMMAND_8
        PRE_COMMAND_9
        PRE_COMMAND_0_WORKING_DIRECTORY
        PRE_COMMAND_1_WORKING_DIRECTORY
        PRE_COMMAND_2_WORKING_DIRECTORY
        PRE_COMMAND_3_WORKING_DIRECTORY
        PRE_COMMAND_4_WORKING_DIRECTORY
        PRE_COMMAND_5_WORKING_DIRECTORY
        PRE_COMMAND_6_WORKING_DIRECTORY
        PRE_COMMAND_7_WORKING_DIRECTORY
        PRE_COMMAND_8_WORKING_DIRECTORY
        PRE_COMMAND_9_WORKING_DIRECTORY
        CONFIGURE_COMMAND
        BUILD_COMMAND
        TEST_COMMAND
        INSTALL_COMMAND
        POST_COMMAND_0
        POST_COMMAND_1
        POST_COMMAND_2
        POST_COMMAND_3
        POST_COMMAND_4
        POST_COMMAND_5
        POST_COMMAND_6
        POST_COMMAND_7
        POST_COMMAND_8
        POST_COMMAND_9
        POST_COMMAND_0_WORKING_DIRECTORY
        POST_COMMAND_1_WORKING_DIRECTORY
        POST_COMMAND_2_WORKING_DIRECTORY
        POST_COMMAND_3_WORKING_DIRECTORY
        POST_COMMAND_4_WORKING_DIRECTORY
        POST_COMMAND_5_WORKING_DIRECTORY
        POST_COMMAND_6_WORKING_DIRECTORY
        POST_COMMAND_7_WORKING_DIRECTORY
        POST_COMMAND_8_WORKING_DIRECTORY
        POST_COMMAND_9_WORKING_DIRECTORY
        SKIP_CONFIG
        SKIP_BUILD
        SKIP_TEST
        SKIP_INSTALL
        USE_PKG_CONFIG
    )
    set(multiValueArgs
        PREFIX_PATH
        PRE_COMMAND_0_ARGS
        PRE_COMMAND_1_ARGS
        PRE_COMMAND_2_ARGS
        PRE_COMMAND_3_ARGS
        PRE_COMMAND_4_ARGS
        PRE_COMMAND_5_ARGS
        PRE_COMMAND_6_ARGS
        PRE_COMMAND_7_ARGS
        PRE_COMMAND_8_ARGS
        PRE_COMMAND_9_ARGS
        CONFIGURE_COMMAND_ARGS
        BUILD_COMMAND_ARGS
        TEST_COMMAND_ARGS
        INSTALL_COMMAND_ARGS
        POST_COMMAND_0_ARGS
        POST_COMMAND_1_ARGS
        POST_COMMAND_2_ARGS
        POST_COMMAND_3_ARGS
        POST_COMMAND_4_ARGS
        POST_COMMAND_5_ARGS
        POST_COMMAND_6_ARGS
        POST_COMMAND_7_ARGS
        POST_COMMAND_8_ARGS
        POST_COMMAND_9_ARGS
    )
    cmake_parse_arguments(PARSE_ARGV 0 DEPENDENCY "${options}" "${oneValueArgs}" "${multiValueArgs}")

    # short path -----------------------------------------------------------------------

    # config -----------------------------------------------------------------------

    # process -----------------------------------------------------------------------

    # update 'CMAKE_PREFIX_PATH'
    file(GLOB PACKAGES_LS LIST_DIRECTORIES TRUE "${DEPENDENCY_PACKAGES_PREFIX}/*")
    set(PACKAGES)
    foreach(f ${PACKAGES_LS})
        if(IS_DIRECTORY "${f}")
            list(APPEND PACKAGES "${f}")
        endif()
    endforeach()
    unset(PACKAGES_LS)
    set(NEW_CMAKE_PREFIX_PATH)
    foreach(f ${PACKAGES})
        list(APPEND NEW_CMAKE_PREFIX_PATH "${f}")
        list(REMOVE_DUPLICATES NEW_CMAKE_PREFIX_PATH)
    endforeach()
    unset(PACKAGES)
    set(CMAKE_PREFIX_PATH "${NEW_CMAKE_PREFIX_PATH}")
    set(CMAKE_PREFIX_PATH "${NEW_CMAKE_PREFIX_PATH}" PARENT_SCOPE)
    unset(NEW_CMAKE_PREFIX_PATH)

    # check one '${DEPENDENCY_NAME}' type 'QUIET'
    if(DEFINED DEPENDENCY_VERSION)
        if(DEPENDENCY_USE_PKG_CONFIG)
            pkg_search_module("${DEPENDENCY_NAME}"
                "${DEPENDENCY_NAME}-${DEPENDENCY_VERSION}"
                "${DEPENDENCY_NAME}${DEPENDENCY_VERSION}"
                "${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_VERSION}"
                "${DEPENDENCY_PACKAGE_NAME}${DEPENDENCY_VERSION}"
                )
        else()
            find_package("${DEPENDENCY_NAME}" "${DEPENDENCY_VERSION}" QUIET)
        endif()
    else()
        if(DEPENDENCY_USE_PKG_CONFIG)
            pkg_search_module("${DEPENDENCY_NAME}"
                "${DEPENDENCY_NAME}"
                "${DEPENDENCY_PACKAGE_NAME}"
                )
        else()
            find_package("${DEPENDENCY_NAME}" QUIET)
        endif()
    endif()

    # build if not found '${DEPENDENCY_NAME}'
    load_dependency(
        SKIP                             ${${DEPENDENCY_NAME}_FOUND}
        SKIP_CONFIG                      ${DEPENDENCY_SKIP_CONFIG}
        SKIP_BUILD                       ${DEPENDENCY_SKIP_BUILD}
        SKIP_TEST                        ${DEPENDENCY_SKIP_TEST}
        SKIP_INSTALL                     ${DEPENDENCY_SKIP_INSTALL}
        PREFIX_PATH                      ${DEPENDENCY_PREFIX_PATH}
        DIRECTORY_NAME                   ${DEPENDENCY_PACKAGE_DIRECTORY_NAME}
        NAME                             ${DEPENDENCY_PACKAGE_NAME}
        VERSION                          ${DEPENDENCY_PACKAGE_VERSION}
        DOWNLOADS_PREFIX                 ${DEPENDENCY_DOWNLOADS_PREFIX}
        PACKAGES_PREFIX                  ${DEPENDENCY_PACKAGES_PREFIX}
        URL_SCHEMA                       ${DEPENDENCY_URL_SCHEMA}
        URL_HOST                         ${DEPENDENCY_URL_HOST}
        URL_MD5                          ${DEPENDENCY_URL_MD5}
        DOWNLOAD_DIRECTORY_NAME          ${DEPENDENCY_DOWNLOAD_DIRECTORY_NAME}
        DOWNLOAD_FILE_NAME               ${DEPENDENCY_DOWNLOAD_FILE_NAME}
        PRE_COMMAND_0                    ${DEPENDENCY_PRE_COMMAND_0}
        PRE_COMMAND_1                    ${DEPENDENCY_PRE_COMMAND_1}
        PRE_COMMAND_2                    ${DEPENDENCY_PRE_COMMAND_2}
        PRE_COMMAND_3                    ${DEPENDENCY_PRE_COMMAND_3}
        PRE_COMMAND_4                    ${DEPENDENCY_PRE_COMMAND_4}
        PRE_COMMAND_5                    ${DEPENDENCY_PRE_COMMAND_5}
        PRE_COMMAND_6                    ${DEPENDENCY_PRE_COMMAND_6}
        PRE_COMMAND_7                    ${DEPENDENCY_PRE_COMMAND_7}
        PRE_COMMAND_8                    ${DEPENDENCY_PRE_COMMAND_8}
        PRE_COMMAND_9                    ${DEPENDENCY_PRE_COMMAND_9}
        PRE_COMMAND_0_ARGS               ${DEPENDENCY_PRE_COMMAND_0_ARGS}
        PRE_COMMAND_1_ARGS               ${DEPENDENCY_PRE_COMMAND_1_ARGS}
        PRE_COMMAND_2_ARGS               ${DEPENDENCY_PRE_COMMAND_2_ARGS}
        PRE_COMMAND_3_ARGS               ${DEPENDENCY_PRE_COMMAND_3_ARGS}
        PRE_COMMAND_4_ARGS               ${DEPENDENCY_PRE_COMMAND_4_ARGS}
        PRE_COMMAND_5_ARGS               ${DEPENDENCY_PRE_COMMAND_5_ARGS}
        PRE_COMMAND_6_ARGS               ${DEPENDENCY_PRE_COMMAND_6_ARGS}
        PRE_COMMAND_7_ARGS               ${DEPENDENCY_PRE_COMMAND_7_ARGS}
        PRE_COMMAND_8_ARGS               ${DEPENDENCY_PRE_COMMAND_8_ARGS}
        PRE_COMMAND_9_ARGS               ${DEPENDENCY_PRE_COMMAND_9_ARGS}
        PRE_COMMAND_0_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_0_WORKING_DIRECTORY}
        PRE_COMMAND_1_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_1_WORKING_DIRECTORY}
        PRE_COMMAND_2_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_2_WORKING_DIRECTORY}
        PRE_COMMAND_3_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_3_WORKING_DIRECTORY}
        PRE_COMMAND_4_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_4_WORKING_DIRECTORY}
        PRE_COMMAND_5_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_5_WORKING_DIRECTORY}
        PRE_COMMAND_6_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_6_WORKING_DIRECTORY}
        PRE_COMMAND_7_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_7_WORKING_DIRECTORY}
        PRE_COMMAND_8_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_8_WORKING_DIRECTORY}
        PRE_COMMAND_9_WORKING_DIRECTORY  ${DEPENDENCY_PRE_COMMAND_9_WORKING_DIRECTORY}
        CONFIGURE_COMMAND                ${DEPENDENCY_CONFIGURE_COMMAND}
        BUILD_COMMAND                    ${DEPENDENCY_BUILD_COMMAND}
        TEST_COMMAND                     ${DEPENDENCY_TEST_COMMAND}
        INSTALL_COMMAND                  ${DEPENDENCY_INSTALL_COMMAND}
        CONFIGURE_COMMAND_ARGS           ${DEPENDENCY_CONFIGURE_COMMAND_ARGS}
        BUILD_COMMAND_ARGS               ${DEPENDENCY_BUILD_COMMAND_ARGS}
        TEST_COMMAND_ARGS                ${DEPENDENCY_TEST_COMMAND_ARGS}
        INSTALL_COMMAND_ARGS             ${DEPENDENCY_INSTALL_COMMAND_ARGS}
        POST_COMMAND_0                   ${DEPENDENCY_POST_COMMAND_0}
        POST_COMMAND_1                   ${DEPENDENCY_POST_COMMAND_1}
        POST_COMMAND_2                   ${DEPENDENCY_POST_COMMAND_2}
        POST_COMMAND_3                   ${DEPENDENCY_POST_COMMAND_3}
        POST_COMMAND_4                   ${DEPENDENCY_POST_COMMAND_4}
        POST_COMMAND_5                   ${DEPENDENCY_POST_COMMAND_5}
        POST_COMMAND_6                   ${DEPENDENCY_POST_COMMAND_6}
        POST_COMMAND_7                   ${DEPENDENCY_POST_COMMAND_7}
        POST_COMMAND_8                   ${DEPENDENCY_POST_COMMAND_8}
        POST_COMMAND_9                   ${DEPENDENCY_POST_COMMAND_9}
        POST_COMMAND_0_ARGS              ${DEPENDENCY_POST_COMMAND_0_ARGS}
        POST_COMMAND_1_ARGS              ${DEPENDENCY_POST_COMMAND_1_ARGS}
        POST_COMMAND_2_ARGS              ${DEPENDENCY_POST_COMMAND_2_ARGS}
        POST_COMMAND_3_ARGS              ${DEPENDENCY_POST_COMMAND_3_ARGS}
        POST_COMMAND_4_ARGS              ${DEPENDENCY_POST_COMMAND_4_ARGS}
        POST_COMMAND_5_ARGS              ${DEPENDENCY_POST_COMMAND_5_ARGS}
        POST_COMMAND_6_ARGS              ${DEPENDENCY_POST_COMMAND_6_ARGS}
        POST_COMMAND_7_ARGS              ${DEPENDENCY_POST_COMMAND_7_ARGS}
        POST_COMMAND_8_ARGS              ${DEPENDENCY_POST_COMMAND_8_ARGS}
        POST_COMMAND_9_ARGS              ${DEPENDENCY_POST_COMMAND_9_ARGS}
        POST_COMMAND_0_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_0_WORKING_DIRECTORY}
        POST_COMMAND_1_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_1_WORKING_DIRECTORY}
        POST_COMMAND_2_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_2_WORKING_DIRECTORY}
        POST_COMMAND_3_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_3_WORKING_DIRECTORY}
        POST_COMMAND_4_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_4_WORKING_DIRECTORY}
        POST_COMMAND_5_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_5_WORKING_DIRECTORY}
        POST_COMMAND_6_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_6_WORKING_DIRECTORY}
        POST_COMMAND_7_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_7_WORKING_DIRECTORY}
        POST_COMMAND_8_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_8_WORKING_DIRECTORY}
        POST_COMMAND_9_WORKING_DIRECTORY ${DEPENDENCY_POST_COMMAND_9_WORKING_DIRECTORY}
    )

    # update 'CMAKE_PREFIX_PATH'
    file(GLOB PACKAGES_LS LIST_DIRECTORIES TRUE "${DEPENDENCY_PACKAGES_PREFIX}/*")
    set(PACKAGES)
    foreach(f ${PACKAGES_LS})
        if(IS_DIRECTORY "${f}")
            list(APPEND PACKAGES "${f}")
        endif()
    endforeach()
    unset(PACKAGES_LS)
    set(NEW_CMAKE_PREFIX_PATH)
    foreach(f ${PACKAGES})
        list(APPEND NEW_CMAKE_PREFIX_PATH "${f}")
        list(REMOVE_DUPLICATES NEW_CMAKE_PREFIX_PATH)
    endforeach()
    unset(PACKAGES)
    set(CMAKE_PREFIX_PATH "${NEW_CMAKE_PREFIX_PATH}")
    set(CMAKE_PREFIX_PATH "${NEW_CMAKE_PREFIX_PATH}" PARENT_SCOPE)
    unset(NEW_CMAKE_PREFIX_PATH)

    # check two '${DEPENDENCY_NAME}' type 'REQUIRED'
    if(DEFINED DEPENDENCY_VERSION)
        if(DEPENDENCY_USE_PKG_CONFIG)
            pkg_search_module("${DEPENDENCY_NAME}"
                "${DEPENDENCY_NAME}-${DEPENDENCY_VERSION}"
                "${DEPENDENCY_NAME}${DEPENDENCY_VERSION}"
                "${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_VERSION}"
                "${DEPENDENCY_PACKAGE_NAME}${DEPENDENCY_VERSION}"
                )
            if(NOT ${${DEPENDENCY_NAME}_FOUND})
                message(FATAL_ERROR "ERROR: ${DEPENDENCY_NAME}-${DEPENDENCY_VERSION} (found: ${${DEPENDENCY_NAME}_FOUND})")
            endif()
        else()
            find_package("${DEPENDENCY_NAME}" "${DEPENDENCY_VERSION}" REQUIRED)
        endif()
    else()
        if(DEPENDENCY_USE_PKG_CONFIG)
            pkg_search_module("${DEPENDENCY_NAME}"
                "${DEPENDENCY_NAME}"
                "${DEPENDENCY_PACKAGE_NAME}"
                )
            if(NOT ${${DEPENDENCY_NAME}_FOUND})
                message(FATAL_ERROR "ERROR: ${DEPENDENCY_NAME} (found: ${${DEPENDENCY_NAME}_FOUND})")
            endif()
        else()
            find_package("${DEPENDENCY_NAME}" REQUIRED)
        endif()
    endif()

endfunction()

# define function 'load_dependency'
function(load_dependency)
    list(APPEND CMAKE_MESSAGE_CONTEXT "load_dependency")

    set(options)
    set(oneValueArgs
        DIRECTORY_NAME
        NAME
        VERSION
        DOWNLOADS_PREFIX
        PACKAGES_PREFIX
        URL_SCHEMA
        URL_HOST
        URL_MD5
        DOWNLOAD_DIRECTORY_NAME
        DOWNLOAD_FILE_NAME
        PRE_COMMAND_0
        PRE_COMMAND_1
        PRE_COMMAND_2
        PRE_COMMAND_3
        PRE_COMMAND_4
        PRE_COMMAND_5
        PRE_COMMAND_6
        PRE_COMMAND_7
        PRE_COMMAND_8
        PRE_COMMAND_9
        PRE_COMMAND_0_WORKING_DIRECTORY
        PRE_COMMAND_1_WORKING_DIRECTORY
        PRE_COMMAND_2_WORKING_DIRECTORY
        PRE_COMMAND_3_WORKING_DIRECTORY
        PRE_COMMAND_4_WORKING_DIRECTORY
        PRE_COMMAND_5_WORKING_DIRECTORY
        PRE_COMMAND_6_WORKING_DIRECTORY
        PRE_COMMAND_7_WORKING_DIRECTORY
        PRE_COMMAND_8_WORKING_DIRECTORY
        PRE_COMMAND_9_WORKING_DIRECTORY
        CONFIGURE_COMMAND
        BUILD_COMMAND
        TEST_COMMAND
        INSTALL_COMMAND
        POST_COMMAND_0
        POST_COMMAND_1
        POST_COMMAND_2
        POST_COMMAND_3
        POST_COMMAND_4
        POST_COMMAND_5
        POST_COMMAND_6
        POST_COMMAND_7
        POST_COMMAND_8
        POST_COMMAND_9
        POST_COMMAND_0_WORKING_DIRECTORY
        POST_COMMAND_1_WORKING_DIRECTORY
        POST_COMMAND_2_WORKING_DIRECTORY
        POST_COMMAND_3_WORKING_DIRECTORY
        POST_COMMAND_4_WORKING_DIRECTORY
        POST_COMMAND_5_WORKING_DIRECTORY
        POST_COMMAND_6_WORKING_DIRECTORY
        POST_COMMAND_7_WORKING_DIRECTORY
        POST_COMMAND_8_WORKING_DIRECTORY
        POST_COMMAND_9_WORKING_DIRECTORY
        SKIP
        SKIP_CONFIG
        SKIP_BUILD
        SKIP_TEST
        SKIP_INSTALL
    )
    set(multiValueArgs
        PREFIX_PATH
        PRE_COMMAND_0_ARGS
        PRE_COMMAND_1_ARGS
        PRE_COMMAND_2_ARGS
        PRE_COMMAND_3_ARGS
        PRE_COMMAND_4_ARGS
        PRE_COMMAND_5_ARGS
        PRE_COMMAND_6_ARGS
        PRE_COMMAND_7_ARGS
        PRE_COMMAND_8_ARGS
        PRE_COMMAND_9_ARGS
        CONFIGURE_COMMAND_ARGS
        BUILD_COMMAND_ARGS
        TEST_COMMAND_ARGS
        INSTALL_COMMAND_ARGS
        POST_COMMAND_0_ARGS
        POST_COMMAND_1_ARGS
        POST_COMMAND_2_ARGS
        POST_COMMAND_3_ARGS
        POST_COMMAND_4_ARGS
        POST_COMMAND_5_ARGS
        POST_COMMAND_6_ARGS
        POST_COMMAND_7_ARGS
        POST_COMMAND_8_ARGS
        POST_COMMAND_9_ARGS
    )
    cmake_parse_arguments(PARSE_ARGV 0 LOAD_DEPENDENCY "${options}" "${oneValueArgs}" "${multiValueArgs}")

    # short path -----------------------------------------------------------------------

    # check 'SKIP'
    if(LOAD_DEPENDENCY_SKIP)
        return()
    endif()

    # config -----------------------------------------------------------------------

    # set 'LOAD_DEPENDENCY_DOWNLOAD_DIRECTORY_NAME'
    if(NOT DEFINED LOAD_DEPENDENCY_DOWNLOAD_DIRECTORY_NAME OR "" STREQUAL "${LOAD_DEPENDENCY_DOWNLOAD_DIRECTORY_NAME}")
        set(LOAD_DEPENDENCY_DOWNLOAD_DIRECTORY_NAME "${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}")
    endif()

    # set 'LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME'
    if(NOT DEFINED LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME OR "" STREQUAL "${LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME}")
        if("${LOAD_DEPENDENCY_URL_HOST}" MATCHES "^.+\\.zip$")
            set(LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME "archive.zip")
        elseif("${LOAD_DEPENDENCY_URL_HOST}" MATCHES "^.+\\.tar\\.gz$")
            set(LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME "archive.tar.gz")
        else()
            string(REGEX REPLACE ".+/" "" LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME "${LOAD_DEPENDENCY_URL_HOST}")
        endif()
    endif()

    # set 'LOAD_DEPENDENCY_URL'
    if(EXISTS "${LOAD_DEPENDENCY_DOWNLOADS_PREFIX}/${LOAD_DEPENDENCY_DOWNLOAD_DIRECTORY_NAME}/${LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME}")
        set(LOAD_DEPENDENCY_URL "file://${LOAD_DEPENDENCY_DOWNLOADS_PREFIX}/${LOAD_DEPENDENCY_DOWNLOAD_DIRECTORY_NAME}/${LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME}")
    else()
        set(LOAD_DEPENDENCY_URL "${LOAD_DEPENDENCY_URL_SCHEMA}://${LOAD_DEPENDENCY_URL_HOST}")
    endif()

    # set 'LOAD_DEPENDENCY_DIRECTORY_NAME'
    if(NOT DEFINED LOAD_DEPENDENCY_DIRECTORY_NAME OR "" STREQUAL "${LOAD_DEPENDENCY_DIRECTORY_NAME}")
        set(LOAD_DEPENDENCY_DIRECTORY_NAME "${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}")
    endif()

    # set 'LOAD_DEPENDENCY_PRE_COMMAND_NAMES'
    set(LOAD_DEPENDENCY_PRE_COMMAND_NAMES
        "PRE_COMMAND_0"
        "PRE_COMMAND_1"
        "PRE_COMMAND_2"
        "PRE_COMMAND_3"
        "PRE_COMMAND_4"
        "PRE_COMMAND_5"
        "PRE_COMMAND_6"
        "PRE_COMMAND_7"
        "PRE_COMMAND_8"
        "PRE_COMMAND_9"
    )

    # set 'LOAD_DEPENDENCY_CONFIGURE_COMMAND'
    set(LOAD_DEPENDENCY_CONFIGURE_COMMAND "${LOAD_DEPENDENCY_DEFAULT_CONFIGURE_COMMAND}")

    # set 'LOAD_DEPENDENCY_CONFIGURE_COMMAND_ARGS'
    set(LOAD_DEPENDENCY_CONFIGURE_COMMAND_ARGS)
    foreach(arg ${LOAD_DEPENDENCY_DEFAULT_CONFIGURE_COMMAND_ARGS})
        if("" STREQUAL "${CMAKE_EXTRA_GENERATOR}")
            string(REPLACE "{{{GENERATOR}}}" "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}" arg "${arg}")
        else()
            string(REPLACE "{{{GENERATOR}}}" "${CMAKE_GENERATOR}" arg "${arg}")
        endif()
        string(REPLACE "{{{PREFIX_PATH}}}"           "${LOAD_DEPENDENCY_PREFIX_PATH}"     arg "${arg}")
        string(REPLACE "{{{PACKAGES_PREFIX}}}"       "${LOAD_DEPENDENCY_PACKAGES_PREFIX}" arg "${arg}")
        string(REPLACE "{{{PACKAGE_DIRECTORY_NAME}}}" "${LOAD_DEPENDENCY_DIRECTORY_NAME}" arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"           arg "${arg}")
        list(APPEND LOAD_DEPENDENCY_CONFIGURE_COMMAND_ARGS "${arg}")
    endforeach()

    # set 'LOAD_DEPENDENCY_BUILD_COMMAND'
    set(LOAD_DEPENDENCY_BUILD_COMMAND "${LOAD_DEPENDENCY_DEFAULT_BUILD_COMMAND}")

    # set 'LOAD_DEPENDENCY_BUILD_COMMAND_ARGS'
    set(LOAD_DEPENDENCY_BUILD_COMMAND_ARGS)
    foreach(arg ${LOAD_DEPENDENCY_DEFAULT_BUILD_COMMAND_ARGS})
        string(REPLACE "{{{PACKAGE_DIRECTORY_NAME}}}" "${LOAD_DEPENDENCY_DIRECTORY_NAME}" arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"           arg "${arg}")
        list(APPEND LOAD_DEPENDENCY_BUILD_COMMAND_ARGS "${arg}")
    endforeach()

    # set 'LOAD_DEPENDENCY_TEST_COMMAND'
    set(LOAD_DEPENDENCY_TEST_COMMAND "${LOAD_DEPENDENCY_DEFAULT_TEST_COMMAND}")

    # set 'LOAD_DEPENDENCY_TEST_COMMAND_ARGS'
    set(LOAD_DEPENDENCY_TEST_COMMAND_ARGS)
    foreach(arg ${LOAD_DEPENDENCY_DEFAULT_TEST_COMMAND_ARGS})
        string(REPLACE "{{{PACKAGE_DIRECTORY_NAME}}}" "${LOAD_DEPENDENCY_DIRECTORY_NAME}" arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"           arg "${arg}")
        list(APPEND LOAD_DEPENDENCY_TEST_COMMAND_ARGS "${arg}")
    endforeach()

    # set 'LOAD_DEPENDENCY_INSTALL_COMMAND'
    set(LOAD_DEPENDENCY_INSTALL_COMMAND "${LOAD_DEPENDENCY_DEFAULT_INSTALL_COMMAND}")

    # set 'LOAD_DEPENDENCY_INSTALL_COMMAND_ARGS'
    set(LOAD_DEPENDENCY_INSTALL_COMMAND_ARGS)
    foreach(arg ${LOAD_DEPENDENCY_DEFAULT_INSTALL_COMMAND_ARGS})
        string(REPLACE "{{{PACKAGE_DIRECTORY_NAME}}}" "${LOAD_DEPENDENCY_DIRECTORY_NAME}" arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"           arg "${arg}")
        list(APPEND LOAD_DEPENDENCY_INSTALL_COMMAND_ARGS "${arg}")
    endforeach()

    # set 'LOAD_DEPENDENCY_POST_COMMAND_NAMES'
    set(LOAD_DEPENDENCY_POST_COMMAND_NAMES
        "POST_COMMAND_0"
        "POST_COMMAND_1"
        "POST_COMMAND_2"
        "POST_COMMAND_3"
        "POST_COMMAND_4"
        "POST_COMMAND_5"
        "POST_COMMAND_6"
        "POST_COMMAND_7"
        "POST_COMMAND_8"
        "POST_COMMAND_9"
    )

    # process -----------------------------------------------------------------------

    # extract
    message(STATUS "--- extract '${LOAD_DEPENDENCY_NAME}' (start) ---")
    FetchContent_Declare("fetch_content_${LOAD_DEPENDENCY_NAME}"
        DOWNLOAD_DIR  "${LOAD_DEPENDENCY_DOWNLOADS_PREFIX}/${LOAD_DEPENDENCY_DOWNLOAD_DIRECTORY_NAME}"
        DOWNLOAD_NAME "${LOAD_DEPENDENCY_DOWNLOAD_FILE_NAME}"
        SOURCE_DIR    "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_DIRECTORY_NAME}/src"
        BINARY_DIR    "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_DIRECTORY_NAME}/build"
        SUBBUILD_DIR  "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_DIRECTORY_NAME}/subbuild"
        URL           "${LOAD_DEPENDENCY_URL}"
        URL_MD5       "${LOAD_DEPENDENCY_URL_MD5}"
        #CMAKE_ARGS    "-DCMAKE_INSTALL_PREFIX=${LOAD_DEPENDENCY_PACKAGES_PREFIX}/${LOAD_DEPENDENCY_DIRECTORY_NAME}"
        )
    FetchContent_GetProperties("fetch_content_${LOAD_DEPENDENCY_NAME}")
    if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_POPULATED})
        FetchContent_Populate("fetch_content_${LOAD_DEPENDENCY_NAME}")
    endif()
    if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_POPULATED})
        message(FATAL_ERROR "ERROR: 'fetch_content_${LOAD_DEPENDENCY_NAME}' not populated !!!")
    endif()
    message(STATUS "--- extract '${LOAD_DEPENDENCY_NAME}' (done) ---")

    # pre
    foreach(pre_command_name ${LOAD_DEPENDENCY_PRE_COMMAND_NAMES})
        if(NOT "" STREQUAL "${LOAD_DEPENDENCY_${pre_command_name}}")
            if("" STREQUAL "${LOAD_DEPENDENCY_${pre_command_name}_WORKING_DIRECTORY}")
                message(FATAL_ERROR "ERROR: '${pre_command_name}_WORKING_DIRECTORY' is empty !!!")
            endif()
            if("" STREQUAL "${LOAD_DEPENDENCY_${pre_command_name}_ARGS}")
                message(FATAL_ERROR "ERROR: '${pre_command_name}_ARGS' is empty !!!")
            endif()
            message(STATUS "--- ${pre_command_name} '${LOAD_DEPENDENCY_NAME}' (start) ---")
            execute_process(
                COMMAND           ${LOAD_DEPENDENCY_${pre_command_name}} ${LOAD_DEPENDENCY_${pre_command_name}_ARGS}
                WORKING_DIRECTORY "${LOAD_DEPENDENCY_${pre_command_name}_WORKING_DIRECTORY}"
                RESULT_VARIABLE   "${pre_command_name}_RESULT"
            )
            if(NOT ${${pre_command_name}_RESULT} EQUAL 0)
                message(
                    FATAL_ERROR
                    "ERROR: config '${pre_command_name}' exit code ${${pre_command_name}_RESULT} !!!"
                )
            endif()
            message(STATUS "--- ${pre_command_name} '${LOAD_DEPENDENCY_NAME}' (done) ---")
        endif()
    endforeach()

    # config
    if(LOAD_DEPENDENCY_SKIP_CONFIG)
        message(STATUS "Skipping config for '${LOAD_DEPENDENCY_NAME}'")
    else()
        message(STATUS "--- config '${LOAD_DEPENDENCY_NAME}' (start) ---")
        execute_process(
            COMMAND           ${LOAD_DEPENDENCY_CONFIGURE_COMMAND} ${LOAD_DEPENDENCY_CONFIGURE_COMMAND_ARGS}
            WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_DIRECTORY_NAME}"
            RESULT_VARIABLE   "fetch_content_${LOAD_DEPENDENCY_NAME}_CONFIG_RESULT"
        )
        if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_CONFIG_RESULT} EQUAL 0)
            message(
                FATAL_ERROR
                "ERROR: config 'fetch_content_${LOAD_DEPENDENCY_NAME}' exit code ${fetch_content_${LOAD_DEPENDENCY_NAME}_CONFIG_RESULT} !!!"
            )
        endif()
        message(STATUS "--- config '${LOAD_DEPENDENCY_NAME}' (done) ---")
    endif()

    # build
    if(LOAD_DEPENDENCY_SKIP_BUILD)
        message(STATUS "Skipping build for '${LOAD_DEPENDENCY_NAME}'")
    else()
        message(STATUS "--- build '${LOAD_DEPENDENCY_NAME}' (start) ---")
        execute_process(
            COMMAND           ${LOAD_DEPENDENCY_BUILD_COMMAND} ${LOAD_DEPENDENCY_BUILD_COMMAND_ARGS}
            WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_DIRECTORY_NAME}"
            RESULT_VARIABLE   "fetch_content_${LOAD_DEPENDENCY_NAME}_BUILD_RESULT"
        )
        if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_BUILD_RESULT} EQUAL 0)
            message(
                FATAL_ERROR
                "ERROR: build 'fetch_content_${LOAD_DEPENDENCY_NAME}' exit code ${fetch_content_${LOAD_DEPENDENCY_NAME}_BUILD_RESULT} !!!"
            )
        endif()
        message(STATUS "--- build '${LOAD_DEPENDENCY_NAME}' (done) ---")
    endif()

    # test
    if(LOAD_DEPENDENCY_SKIP_TEST)
        message(STATUS "Skipping test for '${LOAD_DEPENDENCY_NAME}'")
    else()
        message(STATUS "--- test '${LOAD_DEPENDENCY_NAME}' (start) ---")
        execute_process(
            COMMAND           ${LOAD_DEPENDENCY_TEST_COMMAND} ${LOAD_DEPENDENCY_TEST_COMMAND_ARGS}
            WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_DIRECTORY_NAME}"
            RESULT_VARIABLE   "fetch_content_${LOAD_DEPENDENCY_NAME}_TEST_RESULT"
        )
        if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_TEST_RESULT} EQUAL 0)
            message(
                FATAL_ERROR
                "ERROR: test 'fetch_content_${LOAD_DEPENDENCY_NAME}' exit code ${fetch_content_${LOAD_DEPENDENCY_NAME}_TEST_RESULT} !!!"
            )
        endif()
        message(STATUS "--- test '${LOAD_DEPENDENCY_NAME}' (done) ---")
    endif()

    # install
    if(LOAD_DEPENDENCY_SKIP_INSTALL)
        message(STATUS "Skipping install for '${LOAD_DEPENDENCY_NAME}'")
    else()
        message(STATUS "--- install '${LOAD_DEPENDENCY_NAME}' (start) ---")
        execute_process(
            COMMAND           ${LOAD_DEPENDENCY_INSTALL_COMMAND} ${LOAD_DEPENDENCY_INSTALL_COMMAND_ARGS}
            WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_DIRECTORY_NAME}"
            RESULT_VARIABLE   "fetch_content_${LOAD_DEPENDENCY_NAME}_INSTALL_RESULT"
        )
        if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_INSTALL_RESULT} EQUAL 0)
            message(
                FATAL_ERROR
                "ERROR: install 'fetch_content_${LOAD_DEPENDENCY_NAME}' exit code ${fetch_content_${LOAD_DEPENDENCY_NAME}_INSTALL_RESULT} !!!"
            )
        endif()
        message(STATUS "--- install '${LOAD_DEPENDENCY_NAME}' (done) ---")
    endif()

    # post
    foreach(post_command_name ${LOAD_DEPENDENCY_POST_COMMAND_NAMES})
        if(NOT "" STREQUAL "${LOAD_DEPENDENCY_${post_command_name}}")
            if("" STREQUAL "${LOAD_DEPENDENCY_${post_command_name}_WORKING_DIRECTORY}")
                message(FATAL_ERROR "ERROR: '${post_command_name}_WORKING_DIRECTORY' is empty !!!")
            endif()
            if("" STREQUAL "${LOAD_DEPENDENCY_${post_command_name}_ARGS}")
                message(FATAL_ERROR "ERROR: '${post_command_name}_ARGS' is empty !!!")
            endif()
            message(STATUS "--- ${post_command_name} '${LOAD_DEPENDENCY_NAME}' (start) ---")
            execute_process(
                COMMAND           ${LOAD_DEPENDENCY_${post_command_name}} ${LOAD_DEPENDENCY_${post_command_name}_ARGS}
                WORKING_DIRECTORY "${LOAD_DEPENDENCY_${post_command_name}_WORKING_DIRECTORY}"
                RESULT_VARIABLE   "${post_command_name}_RESULT"
            )
            if(NOT ${${post_command_name}_RESULT} EQUAL 0)
                message(
                    FATAL_ERROR
                    "ERROR: config '${post_command_name}' exit code ${${post_command_name}_RESULT} !!!"
                )
            endif()
            message(STATUS "--- ${post_command_name} '${LOAD_DEPENDENCY_NAME}' (done) ---")
        endif()
    endforeach()

endfunction()
