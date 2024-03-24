cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(PUSH)
    cmake_policy(SET CMP0007 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0010 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0012 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0054 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0057 NEW)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(list_functions)
    message("test_1")
endfunction()

function(test_1)
    get_filename_component(testFileName "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    set(testFunctionName "${CMAKE_CURRENT_FUNCTION}")
    message("${testFileName}.${testFunctionName} ...")

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${testFileName}/${testFunctionName}/settings.json" expectedSettings)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../resources/${testFileName}/${testFunctionName}/c_cpp_properties.json" expectedCCppProperties)

    file(REMOVE "${CMAKE_CURRENT_LIST_DIR}/../../../build/${testFileName}/${testFunctionName}/settings.json")
    file(REMOVE "${CMAKE_CURRENT_LIST_DIR}/../../../build/${testFileName}/${testFunctionName}/c_cpp_properties.json")

    set(settings "{\"C_Cpp.errorSquiggles\": \"enabled\"}")

    vscode(
        SETTINGS_VAR "settings"
        SETTINGS_INPUT "var"
        SETTINGS_C_CPP_ERROR_SQUIGGLES "enabledIfIncludesResolve"
        SETTINGS_FILE "${CMAKE_CURRENT_LIST_DIR}/../../../build/${testFileName}/${testFunctionName}/settings.json"
        C_CPP_PROPERTIES_FILE "${CMAKE_CURRENT_LIST_DIR}/../../../build/${testFileName}/${testFunctionName}/c_cpp_properties.json"
        C_CPP_PROPERTIES_CONFIG_NAME "mscv-1"
        C_CPP_PROPERTIES_CONFIG_COMPILER_PATH "C:/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/cl.exe"
        C_CPP_PROPERTIES_CONFIG_COMPILER_ARGS "-m64"
        C_CPP_PROPERTIES_CONFIG_INTELLI_SENSE_MODE "windows-msvc-x64"
        C_CPP_PROPERTIES_CONFIG_C_STANDARD "c17"
        C_CPP_PROPERTIES_CONFIG_CPP_STANDARD "c++20"
        C_CPP_PROPERTIES_CONFIG_INCLUDE_PATH "\${workspaceFolder}/src/main/c" "\${workspaceFolder}/src/main/cpp"
    )

    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/${testFileName}/${testFunctionName}/settings.json" actualSettings)
    file(READ "${CMAKE_CURRENT_LIST_DIR}/../../../build/${testFileName}/${testFunctionName}/c_cpp_properties.json" actualCCppProperties)

    string(JSON settingsEqual EQUAL "${expectedSettings}" "${actualSettings}")
    if(NOT "${settingsEqual}")
        message(FATAL_ERROR "'expectedSettings': '${expectedSettings}' != 'actualSettings': '${actualSettings}'")
    endif()

    string(JSON cCppPropertiesEqual EQUAL "${expectedCCppProperties}" "${actualCCppProperties}")
    if(NOT "${cCppPropertiesEqual}")
        message(FATAL_ERROR "'expectedCCppProperties': '${expectedCCppProperties}' != 'actualCCppProperties': '${actualCCppProperties}'")
    endif()

    message("... PASS")
endfunction()

block()
    if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
        set(args)
        set(argsStarted "FALSE")
        math(EXPR argIndexMax "${CMAKE_ARGC} - 1")

        foreach(i RANGE "0" "${argIndexMax}")
            if("${argsStarted}")
                list(APPEND args "${CMAKE_ARGV${i}}")
            elseif(NOT "${argsStarted}" AND "${CMAKE_ARGV${i}}" STREQUAL "--")
                set(argsStarted "TRUE")
            endif()
        endforeach()

        set(noEscapeBackslashOption "--no-escape-backslash")

        if("${args}" STREQUAL "")
            cmake_path(GET CMAKE_CURRENT_LIST_FILE FILENAME fileName)
            message(FATAL_ERROR "Usage: cmake -P ${fileName} -- [${noEscapeBackslashOption}] function_name args...")
        endif()

        list(POP_FRONT args firstArg)
        set(escapeBackslash "TRUE")

        if("${firstArg}" STREQUAL "${noEscapeBackslashOption}")
            set(escapeBackslash "FALSE")
            list(POP_FRONT args func)
        else()
            set(func "${firstArg}")
        endif()

        set(wrappedArgs "")

        if(NOT "${args}" STREQUAL "")
            foreach(arg IN LISTS args)
                set(wrappedArg "${arg}")
                string(FIND "${wrappedArg}" " " firstIndexOfSpace)

                if(NOT "${firstIndexOfSpace}" EQUAL "-1")
                    set(wrappedArg "\"${wrappedArg}\"")
                endif()

                if("${escapeBackslash}")
                    string(REPLACE "\\" "\\\\" wrappedArg "${wrappedArg}")
                endif()

                if("${wrappedArgs}" STREQUAL "")
                    string(APPEND wrappedArgs "${wrappedArg}")
                else()
                    string(APPEND wrappedArgs " ${wrappedArg}")
                endif()
            endforeach()
        endif()

        cmake_language(EVAL CODE "${func}(${wrappedArgs})")
    endif()
endblock()

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
endif()