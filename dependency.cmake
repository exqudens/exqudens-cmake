# set variables
set(
    DEPENDENCY_DEFAULT_CONFIGURE_COMMAND_TEMPLATE
    "{{{CMAKE_COMMAND}}} -DCMAKE_INSTALL_PREFIX={{{PACKAGES_PREFIX}}}/{{{PACKAGE_NAME}}}-{{{PACKAGE_VERSION}}} -G \"{{{G_ARG}}}\" -S {{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_NAME}}}-{{{PACKAGE_VERSION}}}/src -B {{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_NAME}}}-{{{PACKAGE_VERSION}}}/build"
)

# enable extensions
include(FindPkgConfig)
include(FetchContent)

# define function 'dependency'
function(dependency)

    # config -----------------------------------------------------------------------

    set(options

        OPTIONAL
    )
    set(oneValueArgs

        NAME
        VERSION
        PACKAGE_NAME
        PACKAGE_VERSION
        DOWNLOADS_PREFIX
        PACKAGES_PREFIX
        URL_SCHEMA
        URL_HOST
        URL_MD5
        DOWNLOAD_NAME
    )
    set(multiValueArgs)
    cmake_parse_arguments(PARSE_ARGV 0 DEPENDENCY "${options}" "${oneValueArgs}" "${multiValueArgs}")

    message(STATUS "---")

    message(STATUS "DEPENDENCY_NAME:             '${DEPENDENCY_NAME}'")
    message(STATUS "DEPENDENCY_VERSION:          '${DEPENDENCY_VERSION}'")
    message(STATUS "DEPENDENCY_PACKAGE_NAME:     '${DEPENDENCY_PACKAGE_NAME}'")
    message(STATUS "DEPENDENCY_PACKAGE_VERSION:  '${DEPENDENCY_PACKAGE_VERSION}'")
    message(STATUS "DEPENDENCY_DOWNLOADS_PREFIX: '${DEPENDENCY_DOWNLOADS_PREFIX}'")
    message(STATUS "DEPENDENCY_PACKAGES_PREFIX:  '${DEPENDENCY_PACKAGES_PREFIX}'")
    message(STATUS "DEPENDENCY_URL_SCHEMA:       '${DEPENDENCY_URL_SCHEMA}'")
    message(STATUS "DEPENDENCY_URL_HOST:         '${DEPENDENCY_URL_HOST}'")
    message(STATUS "DEPENDENCY_URL_MD5:          '${DEPENDENCY_URL_MD5}'")
    message(STATUS "DEPENDENCY_DOWNLOAD_NAME:    '${DEPENDENCY_DOWNLOAD_NAME}'")

    message(STATUS "")

    message(STATUS "DEPENDENCY_OPTIONAL:         '${DEPENDENCY_OPTIONAL}'")

    message(STATUS "---")

    set(INTERNAL_VAR_1 "${DEPENDENCY_DEFAULT_CONFIGURE_COMMAND_TEMPLATE}")

    string(REPLACE "{{{CMAKE_COMMAND}}}" "${CMAKE_COMMAND}" INTERNAL_VAR_1 "${INTERNAL_VAR_1}")
    string(REPLACE "{{{PACKAGES_PREFIX}}}" "${CMAKE_BINARY_DIR}/packages" INTERNAL_VAR_1 "${INTERNAL_VAR_1}")
    string(REPLACE "{{{PACKAGE_NAME}}}" "zlib" INTERNAL_VAR_1 "${INTERNAL_VAR_1}")
    string(REPLACE "{{{PACKAGE_VERSION}}}" "1.2.11" INTERNAL_VAR_1 "${INTERNAL_VAR_1}")
    string(REPLACE "{{{G_ARG}}}" "CodeBlocks - MinGW Makefiles" INTERNAL_VAR_1 "${INTERNAL_VAR_1}")
    string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}" INTERNAL_VAR_1 "${INTERNAL_VAR_1}")

    set(TEST_VAR_1 "${INTERNAL_VAR_1}" PARENT_SCOPE)

    # process -----------------------------------------------------------------------

    # check one '${DEPENDENCY_NAME}' type 'QUIET'
    if(DEPENDENCY_VERSION)
        find_package("${DEPENDENCY_NAME}" "${DEPENDENCY_VERSION}" QUIET)
    else()
        find_package("${DEPENDENCY_NAME}" QUIET)
    endif()

    # build if not found '${DEPENDENCY_NAME}'
    if(NOT ${${DEPENDENCY_NAME}_FOUND})
        FetchContent_Declare("fetch_content_${DEPENDENCY_PACKAGE_NAME}"
            DOWNLOAD_DIR  "${DEPENDENCY_DOWNLOADS_PREFIX}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}"
            DOWNLOAD_NAME "${DEPENDENCY_DOWNLOAD_NAME}"
            URL           "${DEPENDENCY_URL_SCHEMA}://${DEPENDENCY_URL_HOST}"
            URL_MD5       "${DEPENDENCY_URL_MD5}"
            #CMAKE_ARGS    "-DCMAKE_INSTALL_PREFIX=${DEPENDENCY_PACKAGES_PREFIX}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}"
        )
        FetchContent_GetProperties("fetch_content_${DEPENDENCY_PACKAGE_NAME}")
        if(NOT ${fetch_content_${DEPENDENCY_PACKAGE_NAME}_POPULATED})
            FetchContent_Populate("fetch_content_${DEPENDENCY_PACKAGE_NAME}")
        endif()
    endif()

endfunction()
