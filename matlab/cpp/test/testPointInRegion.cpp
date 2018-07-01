#include <eigen3/Eigen/Dense>

#include <string>
#include <iostream>

#include "Catch2/catch.hpp"
#include "../getRegion.h"
#include "../aux.h"
#include "../typedefs.cpp"
#include "../vd.h"
#include "../pointInRegion.h"
#include "test-help-fns/loadVD.h"
#include "test-help-fns/loadStruct.h"

// Load VD
std::string path = "../../cpp/test/resources/";
loadStruct loadResults = loadVD(path);
RealVec Sx = loadResults.Sx;
RealVec Sy = loadResults.Sy;
vd VD = loadResults.VD;

TEST_CASE("Boundary of window points"){
    for(uint32 j = 1; j < 6; ++j) {
        std::cout << "Seed: " << j << "\n-------------------\n";
        Mat bounds = getRegion(VD, j);
        for (uint32 i = 0; i < bounds.rows(); ++i) {
            std::string str = std::to_string(i) + ": " + std::to_string(bounds(i, 0)) + ", " +
                    std::to_string(bounds(i, 1)) + "\n";
            std::cout << str;
        }
        break;
    }
    std::array<real, 2> pt = { 120, 243 };
    //REQUIRE( pointInRegion(VD, pt, 1, VD.getNkByIdx(1)) );

    pt[0] = 256;
    pt[1] = 243;
    REQUIRE( pointInRegion(VD, pt, 1, VD.getNkByIdx(1)) );
}