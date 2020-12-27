cmake_minimum_required(VERSION 3.17)
project(exqudens_cmake)

message(STATUS "1) CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

include(dependency.cmake)
dependency(
    NAME             "ZLIB"
    #VERSION          ""
    PACKAGE_NAME     "zlib"
    PACKAGE_VERSION  "1.2.11"
    DOWNLOADS_PREFIX "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX  "${CMAKE_SOURCE_DIR}/packages"
    URL_SCHEMA       "https"
    URL_HOST         "github.com/madler/zlib/archive/v1.2.11.zip"
    URL_MD5          "9d6a627693163bbbf3f26403a3a0b0b1"
    DOWNLOAD_NAME    "archive.zip"
)

message(STATUS "2) CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
