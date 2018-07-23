/**
 * @file
 * @brief Unit tests for whether inVector correctly identifies the presence or otherwise of numeric values in vectors
 */
#include "../aux-functions/inVector.h"
#include "../typedefs.h"
#include "Catch2/catch.hpp"

/**
 * @test InVectorOfInts
 * @brief Check if inVector correctly identifies item in vector of ints
 */
TEST_CASE("Check if inVector correctly identifies item in vector of ints") {
    std::vector<int> vec = { 1, -2, 3, 4, 5 };
    REQUIRE( inVector(vec, 1) );
}

/**
 * @test NotInVectorOfInts
 * @brief Check if inVector correctly identifies item in vector of ints
 */
TEST_CASE("Check if inVector correctly identifies lack of item in vector of ints") {
    std::vector<int> vec = { 1, 2, -3, 4, 5 };
    REQUIRE( !inVector(vec, 0) );
}

/**
 * @test InVectorOfReals
 * @brief Check if inVector correctly identifies item in vector of reals
 */
TEST_CASE("Check if inVector correctly identifies item in vector of reals") {
    RealVec vec = { 13, 4.1, 12311, -1003.1, 10 };
    REQUIRE( inVector(vec, 10) );
}

/**
 * @test NotInVectorOfReals
 * @brief Check if inVector correctly identifies lack of item in vector of reals
 */
TEST_CASE("Check if inVector correctly identifies lack of item in vector of reals") {
    RealVec vec = { 13, 4.1, 12311, -1003.1, 10 };
    REQUIRE( !inVector(vec, 11) );
}

/**
 * @test InEmptyVector
 * @brief Check if inVector can handle empty vectors
 */
 TEST_CASE("Check if inVector can handle empty vectors"){
     std::vector<uint32> vec;
     REQUIRE( !inVector(vec, 1) );
 }

