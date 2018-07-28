/**
 * @file
 * @brief Unit tests for sqDist function
 */

#include "../aux-functions/sqDist.h"
#include "Catch2/catch.hpp"

/**
 * @test SquaredDistanceIdenticalPoints
 * @brief Test whether squared distance between identical points returns zero
 */
TEST_CASE("Square distance of identical points") {
    uint32 p1 = 10;
    uint32 p2 = 25;
    uint32 q1 = 10;
    uint32 q2 = 25;
    REQUIRE (sqDist(p1, p2, q1, q2) == 0);
}

/**
 * @test SquaredDistanceVerticalPoints
 * @brief Checks squared distance on vertically aligned points
 */
TEST_CASE("Check squared distance on vertically aligned points") {
    uint32 p1 = 10;
    uint32 p2 = 25;
    uint32 q1 = 10;
    uint32 q2 = 35;
    REQUIRE (sqDist(p1, p2, q1, q2) == 100);
}

/**
 * @test SquaredDistanceHorizontalPoints
 * @brief Checks squared distance on horizontally aligned points
 */
TEST_CASE("Check squared distance on horizontally aligned points") {
    uint32 p1 = 10;
    uint32 p2 = 25;
    uint32 q1 = 100;
    uint32 q2 = 25;
    REQUIRE (sqDist(p1, p2, q1, q2) == 8100);
}

/**
 * @test SquaredDistanceNonIntegerPoints
 * @brief Checks squared distance between points with non-integer coordinates
 */
TEST_CASE("Check squared distance between points with non-integer coordinates") {
    real p1 = 10;
    real p2 = 25;
    real q1 = 11.5;
    real q2 = 25;
    REQUIRE (sqDist(p1, p2, q1, q2) == 2.25);
}

/**
 * @test SquaredDistanceNonAlignedPoints
 * @brief Checks squared distance between points which are neither vertically nor horizontally aligned
 */
TEST_CASE("Check squared distance between points which are neither vertically nor horizontally aligned") {
    uint32 p1 = 101;
    uint32 p2 = 253;
    uint32 q1 = 134;
    uint32 q2 = 21;
    REQUIRE (sqDist(p1, p2, q1, q2) == 54913);
}

/**
 * @test SquaredDistanceNegativePoints
 * @brief Checks squared distance between points, some of which have negative coordinates.
 */
TEST_CASE("Check squared distance between points, some of which have negative coordinates") {
    int p1 = -31;
    int p2 = -11;
    int q1 = -4;
    int q2 = 20;
    REQUIRE (sqDist(p1, p2, q1, q2) == 1690);
}


