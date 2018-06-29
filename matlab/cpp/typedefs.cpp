/**
 * @file
 * @brief Type definitions (all in one place)
 */
#ifndef TYPEDEFS
#define TYPEDEFS
#include <vector>
#include <eigen3/Eigen/Dense>
typedef double real;
typedef unsigned int uint32;
typedef std::vector<real> RealVec;
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif