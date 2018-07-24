/**
 * @file
 * @brief Removes seed from Voronoi diagram
 */

#include "addSeed.h"
#include "skizException.h"
#include "NSStar.h"
#include "pointInRegion.h"
#include "getRegion.h"
#include "typedefs.h"
#include "removeSeed.h"
#include "aux-functions/inVector.h"
#include "aux-functions/sqDist.h"
#include "aux-functions/circumcentre.h"
#include "aux-functions/updateDict.h"

/**
 * @brief Removes seed from voronoi diagram
 * @param VD Voronoi Diagram
 * @param Sk ID of seed to be removed
 * Method used is taken from "Discrete Voronoi Diagrams and the SKIZ Operator:
 * A Dynamic Algorithm" [1], Section 3.2.
 *
*/
void removeSeed(vd &VD, real sRemove) {

    VD.incrementK();

    // Get list of row-wise bounds on R(Sk)
    Mat bounds = getRegion(VD, sRemove);
    RealVec Ns = VD.getNkByIdx(sRemove); // Neighbours of seed to be removed
    bool finish = false;
    for (int j = 0; j < bounds.rows(); ++j) {
        if (bounds(j, 0) == -1) {
            if (finish) {
                break; // R(s) convex so we are done
            } else {
                continue; // We have not yet reached a row with pixels in R(s)
            }
        }
        finish = true; // Next time we reach a bound with -1, we are finished

        // Lower and upper bounds modified to fit C++ array indexing
        real lb = std::max(0.0, bounds(j, 0) - 1);
        real ub = std::min((real)VD.getNc(), bounds(j, 1));

        // For this row, scan relevant pixels
        for (real i = lb; i < ub; ++i) {

            // Initialise to first seed in neighbour list, first distance
            real lam = Ns.at(0);
            bool v = 0;
            real oldDist = sqDist(i+1, j+1, VD.getSxByIdx(lam),
                                  VD.getSyByIdx(lam));

            // Check distance to all seeds in a greedy fashion
            for (uint32 idx = 1; idx<Ns.size(); ++idx) {
                uint32 r = Ns.at(idx);
                real newDist = sqDist(i+1, j+1, VD.getSxByIdx(r),
                        VD.getSyByIdx(r));
                if(newDist < oldDist){
                    v = 0;
                    lam = r;
                    oldDist = newDist;
                } else if (newDist == oldDist){
                    v = 1;
                }
            }

            // Finally set lambda and v values to those found
            VD.setLamByIdx(j, i, lam);
            VD.setVByIdx(j, i, v);
        }
    }

    // Initialise N_{k+1}(s), s in N_k(s*)
    std::map<real, RealVec> newDict;
    for (auto s : VD.getNkByIdx(sRemove)) {
        RealVec Ns = VD.getNkByIdx(s);
        Ns.erase(std::remove(Ns.begin(), Ns.end(), sRemove), Ns.end());
        newDict[s] = Ns;
    }

    // Update new dictionaries as per 3.2.2 in [1]
    for (auto s : VD.getNkByIdx(sRemove)) {
        if(s == sRemove) {
            continue;
        }
        RealVec A = VD.getNkByIdx(s);
        RealVec B = VD.getNkByIdx(sRemove);
        A.insert(A.end(), B.begin(), B.end());
        A.erase(std::remove(A.begin(), A.end(), s), A.end());
        A.erase(std::remove(A.begin(), A.end(), sRemove), A.end());
        for (auto r : VD.getNkByIdx(sRemove)) {
            if (r == sRemove || r == s || inVector(VD.getNkByIdx(s), r)) {
                continue;
            }
            for(auto u : A) {
                if(u == r) {
                    continue;
                }

                std::array<real, 2> cc;
                try {
                    cc = circumcentre(VD.getSxByIdx(s), VD.getSyByIdx(s),
                                      VD.getSxByIdx(r), VD.getSyByIdx(r),
                                      VD.getSxByIdx(u), VD.getSyByIdx(u));
                } catch (SKIZLinearSeedsException &e) {
                    continue; // Collinearity means that s not in N(r) and v.v.
                }

                // s and r are neighbours!
                if(pointInRegion(VD, cc, s, A)) {
                    updateDict(newDict, s, r);
                    updateDict(newDict, r, s);
                    break;
                }
            }
        }
    }

    // Update main neighbour dictionary with new relationships
    for(auto i : newDict) {
        VD.setNkByIdx(i.first, i.second);
    }

    // Finally remove seed from active seed list and delete its Nk entry
    VD.eraseSk(sRemove);
    VD.setNkByIdx(sRemove, {});
}