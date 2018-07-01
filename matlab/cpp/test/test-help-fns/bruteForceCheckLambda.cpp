/**
 * @file
 * @brief Checks by brute force whether correct values of lambda have been assigned according to [1] Section 3.
 */

#include <eigen3/Eigen/Dense>

#include "bruteForceCheckLambda.h"

#include "../../typedefs.cpp"
#include "../../aux.h"
#include "../../vd.h"
#include <iostream>
/**
 * @brief Checks by brute force whether correct values of lambda have been assigned according to [1] Section 3.
 * @param VD Voronoi diagram to be checked
 * @return true: All values of lambda correspond to (one of) lowest pixel-seed distances
 * @return false: One or more pixels havel lambda values that do not correspond to closest seed
 */
bool bruteForceCheckLambda(vd &VD) {
    real nc = VD.getNc();
    real nr = VD.getNr();
    std::map<real, real> Sx = VD.getSx();
    std::map<real, real> Sy = VD.getSy();
    std::map<real, real> Sk = VD.getSk();
    unsigned long ns = Sk.size();
    for (uint32 i = 0; i < nr; ++i) {
        for (uint32 j = 0; j < nc; ++j) {
            real lam = VD.getLamByIdx(i, j);
            real lamDist = sqDist(j, i, Sx.at(lam) - 1, Sy.at(lam) - 1);
            std::map<real, real>::iterator SkIt = Sk.begin();
            for (uint32 s = 0; s < ns; ++s) {
                real idx = SkIt->first;
                if (sqDist(j, i, Sx.at(idx) - 1, Sy.at(idx) - 1) < lamDist){
                    return false;
                }
                ++SkIt;
            }
        }
    }
    return true;
}