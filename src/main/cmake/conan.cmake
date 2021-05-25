function(
    conan_settings
    variableName
    cmakeSystemName
    cmakeSystemProcessor
    cmakeCxxCompilerId
    cmakeCxxCompilerVersion
    cmakeMsvcRuntimeLibrary
    cmakeCxxStandard
    cmakeBuildType
)
    if(NOT DEFINED "${variableName}" OR "OVERWRITE" STREQUAL "${overwrite}")
        # os
        if("${cmakeSystemName}" STREQUAL "Windows")
            set(value "--settings" "os=${cmakeSystemName}")
        elseif("${cmakeSystemName}" STREQUAL "Linux")
            set(value "--settings" "os=${cmakeSystemName}")
        elseif("${cmakeSystemName}" STREQUAL "Darwin")
            set(value "--settings" "os=Macos")
        else()
            message(FATAL_ERROR "Unsupported cmakeSystemName: '${cmakeSystemName}'")
        endif()

        # arch
        if("${cmakeSystemProcessor}" STREQUAL "AMD64")
            set(value "${value}" "--settings" "arch=x86_64")
        else()
            message(FATAL_ERROR "Unsupported cmakeSystemProcessor: '${cmakeSystemProcessor}'")
        endif()

        # compiler
        if(
            "${cmakeCxxCompilerId}" STREQUAL "MSVC"
            AND "${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "19"
        )
            set(value "${value}" "--settings" "compiler=Visual Studio")
            set(value "${value}" "--settings" "compiler.version=16")
            if("${cmakeMsvcRuntimeLibrary}" STREQUAL "MultiThreadedDLL")
                set(value "${value}" "--settings" "compiler.runtime=MD")
            else()
                set(value "${value}" "--settings" "compiler.runtime=MD")
            endif()
        elseif(
            "${cmakeCxxCompilerId}" STREQUAL "GNU"
            AND "${cmakeCxxCompilerVersion}" VERSION_GREATER_EQUAL "10"
        )
            set(value "${value}" "--settings" "compiler=gcc")
            set(value "${value}" "--settings" "compiler.version=10")
            if("${cmakeCxxStandard}" GREATER_EQUAL "11")
                set(value "${value}" "--settings" "compiler.libcxx=libstdc++11")
            else()
                set(value "${value}" "--settings" "compiler.libcxx=libstdc++")
            endif()
        else()
            message(FATAL_ERROR "Unsupported cmakeCxxCompilerId: '${cmakeCxxCompilerId}' and cmakeCxxCompilerVersion: '${cmakeCxxCompilerVersion}' and cmakeCxxStandard: '${cmakeCxxStandard}'")
        endif()

        # build_type
        if("${cmakeBuildType}" STREQUAL "Release")
            set(value "${value}" "--settings" "build_type=Release")
        else()
            message(FATAL_ERROR "Unsupported cmakeBuildType: '${cmakeBuildType}'")
        endif()

        set("${variableName}" "${value}" PARENT_SCOPE)
    endif()
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
    if("${ARGC}" GREATER_EQUAL "4")
        set("start" "3")
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
    if(NOT "" STREQUAL "${conanProgramPath}")
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
    if(NOT "" STREQUAL "${conanProgramPath}")
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
    endif()
endmacro()

macro(
    add_custom_target_conan_install_clean
    targetName
    cmakeProgramPath
    conanInstalledDir
)
    if(NOT "" STREQUAL "${cmakeProgramPath}")
        add_custom_target("${targetName}"
            COMMAND "${cmakeProgramPath}"
                    -E
                    rm
                    -rf
                    "${conanInstalledDir}"
            COMMENT "custom-target: '${targetName}'"
            VERBATIM
        )
    endif()
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
    if(NOT "" STREQUAL "${conanProgramPath}")
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
    endif()
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
    if(NOT "" STREQUAL "${conanProgramPath}")
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
    endif()
endmacro()
