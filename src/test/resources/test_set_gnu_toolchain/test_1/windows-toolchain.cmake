set(CMAKE_SYSTEM_PROCESSOR "arm")
set(CMAKE_SYSTEM_NAME "Generic")

set(CMAKE_C_COMPILER   "C:/gcc/bin/arm-none-eabi-gcc.exe")
set(CMAKE_CXX_COMPILER "C:/gcc/bin/arm-none-eabi-g++.exe")
set(CMAKE_ASM_COMPILER "C:/gcc/bin/arm-none-eabi-gcc.exe")
set(CMAKE_SIZE         "C:/gcc/bin/arm-none-eabi-size.exe")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(ENV{PATH} "C:\\gcc\\bin;$ENV{PATH}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
