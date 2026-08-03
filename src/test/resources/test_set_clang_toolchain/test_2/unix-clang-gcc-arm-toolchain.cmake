set(CMAKE_SYSTEM_PROCESSOR "armv7")
set(CMAKE_SYSTEM_NAME "Generic")

set(CMAKE_ASM_COMPILER "/opt/llvm/bin/clang")
set(CMAKE_C_COMPILER   "/opt/llvm/bin/clang")
set(CMAKE_CXX_COMPILER "/opt/llvm/bin/clang++")
set(CLANG_OBJCOPY      "/opt/llvm/bin/llvm-objcopy")
set(CLANG_SIZE         "/opt/llvm/bin/llllvm-size")

set(CMAKE_ASM_COMPILER_TARGET "arm-none-eabi")
set(CMAKE_C_COMPILER_TARGET   "arm-none-eabi")
set(CMAKE_CXX_COMPILER_TARGET "arm-none-eabi")

set(CMAKE_SYSROOT "/opt/arm-none-eabi-gcc")

set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES
    "/opt/arm-none-eabi-gcc/lib/gcc/arm-none-eabi/14.3.1/include"
    "/opt/arm-none-eabi-gcc/lib/gcc/arm-none-eabi/14.3.1/include-fixed"
    "/opt/arm-none-eabi-gcc/arm-none-eabi/include"
)
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES
    "${CMAKE_C_STANDARD_INCLUDE_DIRECTORIES}"
    "/opt/arm-none-eabi-gcc/arm-none-eabi/include/c++/14.3.1"
    "/opt/arm-none-eabi-gcc/arm-none-eabi/include/c++/14.3.1/arm-none-eabi"
    "/opt/arm-none-eabi-gcc/arm-none-eabi/include/c++/14.3.1/backward"
)

set(ENV{PATH} "/opt/llvm/bin:/opt/arm-none-eabi-gcc/bin:$ENV{PATH}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
