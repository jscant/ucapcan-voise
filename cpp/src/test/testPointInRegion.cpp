/**
 * @file
 * @brief Unit tests for various normal and pathalogical cases for the pointInRegion function
 */

#include <eigen3/Eigen/Dense>

#include <string>
#include <iostream>

#include "../getRegion.h"
#include "../typedefs.cpp"
#include "../vd.h"
#include "../pointInRegion.h"
#include "../addSeed.h"
#include "test-help-fns/loadVD.h"
#include "test-help-fns/loadStruct.h"
#include "Catch2/catch.hpp"




/**
 * @test GetRegionLowerBound
 * @brief Checks whether the pixels on and around the lower bound calculated by getRegion are in said region.
 */
TEST_CASE("Lower bounds of getRegion"){

    // Load VD
    std::string path = "../src/test/resources/";
    loadStruct loadResults = loadVD(path, "benchVDSeeds256.txt", "benchVDLambda256.txt", "benchVDV256.txt");
    RealVec Sx = loadResults.Sx;
    RealVec Sy = loadResults.Sy;
    vd VD = loadResults.VD;
    std::array<real, 2> pt;

    // Add a lot of seeds for a lot of tests
    for(auto i = 2; i < 100; ++i){
        addSeed(VD, Sx.at(i), Sy.at(i));
    }

    // Check correct identification of lower bounds
    for(uint32 s = 1; s <= VD.getSx().size(); ++s) {
        Mat bounds = getRegion(VD, s);
        for (uint32 j = 0; j < bounds.rows(); ++j) {
            if(bounds(j, 0) == -1){
                continue;
            }
            if(bounds(j, 0) < bounds(j, 1)) {
                real i = std::max(0.0, bounds(j, 0) - 1);
                pt[0] = i + 1;
                pt[1] = j + 1;
                REQUIRE (pointInRegion(VD, pt, s, VD.getNkByIdx(s)));
                if(i > 0) {
                    pt[0] = i; pt[1] = j + 1;
                    REQUIRE (!pointInRegion(VD, pt, s, VD.getNkByIdx(s)));
                }
            }
        }
    }
}

/**
 * @test GetRegionUpperBound
 * @brief Checks whether the pixels on and around the upper bound calculated by getRegion are in said region.
 */
TEST_CASE("Upper bounds of getRegion"){

    // Load VD
    std::string path = "../src/test/resources/";
    loadStruct loadResults = loadVD(path, "benchVDSeeds256.txt", "benchVDLambda256.txt", "benchVDV256.txt");
    RealVec Sx = loadResults.Sx;
    RealVec Sy = loadResults.Sy;
    vd VD = loadResults.VD;
    std::array<real, 2> pt;

    // Add a lot of seeds for a lot of tests
    for(auto i = 2; i < 100; ++i){
        addSeed(VD, Sx.at(i), Sy.at(i));
    }

    // Check correct identification of lower bounds
    for(uint32 s = 1; s <= VD.getSx().size(); ++s) {
        Mat bounds = getRegion(VD, s);
        for (uint32 j = 0; j < bounds.rows(); ++j) {
            if(bounds(j, 0) == -1){
                continue;
            }
            if(bounds(j, 0) < bounds(j, 1)) {
                real i = std::min((real)VD.getNc(), bounds(j, 1) - 1);
                pt[0] = i + 1;
                pt[1] = j + 1;
                REQUIRE (pointInRegion(VD, pt, s, VD.getNkByIdx(s)));
                if(pt[0] < VD.getNr()) {
                    pt[0] = i + 2;
                    pt[1] = j + 1;
                    REQUIRE (!pointInRegion(VD, pt, s, VD.getNkByIdx(s)));
                }
            }
        }
    }
}