# set include once
include_guard()

# enable 'extension'
include(extension.cmake)

# load 'pkg-config-lite'
dependency(
    NAME                             "PkgConfig"
    PACKAGE_NAME                     "pkg-config-lite"
    PACKAGE_VERSION                  "0.28.1"
    DOWNLOADS_PREFIX                 "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX                  "${CMAKE_SOURCE_DIR}/packages"
    URL_SCHEMA                       "https"
    URL_HOST                         "sourceforge.net/projects/pkgconfiglite/files/0.28-1/pkg-config-lite-0.28-1_bin-win32.zip"
    URL_MD5                          "6004df17818f5a6dbf19cb335cc92702"
    PREFIX_PATH                      "${CMAKE_PREFIX_PATH}"
    SKIP_CONFIG                      TRUE
    SKIP_BUILD                       TRUE
    SKIP_TEST                        TRUE
    SKIP_INSTALL                     TRUE
    PRE_COMMAND_0                    "${CMAKE_COMMAND}"
    PRE_COMMAND_0_WORKING_DIRECTORY  "${CMAKE_SOURCE_DIR}"
    PRE_COMMAND_0_ARGS
        "-E"
        "make_directory"
        "${CMAKE_SOURCE_DIR}/packages/pkg-config-lite-0.28.1"
    PRE_COMMAND_1                    "${CMAKE_COMMAND}"
    PRE_COMMAND_1_WORKING_DIRECTORY  "${CMAKE_SOURCE_DIR}"
    PRE_COMMAND_1_ARGS
        "-E"
        "copy_directory"
        "${FETCHCONTENT_BASE_DIR}/pkg-config-lite-0.28.1/src"
        "${CMAKE_SOURCE_DIR}/packages/pkg-config-lite-0.28.1"
)

# load 'googletest'
dependency(
    USE_PKG_CONFIG          TRUE
    PREFIX_PATH             "${CMAKE_PREFIX_PATH}"
    NAME                    "GTEST"
    PACKAGE_NAME            "gtest"
    PACKAGE_VERSION         "1.10.0-custom"
    DOWNLOADS_PREFIX        "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX         "${CMAKE_SOURCE_DIR}/packages"
    DOWNLOAD_DIRECTORY_NAME "gtest_gmock-1.10.0-custom"
    PACKAGE_DIRECTORY_NAME  "gtest_gmock-1.10.0-custom"
    URL_SCHEMA              "https"
    URL_HOST                "github.com/google/googletest/archive/389cb68b87193358358ae87cc56d257fd0d80189.zip"
    URL_MD5                 "07166e65eed56641d582d139cd750be0"
)

# load 'zlib'
dependency(
    PREFIX_PATH      "${CMAKE_PREFIX_PATH}"
    NAME             "ZLIB"
    PACKAGE_NAME     "zlib"
    PACKAGE_VERSION  "1.2.11"
    DOWNLOADS_PREFIX "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX  "${CMAKE_SOURCE_DIR}/packages"
    URL_SCHEMA       "https"
    URL_HOST         "github.com/madler/zlib/archive/v1.2.11.zip"
    URL_MD5          "9d6a627693163bbbf3f26403a3a0b0b1"
)

# load 'libpng'
dependency(
    PREFIX_PATH      "${CMAKE_PREFIX_PATH}"
    NAME             "PNG"
    PACKAGE_NAME     "libpng"
    PACKAGE_VERSION  "1.6.37"
    DOWNLOADS_PREFIX "${CMAKE_SOURCE_DIR}/downloads"
    PACKAGES_PREFIX  "${CMAKE_SOURCE_DIR}/packages"
    URL_SCHEMA       "https"
    URL_HOST         "github.com/glennrp/libpng/archive/v1.6.37.zip"
    URL_MD5          "1bbb6b2bcd580d50b82145e827eb3fb4"
    SKIP_TEST        TRUE
)

# load 'pngpp'
dependency(
    USE_PKG_CONFIG                   TRUE
    PREFIX_PATH                      "${CMAKE_PREFIX_PATH}"
    NAME                             "PNGPP"
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
