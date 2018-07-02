#include "../aux-functions/sqDist.h"
#include "Catch2/catch.hpp"

TEST_CASE("Square distance of identical points") {
    uint32 p1 = 10;
    uint32 p2 = 25;
    uint32 q1 = 10;
    uint32 q2 = 25;
    REQUIRE (sqDist(p1, p2, q1, q2) == 0);
}

TEST_CASE("Square distance of vertically aligned points") {
    uint32 p1 = 10;
    uint32 p2 = 25;
    uint32 q1 = 10;
    uint32 q2 = 35;
    REQUIRE (sqDist(p1, p2, q1, q2) == 100);
}

TEST_CASE("Square distance between non-integer points") {
    real p1 = 10;
    real p2 = 25;
    real q1 = 11.5;
    real q2 = 25;
    REQUIRE (sqDist(p1, p2, q1, q2) == 2.25);
}

TEST_CASE("Square distance between horizontally aligned points") {
    uint32 p1 = 10;
    uint32 p2 = 25;
    uint32 q1 = 100;
    uint32 q2 = 25;
    REQUIRE (sqDist(p1, p2, q1, q2) == 8100);
}

TEST_CASE("Square distance between non-aligned points") {
    uint32 p1 = 101;
    uint32 p2 = 253;
    uint32 q1 = 134;
    uint32 q2 = 21;
    REQUIRE (sqDist(p1, p2, q1, q2) == 54913);
}

TEST_CASE("Square distance between negative and positive points") {
    int p1 = -31;
    int p2 = -11;
    int q1 = -4;
    int q2 = 20;
    REQUIRE (sqDist(p1, p2, q1, q2) == 1690);
}


