set(CMAKE_SYSTEM_PROCESSOR "AMD64" CACHE INTERNAL "..." FORCE)
set(CMAKE_SYSTEM_NAME "Windows" CACHE INTERNAL "..." FORCE)

set(MSVC_CL_PATH "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64" CACHE INTERNAL "..." FORCE)
set(MSVC_RC_PATH "C:/Program Files (x86)/Windows Kits/10/bin/10.0.19041.0/x64" CACHE INTERNAL "..." FORCE)

set(CMAKE_C_COMPILER   "${MSVC_CL_PATH}/cl.exe" CACHE INTERNAL "..." FORCE)
set(CMAKE_CXX_COMPILER "${MSVC_CL_PATH}/cl.exe" CACHE INTERNAL "..." FORCE)
set(CMAKE_AR           "${MSVC_CL_PATH}/lib.exe" CACHE INTERNAL "..." FORCE)
set(CMAKE_LINKER       "${MSVC_CL_PATH}/link.exe" CACHE INTERNAL "..." FORCE)
set(CMAKE_RC_COMPILER  "${MSVC_RC_PATH}/rc.exe" CACHE INTERNAL "..." FORCE)
set(CMAKE_MT           "${MSVC_RC_PATH}/mt.exe" CACHE INTERNAL "..." FORCE)

set(ENV{INCLUDE} "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\VC\\Tools\\MSVC\\14.29.30133\\include;C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.19041.0\\ucrt;C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.19041.0\\shared;C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.19041.0\\um;C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.19041.0\\winrt;C:\\Program Files (x86)\\Windows Kits\\10\\include\\10.0.19041.0\\cppwinrt")
set(ENV{LIBPATH} "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\VC\\Tools\\MSVC\\14.29.30133\\lib\\x64;C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\VC\\Tools\\MSVC\\14.29.30133\\lib\\x86\\store\\references;C:\\Program Files (x86)\\Windows Kits\\10\\UnionMetadata\\10.0.19041.0;C:\\Program Files (x86)\\Windows Kits\\10\\References\\10.0.19041.0;C:\\Windows\\Microsoft.NET\\Framework64\\v4.0.30319")
set(ENV{LIB} "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\VC\\Tools\\MSVC\\14.29.30133\\lib\\x64;C:\\Program Files (x86)\\Windows Kits\\10\\lib\\10.0.19041.0\\ucrt\\x64;C:\\Program Files (x86)\\Windows Kits\\10\\lib\\10.0.19041.0\\um\\x64")
set(ENV{PATH} "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\BuildTools\\VC\\Tools\\MSVC\\14.29.30133\\bin\\Hostx64\\x64;C:\\Program Files (x86)\\Windows Kits\\10\\bin\\10.0.19041.0\\x64;$ENV{PATH}")

set(CMAKE_C_STANDARD_INCLUDE_DIRECTORIES "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/include;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/ucrt;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/shared;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/um;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/winrt;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/cppwinrt" CACHE INTERNAL "..." FORCE)
set(CMAKE_C_STANDARD_LINK_DIRECTORIES "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x64;C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x86/store/references;C:/Program Files (x86)/Windows Kits/10/UnionMetadata/10.0.19041.0;C:/Program Files (x86)/Windows Kits/10/References/10.0.19041.0;C:/Windows/Microsoft.NET/Framework64/v4.0.30319" CACHE INTERNAL "..." FORCE)

set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/include;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/ucrt;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/shared;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/um;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/winrt;C:/Program Files (x86)/Windows Kits/10/include/10.0.19041.0/cppwinrt" CACHE INTERNAL "..." FORCE)
set(CMAKE_CXX_STANDARD_LINK_DIRECTORIES "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x64;C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x86/store/references;C:/Program Files (x86)/Windows Kits/10/UnionMetadata/10.0.19041.0;C:/Program Files (x86)/Windows Kits/10/References/10.0.19041.0;C:/Windows/Microsoft.NET/Framework64/v4.0.30319;C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/lib/x64;C:/Program Files (x86)/Windows Kits/10/lib/10.0.19041.0/ucrt/x64;C:/Program Files (x86)/Windows Kits/10/lib/10.0.19041.0/um/x64" CACHE INTERNAL "..." FORCE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER CACHE INTERNAL "..." FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY CACHE INTERNAL "..." FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY CACHE INTERNAL "..." FORCE)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY CACHE INTERNAL "..." FORCE)

link_directories("${CMAKE_CXX_STANDARD_LINK_DIRECTORIES}") # remove when CMAKE_CXX_STANDARD_LINK_DIRECTORIES is supported
