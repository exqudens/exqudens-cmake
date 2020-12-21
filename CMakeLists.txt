cmake_minimum_required(VERSION 3.17)
project(exqudens_cmake)

# config 1
include(extension.cmake)
if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}")
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}")
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/.cmake")
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/.cmake/packages")
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/.cmake/downloads")
endif()
init("${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}")

message_status("---")
message_status("1: ${HOME_PREFIX}")
message_status("2: ${PACKAGES_PREFIX}")
message_status("3: ${DOWNLOADS_PREFIX}")
message_status("---")
download(
        "${DOWNLOADS_PREFIX}/zlib-1.2.11"
        "archive.zip"
        "https://github.com/madler/zlib/archive/v1.2.11.zip"
        "9d6a627693163bbbf3f26403a3a0b0b1"
)
if(NOT EXISTS "${DOWNLOADS_PREFIX}/zlib-1.2.11/archive.zip")
    message_fatal_error("Not exists: ${DOWNLOADS_PREFIX}/zlib-1.2.11/archive.zip")
endif()
message_status("---")

# config 2
include(extension.cmake)
if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_HOME")
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_HOME")
    set_home_prefix("${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_HOME")
endif()
if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_PACKAGES")
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_PACKAGES")
    set_packages_prefix("${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_PACKAGES")
endif()
if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_DOWNLOADS")
    file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_DOWNLOADS")
    set_downloads_prefix("${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_DOWNLOADS")
endif()

message_status("---")
message_status("1: ${HOME_PREFIX}")
message_status("2: ${PACKAGES_PREFIX}")
message_status("3: ${DOWNLOADS_PREFIX}")
message_status("---")
download(
        "${DOWNLOADS_PREFIX}/zlib-1.2.11"
        "archive.zip"
        "https://github.com/madler/zlib/archive/v1.2.11.zip"
        "9d6a627693163bbbf3f26403a3a0b0b1"
)
if(NOT EXISTS "${DOWNLOADS_PREFIX}/zlib-1.2.11/archive.zip")
    message_fatal_error("Not exists: ${DOWNLOADS_PREFIX}/zlib-1.2.11/archive.zip")
endif()
message_status("---")
