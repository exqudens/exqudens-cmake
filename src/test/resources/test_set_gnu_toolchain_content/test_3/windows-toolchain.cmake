set(CMAKE_SYSTEM_PROCESSOR "x86_64")
set(CMAKE_SYSTEM_NAME "Linux")

set(COMPILER_PATH "/usr/bin")

set(CMAKE_C_COMPILER   "${COMPILER_PATH}/gcc")
set(CMAKE_CXX_COMPILER "${COMPILER_PATH}/g++")

set(ENV{PATH} "\\usr\\bin;$ENV{PATH}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
