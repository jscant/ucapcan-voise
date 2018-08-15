/**
 * @file
 * @brief Adds seed to Voronoi diagram.
 *
 * Method used is taken from "Discrete Voronoi Diagrams and the SKIZ Operator:
 * A Dynamic Algorithm" [1], Section 3.1
 *
 * @date Created 01/07/18
 * @author Jack Scantlebury
*/

#include "addSeed.h"
#include "skizException.h"
#include "NSStar.h"
#include "pointInRegion.h"
#include "getRegion.h"
#include "aux-functions/inVector.h"
#include "aux-functions/sqDist.h"
#include "aux-functions/circumcentre.h"
#include "aux-functions/updateDict.h"
#include "typedefs.h"
#include <iostream>

/**
 * @defgroup addSeed addSeed
 * @ingroup addSeed
 *
 * @brief Adds seed to voronoi diagram.
 *
 * Method used is taken from "Discrete Voronoi Diagrams and the SKIZ Operator:
 * A Dynamic Algorithm" [1], Section 3.1
 *
 * @param VD vd object (definition in vd.h)
 * @param s1 x coordinate of seed to be added
 * @param s2 y coordinate of seed to be added
 *
*/
void addSeed(vd &VD, real s1, real s2) {

    // Add seed coordinates to seed list, update k and active seeds Sk
    VD.incrementK();
    VD.addSx(s1);
    VD.addSy(s2);
    VD.addSk(VD.getK());

    try {
        // Get N_{k+1}(s*) from 3.1.2 in [1]
        VD.setNkByIdx(VD.getK(), nsStar(VD));
    } catch (std::exception &e){
        throw e;
    }

    /*
     * Only N(s) for s in N(s*) need to be recalculated. Initialise these with
     * {s*} U N_k(s)\N_k+1(s*)
     */
    std::map<real, RealVec> newDict;
    for (auto s : VD.getNkByIdx(VD.getK())) {
        RealVec v1 = VD.getNkByIdx(s);
        RealVec v2 = VD.getNkByIdx(VD.getK());
        RealVec init;
        for (auto i : v1) {
            if (!inVector(v2, i)) {
                init.push_back(i);
            }
        }
        init.push_back(VD.getK());
        newDict[s] = init;
    }

    // Build up N(s) for s in N(s*) incrementally (from 3.1.2 in [1])
    for (auto s : VD.getNkByIdx(VD.getK())) {
        for (auto r : VD.getNkByIdx(s)) {
            if (!inVector(VD.getNkByIdx(VD.getK()), r)) {
                continue;
            }
            if (inVector(newDict.at(r), s)) {
                continue;
            }
            RealVec uList = VD.getNkByIdx(s);

            uList.push_back(VD.getK());
            for (auto u : uList) {
                if (u == r) {
                    continue;
                }
                std::array<real, 2> cc;
                try {
                    cc = circumcentre(VD.getSxByIdx(s), VD.getSyByIdx(s),
                                      VD.getSxByIdx(r), VD.getSyByIdx(r),
                                      VD.getSxByIdx(u), VD.getSyByIdx(u));
                } catch (SKIZLinearSeedsException &e) {
                    continue; // Linearity means seeds are not neighbours
                }
                if (pointInRegion(VD, cc, s, uList)) {
                    updateDict(newDict, s, r);
                    updateDict(newDict, r, s);
                    break;
                }
            }
        }
    }

    // Update Nk with new neighbour relationships
    for (auto i : newDict) {
        VD.setNkByIdx(i.first, i.second);
    }

    // Find bounds of new region using inequalities derived in section 2.2
    Mat bounds = getRegion(VD, VD.getK());

    // Scan row by row as per section 2.2
    bool finish = false;
    for (uint32 i = 0; i < VD.getNr(); ++i) {
        if (bounds(i, 0) == -1) { // There are no pixels in R(s*) on this row
            if (finish) {
                break; // R(s*) is convex; we are finished
            } else {
                continue; //R(s*) has not begun
            }
        } else { // R(s*) has begun, next -1 bound means R(s) is finished
            finish = true;
        }

        real lb = std::max((real)0.0, bounds(i, 0) - 1);
        real ub = std::min((real)VD.getNc(), bounds(i, 1));
        for (auto j = lb; j < ub; ++j) { // Scan only relevant pixels in row

            // Sq distance to 'old' closest seed
            const uint32 l1 = VD.getSxByIdx(VD.getLamByIdx(i, j));

            // Sq distance to candidate seed
            const uint32 l2 = VD.getSyByIdx(VD.getLamByIdx(i, j));
            real newMu = sqDist(s1, s2, j+1, i+1); // Sq distance to s*
            real oldMu = sqDist(l1, l2, j+1, i+1);

            if (newMu < oldMu) { // Pixel is in new region
                VD.setLamByIdx(i, j, VD.getK());
                VD.setVByIdx(i, j, 0);
            } else if (newMu == oldMu) { // Pixel is part of skeleton K
                VD.setVByIdx(i, j, 1);
            }
        }
    }
}