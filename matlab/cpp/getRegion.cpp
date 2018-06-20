//
// Created by root on 20/06/18.
//

#ifndef GETREGION_H
#define GETREGION_H
#include "getRegion.h"
#endif

#ifndef EIGEN_DENSE_H
#define EIGEN_DENSE_H
#include "eigen/Eigen/Dense"
#endif

#ifndef MAT
#define MAT
typedef Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

#ifndef MEX_H
#define MEX_H
#include "mex.h"
#endif

#ifndef MATRIX_H
#define MATRIX_H
#include "matrix.h"
#endif

#ifndef MATH_H
#define MATH_H
#include "math.h"
#endif

// Return a n x 2 array of lower and upper bounds for R(s) for each row
Mat getRegion(const vd &VD, double s) {
    double k = VD.k;
    const double s1 = VD.Sx.at(s);
    const double s2 = VD.Sy.at(s);

    // Lambda expression to find maximum/minimum value of i in region
    auto f = [](double p1, double p2, double q1, double q2, double i) -> double {
        return ((p2 - q2) * i + 0.5 * (pow(p1, 2) + pow(p2, 2) - pow(q1, 2) -
                                       pow(q2, 2))) / (p1 - q1);
    };

    std::vector<double> A = VD.Nk.at(s);
    Mat boundsUp, boundsDown;
    boundsUp.resize(VD.nc - s2 + 1, 2);
    boundsDown.resize(s2 - 1, 2);
    boundsUp.setOnes();
    boundsDown.setOnes();
    boundsUp *= -1;
    boundsDown *= -1;

    // Upward sweep including s2 row
    for (double i = s2; i < VD.nc + 1; ++i) {
        std::vector<double> lb, ub;

        const double boundsIdx = i - s2 + 1;
        bool killLine = false;
        for (double j = 0; j < A.size(); ++j) {
            const double r = A[j];
            const double r1 = VD.Sx.at(r);
            const double r2 = VD.Sy.at(r);

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
        double highestLB, lowestUB;
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
    for (double i = s2 - 1; i > 0; --i) {
        std::vector<double> lb, ub;
        bool killLine = false;
        for (auto r : A) {
            const double r1 = VD.Sx.at(r);
            const double r2 = VD.Sy.at(r);
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
        double highestLB, lowestUB;
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