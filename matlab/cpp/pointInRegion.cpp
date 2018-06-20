//
// Created by root on 20/06/18.
//

#ifndef POINTINREGION_H
#define POINTINREGION_H
#include "pointInRegion.h"
#endif

#ifndef SKIZ_SKIZEXCEPTION_H
#define SKIZ_SKIZEXCEPTION_H
#include "skizException.h"
#endif

#ifndef INF
#define INF std::numeric_limits<double>::infinity()
#endif

bool pointInRegion(const vd &VD, std::array<double, 2> pt, double s, std::vector<double> A) {
    if (A.size() < 1) {
        A = VD.Nk.at(s);
    }
    const double pt1 = pt[0];
    const double pt2 = pt[1];
    const double s1 = VD.Sx.at(s);
    const double s2 = VD.Sy.at(s);

    auto f = [](double p1, double p2, double q1, double q2, double i) -> double {
        return ((p2 - q2) * i + 0.5 * (pow(p1, 2) + pow(p2, 2) - pow(q1, 2) - pow(q2, 2))) / (p1 - q1);
    };

    std::vector<double> lb, ub;

    for (double r : A) {
        if (r != s) {
            const double r1 = VD.Sx.at(r);
            const double r2 = VD.Sy.at(r);
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
                    throw SKIZIdenticalSeedsError("Identical seeds");
                }
                continue;
            } else if ((s1 - r1) < 0) {
                ub.push_back(f(s1, s2, r1, r2, -pt2));
            } else if ((s1 - r1) > 0) {
                lb.push_back(f(s1, s2, r1, r2, -pt2));
            }
        }
    }

    double highestLB, lowestUB;
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