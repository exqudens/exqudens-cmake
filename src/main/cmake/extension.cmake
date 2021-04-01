# declare script commands
if("file_upload" STREQUAL "${CMAKE_ARGV3}")
    # file = ${CMAKE_ARGV4}
    # url = ${CMAKE_ARGV5}
    file(UPLOAD ${CMAKE_ARGV4} ${CMAKE_ARGV5})
elseif("file_download" STREQUAL "${CMAKE_ARGV3}")
    # url = ${CMAKE_ARGV4}
    # file = ${CMAKE_ARGV5}
    file(DOWNLOAD ${CMAKE_ARGV4} ${CMAKE_ARGV5})
endif()

# declare macro 'add_custom_target_upload_file'
macro(add_custom_target_upload_file
    name
    depends
    file
    url
    command
    script
)
    add_custom_target(${name}
        COMMAND ${command} -P ${script} file_upload ${file} ${url}
        COMMENT "Uploading project."
    )
    if(NOT "" STREQUAL "${depends}")
        add_dependencies(${name} ${depends})
    endif()
endmacro()

# declare macro 'add_custom_target_download_file'
macro(add_custom_target_download_file
    name
    depends
    url
    file
    command
    script
)
    add_custom_target(${name}
        COMMAND ${command} -P ${script} file_download ${url} ${file}
        COMMENT "Uploading project."
    )
    if(NOT "" STREQUAL "${depends}")
        add_dependencies(${name} ${depends})
    endif()
endmacro()

# declare macro 'add_custom_target_zip_directory'
macro(add_custom_target_zip_directory
    name
    depends
    input
    output
    command
)
    add_custom_target(${name}
        COMMAND ${command} -E tar cfv ${output} --format=zip -- .
        BYPRODUCTS ${output}
        WORKING_DIRECTORY ${input}
        COMMENT "Zip directory '${input}'."
    )
    if(NOT "" STREQUAL "${depends}")
        add_dependencies(${name} ${depends})
    endif()
endmacro()

# declare macro 'add_custom_target_unzip_directory'
macro(add_custom_target_unzip_directory
    name
    depends
    input
    output
    command
)
    add_custom_command(
        OUTPUT ${output}
        COMMAND ${command}
        ARGS -E make_directory ${output}
        BYPRODUCTS ${output}
    )
    add_custom_target(${name}
        COMMAND ${command} -E tar xzf ${input}
        DEPENDS ${output}
        WORKING_DIRECTORY ${output}
        COMMENT "Un-Zip directory '${input}'."
    )
    if(NOT "" STREQUAL "${depends}")
        add_dependencies(${name} ${depends})
    endif()
endmacro()

# declare macro 'add_custom_target_install'
macro(add_custom_target_install
    name
    depends
    input
    output
    command
)
    add_custom_command(
        OUTPUT ${output}
        COMMAND ${command}
        ARGS -E make_directory ${output}
        COMMAND ${command}
        ARGS -E copy_directory ${input} ${output}
        COMMENT "Installing project."
    )
    add_custom_target(${name}
        DEPENDS ${output}
    )
    if(NOT "" STREQUAL "${depends}")
        add_dependencies(${name} ${depends})
    endif()
endmacro()

# declare function 'set_if_not_defined'
function(set_if_not_defined variableName)
    if(NOT DEFINED ${variableName})
        if(${ARGC} EQUAL 2)
            set(${variableName} ${ARGV1} PARENT_SCOPE)
        elseif(${ARGC} GREATER 2)
            set(values)
            foreach(argv ${ARGV})
                if(NOT "${argv}" STREQUAL "${variableName}")
                    list(APPEND values "${argv}")
                endif()
            endforeach()
            set(${variableName} ${values} PARENT_SCOPE)
        else()
            set(${variableName} PARENT_SCOPE)
        endif()
    endif()
endfunction()

# declare function 'set_home_prefix'
function(set_home_prefix variableName)
    if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
        file(TO_CMAKE_PATH "$ENV{USERPROFILE}" homePrefix)
    elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
        file(TO_CMAKE_PATH "$ENV{HOME}" homePrefix)
    elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
        file(TO_CMAKE_PATH "$ENV{HOME}" homePrefix)
    else()
        message(
            FATAL_ERROR
            "Unable to get 'homePrefix' for CMAKE_HOST_SYSTEM_NAME: '${CMAKE_HOST_SYSTEM_NAME}'"
        )
    endif()
    set("${variableName}" "${homePrefix}" PARENT_SCOPE)
endfunction()

# declare function 'set_home_prefix_if_not_defined'
function(set_home_prefix_if_not_defined variableName)
    if(NOT DEFINED ${variableName})
        set_home_prefix(homePrefix)
        set(${variableName} ${homePrefix} PARENT_SCOPE)
    endif()
endfunction()
