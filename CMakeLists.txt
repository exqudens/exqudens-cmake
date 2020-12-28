cmake_minimum_required(VERSION 3.17)
project(exqudens_cmake)

set(CMAKE_MESSAGE_CONTEXT_SHOW TRUE)

message(STATUS "1) CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

include(dependency.cmake)
dependency(
    PREFIX_PATH      "${CMAKE_PREFIX_PATH}"
    NAME             "ZLIB"
    #VERSION          ""
    PACKAGE_NAME     "zlib"
    PACKAGE_VERSION  "1.2.11"
    DOWNLOADS_PREFIX "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX  "${CMAKE_SOURCE_DIR}/packages"
    URL_SCHEMA       "https"
    URL_HOST         "github.com/madler/zlib/archive/v1.2.11.zip"
    URL_MD5          "9d6a627693163bbbf3f26403a3a0b0b1"
)

message(STATUS "2) CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

dependency(
    PREFIX_PATH      "${CMAKE_PREFIX_PATH}"
    NAME             "PNG"
    #VERSION          ""
    PACKAGE_NAME     "libpng"
    PACKAGE_VERSION  "1.6.37"
    DOWNLOADS_PREFIX "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX  "${CMAKE_SOURCE_DIR}/packages"
    URL_SCHEMA       "https"
    URL_HOST         "github.com/glennrp/libpng/archive/v1.6.37.zip"
    URL_MD5          "1bbb6b2bcd580d50b82145e827eb3fb4"
    SKIP_TEST        TRUE
)

message(STATUS "3) CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

dependency(
    USE_PKG_CONFIG   TRUE
    PREFIX_PATH      "${CMAKE_PREFIX_PATH}"
    NAME             "PNGPP"
    VERSION          "0.2.9"
    PACKAGE_NAME     "pngpp"
    PACKAGE_VERSION  "0.2.9"
    DOWNLOADS_PREFIX "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX  "${CMAKE_SOURCE_DIR}/packages"
    URL_SCHEMA       "http"
    URL_HOST         "download.savannah.nongnu.org/releases/pngpp/png++-0.2.9.tar.gz"
    URL_MD5          "92863df3bee625d707cebc0e749c10df"
    SKIP_CONFIG      TRUE
    SKIP_BUILD       TRUE
    SKIP_TEST        TRUE
    SKIP_INSTALL     TRUE
)

message(STATUS "4) CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
