cmake_policy(PUSH)
cmake_policy(SET CMP0054 NEW)
cmake_policy(PUSH)
cmake_policy(SET CMP0007 NEW)
cmake_policy(PUSH)
cmake_policy(SET CMP0012 NEW)
cmake_policy(PUSH)
cmake_policy(SET CMP0057 NEW)

function(execute)
    block()
        set(options)
        set(oneValueKeywords
            "MESSAGE_MODE"
        )
        set(multiValueKeywords
            "INCLUDES"
            "FUNCTION"
            "ARGS"
            "OUTPUTS"
        )
        cmake_parse_arguments("execute" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

        if(NOT "${execute_UNPARSED_ARGUMENTS}" STREQUAL "")
            message(FATAL_ERROR "Unparsed arguments: '${execute_UNPARSED_ARGUMENTS}'")
        elseif(NOT "${execute_KEYWORDS_MISSING_VALUES}" STREQUAL "")
            message(FATAL_ERROR "Keywords missing values: '${execute_KEYWORDS_MISSING_VALUES}'")
        endif()

        if("${execute_FUNCTION}" STREQUAL "")
            get_filename_component(currentFileName "${CMAKE_CURRENT_LIST_FILE}" NAME)
            string(JOIN " " usageMessage
                "usage:"
                "cmake -P ${currentFileName} FUNCTION <function-name>"
                "[MESSAGE_MODE NOTICE | STATUS | VERBOSE | DEBUG | TRACE | DEPRECATION | AUTHOR_WARNING | WARNING | SEND_ERROR | FATAL_ERROR]"
                "[INCLUDES <include-file>...]"
                "[ARGS <args>...]"
                "[OUTPUTS <output>...]"
            )
            message(FATAL_ERROR "${usageMessage}")
        else()
            set(functions "${execute_FUNCTION}")
        endif()

        if("${execute_MESSAGE_MODE}" STREQUAL "")
            set(messageMode "STATUS")
        else()
            set(messageMode "${execute_MESSAGE_MODE}")
        endif()

        set(includes "${execute_INCLUDES}")
        set(arguments "${execute_ARGS}")
        set(outputs "${execute_OUTPUTS}")

        foreach(include ${includes})
            include("${include}")
        endforeach()

        foreach(func args IN ZIP_LISTS functions arguments)
            cmake_language(EVAL CODE "${func}(${args})")
        endforeach()

        foreach(output ${outputs})
            message("${messageMode}" "${output}: '${${output}}'")
        endforeach()
    endblock()
endfunction()

block()
    set(args "")
    set(argsStarted "false")
    math(EXPR max "${CMAKE_ARGC} - 1")
    foreach(i RANGE "${max}")
        if("${CMAKE_ARGV${i}}" STREQUAL "--")
            set(argsStarted "true")
            continue()
        endif()
        if("${argsStarted}")
            list(APPEND args "${CMAKE_ARGV${i}}")
        endif()
    endforeach()
    execute("${args}")
endblock()

cmake_policy(POP)
cmake_policy(POP)
cmake_policy(POP)
cmake_policy(POP)
