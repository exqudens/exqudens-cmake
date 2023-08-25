include("${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")

function(test_1)
    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    set(currentResourcesDir "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")
    cmake_path(NORMAL_PATH currentResourcesDir)
    set(currentOutputDir "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")

    if(EXISTS "${currentOutputDir}/src" AND IS_DIRECTORY "${currentOutputDir}/src")
        file(REMOVE_RECURSE "${currentOutputDir}/src")
    endif()

    file(COPY "${currentResourcesDir}/" DESTINATION "${currentOutputDir}")

    if(EXISTS "${currentOutputDir}/build")
        file(REMOVE_RECURSE "${currentOutputDir}/build")
    endif()

    message("currentOutputDir: '${currentOutputDir}'")

    doxygen(
        SOURCE_BASE_DIR "${currentOutputDir}"
    )

    if(NOT EXISTS "${currentOutputDir}/build/doxygen/main/xml/index.xml")
        message(FATAL_ERROR "Not exists '${currentOutputDir}/build/doxygen/main/xml/index.xml'")
    endif()

    sphinx(
        SOURCE_BASE_DIR "${currentOutputDir}"
        ENV_VARS "PROJECT_DIR=${currentOutputDir}"
                 "PROJECT_TITLE=${CMAKE_CURRENT_FUNCTION}_designs"
        FILES "requirements/requirements.rst"
              "designs/designs.rst"
              "links/links.rst"
        EXTRA_FILES "designs/png/structure.png"
    )
endfunction()

function(test_2)
    get_filename_component(currentFileNameNoExt "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
    set(currentResourcesDir "${CMAKE_CURRENT_LIST_DIR}/../resources/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")
    cmake_path(NORMAL_PATH currentResourcesDir)
    set(currentOutputDir "${CMAKE_CURRENT_BINARY_DIR}/${currentFileNameNoExt}/${CMAKE_CURRENT_FUNCTION}")

    if(EXISTS "${currentOutputDir}/src" AND IS_DIRECTORY "${currentOutputDir}/src")
        file(REMOVE_RECURSE "${currentOutputDir}/src")
    endif()

    file(COPY "${currentResourcesDir}/" DESTINATION "${currentOutputDir}")

    if(EXISTS "${currentOutputDir}/build")
        file(REMOVE_RECURSE "${currentOutputDir}/build")
    endif()

    set(scriptFile "${CMAKE_CURRENT_LIST_DIR}/../../main/cmake/util.cmake")
    cmake_path(NORMAL_PATH scriptFile)

    execute_process(
        COMMAND "${CMAKE_COMMAND}" "-P" "${scriptFile}" "--" "doxygen"
                SOURCE_BASE_DIR "${currentOutputDir}"
        WORKING_DIRECTORY "${currentOutputDir}"
        COMMAND_ECHO "STDOUT"
        COMMAND_ERROR_IS_FATAL "ANY"
    )

    if(NOT EXISTS "${currentOutputDir}/build/doxygen/main/xml/index.xml")
        message(FATAL_ERROR "Not exists '${currentOutputDir}/build/doxygen/main/xml/index.xml'")
    endif()

    execute_process(
        COMMAND "${CMAKE_COMMAND}" "-P" "${scriptFile}" "--" "sphinx"
                SOURCE_BASE_DIR "${currentOutputDir}"
                ENV_VARS "PROJECT_DIR=${currentOutputDir}"
                         "PROJECT_TITLE=${CMAKE_CURRENT_FUNCTION}___SPACE___designs"
                FILES "requirements/requirements.rst"
                      "designs/designs.rst"
                      "links/links.rst"
                EXTRA_FILES "designs/png/structure.png"
        WORKING_DIRECTORY "${currentOutputDir}"
        COMMAND_ECHO "STDOUT"
        COMMAND_ERROR_IS_FATAL "ANY"
    )
endfunction()

function(execute_test_script)
    test_1()
    test_2()
endfunction()

execute_test_script()
