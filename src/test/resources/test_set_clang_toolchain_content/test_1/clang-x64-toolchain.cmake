set(CMAKE_SYSTEM_PROCESSOR "AMD64")
set(CMAKE_SYSTEM_NAME "Windows")

set(COMPILER_PATH "C:/Program Files/LLVM/bin")

set(CMAKE_C_COMPILER          "${COMPILER_PATH}/clang.exe")
set(CMAKE_C_COMPILER_TARGET   "x86_64-pc-windows-msvc")
set(CMAKE_CXX_COMPILER        "${COMPILER_PATH}/clang++.exe")
set(CMAKE_CXX_COMPILER_TARGET "x86_64-pc-windows-msvc")

set(ENV{PATH} "C:\\Program Files\\LLVM\\bin;$ENV{PATH}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
