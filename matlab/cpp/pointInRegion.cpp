/**
 * @file
 * @headerfile ""
 * @brief Checks whether a point is within region C(s, A) according to [1] Definition 2.5
 *
 */

#include "pointInRegion.h"
#include "skizException.h"

#ifndef INF
#define INF std::numeric_limits<real>::infinity()
#endif

/**
 * @defgroup pointInRegion pointInRegion
 * @ingroup pointInRegion
 * @brief Checks whether a point is within region C(s, A) according to [1] Definition 2.5
 *
 * @param vd Voronoi Diagram
 * @param pt x and y coordinates of point to check
 * @param s Index of seed which defines the region being checked
 * @param A Vector of seeds which together form half-planes that make up C(s, A)
 * @returns true: Point is in C(s, A)
 * @returns false: Point is not in C(s, A)
 */

bool pointInRegion(const vd &VD, std::array<real, 2> pt, real s, RealVec A) {
    if (A.size() < 1) {
        A = VD.getNkByIdx(s);
    }
    const real pt1 = pt[0];
    const real pt2 = pt[1];
    const real s1 = VD.Sx.at(s);
    const real s2 = VD.Sy.at(s);

    auto f = [](real p1, real p2, real q1, real q2, real i) -> real {
        return ((p2 - q2) * i + 0.5 * (pow(p1, 2) + pow(p2, 2) - pow(q1, 2) - pow(q2, 2))) / (p1 - q1);
    };

    RealVec lb, ub;

    for (real r : A) {
        if (r != s) {
            const real r1 = VD.Sx.at(r);
            const real r2 = VD.Sy.at(r);
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
                    std::string msg = "Identical seeds: " + std::to_string((int)s1) + ", " + std::to_string((int)s2) + "\n";
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

    real highestLB, lowestUB;
    try {
        if (lb.size() > 0) {
            highestLB = *std::max_element(lb.begin(), lb.end());
        } else {
            highestLB = -INF;
        }
    } catch (const std::exception &e) {
        // PUT ERR MSG HERE
        highestLB = -INF;
    }
    try {
        if (ub.size() > 0) {
            lowestUB = *std::min_element(ub.begin(), ub.end());
        } else {
            lowestUB = INF;
        }
    } catch (const std::exception &e) {
        // PUT ERR MSG HERE
        lowestUB = INF;
    }
    if (highestLB - 10e-7 <= pt1 && pt1 <= lowestUB + 10e-7) {
        return true;
    }
    return false;
}
