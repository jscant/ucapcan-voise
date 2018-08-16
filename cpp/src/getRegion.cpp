/**
 * @file
 * @brief Finds the Voronoi region R(s) of a seed s.
 *
 * From section 2.2 (Discretisation) of R. E. Sequeira and F. J. Preteux.
 * “Discrete Voronoi diagrams and the SKIZ operator: a dynamic algorithm”.
 * In: IEEE Transactions on Pattern Analysis and Machine Intelligence 19.10
 * (1997), pp. 1165–1170. [1]
 *
 * @date Created 01/07/18
 * @author Jack Scantlebury
*/

#include <eigen3/Eigen/Dense>
#include <math.h>

#include "getRegion.h"

/**
 * @defgroup getRegion getRegion
 * @ingroup getRegion
 * @brief Finds the voronoi region R(s) of a seed s.
 *
 * This function uses a result arising from discussion in [1] section 2.2
 * (Discretisation). A row-scanning technique is used to build up a series
 * of inequalities for each row that must be satisfied for a pixel to be a
 * member of a Voronoi region. The highest lower and lowest upper bounds are
 * the only active constraints, and define the region in \f$\Omega\f$.
 *
 * @param VD Voronoi diagram
 * @param s ID of seed for which R(s) is to be found
 * @returns (m x 2) Eigen::Array. Each row is either (-1, -1) if there are no
 * pixels in the corresponding row in W that are also in R(s), or (lb, ub) where
 * 0 <= lb <= ub < n, indicating that the pixels in the \f$i^{th}\f$ row in the
 * interval (lb, ub] are in R(s).
 *
 * R(s) is as defined in [1], Definition 1.1.
*/

Mat getRegion(const vd &VD, const real &s) {
    const uint32 s1 = VD.getSxByIdx(s);
    const uint32 s2 = VD.getSyByIdx(s);

    // Lambda expression to find maximum/minimum value of i in region. Comes from eq. 2.5 in [1]
    auto f = [](real p1, real p2, real q1, real q2, real i) -> real {
        return ((p2 - q2) * i + 0.5 * (pow(p1, 2) + pow(p2, 2) - pow(q1, 2) - pow(q2, 2))) / (p1 - q1);
    };

    // Initialise bounds,
    RealVec A = VD.getNkByIdx(s);
    Mat boundsUp(VD.getNr() - s2 + 1, 2);
    Mat boundsDown(s2 - 1, 2);
    boundsUp.setOnes();
    boundsDown.setOnes();
    boundsUp *= -1; // (-1, -1) indicates no pixels in row are in R(s)
    boundsDown *= -1;

    // Upward sweep including s2 row
    for (real i = s2; i < VD.getNr() + 1; ++i) {

        RealVec lb, ub;
        const real boundsIdx = i - s2 + 1;
        bool killLine = false; // For use when s1 == s2
        for (auto r : A) { // Apply conditions from neighbours only

            const real r1 = VD.getSxByIdx(r);
            const real r2 = VD.getSyByIdx(r);

            /*
             * (s1 - r1)j - (s2 - r2)i >= (s1^2 + s2^2 - r1^2 - r2^2)/2
             * Equality changes sign depending on (s1 - r1) so bound can be
             * upper or lower. If s1 == r1 then no dependence on j, only
             * dependence on i (killLine means no pixels in row can be in R(s))
            */
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

        /*
         * We now have all conditions on membership of R(s) that come from r in
         * N(s). Only the lowest upper bound and highest lower bound of these
         * conditions is active, and become the upper and lower bound of the
         * region on the row.
        */
        real highestLB, lowestUB;
        if (killLine) {
            /*
             * killLine means there is a seed in the same column as s which is
             * closer to all pixels in that row, so row has no bounds in R(s)
            */
            break;
        } else {
            highestLB = 0;
            lowestUB = VD.getNc();
            try {
                if (lb.size() > 0) {
                    highestLB = std::max((real)0.0, ceil(
                            *std::max_element(lb.begin(), lb.end())));
                }
            } catch (const std::exception &e) {
                highestLB = 0;
            }
            try {
                if (ub.size() > 0) {
                    lowestUB = std::min((real)VD.getNc(), floor(
                            *std::min_element(ub.begin(), ub.end())));
                }
            } catch (const std::exception &e) {
                lowestUB = VD.getNc();
            }
            if (lowestUB < highestLB) {
                break;
            }
            boundsUp(boundsIdx - 1, 0) = highestLB;
            boundsUp(boundsIdx - 1, 1) = lowestUB;
        }
    }

    // Downward sweep excluding s2 row
    for (real i = s2 - 1; i > 0; --i) {
        RealVec lb, ub;
        bool killLine = false;
        for (auto r : A) {
            const real r1 = VD.getSxByIdx(r);
            const real r2 = VD.getSyByIdx(r);
            if (s1 > r1) {
                lb.push_back(f(s1, s2, r1, r2, -i));
            } else if (r1 > s1) {
                ub.push_back(f(s1, s2, r1, r2, -i));
            } else {

                /*
                 * Seeds are stacked vertically. All lines above/below
                 * halfway between them are not in region.
                */
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
            lowestUB = VD.getNc();
            try {
                if (lb.size() > 0) {
                    highestLB = std::max((real)0.0,
                            ceil(*std::max_element(lb.begin(), lb.end())));
                }
            } catch (const std::exception &e) {
                highestLB = 0;
            }

            try {
                if (ub.size() > 0) {
                    lowestUB = std::min((real)VD.getNc(), floor(*std::min_element(ub.begin(), ub.end())));
                }
            } catch (const std::exception &e) {
                lowestUB = VD.getNc();
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

    // We now have all bounds for every row, put them in result and return
    Mat result(boundsUp.rows() + boundsDown.rows(), 2);

    result << boundsDown.colwise().reverse(),
           boundsUp;

    return result;
}