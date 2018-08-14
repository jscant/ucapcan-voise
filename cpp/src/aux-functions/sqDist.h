/**
 * @file
 * @brief Finds the squared difference between two points (templated).
 * Header only for templating/linking reasons.
 *
 * @date Created 30/06/18
 * @author Jack Scantlebury
 */
#ifndef SQDIST_H
#define SQDIST_H

#include "../typedefs.h"
/**
 * @defgroup sqDist sqDist
 * @ingroup sqDist
 * @{
 * @brief Finds the squared difference between two points
 * @param p1,p2 x and y coordinates of first point
 * @param q1,q2 x and y coordinates of second point
 * @returns Squared distance between points p and q
 *
 * Using squared distance gives integer results when inputs are limited to W as
 * defined in [1]  doi: 10.1109/34.625128, Section 2.2 which avoids floating
 * point precision errors.
 */

template <class T1, class T2, class T3, class T4>
real sqDist(const T1 &p1, const T2 &p2, const T3 &q1, const T4 &q2) {
    return (pow(((real)p1 - (real)q1), 2) + pow(((real)p2 - (real)q2), 2));
}

#endif //SQDIST_H
