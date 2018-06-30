/**
 * @file
 * @brief Type definitions (all in one place)
 */
#ifndef TYPEDEFS
#define TYPEDEFS
#include <vector>
#include <eigen3/Eigen/Dense>

/**
 * @typedef real
 * @brief All matlab inputs are doubles
 */
typedef double real;

/**
 * @typedef uint32
 * @brief Used for counters
 */
typedef unsigned int uint32;

/**
 * @typedef RealVec
 * @brief std::vector of reals
 */
typedef std::vector<real> RealVec;

/**
 * @typedef Mat
 * @brief Dynamically (determined at runtime) sized Eigen::Array of reals
 */
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif