cmake_minimum_required(VERSION 3.17)
project(exqudens_cmake)

set(CMAKE_MESSAGE_CONTEXT_SHOW TRUE)

message(STATUS "1) CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

include(extension.cmake)
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
    USE_PKG_CONFIG                   TRUE
    PREFIX_PATH                      "${CMAKE_PREFIX_PATH}"
    NAME                             "PNGPP"
    #VERSION                          "0.2.9"
    PACKAGE_NAME                     "pngpp"
    PACKAGE_VERSION                  "0.2.9"
    DOWNLOADS_PREFIX                 "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX                  "${CMAKE_SOURCE_DIR}/packages"
    URL_SCHEMA                       "http"
    URL_HOST                         "download.savannah.nongnu.org/releases/pngpp/png++-0.2.9.tar.gz"
    URL_MD5                          "92863df3bee625d707cebc0e749c10df"
    SKIP_CONFIG                      TRUE
    SKIP_BUILD                       TRUE
    SKIP_TEST                        TRUE
    SKIP_INSTALL                     TRUE

    PRE_COMMAND_0                    "${CMAKE_COMMAND}"
    PRE_COMMAND_0_WORKING_DIRECTORY  "${CMAKE_SOURCE_DIR}"
    PRE_COMMAND_0_ARGS
        "-E"
        "make_directory"
        "${CMAKE_SOURCE_DIR}/packages/pngpp-0.2.9/include/png++"

    PRE_COMMAND_1                    "${CMAKE_COMMAND}"
    PRE_COMMAND_1_WORKING_DIRECTORY  "${CMAKE_SOURCE_DIR}"
    PRE_COMMAND_1_ARGS
        "-E"
        "make_directory"
        "${CMAKE_SOURCE_DIR}/packages/pngpp-0.2.9/share/pkgconfig"

    PRE_COMMAND_2                    "${CMAKE_COMMAND}"
    PRE_COMMAND_2_WORKING_DIRECTORY  "${CMAKE_SOURCE_DIR}"
    PRE_COMMAND_2_ARGS
        "-E"
        "copy"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/color.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/config.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/consumer.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/convert_color_space.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/end_info.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/error.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/ga_pixel.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/generator.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/gray_pixel.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/image.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/image_info.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/index_pixel.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/info.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/info_base.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/io_base.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/packed_pixel.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/palette.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/pixel_buffer.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/pixel_traits.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/png.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/reader.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/require_color_space.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/rgb_pixel.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/rgba_pixel.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/solid_pixel_buffer.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/streaming_base.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/tRNS.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/types.hpp"
            "${FETCHCONTENT_BASE_DIR}/pngpp-0.2.9/src/writer.hpp"
        "${CMAKE_SOURCE_DIR}/packages/pngpp-0.2.9/include/png++"

    POST_COMMAND_3                   "${CMAKE_COMMAND}"
    POST_COMMAND_3_WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    POST_COMMAND_3_ARGS
        "-E"
        "copy"
            "${CMAKE_SOURCE_DIR}/src/test/resources/pc/pngpp-0.2.9/share/pkgconfig/pngpp.pc"
        "${CMAKE_SOURCE_DIR}/packages/pngpp-0.2.9/share/pkgconfig"
)

message(STATUS "4) CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

pkg_search_module("PNGPP" "PNGPP" "pngpp")
message(STATUS "zzz_0: ${PNGPP_FOUND}")
message(STATUS "zzz_1: ${PNGPP_LIBRARIES}")
message(STATUS "zzz_2: ${PNGPP_LINK_LIBRARIES}")
message(STATUS "zzz_3: ${PNGPP_LIBRARY_DIRS}")
message(STATUS "zzz_4: ${PNGPP_LDFLAGS}")
message(STATUS "zzz_5: ${PNGPP_LDFLAGS_OTHER}")
message(STATUS "zzz_6: ${PNGPP_INCLUDE_DIRS}")
message(STATUS "zzz_7: ${PNGPP_CFLAGS}")
message(STATUS "zzz_8: ${PNGPP_CFLAGS_OTHER}")
message(STATUS "zzz_9: ${PNGPP_PREFIX}")
