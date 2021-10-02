cmake_minimum_required(VERSION 3.21 FATAL_ERROR)
get_filename_component(RAW_NAME "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
string(REPLACE " " "_" NAME "${RAW_NAME}")
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/version.txt" RAW_VERSION)
string(STRIP "${RAW_VERSION}" VERSION)
project("${NAME}" VERSION "${VERSION}" LANGUAGES "NONE")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

include("src/main/cmake/util.cmake")
include("src/main/cmake/config.cmake")

add_subdirectory("${PROJECT_NAME}-cpp-strings")
#add_subdirectory("${PROJECT_NAME}-conan-test")
#add_subdirectory("${PROJECT_NAME}-extension-test")
#add_subdirectory("${PROJECT_NAME}-test")

#[[
set_targets("${PROJECT_NAME}_TARGETS")

add_custom_target("targets"
    COMMAND "${CMAKE_COMMAND}" -E echo ${${PROJECT_NAME}_TARGETS}
    VERBATIM
)
]]
