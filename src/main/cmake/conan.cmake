function(
    conan_settings
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
    elseif("${systemName}" STREQUAL "Linux")
        set(value "--settings" "os=${systemName}")
    elseif("${systemName}" STREQUAL "Darwin")
        set(value "--settings" "os=Macos")
    else()
        message(FATAL_ERROR "Unsupported systemName: '${systemName}'")
    endif()

    # arch
    if("${systemProcessor}" STREQUAL "AMD64")
        set(value "${value}" "--settings" "arch=x86_64")
    else()
        message(FATAL_ERROR "Unsupported systemProcessor: '${systemProcessor}'")
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
        if("${msvcRuntimeLibrary}" STREQUAL "MultiThreadedDLL")
            set(value "${value}" "--settings" "compiler.runtime=MD")
        else()
            message(FATAL_ERROR "Unsupported msvcRuntimeLibrary: '${msvcRuntimeLibrary}'")
        endif()
    elseif("${cxxCompilerId}" STREQUAL "GNU")
        set(value "${value}" "--settings" "compiler=gcc")

        # compiler.version
        if("${cxxCompilerVersion}" VERSION_GREATER_EQUAL "10")
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

    set("${variableName}" "${value}" PARENT_SCOPE)
endfunction()

function(
    conan_options
    variableName
    buildSharedLibs
)
    set("pythonBoolValue" "False")
    if("${buildSharedLibs}")
        set("pythonBoolValue" "True")
    endif()

    # self
    set(value "--options" "shared=${pythonBoolValue}")

    # dependencies
    if("${ARGC}" GREATER_EQUAL "3")
        set("start" "2")
        math(EXPR "stop" "${ARGC} - 1")
        foreach(i RANGE "${start}" "${stop}")
            set(value "--options" "${ARGV${i}}:shared=${pythonBoolValue}" "${value}")
        endforeach()
    endif()

    set("${variableName}" "${value}" PARENT_SCOPE)
endfunction()

macro(
    conan_install
    conanProgramPath
    conanFile
    conanInstalledDir
    conanSettings
    conanOptions
)
    if("" STREQUAL "${conanProgramPath}" OR NOT EXISTS "${conanProgramPath}")
        message(FATAL_ERROR "Not defined or not exists conanProgramPath: '${conanProgramPath}'")
    endif()
    if(NOT EXISTS "${conanInstalledDir}")
        execute_process(
            COMMAND "${conanProgramPath}"
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
    conanProgramPath
    conanFile
    conanInstalledDir
    conanSettings
    conanOptions
)
    if("" STREQUAL "${conanProgramPath}" OR NOT EXISTS "${conanProgramPath}")
        message(FATAL_ERROR "Not defined or not exists conanProgramPath: '${conanProgramPath}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${conanProgramPath}"
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
    conanProgramPath
    conanFile
    conanUser
    conanChannel
    conanPackageDir
    conanSettings
    conanOptions
)
    if("" STREQUAL "${conanProgramPath}" OR NOT EXISTS "${conanProgramPath}")
        message(FATAL_ERROR "Not defined or not exists conanProgramPath: '${conanProgramPath}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${conanProgramPath}"
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
    add_custom_target_conan_export
    targetName
    conanProgramPath
    conanFile
    conanPackageDir
    conanSettings
    conanOptions
)
    if("" STREQUAL "${conanProgramPath}" OR NOT EXISTS "${conanProgramPath}")
        message(FATAL_ERROR "Not defined or not exists conanProgramPath: '${conanProgramPath}'")
    endif()
    add_custom_target("${targetName}"
        COMMAND "${conanProgramPath}"
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
