set(CMAKE_SYSTEM_PROCESSOR "arm")
set(CMAKE_SYSTEM_NAME "Generic")

set(COMPILER_PATH "C:/Program Files/IAR Systems/Embedded Workbench 9.3/arm/bin")

set(CMAKE_ASM_COMPILER "${COMPILER_PATH}/iasmarm.exe")
set(CMAKE_C_COMPILER   "${COMPILER_PATH}/iccarm.exe")
set(CMAKE_CXX_COMPILER "${COMPILER_PATH}/iccarm.exe")
set(CMAKE_AR           "${COMPILER_PATH}/iarchive.exe")
set(CMAKE_LINKER       "${COMPILER_PATH}/ilinkarm.exe")
set(CMAKE_RC_COMPILER  "")

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

set(ENV{PATH} "C:\\Program Files\\IAR Systems\\Embedded Workbench 9.3\\arm\\bin;$ENV{PATH}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM "NEVER")
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY "ONLY")
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE "ONLY")
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE "ONLY")
