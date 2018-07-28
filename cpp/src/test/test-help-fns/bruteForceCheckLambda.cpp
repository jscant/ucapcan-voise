/**
 * @file
 * @brief Checks by brute force whether correct values of lambda have been
 * assigned according to [1] Section 3.
 */

#include <eigen3/Eigen/Dense>
#include "bruteForceCheckLambda.h"
#include "../../typedefs.h"
#include "../../vd.h"
#include "../../aux-functions/sqDist.h"

/**
 * @brief Checks by brute force whether correct values of lambda have been
 * assigned according to [1] Section 3.
 * @param VD Voronoi diagram to be checked
 * @return true: All values of lambda correspond to (one of) lowest pixel-seed
 * distances
 * @return false: One or more pixels havel lambda values that do not correspond
 * to closest seed
 */
bool bruteForceCheckLambda(vd &VD) {

    // Columns, rows and number of seeds
    real nc = VD.getNc();
    real nr = VD.getNr();
    unsigned long ns = VD.getSk().size();

    /*
     * Check each pixel against every seed manually for distance. Check that
     * lowest distance matches up with lambda value.
     */
    for (uint32 i = 0; i < nr; ++i) {
        for (uint32 j = 0; j < nc; ++j) {
            real lam = VD.getLamByIdx(i, j);
            real lamDist = sqDist(j, i, VD.getSxByIdx(lam) - 1,
                    VD.getSyByIdx(lam) - 1);
            real SkIt = 0;
            for (uint32 s = 0; s < ns; ++s) {
                real idx = VD.getSkByIdx(SkIt);
                if (sqDist(j, i, VD.getSxByIdx(idx) - 1,
                           VD.getSyByIdx(idx) - 1) < lamDist){
                    return false;
                }
                ++SkIt;
            }
        }
    }

    // No problems found
    return true;
}