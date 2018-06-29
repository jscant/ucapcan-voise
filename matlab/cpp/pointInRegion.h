/**
 * @file pointInRegion.h
 * @headerfile ""
 * @brief Checks whether a point is within region C(s, A) according to the definition 2.5 in the SKIZ paper [ DOI: 10.1109/34.625128 ]
 *
 */
#include <vector>

#ifndef VD_H
#define VD_H
#include "vd.h"
#endif

#ifndef TYPEDEFS
#define TYPEDEFS
typedef double real;
typedef std::vector<real> RealVec;
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

bool pointInRegion(const vd &VD, std::array<real, 2> pt, real s, RealVec A);

// Doxygen:
/**
 * @fn pointInRegion(const vd &VD, std::array<real, 2> pt, real s, RealVec A)
 * @brief Checks whether a point is within region C(s, A) according to the definition 2.5 in the SKIZ paper [ DOI: 10.1109/34.625128 ]
 * @param vd Voronoi Diagram
 * @param pt x and y coordinates of point to check
 * @param s Index of seed which defines the region being checked
 * @param A Vector of seeds which together form half-planes that make up C(s, A)
 * @returns true: Point is in C(s, A)
 * @returns false: Point is not in C(s, A)
 */

/**
 * @var typedef double real
 */

/**
 * @var typedef std::vector<double> RealVec
 * @brief Vector of doubles for use in tracking neighbour relationships and seed locations
 */

/**
 * @var typedef Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> Mat
 * @brief Matrix for storage of v and lambda values with size determined at runtime
 */