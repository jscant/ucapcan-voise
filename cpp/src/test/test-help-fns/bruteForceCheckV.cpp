/**
 * @file
 * @brief Checks in a greedy fashion whether correct values of v have been
 * assigned according to [1] Section 3.
 */

#include <eigen3/Eigen/Dense>

#include "bruteForceCheckV.h"
#include "../../typedefs.h"
#include "../../vd.h"
#include "../../aux-functions/sqDist.h"

/**
 * @brief Checks in a greedy fashion whether correct values of v have been
 * assigned according to [1] Section 3.
 * @param VD Voronoi diagram to be checked
 * @return true: All values of v correspond are correct
 * @return false: One or more pixels havel v values that are incorrect
 */
bool bruteForceCheckV(vd &VD) {

    // Load cols, rows and seeds
    real nc = VD.getNc();
    real nr = VD.getNr();
    unsigned long ns = VD.getSk().size();

    /*
     * For each pixel, manually check whether there are one or more than one
     * closest seeds
     */
    for (uint32 i = 0; i < nr; ++i) {
        for (uint32 j = 0; j < nc; ++j) {
            real SkIt = 0;
            real lowest = INF;
            bool v = 0;
            for (uint32 s = 0; s < ns; ++s) {
                real idx = VD.getSkByIdx(SkIt);
                real sqd = sqDist(j, i, VD.getSxByIdx(idx) - 1, VD.getSyByIdx(idx) - 1);
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

    // No problems
    return true;
}