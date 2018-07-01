cmake_minimum_required(VERSION 3.11)
project(standalone_skiz)

find_package(Doxygen)

set(SOURCE_FILES main.cpp aux.cpp aux.h pointInRegion.cpp pointInRegion.h skizException.cpp skizException.h addSeed.cpp
        addSeed.h getRegion.cpp getRegion.h grabVD.cpp grabVD.h NSStar.cpp NSStar.h pushVD.cpp pushVD.h removeSeed.cpp
        removeSeed.h vd.cpp vd.h)

if(DOXYGEN_FOUND)
    set(CMAKE_PROJECT_NAME "ASDF")
    set(DOXYGEN_PROJECT_NAME ${CMAKE_PROJECT_NAME})
    set(DOXYGEN_PROJECT_NAME EHASDF)


    set(DOXYGEN_INPUT ${SOURCE_FILES})
    set(DOXYGEN_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    set(DOXYGEN_EXTRACT_ALL YES)
    set(DOXYGEN_EXTRACT_PRIVATE YES)
    set(DOXYGEN_EXTRACT_STATIC YES)
    set(DOXYGEN_OPTIMIZE_OUTPUT_FOR_C YES)
    set(DOXYGEN_SKIP_FUNCTION_MACROS NO)
    set(DOXYGEN_LAYOUT_FILE DoxygenLayout.xml)
    set(DOXYGEN_EXTRACT_PRIVATE YES)


    add_custom_command(
            OUTPUT ${DOXYGEN_OUTPUT}
            COMMAND ${CMAKE_COMMAND} -E echo_append "Building API Documentation..."
            COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_INPUT}
            COMMAND ${CMAKE_COMMAND} -E echo "Done."
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            DEPENDS ${DOXYGEN_INPUT}
    )

    add_custom_target(apidoc ALL DEPENDS ${DOXYGEN_OUTPUT})

    add_custom_target(apidoc_forced
            COMMAND ${CMAKE_COMMAND} -E echo_append "Building API Documentation..."
            COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_INPUT}
            COMMAND ${CMAKE_COMMAND} -E echo "Done."
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            )

endif(DOXYGEN_FOUND)

set(CMAKE_CXX_STANDARD 14)
message(STATUS "${CMAKE_CXX_STANDARD}")

set( CMAKE_CXX_FLAGS "-Wall -g -O3" )

add_executable(standalone_skiz main.cpp typedefs.cpp addSeed.cpp aux.cpp getRegion.cpp NSStar.cpp pointInRegion.cpp
        removeSeed.cpp skizException.cpp vd.cpp typedefs.cpp)


enable_testing()
add_library(Catch INTERFACE test/test-help-fns/loadStruct.h test/test-help-fns/bruteForceCheckLambda.cpp test/test-help-fns/bruteForceCheckLambda.h)
target_include_directories(Catch INTERFACE test/Catch2/include)
target_sources(Catch INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/test/Catch2/test_main.cpp")

add_executable(test1 test/test_case_1.cpp)
add_executable(test2 test/test_case_2.cpp)
target_link_libraries(test1 Catch)
target_link_libraries(test2 Catch)

add_test(NAME Test1 COMMAND test1)
add_test(NAME Test2 COMMAND test2)