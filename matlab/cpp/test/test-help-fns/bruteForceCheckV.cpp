#include <eigen3/Eigen/Dense>

#include "bruteForceCheckV.h"
#include "../../typedefs.cpp"
#include "../../aux.h"
#include "../../vd.h"
#include "../../aux-functions/sqDist.h"

#ifndef INF
#define INF std::numeric_limits<real>::infinity()
#endif

/**
 * @brief Checks by brute force whether correct values of v have been assigned according to [1] Section 3.
 * @param VD Voronoi diagram to be checked
 * @return true: All values of v correspond are correct
 * @return false: One or more pixels havel v values that are incorrect
 */
bool bruteForceCheckV(vd &VD) {
    real nc = VD.getNc();
    real nr = VD.getNr();
    std::map<real, real> Sx = VD.getSx();
    std::map<real, real> Sy = VD.getSy();
    std::map<real, real> Sk = VD.getSk();
    unsigned long ns = Sk.size();
    for (uint32 i = 0; i < nr; ++i) {
        for (uint32 j = 0; j < nc; ++j) {
            std::map<real, real>::iterator SkIt = Sk.begin();
            real lowest = INF;
            bool v = 0;
            for (uint32 s = 0; s < ns; ++s) {
                real idx = SkIt->first;
                real sqd = sqDist(j, i, Sx.at(idx) - 1, Sy.at(idx) - 1);
                if (sqd < lowest){
                    lowest = sqd;
                    v = 0;
                } else if (sqd == lowest){
                    v = 1;
                }
                ++SkIt;
            }
            if(VD.getVByIdx(i, j) != v){
                return false;
            }
        }
    }
    return true;
}