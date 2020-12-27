# set variables
set(DEPENDENCY_DEFAULT_CONFIGURE_COMMAND ${CMAKE_COMMAND})
set(DEPENDENCY_DEFAULT_CONFIGURE_COMMAND_ARGS
    "-DCMAKE_INSTALL_PREFIX={{{PACKAGES_PREFIX}}}/{{{PACKAGE_NAME}}}-{{{PACKAGE_VERSION}}}"
    "-G"
    "{{{GENERATOR}}}"
    "-S"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_NAME}}}-{{{PACKAGE_VERSION}}}/src"
    "-B"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{PACKAGE_NAME}}}-{{{PACKAGE_VERSION}}}/build"
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

    # set 'DEPENDENCY_URL'
    if(EXISTS "${DEPENDENCY_DOWNLOADS_PREFIX}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}/${DEPENDENCY_DOWNLOAD_NAME}")
        set(DEPENDENCY_URL "file://${DEPENDENCY_DOWNLOADS_PREFIX}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}/${DEPENDENCY_DOWNLOAD_NAME}")
    else()
        set(DEPENDENCY_URL "${DEPENDENCY_URL_SCHEMA}://${DEPENDENCY_URL_HOST}")
    endif()

    # set 'DEPENDENCY_CONFIGURE_COMMAND'
    set(DEPENDENCY_CONFIGURE_COMMAND "${DEPENDENCY_DEFAULT_CONFIGURE_COMMAND}")

    # set 'DEPENDENCY_CONFIGURE_COMMAND_ARGS'
    set(DEPENDENCY_CONFIGURE_COMMAND_ARGS)
    foreach(arg ${DEPENDENCY_DEFAULT_CONFIGURE_COMMAND_ARGS})
        string(REPLACE "{{{GENERATOR}}}"             "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}" arg "${arg}")
        string(REPLACE "{{{PACKAGES_PREFIX}}}"       "${DEPENDENCY_PACKAGES_PREFIX}"                 arg "${arg}")
        string(REPLACE "{{{PACKAGE_NAME}}}"          "${DEPENDENCY_PACKAGE_NAME}"                    arg "${arg}")
        string(REPLACE "{{{PACKAGE_VERSION}}}"       "${DEPENDENCY_PACKAGE_VERSION}"                 arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"                      arg "${arg}")
        list(APPEND DEPENDENCY_CONFIGURE_COMMAND_ARGS "${arg}")
    endforeach()

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

    message(STATUS "DEPENDENCY_URL: '${DEPENDENCY_URL}'")
    message(STATUS "DEPENDENCY_CONFIGURE_COMMAND: ${DEPENDENCY_CONFIGURE_COMMAND}")
    message(STATUS "DEPENDENCY_CONFIGURE_COMMAND_ARGS: ${DEPENDENCY_CONFIGURE_COMMAND_ARGS}")

    message(STATUS "---")

    #set(TEST_VAR_1 "AAAbbbCCCddd" PARENT_SCOPE)

    # process -----------------------------------------------------------------------

    # check one '${DEPENDENCY_NAME}' type 'QUIET'
    if(DEPENDENCY_VERSION)
        find_package("${DEPENDENCY_NAME}" "${DEPENDENCY_VERSION}" QUIET)
    else()
        find_package("${DEPENDENCY_NAME}" QUIET)
    endif()

    # build if not found '${DEPENDENCY_NAME}'
    if(NOT ${${DEPENDENCY_NAME}_FOUND})

        message(STATUS "--- extract '${DEPENDENCY_PACKAGE_NAME}' (start) ---")
        FetchContent_Declare("fetch_content_${DEPENDENCY_PACKAGE_NAME}"
            DOWNLOAD_DIR  "${DEPENDENCY_DOWNLOADS_PREFIX}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}"
            DOWNLOAD_NAME "${DEPENDENCY_DOWNLOAD_NAME}"
            SOURCE_DIR    "${FETCHCONTENT_BASE_DIR}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}/src"
            BINARY_DIR    "${FETCHCONTENT_BASE_DIR}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}/build"
            SUBBUILD_DIR  "${FETCHCONTENT_BASE_DIR}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}/subbuild"
            URL           "${DEPENDENCY_URL}"
            URL_MD5       "${DEPENDENCY_URL_MD5}"
            #CMAKE_ARGS    "-DCMAKE_INSTALL_PREFIX=${DEPENDENCY_PACKAGES_PREFIX}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}"
        )
        FetchContent_GetProperties("fetch_content_${DEPENDENCY_PACKAGE_NAME}")
        if(NOT ${fetch_content_${DEPENDENCY_PACKAGE_NAME}_POPULATED})
            FetchContent_Populate("fetch_content_${DEPENDENCY_PACKAGE_NAME}")
        endif()
        if(NOT ${fetch_content_${DEPENDENCY_PACKAGE_NAME}_POPULATED})
            message(FATAL_ERROR "ERROR: 'fetch_content_${DEPENDENCY_PACKAGE_NAME}' not populated !!!")
        endif()
        message(STATUS "--- extract '${DEPENDENCY_PACKAGE_NAME}' (done) ---")

        message(STATUS "--- config '${DEPENDENCY_PACKAGE_NAME}' (start) ---")
        execute_process(
            COMMAND           ${DEPENDENCY_CONFIGURE_COMMAND} ${DEPENDENCY_CONFIGURE_COMMAND_ARGS}
            WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${DEPENDENCY_PACKAGE_NAME}-${DEPENDENCY_PACKAGE_VERSION}"
            RESULT_VARIABLE   "fetch_content_${DEPENDENCY_PACKAGE_NAME}_CONFIG_RESULT"
        )
        if(NOT ${fetch_content_${DEPENDENCY_PACKAGE_NAME}_CONFIG_RESULT} EQUAL 0)
            message(
                FATAL_ERROR
                "ERROR: config 'fetch_content_${DEPENDENCY_PACKAGE_NAME}' exit code ${fetch_content_${DEPENDENCY_PACKAGE_NAME}_CONFIG_RESULT} !!!"
            )
        endif()
        message(STATUS "--- config '${DEPENDENCY_PACKAGE_NAME}' (done) ---")

    endif()

endfunction()
