include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(prefix "actual")
    set(name "c.txt")
    set(path "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a")

    set(expected_FILE "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c/c.txt")
    set(expected_DIR "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c")

    cmake_path(NORMAL_PATH path)
    cmake_path(NORMAL_PATH expected_FILE)
    cmake_path(NORMAL_PATH expected_DIR)

    find_file_in("${prefix}" "${name}" "${path}")

    if(NOT "${expected_FILE}" STREQUAL "${actual_FILE}")
        message(FATAL_ERROR "'expected_FILE': '${expected_FILE}' != 'actual_FILE': '${actual_FILE}'")
    endif()

    if(NOT "${expected_DIR}" STREQUAL "${actual_DIR}")
        message(FATAL_ERROR "'expected_DIR': '${expected_DIR}' != 'actual_DIR': '${actual_DIR}'")
    endif()

    message("... PASS")
endfunction()

function(execute_test_script)
    test_1()
endfunction()

execute_test_script()
