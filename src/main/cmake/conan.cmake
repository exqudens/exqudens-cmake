function(
    conan_settings
    overwrite
    variableName
    cmakeSystemName
    cmakeSystemProcessor
    cmakeCxxCompilerId
    cmakeCxxCompilerVersion
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
            message(FATAL_ERROR "Unsupported cmakeCxxCompilerId: '${cmakeCxxCompilerId}' and cmakeCxxCompilerVersion: '${cmakeCxxCompilerVersion}'")
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
    overwrite
    variableName
    buildSharedLibs
)
    if(NOT DEFINED "${variableName}" OR "OVERWRITE" STREQUAL "${overwrite}")
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
    endif()
endfunction()

macro(
    conan_install
    overwrite
    conanInstalledDir
    conanFile
    conanSettings
    conanOptions
    conanProgram
)
    if(NOT "" STREQUAL "${conanProgram}")
        if("OVERWRITE" STREQUAL "${overwrite}")
            file(REMOVE_RECURSE "${conanInstalledDir}")
        endif()
        if(NOT EXISTS "${conanInstalledDir}")
            execute_process(
                COMMAND "${conanProgram}"
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
    conan_install_target
    targetName
    dependsOnTargetNames
    comment
    overwrite
    conanInstalledDir
    conanFile
    conanSettings
    conanOptions
    conanProgram
    cmakeProgram
)
    if(NOT "" STREQUAL "${conanProgram}")
        if("OVERWRITE" STREQUAL "${overwrite}" AND NOT "" STREQUAL "${comment}")
            add_custom_target("${targetName}"
                COMMAND "${cmakeProgram}"
                        -E
                        rm
                        -rf
                        "${conanInstalledDir}"
                COMMAND "${conanProgram}"
                        install
                        "${conanFile}"
                        --install-folder
                        "${conanInstalledDir}"
                        ${conanSettings}
                        ${conanOptions}
                COMMENT "${comment}"
                VERBATIM
            )
        elseif("OVERWRITE" STREQUAL "${overwrite}" AND "" STREQUAL "${comment}")
            add_custom_target("${targetName}"
                COMMAND "${cmakeProgram}"
                        -E
                        rm
                        -rf
                        "${conanInstalledDir}"
                COMMAND "${conanProgram}"
                        install
                        "${conanFile}"
                        --install-folder
                        "${conanInstalledDir}"
                        ${conanSettings}
                        ${conanOptions}
                VERBATIM
            )
        elseif(NOT "OVERWRITE" STREQUAL "${overwrite}" AND NOT "" STREQUAL "${comment}")
            add_custom_target("${targetName}"
                COMMAND "${conanProgram}"
                        install
                        "${conanFile}"
                        --install-folder
                        "${conanInstalledDir}"
                        ${conanSettings}
                        ${conanOptions}
                COMMENT "${comment}"
                VERBATIM
            )
        elseif(NOT "OVERWRITE" STREQUAL "${overwrite}" AND "" STREQUAL "${comment}")
            add_custom_target("${targetName}"
                COMMAND "${conanProgram}"
                        install
                        "${conanFile}"
                        --install-folder
                        "${conanInstalledDir}"
                        ${conanSettings}
                        ${conanOptions}
                VERBATIM
            )
        endif()
        if(NOT "" STREQUAL "${dependsOnTargetNames}")
            foreach(d ${dependsOnTargetNames})
                add_dependencies(${targetName} ${d})
            endforeach()
        endif()
    endif()
endmacro()

macro(
    conan_install_clean_target
    targetName
    dependsOnTargetNames
    comment
    conanInstalledDir
    cmakeProgram
)
    if(NOT "" STREQUAL "${comment}")
        add_custom_target("${targetName}"
            COMMAND "${cmakeProgram}"
                    -E
                    rm
                    -rf
                    "${conanInstalledDir}"
            COMMENT "${comment}"
            VERBATIM
        )
    elseif("" STREQUAL "${comment}")
        add_custom_target("${targetName}"
            COMMAND "${cmakeProgram}"
                    -E
                    rm
                    -rf
                    "${conanInstalledDir}"
            VERBATIM
        )
    endif()
    if(NOT "" STREQUAL "${dependsOnTargetNames}")
        foreach(d ${dependsOnTargetNames})
            add_dependencies(${targetName} ${d})
        endforeach()
    endif()
endmacro()

macro(
    conan_export_target
    targetName
    dependsOnTargetNames
    comment
    conanPackageDir
    conanFile
    conanUser
    conanChannel
    conanSettings
    conanOptions
    conanProgram
)
    if(NOT "" STREQUAL "${conanProgram}")
        if(NOT "" STREQUAL "${conanUser}" AND NOT "" STREQUAL "${conanChannel}" AND NOT "" STREQUAL "${comment}")
            add_custom_target("${targetName}"
                COMMAND "${conanProgram}"
                        export-pkg
                        -f
                        "${conanFile}"
                        "${conanUser}/${conanChannel}"
                        --package-folder
                        "${conanPackageDir}"
                        ${conanSettings}
                        ${conanOptions}
                COMMENT "${comment}"
                VERBATIM
            )
        elseif(NOT "" STREQUAL "${conanUser}" AND NOT "" STREQUAL "${conanChannel}" AND "" STREQUAL "${comment}")
            add_custom_target("${targetName}"
                COMMAND "${conanProgram}"
                        export-pkg
                        -f
                        "${conanFile}"
                        "${conanUser}/${conanChannel}"
                        --package-folder
                        "${conanPackageDir}"
                        ${conanSettings}
                        ${conanOptions}
                VERBATIM
            )
        elseif("" STREQUAL "${conanUser}" AND "" STREQUAL "${conanChannel}" AND NOT "" STREQUAL "${comment}")
            add_custom_target("${targetName}"
                COMMAND "${conanProgram}"
                        export-pkg
                        "${conanFile}"
                        --package-folder
                        "${conanPackageDir}"
                        ${conanSettings}
                        ${conanOptions}
                COMMENT "${comment}"
                VERBATIM
            )
        elseif("" STREQUAL "${conanUser}" AND "" STREQUAL "${conanChannel}" AND "" STREQUAL "${comment}")
            add_custom_target("${targetName}"
                COMMAND "${conanProgram}"
                        export-pkg
                        "${conanFile}"
                        --package-folder
                        "${conanPackageDir}"
                        ${conanSettings}
                        ${conanOptions}
                VERBATIM
            )
        endif()
        if(NOT "" STREQUAL "${dependsOnTargetNames}")
            foreach(d ${dependsOnTargetNames})
                add_dependencies(${targetName} ${d})
            endforeach()
        endif()
    endif()
endmacro()
