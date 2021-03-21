cmake_minimum_required(VERSION 3.17)
project(exqudens_cmake VERSION 8.1.0)

# extensions
include(src/main/cmake/extension.cmake)

# tests 'set_if_not_defined' --------------------------------------------------

set(KEY_1 "a 1" "a 2" "a 3")
set_if_not_defined(KEY_1 "b 1" "b 2" "b 3")
set_if_not_defined(KEY_2 "c 1" "c 2" "c 3")
set(KEY_3)
set_if_not_defined(KEY_4)

# test_1
if(NOT DEFINED KEY_1)
    message(FATAL_ERROR "'KEY_1' not defined")
endif()

# test_2
if(NOT DEFINED KEY_2)
    message(FATAL_ERROR "'KEY_2' not defined")
endif()

# test_3
if(DEFINED KEY_3)
    message(FATAL_ERROR "'KEY_3' defined")
endif()

# test_4
if(DEFINED KEY_4)
    message(FATAL_ERROR "'KEY_4' defined")
endif()

# test_5
if(NOT "a 1;a 2;a 3" STREQUAL "${KEY_1}")
    message(FATAL_ERROR "'a 1;a 2;a 3' not equal to 'KEY_1' '${BUILD_HOME_PREFIX}' / '${KEY_1}'")
endif()

# test_6
if(NOT "c 1;c 2;c 3" STREQUAL "${KEY_2}")
    message(FATAL_ERROR "'c 1;c 2;c 3' not equal to 'KEY_2' '${BUILD_HOME_PREFIX}' / '${KEY_1}'")
endif()

# tests 'set_home_prefix' --------------------------------------------------

# variables
if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
    string(REPLACE "\\" "/" HOME_PREFIX_1 "$ENV{USERPROFILE}")
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
    set(HOME_PREFIX_1 "$ENV{HOME}")
elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
    set(HOME_PREFIX_1 "$ENV{HOME}")
else()
    message(
        FATAL_ERROR
        "Unable to get 'HOME_PREFIX_1' for CMAKE_HOST_SYSTEM_NAME: '${CMAKE_HOST_SYSTEM_NAME}'"
    )
endif()
set_home_prefix(HOME_PREFIX_2)

# test_1
if(NOT "${HOME_PREFIX_1}" STREQUAL "${HOME_PREFIX_2}")
    message(
        FATAL_ERROR
        "'HOME_PREFIX_1' not equal to 'HOME_PREFIX_2' '${HOME_PREFIX_1}' / '${HOME_PREFIX_2}'"
    )
endif()

# tests 'set_home_prefix_if_not_defined' --------------------------------------------------

# variables
set(BUILD_HOME_PREFIX "${CMAKE_CURRENT_BINARY_DIR}")
set_home_prefix_if_not_defined(BUILD_HOME_PREFIX)
set_home_prefix_if_not_defined(HOME_PREFIX)

# test_1
if(NOT DEFINED BUILD_HOME_PREFIX)
    message(FATAL_ERROR "'BUILD_HOME_PREFIX' not defined")
endif()

# test_2
if(NOT DEFINED HOME_PREFIX)
    message(FATAL_ERROR "'HOME_PREFIX' not defined")
endif()

# test_3
if(NOT "${BUILD_HOME_PREFIX}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
    message(
        FATAL_ERROR
        "'BUILD_HOME_PREFIX' not equal to 'CMAKE_CURRENT_BINARY_DIR' '${BUILD_HOME_PREFIX}' / '${CMAKE_CURRENT_BINARY_DIR}'"
    )
endif()

# test_4
if("${BUILD_HOME_PREFIX}" STREQUAL "${HOME_PREFIX}")
    message(
        FATAL_ERROR
        "'BUILD_HOME_PREFIX' equal to 'HOME_PREFIX' '${BUILD_HOME_PREFIX}' / '${HOME_PREFIX}'"
    )
endif()

# test 'add_custom_command(OUTPUT <...>)' generator expression

#[[macro(add_custom_target_build
    targetName
)
    add_custom_command(
        OUTPUT $<TARGET_PROPERTY:${targetName},property1>
        COMMAND ${CMAKE_COMMAND}
        ARGS -E touch $<TARGET_PROPERTY:${targetName},property1>
    )
    add_custom_target(build-${targetName}
        DEPENDS $<TARGET_PROPERTY:${targetName},property1>
    )
endmacro()

add_custom_target(target1)
set_target_properties(target1 PROPERTIES
    property1 ${CMAKE_CURRENT_BINARY_DIR}/target1-property1-file.txt
)

add_custom_target_build(target1)]]

######################################################################
# info ###############################################################
######################################################################

add_custom_target(project-info
    COMMAND ${CMAKE_COMMAND} -E echo "1:" $<TARGET_PROPERTY:project-info,NAME>
    COMMENT "Project info."
)
