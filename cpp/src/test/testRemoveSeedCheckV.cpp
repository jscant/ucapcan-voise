/**
 * @file
 * @brief Unit tests for whether the removeSeed method correctly recalculates
 * the \f$ \nu \f$ matrix.
 */

#include <string>
#include "Catch2/catch.hpp"
#include "../addSeed.h"
#include "../removeSeed.h"
#include "../getRegion.h"
#include "../skizException.h"
#include "../typedefs.h"
#include "../vd.h"
#include "test-help-fns/loadVD.h"
#include "test-help-fns/loadStruct.h"
#include "test-help-fns/bruteForceCheckV.h"

// Load VD
std::string path = "../src/test/resources/";
loadStruct loadResults = loadVD(path, "benchVDSeeds256.txt",
        "benchVDLambda256.txt", "benchVDV256.txt");
RealVec Sx = loadResults.Sx;
RealVec Sy = loadResults.Sy;
vd VD = loadResults.VD;

/**
* @test RemoveSeedCheckV
* @brief Remove seeds to VD and check (in a greedy fashion) whether the closest
* seed to each pixel is the one held in its \f$ \nu \f$ matrix entry.
*/
TEST_CASE("Check whether the removeSeed method correctly recalculates the "
          "v matrix"){

    // addSeed so that we may later remove them
    for (uint32 i = 0; i < 100; ++i) {
        addSeed(VD, Sx.at(i + 5), Sy.at(i + 5));
    }

    // removeSeed
    for (auto i = 100; i > 0; --i) {
        removeSeed(VD, i);
        REQUIRE(bruteForceCheckV(VD));
    }

}