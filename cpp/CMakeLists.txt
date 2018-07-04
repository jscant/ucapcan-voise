cmake_minimum_required(VERSION 3.11)
project(standalone_skiz)
set(CMAKE_CXX_STANDARD 14)
set( CMAKE_CXX_FLAGS "-Wall -g -O3" )

option(GENERATE_DOXYGEN "Generate Doxymentation")
option(TESTING "Generate Catch2 unit tests")


add_executable(standalone_skiz src/main.cpp src/typedefs.cpp src/addSeed.cpp src/getRegion.cpp src/NSStar.cpp
        src/pointInRegion.cpp src/removeSeed.cpp src/skizException.cpp src/vd.cpp src/aux-functions/readSeeds.cpp
        src/aux-functions/readMatrix.cpp src/aux-functions/metrics.cpp)

set(TESTING ON)
set(GENERATE_DOXYGEN ON)
message(status ${CMAKE_CURRENT_SOURCE_DIR}/build)
if(GENERATE_DOXYGEN)
    find_package(Doxygen)
    if(DOXYGEN_FOUND)
        set(DOXYGEN_OPTIMIZE_OUTPUT_FOR_C YES)
        set(DOXYGEN_SKIP_FUNCTION_MACROS NO)
        set(DOXYGEN_LAYOUT_FILE DoxygenLayout.xml)
        set(DOXYGEN_SHOW_DIRECTORIES YES)
        set(DOXYGEN_INPUT "src src/aux-functions src/test other/mainpage-info.txt src/mex")
        set(doxyfile_in build/CMakeDoxyfile.in)
        set(doxyfile ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile)

        configure_file(${doxyfile_in} ${doxyfile} @ONLY)



        add_custom_target(doc ALL
                COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                COMMENT "Generating API documentation with Doxygen"
                VERBATIM)

        #install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html
                #DESTINATION share/doc)
    endif(DOXYGEN_FOUND)
endif(GENERATE_DOXYGEN)

if(TESTING)
    enable_testing()
    add_library(Catch INTERFACE)
    target_include_directories(Catch INTERFACE src/test/Catch2/include)
    target_sources(Catch INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/src/test/Catch2/test_main.cpp")

    set (TEST_DEPENDENCIES src/test/test-help-fns/bruteForceCheckLambda.cpp src/test/test-help-fns/bruteForceCheckV.cpp
            src/test/test-help-fns/loadStruct.h src/test/test-help-fns/loadVD.cpp src/vd.cpp src/skizException.cpp
            src/addSeed.cpp src/NSStar.cpp src/pointInRegion.cpp src/getRegion.cpp src/removeSeed.cpp
            src/aux-functions/readSeeds.cpp src/aux-functions/readMatrix.cpp)


    add_executable(testAddSeedCheckLambda src/test/testAddSeedCheckLambda.cpp ${TEST_DEPENDENCIES})
    add_executable(testRemoveSeedCheckLambda src/test/testRemoveSeedCheckLambda.cpp ${TEST_DEPENDENCIES})
    add_executable(testAddSeedCheckV src/test/testAddSeedCheckV.cpp ${TEST_DEPENDENCIES})
    add_executable(testRemoveSeedCheckV src/test/testRemoveSeedCheckV.cpp ${TEST_DEPENDENCIES})
    add_executable(PointInRegionCheck src/test/testPointInRegion.cpp ${TEST_DEPENDENCIES})
    add_executable(SqDistanceCheck src/test/testSqDist.cpp ${TEST_DEPENDENCIES})
    add_executable(InVectorCheck src/test/testInVector.cpp ${TEST_DEPENDENCIES})

    target_link_libraries(testAddSeedCheckLambda Catch)
    target_link_libraries(testRemoveSeedCheckLambda Catch)
    target_link_libraries(testAddSeedCheckV Catch)
    target_link_libraries(testRemoveSeedCheckV Catch)
    target_link_libraries(PointInRegionCheck Catch)
    target_link_libraries(SqDistanceCheck Catch)
    target_link_libraries(InVectorCheck Catch)

    add_test(NAME AddSeedCheckLambda COMMAND testAddSeedCheckLambda)
    add_test(NAME RemoveSeedCheckLambda COMMAND testRemoveSeedCheckLambda)
    add_test(NAME AddSeedCheckV COMMAND testAddSeedCheckV)
    add_test(NAME RemoveSeedCheckV COMMAND testRemoveSeedCheckV)
    add_test(NAME PointInRegionCheck COMMAND PointInRegionCheck)
    add_test(NAME SqDistanceCheck COMMAND SqDistanceCheck)
    add_test(NAME InVectorCheck COMMAND InVectorCheck)
endif(TESTING)



