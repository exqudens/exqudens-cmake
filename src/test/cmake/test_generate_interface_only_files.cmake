include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass1.hpp" expected1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass2.hpp" expected2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass3.hpp" expected3)

    set(srcDirectory "${CMAKE_CURRENT_BINARY_DIR}/..")
    get_filename_component(buildDirName "${CMAKE_CURRENT_BINARY_DIR}" NAME)

    cmake_path(NORMAL_PATH srcDirectory)
    cmake_path(APPEND srcDirectory DIR)
    cmake_path(GET srcDirectory PARENT_PATH srcDirectory)

    generate_interface_only_files(actual4
        SRC_DIRECTORY "${srcDirectory}"
        SRC_BASE_DIRECTORY "${srcDirectory}/src/test/resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/input"
        DST_BASE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}"
        HEADER_FILES_EXPRESSIONS "**/*.hpp"
        SOURCE_FILES_EXPRESSIONS "**/*.cpp"
    )

    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp" actual1)
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp" actual2)
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp" actual3)
    set(expected4
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp"
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp"
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp"
    )

    if(NOT "${expected1}" STREQUAL "${actual1}")
        message(FATAL_ERROR "'expected1': '${expected1}' != 'actual1': '${actual1}'")
    endif()

    if(NOT "${expected2}" STREQUAL "${actual2}")
        message(FATAL_ERROR "'expected2': '${expected2}' != 'actual2': '${actual2}'")
    endif()

    if(NOT "${expected3}" STREQUAL "${actual3}")
        message(FATAL_ERROR "'expected3': '${expected3}' != 'actual3': '${actual3}'")
    endif()

    if(NOT "${expected4}" STREQUAL "${actual4}")
        message(FATAL_ERROR "'expected4': '${expected4}' != 'actual4': '${actual4}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass1.hpp" expected1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass2.hpp" expected2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass3.hpp" expected3)

    set(srcDirectory "${CMAKE_CURRENT_BINARY_DIR}/..")
    get_filename_component(buildDirName "${CMAKE_CURRENT_BINARY_DIR}" NAME)

    cmake_path(NORMAL_PATH srcDirectory)
    cmake_path(APPEND srcDirectory DIR)
    cmake_path(GET srcDirectory PARENT_PATH srcDirectory)

    generate_interface_only_files(actual4
        SRC_DIRECTORY "${srcDirectory}"
        SRC_BASE_DIRECTORY "${srcDirectory}/src/test/resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/input"
        DST_BASE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}"
        HEADER_FILES "src/test/resources/test_generate_interface_only_files/test_2/input/testnamespace/testsubnamespace/TestClass1.hpp"
                     "src/test/resources/test_generate_interface_only_files/test_2/input/testnamespace/testsubnamespace/TestClass2.hpp"
                     "src/test/resources/test_generate_interface_only_files/test_2/input/testnamespace/testsubnamespace/TestClass3.hpp"
        SOURCE_FILES "src/test/resources/test_generate_interface_only_files/test_2/input/testnamespace/testsubnamespace/TestClass2.cpp"
                     "src/test/resources/test_generate_interface_only_files/test_2/input/testnamespace/testsubnamespace/TestClass3.cpp"
    )

    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp" actual1)
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp" actual2)
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp" actual3)
    set(expected4
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp"
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp"
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp"
    )

    if(NOT "${expected1}" STREQUAL "${actual1}")
        message(FATAL_ERROR "'expected1': '${expected1}' != 'actual1': '${actual1}'")
    endif()

    if(NOT "${expected2}" STREQUAL "${actual2}")
        message(FATAL_ERROR "'expected2': '${expected2}' != 'actual2': '${actual2}'")
    endif()

    if(NOT "${expected3}" STREQUAL "${actual3}")
        message(FATAL_ERROR "'expected3': '${expected3}' != 'actual3': '${actual3}'")
    endif()

    if(NOT "${expected4}" STREQUAL "${actual4}")
        message(FATAL_ERROR "'expected4': '${expected4}' != 'actual4': '${actual4}'")
    endif()

    message("... PASS")
endfunction()

function(test_3)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass1.hpp" expected1)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass2.hpp" expected2)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/expected/testnamespace/testsubnamespace/TestClass3.hpp" expected3)

    set(srcDirectory "${CMAKE_CURRENT_BINARY_DIR}/..")
    get_filename_component(buildDirName "${CMAKE_CURRENT_BINARY_DIR}" NAME)

    cmake_path(NORMAL_PATH srcDirectory)
    cmake_path(APPEND srcDirectory DIR)
    cmake_path(GET srcDirectory PARENT_PATH srcDirectory)

    generate_interface_only_files(actual4
        SRC_DIRECTORY "${srcDirectory}"
        SRC_BASE_DIRECTORY "${srcDirectory}/src/test/resources/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/input"
        DST_BASE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}"
        HEADER_FILES_EXPRESSIONS "**/*.hpp"
        SOURCE_FILES_EXPRESSIONS "**/*.cpp"
        HEADER_SOURCE_MAPS "TestClass3>WindowsTestClass3"
    )

    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp" actual1)
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp" actual2)
    file(READ "${CMAKE_CURRENT_BINARY_DIR}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp" actual3)
    set(expected4
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass1.hpp"
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass2.hpp"
        "${buildDirName}/test_generate_interface_only_files/${CMAKE_CURRENT_FUNCTION}/testnamespace/testsubnamespace/TestClass3.hpp"
    )

    if(NOT "${expected1}" STREQUAL "${actual1}")
        message(FATAL_ERROR "'expected1': '${expected1}' != 'actual1': '${actual1}'")
    endif()

    if(NOT "${expected2}" STREQUAL "${actual2}")
        message(FATAL_ERROR "'expected2': '${expected2}' != 'actual2': '${actual2}'")
    endif()

    if(NOT "${expected3}" STREQUAL "${actual3}")
        message(FATAL_ERROR "'expected3': '${expected3}' != 'actual3': '${actual3}'")
    endif()

    if(NOT "${expected4}" STREQUAL "${actual4}")
        message(FATAL_ERROR "'expected4': '${expected4}' != 'actual4': '${actual4}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
    test_2()
    test_3()
endfunction()

execute_test_script()
