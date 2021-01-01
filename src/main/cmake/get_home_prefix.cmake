# define function 'get_home_prefix'
function(get_home_prefix result_variable)
    if(DEFINED "${result_variable}")
        set(homePrefix ${${result_variable}})
    elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
        string(REPLACE "\\" "/" homePrefix "$ENV{USERPROFILE}")
    elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Linux")
        set(homePrefix "$ENV{HOME}")
    elseif("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
        set(homePrefix "$ENV{HOME}")
    else()
        message(
            FATAL_ERROR
            "Unable to get 'homePrefix' for CMAKE_HOST_SYSTEM_NAME: '${CMAKE_HOST_SYSTEM_NAME}'"
        )
    endif()

    set("${result_variable}" "${homePrefix}" PARENT_SCOPE)
endfunction()
