function(
    set_not_found_package_names
    variableName
)
    if("${ARGC}" GREATER_EQUAL "2")
        set("start" "1")
        math(EXPR "stop" "${ARGC} - 1")
        foreach(i RANGE "${start}" "${stop}")
            set(argument "${ARGV${i}}")
            if(NOT "${${argument}_FOUND}")
                list(APPEND value "${argument}")
            endif()
        endforeach()
    endif()
    set("${variableName}" "${value}" PARENT_SCOPE)
endfunction()
