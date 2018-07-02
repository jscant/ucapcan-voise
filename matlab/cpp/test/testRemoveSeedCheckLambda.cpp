/**
 * @file
 * @brief TEST FILE
 */

#include <string>
#include "Catch2/catch.hpp"
#include "../addSeed.h"
#include "../removeSeed.h"
#include "../getRegion.h"
#include "../aux.h"
#include "../skizException.h"
#include "../typedefs.cpp"
#include "../vd.h"
#include "test-help-fns/loadVD.h"
#include "test-help-fns/loadStruct.h"
#include "test-help-fns/bruteForceCheckLambda.h"
#include <iostream>
/**
 * @test Brute
 * @brief Bruteforcelambda
 */
TEST_CASE("Brute force check lambdas after removing seeds"){

    // Load VD
    std::string path = "../../cpp/test/resources/";
    loadStruct loadResults = loadVD(path);
    RealVec Sx = loadResults.Sx;
    RealVec Sy = loadResults.Sy;
    vd VD = loadResults.VD;

    // addSeed
    for (auto i = 0; i < 100; ++i) {
        addSeed(VD, Sx.at(i + 5), Sy.at(i + 5));
    }

    // removeSeed
    for (auto i = 100; i > 0; --i) {
        removeSeed(VD, i);
        REQUIRE(bruteForceCheckLambda(VD));
    }
}