/**
 * @file
 * @brief Checks whether a point is within region C(s, A) according to [1]
 * definition 2.5
 *
 */

#include "pointInRegion.h"
#include "skizException.h"
#include "typedefs.h"

/**
 * @defgroup pointInRegion pointInRegion
 * @ingroup pointInRegion
 * @brief Checks whether a point is within region C(s, A) according to [1]
 * definition 2.5
 *
 * A point x is in C(s, A) where A is a set of seeds not including s if x is
 * on the 'correct' side of the lines defining all halfplanes defined by the
 * seeds s and r \f$\in\f$ A.
 *
 * @param vd Voronoi Diagram
 * @param pt x and y coordinates of point to check
 * @param s Index of seed which defines the region being checked
 * @param A Vector of seeds which together form half-planes that make up
 * C(s, A). Default is neighbours of s such that pointInRegion returns true if
 * point is in R(s) and false otherwise.
 * @returns true: Point is in C(s, A)
 * @returns false: Point is not in C(s, A)
 */
bool pointInRegion(const vd &VD, std::array<real, 2> pt, real s, RealVec A) {
    if (A.size() < 1) { // If no argument supplied, use default (neighbours)
        A = VD.getNkByIdx(s);
    }

    // Point in question
    const real pt1 = pt.at(0);
    const real pt2 = pt.at(1);

    // Location of seed that defines VR in question
    const real s1 = VD.getSxByIdx(s);
    const real s2 = VD.getSyByIdx(s);

    // Lambda fn from eq. 2.5 in [1]
    auto f = [](real p1, real p2, real q1, real q2, real i) -> real {
        return ((p2 - q2) * i + 0.5 * (pow(p1, 2) + pow(p2, 2) - pow(q1, 2) -
                                       pow(q2, 2))) / (p1 - q1);
    };

    RealVec lb, ub;

    // Proceed to get all bounds imposed by seeds in A (1 per seed)
    for (real r : A) {
        if (r != s) {
            const real r1 = VD.getSxByIdx(r);
            const real r2 = VD.getSyByIdx(r);
            if (r1 == s1) {
                if (s2 > r2) {
                    if (pt2 < ((r2 + s2) / 2)) {
                        return false;
                    }
                } else if (r2 > s2) {
                    if (pt2 > ((r2 + s2) / 2)) {
                        return false;
                    }
                } else {
                    // Identical seeds; this should not happen.
                    std::string msg = "Identical seeds: " +
                            std::to_string((int)s1) + ", " +
                                      std::to_string((int)s2) + "\n";
                    throw SKIZIdenticalSeedsException(msg.c_str());
                }
                continue;
            } else if ((s1 - r1) < 0) {
                ub.push_back(f(s1, s2, r1, r2, -pt2));
            } else if ((s1 - r1) > 0) {
                lb.push_back(f(s1, s2, r1, r2, -pt2));
            }
        }
    }

    // Find lowest upper and highest lower bound (final conditions)
    real highestLB, lowestUB;
    if (lb.size() > 0) {
        highestLB = *std::max_element(lb.begin(), lb.end());
    } else {
        highestLB = -INF; // No lower bound, no condition here
    }
    if (ub.size() > 0) {
        lowestUB = *std::min_element(ub.begin(), ub.end());
    } else {
        lowestUB = INF; // No upper bound, no condition here
    }

    // Final conditions to be met for membership of C(s, A)
    return (highestLB - EPS < pt1) && (pt1 < lowestUB + EPS);
}
