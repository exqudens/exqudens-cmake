set(CMAKE_SYSTEM_PROCESSOR "armv7")
set(CMAKE_SYSTEM_NAME "Generic")

set(CMAKE_ASM_COMPILER "C:/Program Files/LLVM/bin/clang.exe")
set(CMAKE_C_COMPILER   "C:/Program Files/LLVM/bin/clang.exe")
set(CMAKE_CXX_COMPILER "C:/Program Files/LLVM/bin/clang++.exe")
set(CLANG_OBJCOPY      "C:/Program Files/LLVM/bin/llvm-objcopy.exe")
set(CLANG_SIZE         "C:/Program Files/LLVM/bin/llllvm-size.exe")

set(CMAKE_ASM_COMPILER_TARGET "arm-none-eabi")
set(CMAKE_C_COMPILER_TARGET   "arm-none-eabi")
set(CMAKE_CXX_COMPILER_TARGET "arm-none-eabi")

set(CMAKE_SYSROOT "C:/ST/STM32CubeCLT_1.22.0/GNU-tools-for-STM32/arm-none-eabi")

set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES
    "C:/ST/STM32CubeCLT_1.22.0/GNU-tools-for-STM32/lib/gcc/arm-none-eabi/14.3.1/include"
    "C:/ST/STM32CubeCLT_1.22.0/GNU-tools-for-STM32/lib/gcc/arm-none-eabi/14.3.1/include-fixed"
    "C:/ST/STM32CubeCLT_1.22.0/GNU-tools-for-STM32/arm-none-eabi/include"
)
set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES
    "${CMAKE_C_STANDARD_INCLUDE_DIRECTORIES}"
    "C:/ST/STM32CubeCLT_1.22.0/GNU-tools-for-STM32/arm-none-eabi/include/c++/14.3.1"
    "C:/ST/STM32CubeCLT_1.22.0/GNU-tools-for-STM32/arm-none-eabi/include/c++/14.3.1/arm-none-eabi"
    "C:/ST/STM32CubeCLT_1.22.0/GNU-tools-for-STM32/arm-none-eabi/include/c++/14.3.1/backward"
)

set(ENV{PATH} "C:\\Program Files\\LLVM\\bin;C:\\ST\\STM32CubeCLT_1.22.0\\GNU-tools-for-STM32\\bin;$ENV{PATH}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
