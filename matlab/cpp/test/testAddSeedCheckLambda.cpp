/**
 * @file
 * @brief Unit tests for whether the addSeed method correctly recalculates the \f$ \lambda \f$ matrix.
 */

#include <string>
#include "Catch2/catch.hpp"
#include "../addSeed.h"
#include "../removeSeed.h"
#include "../getRegion.h"
#include "../skizException.h"
#include "../typedefs.cpp"
#include "../vd.h"
#include "test-help-fns/loadVD.h"
#include "test-help-fns/loadStruct.h"
#include "test-help-fns/bruteForceCheckLambda.h"

/**
* @test AddSeedCheckLambda
* @brief Add seeds to VD and check (in a greedy fashion) whether the closest seed to each pixel is the one held in
* its \f$ \lambda \f$ matrix entry.
*/
TEST_CASE("Check whether the addSeed method correctly recalculates the lambda matrix"){

    // Load VD
    std::string path = "../../cpp/test/resources/";
    loadStruct loadResults = loadVD(path);
    RealVec Sx = loadResults.Sx;
    RealVec Sy = loadResults.Sy;
    vd VD = loadResults.VD;

    // addSeed
    for (uint32 i = 0; i < 100; ++i) {
        addSeed(VD, Sx.at(i + 5), Sy.at(i + 5));
        REQUIRE(bruteForceCheckLambda(VD));
    }
}
