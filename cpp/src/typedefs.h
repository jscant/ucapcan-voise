/**
 * @file
 * @brief All type and constant definitions
 */
#ifndef TYPEDEFS
#define TYPEDEFS
#include <vector>
#include <eigen3/Eigen/Dense>
#include <limits>

/**
 * @typedef real
 * @brief All Matlab inputs are doubles
 */
typedef double real;

/**
 * @typedef uint32
 * @brief Used for counters
 */
typedef unsigned int uint32;

/**
 * @typedef RealVec
 * @brief std::vector of reals. Used for Sx, Sy, Sk, Nk.
 */
typedef std::vector<real> RealVec;

/**
 * @typedef Mat
 * @brief Dynamically (determined at runtime) sized Eigen::Array of reals
 */
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;

/// A number larger than any in a comparison is used at various points in this project.
#define INF std::numeric_limits<real>::infinity()

/// Machine precision is sometimes needed for floating point numeric comparisons
#define EPS 1000*std::numeric_limits<real>::epsilon()

#endif