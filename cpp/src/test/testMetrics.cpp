/**
 * @file
 * @brief Unit tests for the metrics used in getVDOp.cpp MEX function
 */

#include <eigen3/Eigen/Dense>

#include <string>
#include <iostream>

#include "../typedefs.cpp"
#include "../skizException.h"
#include "../aux-functions/metrics.h"
#include "Catch2/catch.hpp"

/**
* @test MeanEmtpyVector
* @brief Check that the mean of an empty vector throws an exception
*/
TEST_CASE("Check mean of empty vector") {
    RealVec vec = {};
    REQUIRE_THROWS_AS(metrics::mean(vec), SKIZException);
}

/**
 * @test MeanSingleVector
 * @brief Check the mean of a singularly occupied vector
 */
TEST_CASE("Check calculation of mean of singularly occupied vector") {
    RealVec vec = {13};
    REQUIRE(metrics::mean(vec) == 13);
}

/**
 * @test MeanPosNegVector
 * @brief Check calculation of mean of positive and negative numbers
 */
TEST_CASE("Check calculation of mean of positive and negative numbers") {
    RealVec vec = {-1, 13, 12, 0, 4, 2, -5};
    REQUIRE(metrics::mean(vec) == Approx(3.5714285714));
}

/**
 * @test MeanNonIntegerVector
 * @brief Check calculation of mean of non-integer reals
 */
TEST_CASE("Check calculation of mean of non-integer reals") {
    RealVec vec = {0.12, 3 / 17, -31.2111, 31, 1033};
    REQUIRE(metrics::mean(vec) == Approx(206.58178));
}

/**
 * @test MedianEmptyVector
 * @brief Check that the median of an empty vector throws an exception
 */
TEST_CASE("Check median of empty vector") {
    RealVec vec = {};
    REQUIRE_THROWS_AS(metrics::median(vec), SKIZException);
}

/**
 * @test MedianSingleVector
 * @brief Check the median of a singularly occupied vector
 */
TEST_CASE("Check calculation of median of singularly occupied vector") {
    RealVec vec = {13};
    REQUIRE(metrics::median(vec) == 13);
}

/**
 * @test MedianPosNegVector
 * @brief Check calculation of median of positive and negative numbers
 */
TEST_CASE("Check calculation of median of positive and negative numbers") {
    RealVec vec = {-1, 13, 12, 0, 4, 2, -5};
    REQUIRE(metrics::median(vec) == 2.0);
}

/**
 * @test MedianNonIntegerVector
 * @brief Check calculation of median of non-integer reals
 */
TEST_CASE("Check calculation of median of non-integer reals") {
    RealVec vec = {0.12, 3 / 17, -31.2111, 31, 1033};
    REQUIRE(metrics::median(vec) == 0.12);
}

/**
 * @test SqrtLenEmtpyVector
 * @brief Check square root of the length of an empty vector
 */
TEST_CASE("Check sqrtLen of empty vector") {
    RealVec vec = {};
    REQUIRE(metrics::sqrtLen(vec) == 0);
}

/**
 * @test SqrtLenSingleVector
 * @brief Check square root of length of singularly occupied vector
 */
TEST_CASE("Check sqrtLen of singularly occupied vector") {
    RealVec vec = {13};
    REQUIRE(metrics::sqrtLen(vec) == 1);
}

/**
 * @test SqrtLenVector
 * @brief Check square root of length of longer vector
 */
TEST_CASE("Check sqrtLen of longer vector") {
    RealVec vec = {-1, 13, 12, 0, 4, 2, -5, 13, 45, 2, 54, 22, 452, 53, 4542, 11, 131, 3};
    REQUIRE(metrics::sqrtLen(vec) == Approx(4.2426406871));
}

/**
 * @test RangeEmptyVector
 * @brief Check range of empty vector
 */
TEST_CASE("Check range of empty vector") {
    RealVec vec = {};
    REQUIRE_THROWS_AS(metrics::range(vec), SKIZException);
}

/**
 * @test RangeSingleVector
 * @brief Check calculation of range of singularly occupied vector
 */
TEST_CASE("Check calculation of range of singularly occupied vector") {
    RealVec vec = {13};
    REQUIRE(metrics::range(vec) == 0.0);
}

/**
 * @test RangePosNegVector
 * @brief Check calculation of range of positive and negative numbers
 */
TEST_CASE("Check calculation of range of positive and negative numbers") {
    RealVec vec = {-1, 13, 12, 0, 4, 2, -5};
    REQUIRE(metrics::range(vec) == 18.0);
}

/**
 * @test RangeNonIntegerVector
 * @brief Check calculation of range of non-integer reals
 */
TEST_CASE("Check calculation of range of non-integer reals") {
    RealVec vec = {0.12, 3 / 17, -31.2111, 31, 1033};
    REQUIRE(metrics::range(vec) == 1064.2111);
}

/**
 * @test StdDevEmptyVector
 * @brief Check standard deviation of empty vector
 */
TEST_CASE("Check standard deviation of empty vector") {
    RealVec vec = {};
    REQUIRE_THROWS_AS(metrics::stdDev(vec), SKIZException);
}

/**
 * @test StdDevSingleVector
 * @brief Check calculation of standard deviation of singularly occupied vector
 */
TEST_CASE("Check calculation of standard deviation of singularly occupied vector") {
    RealVec vec = {13};
    REQUIRE(metrics::stdDev(vec) == 0.0);
}

/**
 * @test StdDevPosNegVector
 * @brief Check calculation of standard deviation of positive and negative numbers
 */
TEST_CASE("Check calculation of standard deviation of positive and negative numbers") {
    RealVec vec = {-1, 13, 12, 0, 4, 2, -5};
    REQUIRE(metrics::stdDev(vec) == Approx(6.7046536788));
}

/**
 * @test StdDevNonIntegerVector
 * @brief Check calculation of standard deviation of non-integer reals
 */
TEST_CASE("Check calculation of standard deviation of non-integer reals") {
    RealVec vec = {0.12, 3 / 17, -31.2111, 31, 1033};
    REQUIRE(metrics::stdDev(vec) == Approx(462.5051318697));
}