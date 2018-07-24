/**
 * @file
 * @brief Removes seed from voronoi diagram
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

#ifndef INF
#define INF std::numeric_limits<real>::infinity()
#endif

/**
 * @brief Removes seed from voronoi diagram
 * @param VD Voronoi Diagram
 * @param Sk ID of seed to be removed
 * Method used is taken from "Discrete Voronoi Diagrams and the SKIZ Operator: A Dynamic Algorithm" [1], Section 3.2.
 *
*/
void removeSeed(vd &VD, real Sk) {

    VD.incrementK();

    // Get list of row-wise bounds on R(Sk)
    Mat bounds = getRegion(VD, Sk);
    RealVec Ns = VD.getNkByIdx(Sk); // Neighbours of seed to be removed
    bool finish = false;
    for (int j = 0; j < bounds.rows(); ++j) {
        if (bounds(j, 0) == -1) {
            if (finish) {
                break; // R(s) convex so we are done
            } else {
                continue; // We have not yet reached a row with pixels in R(s)
            }
        }
        finish = true;
        real lb = std::max(0.0, bounds(j, 0) - 1);
        real ub = std::min(VD.getNc(), bounds(j, 1));
        for (real i = lb; i < ub; ++i) {
            VD.setLamByIdx(j, i, Ns.at(0));
            VD.setVByIdx(j, i, 0);
            real lam = Ns.at(0);
            for (uint32 idx=1; idx<Ns.size(); ++idx) {
                uint32 r = Ns.at(idx);
                real newDist = sqDist(i+1, j+1, VD.getSxByIdx(r), VD.getSyByIdx(r));
                real oldDist = sqDist(i+1, j+1, VD.getSxByIdx(lam), VD.getSyByIdx(lam));
                if((int)newDist < (int)oldDist){
                    VD.setLamByIdx(j, i, r);
                    VD.setVByIdx(j, i, 0);
                    lam = r;
                } else if ((int)newDist == (int)oldDist){
                    VD.setLamByIdx(j, i, r);
                    VD.setVByIdx(j, i, 1);
                    lam = r;
                }
            }
        }
    }
    //mexPrintf("FLAG 8\n");
    std::map<real, RealVec> newDict;
    for (uint32 r : VD.getNkByIdx(Sk)) {
        RealVec Ns = VD.getNkByIdx(r);
        Ns.erase(std::remove(Ns.begin(), Ns.end(), Sk), Ns.end());
        newDict[r] = Ns;
    }
    //mexPrintf("FLAG 9\n");
    for (auto s : VD.getNkByIdx(Sk)) {
        if(s == Sk) {
            continue;
        }
        //mexPrintf("FLAG 10\n");
        RealVec A = VD.getNkByIdx(s);
        RealVec B = VD.getNkByIdx(Sk);
        A.insert(A.end(), B.begin(), B.end());
        A.erase(std::remove(A.begin(), A.end(), s), A.end());
        A.erase(std::remove(A.begin(), A.end(), Sk), A.end());
        for (auto r : VD.getNkByIdx(Sk)) {
            if (r == Sk || r == s || inVector(VD.getNkByIdx(s), r)) {
                continue;
            }
            for(int u : A) {
                if(u == r) {
                    continue;
                }
                std::array<real, 2> cc = { -1, -1 };
                try {
                    cc = circumcentre(VD.getSxByIdx(s), VD.getSyByIdx(s), VD.getSxByIdx(r),
                                      VD.getSyByIdx(r), VD.getSxByIdx(u), VD.getSyByIdx(u));
                } catch (SKIZLinearSeedsException &e) {
                    continue;
                }
                if(pointInRegion(VD, cc, s, A)) {
                    updateDict(newDict, s, r);
                    updateDict(newDict, r, s);
                    break;
                }
            }
        }
    }
    for(auto i : newDict) {
        VD.setNkByIdx(i.first, i.second);
    }
    VD.eraseSk(Sk);
    VD.setNkByIdx(Sk, {});
}