/**
 * @file
 * @brief Finds the voronoi region R(s) of a seed s.
*/

#include <eigen3/Eigen/Dense>
#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif
#include <math.h>

#ifndef GETREGION_H
#define GETREGION_H

#include "getRegion.h"

#endif

#ifndef TYPEDEFS
#define TYPEDEFS
typedef double real;
typedef std::vector<real> RealVec;
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

/**
 * @defgroup getRegion getRegion
 * @ingroup getRegion
 * @brief Finds the voronoi region R(s) of a seed s.
 *
 * @param VD Voronoi diagram
 * @param s ID of seed for which R(s) is to be found
 * @returns (m x 2) Eigen::Array. Each row is either (-1, -1) of there are no pixels in the corresponding row in W
 * that are also in R(s), or (lb, ub) where 0 <= lb <= ub < n, indicating that the pixels in the \f$i^{th}\f$ row
 * between lb and ub inclusive are in the region R(s).
 *
 * R(s) is as defined in [1], Definition 1.1.

*/

Mat getRegion(const vd &VD, const real &s) {
    const real s1 = VD.Sx.at(s);
    const real s2 = VD.Sy.at(s);

    // Lambda expression to find maximum/minimum value of i in region
    auto f = [](real p1, real p2, real q1, real q2, real i) -> real {
        return ((p2 - q2) * i + 0.5 * (pow(p1, 2) + pow(p2, 2) - pow(q1, 2) - pow(q2, 2))) / (p1 - q1);
    };

    RealVec A = VD.Nk.at(s);
    Mat boundsUp, boundsDown;
    boundsUp.resize(VD.nc - s2 + 1, 2);
    boundsDown.resize(s2 - 1, 2);
    boundsUp.setOnes();
    boundsDown.setOnes();
    boundsUp *= -1;
    boundsDown *= -1;

    // Upward sweep including s2 row
    for (real i = s2; i < VD.nc + 1; ++i) {
        RealVec lb, ub;

        const real boundsIdx = i - s2 + 1;
        bool killLine = false;
        for (real j = 0; j < A.size(); ++j) {
            const real r = A[j];
            const real r1 = VD.Sx.at(r);
            const real r2 = VD.Sy.at(r);

            if (s1 > r1) {
                lb.push_back(f(s1, s2, r1, r2, -i));
            } else if (r1 > s1) {
                ub.push_back(f(s1, s2, r1, r2, -i));
            } else {
                if (s2 > r2 && i < 0.5 * (s2 + r2)) {
                    killLine = true;
                    break;
                }
                if (r2 > s2 && i > 0.5 * (s2 + r2)) {
                    killLine = true;
                    break;
                }
            }
        }
        real highestLB, lowestUB;
        if (!killLine) {
            highestLB = 0;
            lowestUB = 0;
            try {
                if (lb.size() > 0) {
                    highestLB = std::max(0.0, floor(*std::max_element(lb.begin(), lb.end())));
                } else {
                    highestLB = 0;
                }
            } catch (const std::exception &e) {
                highestLB = 0;
            }
            try {
                if (ub.size() > 0) {
                    lowestUB = std::min(VD.nc, ceil(*std::min_element(ub.begin(), ub.end())));
                } else {
                    lowestUB = VD.nc;
                }
            } catch (const std::exception &e) {
                lowestUB = VD.nc;
            }
            if (lowestUB < highestLB) {
                break;
            }
            boundsUp(boundsIdx - 1, 0) = highestLB;
            boundsUp(boundsIdx - 1, 1) = lowestUB;
        } else {
            break;
        }
    }

    // Downward sweep excluding s2 row
    for (real i = s2 - 1; i > 0; --i) {
        RealVec lb, ub;
        bool killLine = false;
        for (auto r : A) {
            const real r1 = VD.Sx.at(r);
            const real r2 = VD.Sy.at(r);
            if (s1 > r1) {
                lb.push_back(f(s1, s2, r1, r2, -i));
            } else if (r1 > s1) {
                ub.push_back(f(s1, s2, r1, r2, -i));
            } else {

                // Seeds are stacked vertically. All lines above/below
                // halfway between them are not in region.
                if (s2 > r2 && i < 0.5 * (s2 + r2)) {
                    killLine = true;
                    break;
                }
                if (r2 > s2 && i > 0.5 * (s2 + r2)) {
                    killLine = true;
                    break;
                }
            }
        }
        real highestLB, lowestUB;
        if (!killLine) {
            highestLB = 0;
            lowestUB = 0;
            try {
                if (lb.size() > 0) {
                    highestLB = std::max(0.0, floor(*std::max_element(lb.begin(), lb.end())));
                } else {
                    highestLB = 0;
                }
            } catch (const std::exception &e) {
                highestLB = 0;
            }

            try {
                if (ub.size() > 0) {
                    lowestUB = std::min(VD.nc, ceil(*std::min_element(ub.begin(), ub.end())));
                } else {
                    lowestUB = VD.nc;
                }
            } catch (const std::exception &e) {
                lowestUB = VD.nc;
            }
            if (lowestUB < highestLB) {
                break; // We have finished this sweep
            }
            boundsDown(s2 - i - 1, 0) = highestLB;
            boundsDown(s2 - i - 1, 1) = lowestUB;
        } else {
            break;
        }
    }

    Mat result(boundsUp.rows() + boundsDown.rows(), 2);

    result << boundsDown.colwise().reverse(),
           boundsUp;

    return result;
}