# set variables
set(LOAD_DEPENDENCY_DEFAULT_CONFIGURE_COMMAND ${CMAKE_COMMAND})
set(LOAD_DEPENDENCY_DEFAULT_CONFIGURE_COMMAND_ARGS
    "-DCMAKE_INSTALL_PREFIX={{{PACKAGES_PREFIX}}}/{{{NAME}}}-{{{VERSION}}}"
    "-G"
    "{{{GENERATOR}}}"
    "-S"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{NAME}}}-{{{VERSION}}}/src"
    "-B"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{NAME}}}-{{{VERSION}}}/build"
)
set(LOAD_DEPENDENCY_DEFAULT_BUILD_COMMAND ${CMAKE_COMMAND})
set(LOAD_DEPENDENCY_DEFAULT_BUILD_COMMAND_ARGS
    "--build"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{NAME}}}-{{{VERSION}}}/build"
    "--target"
    "all"
    "--"
    "-j"
    "3"
)
set(LOAD_DEPENDENCY_DEFAULT_TEST_COMMAND ${CMAKE_COMMAND})
set(LOAD_DEPENDENCY_DEFAULT_TEST_COMMAND_ARGS
    "--build"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{NAME}}}-{{{VERSION}}}/build"
    "--target"
    "test"
    "--"
    "-j"
    "3"
)
set(LOAD_DEPENDENCY_DEFAULT_INSTALL_COMMAND ${CMAKE_COMMAND})
set(LOAD_DEPENDENCY_DEFAULT_INSTALL_COMMAND_ARGS
    "--build"
    "{{{FETCHCONTENT_BASE_DIR}}}/{{{NAME}}}-{{{VERSION}}}/build"
    "--target"
    "install"
    "--"
    "-j"
    "3"
)

# enable extensions
include(FindPkgConfig)
include(FetchContent)

# define function 'dependency'
function(dependency)

    set(options OPTIONAL)
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
        CONFIGURE_COMMAND
        BUILD_COMMAND
        TEST_COMMAND
        INSTALL_COMMAND
        )
    set(multiValueArgs
        CONFIGURE_COMMAND_ARGS
        BUILD_COMMAND_ARGS
        TEST_COMMAND_ARGS
        INSTALL_COMMAND_ARGS
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
    if(DEPENDENCY_VERSION)
        find_package("${DEPENDENCY_NAME}" "${DEPENDENCY_VERSION}" QUIET)
    else()
        find_package("${DEPENDENCY_NAME}" QUIET)
    endif()

    # build if not found '${DEPENDENCY_NAME}'
    load_dependency(
        SKIP                   ${${DEPENDENCY_NAME}_FOUND}
        NAME                   ${DEPENDENCY_PACKAGE_NAME}
        VERSION                ${DEPENDENCY_PACKAGE_VERSION}
        DOWNLOADS_PREFIX       ${DEPENDENCY_DOWNLOADS_PREFIX}
        PACKAGES_PREFIX        ${DEPENDENCY_PACKAGES_PREFIX}
        URL_SCHEMA             ${DEPENDENCY_URL_SCHEMA}
        URL_HOST               ${DEPENDENCY_URL_HOST}
        URL_MD5                ${DEPENDENCY_URL_MD5}
        DOWNLOAD_NAME          ${DEPENDENCY_DOWNLOAD_NAME}
        CONFIGURE_COMMAND      ${DEPENDENCY_CONFIGURE_COMMAND}
        BUILD_COMMAND          ${DEPENDENCY_BUILD_COMMAND}
        TEST_COMMAND           ${DEPENDENCY_TEST_COMMAND}
        INSTALL_COMMAND        ${DEPENDENCY_INSTALL_COMMAND}
        CONFIGURE_COMMAND_ARGS ${DEPENDENCY_CONFIGURE_COMMAND_ARGS}
        BUILD_COMMAND_ARGS     ${DEPENDENCY_BUILD_COMMAND_ARGS}
        TEST_COMMAND_ARGS      ${DEPENDENCY_TEST_COMMAND_ARGS}
        INSTALL_COMMAND_ARGS   ${DEPENDENCY_INSTALL_COMMAND_ARGS}
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

    # check one '${DEPENDENCY_NAME}' type 'QUIET'
    if(DEPENDENCY_VERSION)
        find_package("${DEPENDENCY_NAME}" "${DEPENDENCY_VERSION}" REQUIRED)
    else()
        find_package("${DEPENDENCY_NAME}" REQUIRED)
    endif()

endfunction()

# define function 'load_dependency'
function(load_dependency)

    set(options)
    set(oneValueArgs
        NAME
        VERSION
        DOWNLOADS_PREFIX
        PACKAGES_PREFIX
        URL_SCHEMA
        URL_HOST
        URL_MD5
        DOWNLOAD_NAME
        CONFIGURE_COMMAND
        BUILD_COMMAND
        TEST_COMMAND
        INSTALL_COMMAND
        SKIP
    )
    set(multiValueArgs
        CONFIGURE_COMMAND_ARGS
        BUILD_COMMAND_ARGS
        TEST_COMMAND_ARGS
        INSTALL_COMMAND_ARGS
    )
    cmake_parse_arguments(PARSE_ARGV 0 LOAD_DEPENDENCY "${options}" "${oneValueArgs}" "${multiValueArgs}")

    # short path -----------------------------------------------------------------------

    # check 'SKIP'
    if(LOAD_DEPENDENCY_SKIP)
        return()
    endif()

    # config -----------------------------------------------------------------------

    # set 'LOAD_DEPENDENCY_URL'
    if(EXISTS "${LOAD_DEPENDENCY_DOWNLOADS_PREFIX}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}/${LOAD_DEPENDENCY_DOWNLOAD_NAME}")
        set(LOAD_DEPENDENCY_URL "file://${LOAD_DEPENDENCY_DOWNLOADS_PREFIX}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}/${LOAD_DEPENDENCY_DOWNLOAD_NAME}")
    else()
        set(LOAD_DEPENDENCY_URL "${LOAD_DEPENDENCY_URL_SCHEMA}://${LOAD_DEPENDENCY_URL_HOST}")
    endif()

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
        string(REPLACE "{{{PACKAGES_PREFIX}}}"       "${LOAD_DEPENDENCY_PACKAGES_PREFIX}" arg "${arg}")
        string(REPLACE "{{{NAME}}}"                  "${LOAD_DEPENDENCY_NAME}"            arg "${arg}")
        string(REPLACE "{{{VERSION}}}"               "${LOAD_DEPENDENCY_VERSION}"         arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"           arg "${arg}")
        list(APPEND LOAD_DEPENDENCY_CONFIGURE_COMMAND_ARGS "${arg}")
    endforeach()

    # set 'LOAD_DEPENDENCY_BUILD_COMMAND'
    set(LOAD_DEPENDENCY_BUILD_COMMAND "${LOAD_DEPENDENCY_DEFAULT_BUILD_COMMAND}")

    # set 'LOAD_DEPENDENCY_BUILD_COMMAND_ARGS'
    set(LOAD_DEPENDENCY_BUILD_COMMAND_ARGS)
    foreach(arg ${LOAD_DEPENDENCY_DEFAULT_BUILD_COMMAND_ARGS})
        string(REPLACE "{{{NAME}}}"                  "${LOAD_DEPENDENCY_NAME}"    arg "${arg}")
        string(REPLACE "{{{VERSION}}}"               "${LOAD_DEPENDENCY_VERSION}" arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"   arg "${arg}")
        list(APPEND LOAD_DEPENDENCY_BUILD_COMMAND_ARGS "${arg}")
    endforeach()

    # set 'LOAD_DEPENDENCY_TEST_COMMAND'
    set(LOAD_DEPENDENCY_TEST_COMMAND "${LOAD_DEPENDENCY_DEFAULT_TEST_COMMAND}")

    # set 'LOAD_DEPENDENCY_TEST_COMMAND_ARGS'
    set(LOAD_DEPENDENCY_TEST_COMMAND_ARGS)
    foreach(arg ${LOAD_DEPENDENCY_DEFAULT_TEST_COMMAND_ARGS})
        string(REPLACE "{{{NAME}}}"                  "${LOAD_DEPENDENCY_NAME}"    arg "${arg}")
        string(REPLACE "{{{VERSION}}}"               "${LOAD_DEPENDENCY_VERSION}" arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"   arg "${arg}")
        list(APPEND LOAD_DEPENDENCY_TEST_COMMAND_ARGS "${arg}")
    endforeach()

    # set 'LOAD_DEPENDENCY_INSTALL_COMMAND'
    set(LOAD_DEPENDENCY_INSTALL_COMMAND "${LOAD_DEPENDENCY_DEFAULT_INSTALL_COMMAND}")

    # set 'LOAD_DEPENDENCY_INSTALL_COMMAND_ARGS'
    set(LOAD_DEPENDENCY_INSTALL_COMMAND_ARGS)
    foreach(arg ${LOAD_DEPENDENCY_DEFAULT_INSTALL_COMMAND_ARGS})
        string(REPLACE "{{{NAME}}}"                  "${LOAD_DEPENDENCY_NAME}"    arg "${arg}")
        string(REPLACE "{{{VERSION}}}"               "${LOAD_DEPENDENCY_VERSION}" arg "${arg}")
        string(REPLACE "{{{FETCHCONTENT_BASE_DIR}}}" "${FETCHCONTENT_BASE_DIR}"   arg "${arg}")
        list(APPEND LOAD_DEPENDENCY_INSTALL_COMMAND_ARGS "${arg}")
    endforeach()

    # process -----------------------------------------------------------------------

    # extract
    message(STATUS "--- extract '${LOAD_DEPENDENCY_NAME}' (start) ---")
    FetchContent_Declare("fetch_content_${LOAD_DEPENDENCY_NAME}"
        DOWNLOAD_DIR  "${LOAD_DEPENDENCY_DOWNLOADS_PREFIX}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}"
        DOWNLOAD_NAME "${LOAD_DEPENDENCY_DOWNLOAD_NAME}"
        SOURCE_DIR    "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}/src"
        BINARY_DIR    "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}/build"
        SUBBUILD_DIR  "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}/subbuild"
        URL           "${LOAD_DEPENDENCY_URL}"
        URL_MD5       "${LOAD_DEPENDENCY_URL_MD5}"
        #CMAKE_ARGS    "-DCMAKE_INSTALL_PREFIX=${LOAD_DEPENDENCY_PACKAGES_PREFIX}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}"
        )
    FetchContent_GetProperties("fetch_content_${LOAD_DEPENDENCY_NAME}")
    if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_POPULATED})
        FetchContent_Populate("fetch_content_${LOAD_DEPENDENCY_NAME}")
    endif()
    if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_POPULATED})
        message(FATAL_ERROR "ERROR: 'fetch_content_${LOAD_DEPENDENCY_NAME}' not populated !!!")
    endif()
    message(STATUS "--- extract '${LOAD_DEPENDENCY_NAME}' (done) ---")

    message(STATUS "--- config '${LOAD_DEPENDENCY_NAME}' (start) ---")
    execute_process(
        COMMAND           ${LOAD_DEPENDENCY_CONFIGURE_COMMAND} ${LOAD_DEPENDENCY_CONFIGURE_COMMAND_ARGS}
        WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}"
        RESULT_VARIABLE   "fetch_content_${LOAD_DEPENDENCY_NAME}_CONFIG_RESULT"
    )
    if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_CONFIG_RESULT} EQUAL 0)
        message(
            FATAL_ERROR
            "ERROR: config 'fetch_content_${LOAD_DEPENDENCY_NAME}' exit code ${fetch_content_${LOAD_DEPENDENCY_NAME}_CONFIG_RESULT} !!!"
        )
    endif()
    message(STATUS "--- config '${LOAD_DEPENDENCY_NAME}' (done) ---")

    message(STATUS "--- build '${LOAD_DEPENDENCY_NAME}' (start) ---")
    execute_process(
        COMMAND           ${LOAD_DEPENDENCY_BUILD_COMMAND} ${LOAD_DEPENDENCY_BUILD_COMMAND_ARGS}
        WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}"
        RESULT_VARIABLE   "fetch_content_${LOAD_DEPENDENCY_NAME}_BUILD_RESULT"
    )
    if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_BUILD_RESULT} EQUAL 0)
        message(
            FATAL_ERROR
            "ERROR: build 'fetch_content_${LOAD_DEPENDENCY_NAME}' exit code ${fetch_content_${LOAD_DEPENDENCY_NAME}_BUILD_RESULT} !!!"
        )
    endif()
    message(STATUS "--- build '${LOAD_DEPENDENCY_NAME}' (done) ---")

    message(STATUS "--- test '${LOAD_DEPENDENCY_NAME}' (start) ---")
    execute_process(
        COMMAND           ${LOAD_DEPENDENCY_TEST_COMMAND} ${LOAD_DEPENDENCY_TEST_COMMAND_ARGS}
        WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}"
        RESULT_VARIABLE   "fetch_content_${LOAD_DEPENDENCY_NAME}_TEST_RESULT"
    )
    if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_TEST_RESULT} EQUAL 0)
        message(
            FATAL_ERROR
            "ERROR: test 'fetch_content_${LOAD_DEPENDENCY_NAME}' exit code ${fetch_content_${LOAD_DEPENDENCY_NAME}_TEST_RESULT} !!!"
        )
    endif()
    message(STATUS "--- test '${LOAD_DEPENDENCY_NAME}' (done) ---")

    message(STATUS "--- install '${LOAD_DEPENDENCY_NAME}' (start) ---")
    execute_process(
        COMMAND           ${LOAD_DEPENDENCY_INSTALL_COMMAND} ${LOAD_DEPENDENCY_INSTALL_COMMAND_ARGS}
        WORKING_DIRECTORY "${FETCHCONTENT_BASE_DIR}/${LOAD_DEPENDENCY_NAME}-${LOAD_DEPENDENCY_VERSION}"
        RESULT_VARIABLE   "fetch_content_${LOAD_DEPENDENCY_NAME}_INSTALL_RESULT"
    )
    if(NOT ${fetch_content_${LOAD_DEPENDENCY_NAME}_INSTALL_RESULT} EQUAL 0)
        message(
            FATAL_ERROR
            "ERROR: install 'fetch_content_${LOAD_DEPENDENCY_NAME}' exit code ${fetch_content_${LOAD_DEPENDENCY_NAME}_INSTALL_RESULT} !!!"
        )
    endif()
    message(STATUS "--- install '${LOAD_DEPENDENCY_NAME}' (done) ---")

endfunction()
