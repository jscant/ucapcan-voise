/**
 * @file
 * @brief Unit tests for whether the getVDOp function correctly calculates the average intensity for each VR
 */

#include <string>
#include <eigen3/Eigen/Dense>
#include "Catch2/catch.hpp"
#include "../addSeed.h"
#include "../removeSeed.h"
#include "../getRegion.h"
#include "../typedefs.cpp"
#include "../vd.h"
#include "../getOp.h"
#include "../aux-functions/metrics.h"
#include "../aux-functions/readMatrix.h"
#include "test-help-fns/loadVD.h"
#include "test-help-fns/loadStruct.h"

// Load VD
std::string path = "../src/test/resources/";
loadStruct loadResults = loadVD(path, "benchVDSeeds10.txt", "benchVDLambda10.txt", "benchVDV10.txt");
RealVec Sx = loadResults.Sx;
RealVec Sy = loadResults.Sy;
vd VD = loadResults.VD;

/**
* @test GetVDOpMedian
* @brief Checks that the getVDOp function correctly returns a matrix of averages from VD and pixel intensity data
*/
TEST_CASE("Checks that the getVDOp function correctly returns a matrix of averages from VD and pixel intensity data") {

    // Add a few seeds
    for (uint32 i = 2; i < 5; ++i) {
        addSeed(VD, Sx.at(i), Sy.at(i));
    }

    // Load input pixel intensities and expected output matrix
    Mat W = readMatrix("../src/test/resources/W.txt");
    Mat WopCorrect = readMatrix("../src/test/resources/Wop.txt");

    // Create space in memory for results, run getVDOp
    Mat Wop((int) VD.getNr(), (int) VD.getNc());
    Mat Sop(VD.getSk().size(), 1);
    getVDOp(VD, W, metrics::median, 1, Wop, Sop);

    // Check if each entry is as expected
    for (int i = 0; i < 10; ++i) {
        for (int j = 0; j < 10; ++j) {
            REQUIRE(Wop(i, j) == Approx(WopCorrect(i, j)));
        }
    }
}
