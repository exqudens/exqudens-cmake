function(
    set_conan_boolean
    variableName
    cmakeValue
)
    if("${cmakeValue}")
        set(value "True")
    else()
        set(value "False")
    endif()

    set("${variableName}" "${value}" PARENT_SCOPE)
endfunction()

function(
    set_conan_msvc_compiler_runtime
    variableName
    msvcRuntimeLibrary
)
    if("${msvcRuntimeLibrary}" STREQUAL "MultiThreaded")
        set(value "MT")
    elseif("${msvcRuntimeLibrary}" STREQUAL "MultiThreadedDLL")
        set(value "MD")
    elseif("${msvcRuntimeLibrary}" STREQUAL "MultiThreadedDebug")
        set(value "MTd")
    elseif("${msvcRuntimeLibrary}" STREQUAL "MultiThreadedDebugDLL")
        set(value "MDd")
    else()
        message(FATAL_ERROR "Unsupported msvcRuntimeLibrary: '${msvcRuntimeLibrary}'")
    endif()

    set("${variableName}" "${value}" PARENT_SCOPE)
endfunction()

function(
    set_conan_path
    variableName
    searchPaths
)
    cmake_path(
        CONVERT "${searchPaths}"
        TO_CMAKE_PATH_LIST "cmakeSearchPaths"
        NORMALIZE
    )
    foreach(pathDir ${cmakeSearchPaths})
        file(GLOB pathDirFileNames RELATIVE "${pathDir}" "${pathDir}/*")
        foreach(pathFileName ${pathDirFileNames})
            if("conan" STREQUAL "${pathFileName}" OR "conan.exe" STREQUAL "${pathFileName}")
                set("conanPath" "${pathDir}/${pathFileName}")
            endif()
        endforeach()
    endforeach()
    if(DEFINED "conanPath" AND EXISTS "${conanPath}")
        cmake_path(
            CONVERT "${conanPath}"
            TO_NATIVE_PATH_LIST "nativeConanPath"
            NORMALIZE
        )
        set("${variableName}" "${nativeConanPath}" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "No 'conan' or 'conan.exe' in '${searchPaths}'")
    endif()
endfunction()

function(
    set_conan_command
    variableName
    conanPath
)
    cmake_path(
        CONVERT "${conanPath}"
        TO_CMAKE_PATH_LIST "conanCommand"
        NORMALIZE
    )
    set("${variableName}" "${conanCommand}" PARENT_SCOPE)
endfunction()

function(
    set_conan_settings
    variableName
    systemName
    systemProcessor
    cxxCompilerId
    cxxCompilerVersion
    msvcRuntimeLibrary
    cxxStandard
    buildType
)
    # os
    if("${systemName}" STREQUAL "Windows")
        set(value "--settings" "os=${systemName}")

        # arch
        if("${systemProcessor}" STREQUAL "AMD64" OR "${systemProcessor}" STREQUAL "IA64")
            set(value "${value}" "--settings" "arch=x86_64")
        elseif("${systemProcessor}" STREQUAL "x86")
            set(value "${value}" "--settings" "arch=x86")
        else()
            message(FATAL_ERROR "Unsupported systemProcessor: '${systemProcessor}'")
        endif()
    else()
        message(FATAL_ERROR "Unsupported systemName: '${systemName}'")
    endif()

    # compiler
    if("${cxxCompilerId}" STREQUAL "MSVC")
        set(value "${value}" "--settings" "compiler=Visual Studio")

        # compiler.version
        if("${cxxCompilerVersion}" VERSION_GREATER_EQUAL "19" AND "${cxxCompilerVersion}" VERSION_LESS "20")
            set(value "${value}" "--settings" "compiler.version=16")
        elseif("${cxxCompilerVersion}" VERSION_GREATER_EQUAL "17" AND "${cxxCompilerVersion}" VERSION_LESS "18")
            set(value "${value}" "--settings" "compiler.version=15")
        else()
            message(FATAL_ERROR "Unsupported cxxCompilerVersion: '${cxxCompilerVersion}'")
        endif()

        # compiler.runtime
        set_conan_msvc_compiler_runtime(conanCompilerRuntime "${msvcRuntimeLibrary}")
        set(value "${value}" "--settings" "compiler.runtime=${conanCompilerRuntime}")
    elseif("${cxxCompilerId}" STREQUAL "GNU")
        set(value "${value}" "--settings" "compiler=gcc")

        # compiler.version
        if("${cxxCompilerVersion}" VERSION_GREATER_EQUAL "8" AND "${cxxCompilerVersion}" VERSION_LESS "9")
            set(value "${value}" "--settings" "compiler.version=8")
        elseif("${cxxCompilerVersion}" VERSION_GREATER_EQUAL "9" AND "${cxxCompilerVersion}" VERSION_LESS "10")
            set(value "${value}" "--settings" "compiler.version=9")
        elseif("${cxxCompilerVersion}" VERSION_GREATER_EQUAL "10" AND "${cxxCompilerVersion}" VERSION_LESS "11")
            set(value "${value}" "--settings" "compiler.version=10")
        else()
            message(FATAL_ERROR "Unsupported cxxCompilerVersion: '${cxxCompilerVersion}'")
        endif()

        # compiler.libcxx
        if("${cxxStandard}" GREATER_EQUAL "11")
            set(value "${value}" "--settings" "compiler.libcxx=libstdc++11")
        else()
            set(value "${value}" "--settings" "compiler.libcxx=libstdc++")
        endif()
    else()
        message(FATAL_ERROR "Unsupported cxxCompilerId: '${cxxCompilerId}'")
    endif()

    # build_type
    if("${buildType}" STREQUAL "Release")
        set(value "${value}" "--settings" "build_type=Release")
    else()
        message(FATAL_ERROR "Unsupported buildType: '${buildType}'")
    endif()

    # additional
    if("${ARGC}" GREATER_EQUAL "9")
        set("start" "8")
        math(EXPR "stop" "${ARGC} - 1")
        foreach(i RANGE "${start}" "${stop}")
            set(argument "${ARGV${i}}")
            if(NOT "" STREQUAL "${argument}")
                if(NOT "${argument}" IN_LIST "value")
                    list(APPEND value "--settings" "${argument}")
                endif()
            endif()
        endforeach()
    endif()

    set("${variableName}" "${value}" PARENT_SCOPE)
endfunction()

function(
    set_conan_options
    variableName
    buildSharedLibs
)
    set_conan_boolean(conanBuildSharedLibs "${buildSharedLibs}")

    # self
    list(APPEND value "--options" "shared=${conanBuildSharedLibs}")

    # additional
    if("${ARGC}" GREATER_EQUAL "3")
        set("start" "2")
        math(EXPR "stop" "${ARGC} - 1")
        foreach(i RANGE "${start}" "${stop}")
            set(argument "${ARGV${i}}")
            if(NOT "" STREQUAL "${argument}")
                if(NOT "${argument}" IN_LIST "value")
                    list(APPEND value "--options" "${argument}")
                endif()
            endif()
        endforeach()
    endif()

    set("${variableName}" "${value}" PARENT_SCOPE)
endfunction()

macro(
    conan_install
    conanCommand
    conanFile
    conanInstalledDir
    conanSettings
    conanOptions
)
    if("" STREQUAL "${conanCommand}" OR NOT EXISTS "${conanCommand}")
        message(FATAL_ERROR "Not defined or not exists conanCommand: '${conanCommand}'")
    endif()
    if(NOT EXISTS "${conanInstalledDir}")
        execute_process(
            COMMAND "${conanCommand}"
                    install
                    "${conanFile}"
                    --install-folder
                    "${conanInstalledDir}"
                    ${conanSettings}
                    ${conanOptions}
            COMMAND_ERROR_IS_FATAL ANY
        )
    endif()
endmacro()

macro(
    add_custom_target_conan_install
    targetName
    conanCommand
    conanFile
    conanInstalledDir
    conanSettings
    conanOptions
)
    if("" STREQUAL "${conanCommand}" OR NOT EXISTS "${conanCommand}")
        message(FATAL_ERROR "Not defined or not exists conanCommand: '${conanCommand}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${conanCommand}"
                install
                "${conanFile}"
                --install-folder
                "${conanInstalledDir}"
                ${conanSettings}
                ${conanOptions}
        COMMENT "custom-target: '${targetName}'"
        VERBATIM
    )
endmacro()

macro(
    add_custom_target_conan_install_clean
    targetName
    cmakeProgramPath
    conanInstalledDir
)
    if("" STREQUAL "${cmakeProgramPath}" OR NOT EXISTS "${cmakeProgramPath}")
        message(FATAL_ERROR "Not defined or not exists cmakeProgramPath: '${cmakeProgramPath}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${cmakeProgramPath}"
                -E
                rm
                -rf
                "${conanInstalledDir}"
        COMMENT "custom-target: '${targetName}'"
        VERBATIM
    )
endmacro()

macro(
    add_custom_target_conan_export_user_channel
    targetName
    conanCommand
    conanFile
    conanUser
    conanChannel
    conanPackageDir
    conanSettings
    conanOptions
)
    if("" STREQUAL "${conanCommand}" OR NOT EXISTS "${conanCommand}")
        message(FATAL_ERROR "Not defined or not exists conanCommand: '${conanCommand}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${conanCommand}"
                export-pkg
                -f
                "${conanFile}"
                "${conanUser}/${conanChannel}"
                --package-folder
                "${conanPackageDir}"
                ${conanSettings}
                ${conanOptions}
        COMMENT "custom-target: '${targetName}'"
        VERBATIM
    )
endmacro()

macro(
    add_custom_target_conan_export_user_channel_clean
    targetName
    conanCommand
    conanPackageName
    conanPackageVersion
    conanUser
    conanChannel
)
    if("" STREQUAL "${conanCommand}" OR NOT EXISTS "${conanCommand}")
        message(FATAL_ERROR "Not defined or not exists conanCommand: '${conanCommand}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${conanCommand}"
                remove
                -f
                "${conanPackageName}/${conanPackageVersion}@${conanUser}/${conanChannel}"
        COMMENT "custom-target: '${targetName}'"
        VERBATIM
    )
endmacro()

macro(
    add_custom_target_conan_export
    targetName
    conanCommand
    conanFile
    conanPackageDir
    conanSettings
    conanOptions
)
    if("" STREQUAL "${conanCommand}" OR NOT EXISTS "${conanCommand}")
        message(FATAL_ERROR "Not defined or not exists conanCommand: '${conanCommand}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${conanCommand}"
                export-pkg
                "${conanFile}"
                --package-folder
                "${conanPackageDir}"
                ${conanSettings}
                ${conanOptions}
        COMMENT "custom-target: '${targetName}'"
        VERBATIM
    )
endmacro()

macro(
    add_custom_target_conan_export_clean
    targetName
    conanCommand
    conanPackageName
    conanPackageVersion
)
    if("" STREQUAL "${conanCommand}" OR NOT EXISTS "${conanCommand}")
        message(FATAL_ERROR "Not defined or not exists conanCommand: '${conanCommand}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${conanCommand}"
                remove
                -f
                "${conanPackageName}/${conanPackageVersion}"
        COMMENT "custom-target: '${targetName}'"
        VERBATIM
    )
endmacro()
