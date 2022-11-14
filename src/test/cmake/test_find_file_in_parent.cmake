include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(prefix "actual")
    set(name "c.txt")
    set(path "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c/c.txt")
    set(maxParentLevel "1")

    set(expected_FILE "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c/c.txt")
    set(expected_DIR "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c")

    cmake_path(NORMAL_PATH path)
    cmake_path(NORMAL_PATH expected_FILE)
    cmake_path(NORMAL_PATH expected_DIR)

    find_file_in_parent("${prefix}" "${name}" "${path}" "${maxParentLevel}")

    if(NOT "${expected_FILE}" STREQUAL "${actual_FILE}")
        message(FATAL_ERROR "'expected_FILE': '${expected_FILE}' != 'actual_FILE': '${actual_FILE}'")
    endif()

    if(NOT "${expected_DIR}" STREQUAL "${actual_DIR}")
        message(FATAL_ERROR "'expected_DIR': '${expected_DIR}' != 'actual_DIR': '${actual_DIR}'")
    endif()

    message("... PASS")
endfunction()

function(test_2)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(prefix "actual")
    set(name "c.txt")
    set(path "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c/c.txt")
    set(maxParentLevel "")

    set(expected_FILE "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c/c.txt")
    set(expected_DIR "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c")

    cmake_path(NORMAL_PATH path)
    cmake_path(NORMAL_PATH expected_FILE)
    cmake_path(NORMAL_PATH expected_DIR)

    find_file_in_parent("${prefix}" "${name}" "${path}" "${maxParentLevel}")

    if(NOT "${expected_FILE}" STREQUAL "${actual_FILE}")
        message(FATAL_ERROR "'expected_FILE': '${expected_FILE}' != 'actual_FILE': '${actual_FILE}'")
    endif()

    if(NOT "${expected_DIR}" STREQUAL "${actual_DIR}")
        message(FATAL_ERROR "'expected_DIR': '${expected_DIR}' != 'actual_DIR': '${actual_DIR}'")
    endif()

    message("... PASS")
endfunction()

function(test_3)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(prefix "actual")
    set(name "b.txt")
    set(path "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c")
    set(maxParentLevel "")

    set(expected_FILE "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/b.txt")
    set(expected_DIR "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b")

    cmake_path(NORMAL_PATH path)
    cmake_path(NORMAL_PATH expected_FILE)
    cmake_path(NORMAL_PATH expected_DIR)

    find_file_in_parent("${prefix}" "${name}" "${path}" "${maxParentLevel}")

    if(NOT "${expected_FILE}" STREQUAL "${actual_FILE}")
        message(FATAL_ERROR "'expected_FILE': '${expected_FILE}' != 'actual_FILE': '${actual_FILE}'")
    endif()

    if(NOT "${expected_DIR}" STREQUAL "${actual_DIR}")
        message(FATAL_ERROR "'expected_DIR': '${expected_DIR}' != 'actual_DIR': '${actual_DIR}'")
    endif()

    message("... PASS")
endfunction()

function(test_4)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(prefix "actual")
    set(name "b.txt")
    set(path "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c")
    set(maxParentLevel "1")

    set(expected_FILE "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/b.txt")
    set(expected_DIR "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b")

    cmake_path(NORMAL_PATH path)
    cmake_path(NORMAL_PATH expected_FILE)
    cmake_path(NORMAL_PATH expected_DIR)

    find_file_in_parent("${prefix}" "${name}" "${path}" "${maxParentLevel}")

    if(NOT "${expected_FILE}" STREQUAL "${actual_FILE}")
        message(FATAL_ERROR "'expected_FILE': '${expected_FILE}' != 'actual_FILE': '${actual_FILE}'")
    endif()

    if(NOT "${expected_DIR}" STREQUAL "${actual_DIR}")
        message(FATAL_ERROR "'expected_DIR': '${expected_DIR}' != 'actual_DIR': '${actual_DIR}'")
    endif()

    message("... PASS")
endfunction()

function(test_5)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(prefix "actual")
    set(name "a.txt")
    set(path "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c/c.txt")
    set(maxParentLevel "3")

    set(expected_FILE "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/a.txt")
    set(expected_DIR "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a")

    cmake_path(NORMAL_PATH path)
    cmake_path(NORMAL_PATH expected_FILE)
    cmake_path(NORMAL_PATH expected_DIR)

    find_file_in_parent("${prefix}" "${name}" "${path}" "${maxParentLevel}")

    if(NOT "${expected_FILE}" STREQUAL "${actual_FILE}")
        message(FATAL_ERROR "'expected_FILE': '${expected_FILE}' != 'actual_FILE': '${actual_FILE}'")
    endif()

    if(NOT "${expected_DIR}" STREQUAL "${actual_DIR}")
        message(FATAL_ERROR "'expected_DIR': '${expected_DIR}' != 'actual_DIR': '${actual_DIR}'")
    endif()

    message("... PASS")
endfunction()

function(test_6)
    message("${CMAKE_CURRENT_FUNCTION} ...")

    set(prefix "actual")
    set(name "a")
    set(path "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a/b/c/c.txt")
    set(maxParentLevel "4")

    set(expected_FILE "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent/a")
    set(expected_DIR "${CMAKE_CURRENT_LIST_DIR}/../resources/test_find_file_in_parent")

    cmake_path(NORMAL_PATH path)
    cmake_path(NORMAL_PATH expected_FILE)
    cmake_path(NORMAL_PATH expected_DIR)

    find_file_in_parent("${prefix}" "${name}" "${path}" "${maxParentLevel}")

    if(NOT "${expected_FILE}" STREQUAL "${actual_FILE}")
        message(FATAL_ERROR "'expected_FILE': '${expected_FILE}' != 'actual_FILE': '${actual_FILE}'")
    endif()

    if(NOT "${expected_DIR}" STREQUAL "${actual_DIR}")
        message(FATAL_ERROR "'expected_DIR': '${expected_DIR}' != 'actual_DIR': '${actual_DIR}'")
    endif()

    message("... PASS")
endfunction()

function(execute_script)
    test_1()
    test_2()
    test_3()
    test_4()
    test_5()
    test_6()
endfunction()

execute_script()
