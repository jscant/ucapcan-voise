#include "Catch2/catch.hpp"
#include "test-help-fns/generateProposition2VD.h"
#include "test-help-fns/loadStruct.h"
#include "../addSeed.h"
#include "../removeSeed.h"
#include "test-help-fns/bruteForceCheckLambda.h"
#include "test-help-fns/bruteForceCheckV.h"
#include <iostream>

TEST_CASE("Testing"){
    uint32 dim = 7;
    loadStruct ls = generateProposition2VD(dim);
    vd VD = ls.VD;
    RealVec Sx = ls.Sx;
    RealVec Sy = ls.Sy;
    uint32 k = VD.getK();

    for(auto i = k; i < Sx.size(); ++i){
        addSeed(VD, Sx.at(i), Sy.at(i));
        REQUIRE(bruteForceCheckLambda(VD));
        REQUIRE(bruteForceCheckV(VD));
    }

    for(auto i = Sx.size() - 1; i > 0; --i){
        removeSeed(VD, i);
        REQUIRE(bruteForceCheckLambda(VD));
        REQUIRE(bruteForceCheckV(VD));
    }




}