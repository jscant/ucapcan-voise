/**
 * @file
 * @brief Unit tests for whether the addSeed method correctly recalculates the
 * \f$ \nu \f$ matrix.
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
 * @test AddSeedCheckV
 * @brief Adds seeds to VD and checks (in a greedy fashion) each pixel for
 * whether there exists one or more closest seeds, and whether this corresponds
 * to the relevant \f$ \nu \f$ matrix entry.
 */
TEST_CASE("Check whether the addSeed method correctly recalculates the v"
          "matrix."){

    // Add seeds to VD and check v with each iteration
    for (uint32 i = 0; i < 100; ++i) {
        addSeed(VD, Sx.at(i + 5), Sy.at(i + 5));
        REQUIRE(bruteForceCheckV(VD));
    }

}
