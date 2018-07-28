/**
 * @file
 * @brief Unit test: Adds and then removes seeds to and from a regular grid to
 * check implementation of proposition 2 in [1]
 */
#include "Catch2/catch.hpp"
#include "test-help-fns/generateProposition2VD.h"
#include "test-help-fns/loadStruct.h"
#include "../addSeed.h"
#include "../removeSeed.h"
#include "test-help-fns/bruteForceCheckLambda.h"
#include "test-help-fns/bruteForceCheckV.h"

// Load VD and seeds
auto dim = 100;
loadStruct ls = generateProposition2VD(dim);
vd VD = ls.VD;
RealVec Sx = ls.Sx;
RealVec Sy = ls.Sy;

/**
 * @test Proposition2Check
 * @brief Adds and then removes seeds to and from a regular grid to check
 * implementation of proposition 2 in [1]
 */
TEST_CASE("Adds and then removes seeds to and from a regular grid to check "
          "implementation of proposition 2 in [1]"){


    std::vector<uint32> randomIdx;
    int size = Sx.size();
    for(auto i = 0; i < size; ++i) {
        randomIdx.push_back(i);
    }

    // Randomise order of seed addition
    std::random_shuffle(randomIdx.begin(), randomIdx.end());

    for(int i = 0; i < size ; ++i){
        addSeed(VD, Sx.at(randomIdx.at(i)), Sy.at(randomIdx.at(i)));
        REQUIRE(bruteForceCheckLambda(VD));
        REQUIRE(bruteForceCheckV(VD));
    }

    // Randomise order of seed subtraction
    std::random_shuffle(randomIdx.begin(), randomIdx.end());

    for(unsigned long i = 0; i < randomIdx.size(); ++i){
        removeSeed(VD, randomIdx.at(i) + 1);
        REQUIRE(bruteForceCheckLambda(VD));
        REQUIRE(bruteForceCheckV(VD));
    }

}