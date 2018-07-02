#include "../aux-functions/inVector.h"
#include "../typedefs.cpp"
#include "Catch2/catch.hpp"

TEST_CASE("In vector of ints") {
    std::vector<int> vec = { 1, 2, 3, 4, 5 };
    REQUIRE( inVector(vec, 1) );
}