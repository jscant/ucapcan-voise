/**
 * @file
 * @brief Unit tests for whether the addSeed method correctly recalculates the
 * \f$ \lambda \f$ matrix.
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
#include "test-help-fns/bruteForceCheckLambda.h"

// Load VD
std::string path = "../src/test/resources/";
loadStruct loadResults = loadVD(path, "benchVDSeeds256.txt",
        "benchVDLambda256.txt", "benchVDV256.txt");
RealVec Sx = loadResults.Sx;
RealVec Sy = loadResults.Sy;
vd VD = loadResults.VD;

/**
* @test AddSeedCheckLambda
* @brief Add seeds to VD and check (in a greedy fashion by comparing the
* distance between every seed and every pixel) whether the closest seed to each
* pixel is the one held in its \f$ \lambda \f$ matrix entry.
*/
TEST_CASE(
    "Check whether the addSeed method correctly recalculates the lambda matrix")
{
    uint32 initSeedCount = VD.getSx().size();
    for (uint32 i = 0; i < 100; ++i) {
        addSeed(VD, Sx.at(i + initSeedCount), Sy.at(i + initSeedCount));
        REQUIRE(bruteForceCheckLambda(VD));
    }

}
