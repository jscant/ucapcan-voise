/**
 * @file
 * @brief Unit tests for whether the getCentroid function correctly returns the
 * centres of mass of the VRs
 *
 */

#include <string>
#include <eigen3/Eigen/Dense>
#include <vector>
#include <iostream>
#include "Catch2/catch.hpp"
#include "test-help-fns/loadVD.h"
#include "test-help-fns/loadStruct.h"
#include "../addSeed.h"
#include "../removeSeed.h"
#include "../getRegion.h"
#include "../typedefs.h"
#include "../vd.h"
#include "../getCentroid.h"
#include "../aux-functions/metrics.h"
#include "../aux-functions/readMatrix.h"

// Load VD
std::string path = "../src/test/resources/";
loadStruct loadResults = loadVD(path, "benchVDSeeds10.txt",
        "benchVDLambda10.txt", "benchVDV10.txt");
RealVec Sx = loadResults.Sx;
RealVec Sy = loadResults.Sy;
vd VD = loadResults.VD;

/**
* @test GetCentroidCheck
* @brief Unit tests for whether the getCentroid function correctly returns the
* centres of mass of the VRs
*/
TEST_CASE("Checks that the getVDOp function correctly returns a matrix of "
          "averages from VD and pixel intensity data") {

    // Add a few seeds
    for (uint32 i = 2; i < 5; ++i) {
        addSeed(VD, Sx.at(i), Sy.at(i));
    }

    // Load input pixel intensities and expected output coordinates
    Mat W = readMatrix("../src/test/resources/W.txt");
    Mat expectedCoords(5, 2);
    expectedCoords << 9, 5,
                        2, 3,
                        8, 2,
                        8, 9,
                        3, 7;

    // Create space in memory for results, run getVDOp
    RealVec seeds;
    for(auto i = 1; i <= 5; ++i){
        seeds.push_back(i);
    }

    // Run function to get results
    Mat centroidCoords = getCentroid(VD, W, seeds);

    // Check if each entry is as expected
    for(auto i = 0; i < centroidCoords.rows(); ++i){
        REQUIRE(centroidCoords(i, 0) == expectedCoords(i, 0));
        REQUIRE(centroidCoords(i, 1) == expectedCoords(i, 1));
    }
}
