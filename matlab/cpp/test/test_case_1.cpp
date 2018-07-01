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

TEST_CASE("Require true"){

    // Load VD
    loadStruct loadResults = loadVD("../../../");
    vd VD = loadResults.VD;
    RealVec Sx = loadResults.Sx;
    RealVec Sy = loadResults.Sy;

    // addSeed
    for (uint32 i = 0; i < ns - 5; ++i) {
        addSeed(VD, Sx.at(i + 5), Sy.at(i + 5));
    }

    //for (auto i = ns - 5; i > 0; --i) {
    //    removeSeed(VD, i);
    //}
}
