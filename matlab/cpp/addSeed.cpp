/**
 * @file
 * @brief Adds seed to Voronoi diagram.
*/

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include "addSeed.h"
#include "skizException.h"
#include "NSStar.h"
#include "pointInRegion.h"
#include "getRegion.h"
#include "aux.h"
#include "typedefs.cpp"

#ifndef INF
#define INF std::numeric_limits<real>::infinity()
#endif


/**
 * @defgroup addSeed addSeed
 * @ingroup addSeed
 * @brief Adds seed to voronoi diagram.
 * @param VD vd object (definition in vd.h)
 * @param s1 First coordinate of seed to be added
 * @param s2 Second coordinate of seed to be added
 *
 * Method used is taken from "Discrete Voronoi Diagrams and the SKIZ
    Operator: A Dynamic Algorithm" [1], Section 3.1
*/

bool addSeed(vd &VD, real s1, real s2) {
    VD.k += 1;
    VD.setSxByIdx(VD.getK(), s1);
    VD.setSyByIdx(VD.getK(), s2);
    VD.setSkByIdx(VD.getK(), VD.getK());

    VD.setNkByIdx(VD.getK(), nsStar(VD));

    // Only N(s) for s in N(s*) need to be recalculated.
    // Initialise these with {s*} U N_k(s)\N_k+1(s*)
    std::map<real, RealVec> newDict;
    for (int s : VD.getNkByIdx(VD.k)) {
        RealVec v1 = VD.getNkByIdx(s);
        RealVec v2 = VD.getNkByIdx(VD.k);
        RealVec init;
        for (auto i : v1) {
            if (!inVector(v2, i)) {
                init.push_back(i);
            }
        }
        init.push_back(VD.k);
        newDict[s] = init;
    }

    // Build up N(s) for s in N(s*) incrementally
    for (auto s : VD.getNkByIdx(VD.k)) {
        for (auto r : VD.getNkByIdx(s)) {
            if (!inVector(VD.getNkByIdx(VD.k), r)) {
                continue;
            }
            if (inVector(newDict.at(r), s)) {
                continue;
            }
            RealVec uList = VD.getNkByIdx(s);

            uList.push_back(VD.k);
            for (auto u : uList) {
                if (u == r) {
                    continue;
                }
                std::array<real, 2> cc;
                try {
                    cc = circumcentre(VD.Sx.at(s), VD.Sy.at(s), VD.Sx.at(r),
                                      VD.Sy.at(r), VD.Sx.at(u), VD.Sy.at(u));
                } catch (SKIZLinearSeedsException &e) {
                    continue;
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
    Mat bounds = getRegion(VD, VD.k);

    // Scan row by row as per section 2.2
    bool finish = false;
    for (auto i = 0; i < VD.nr; ++i) {
        if (bounds(i, 0) == -1) { // There are no pixels in R(s*) on this row
            if (finish) {
                break; // R(s*) is convex; we are finished
            } else {
                continue; //R(s*) has not begun
            }
        } else {
            finish = true; // R(s*) has begun, next -1 bound means R(s) is finished
        }

        real lb = std::max(0.0, bounds(i, 0) - 1);
        real ub = std::min(VD.nc, bounds(i, 1));
        for (real j = lb; j < ub; ++j) { // Scan only relevant pixels in row
            const real l1 = VD.Sx.at(VD.Vk.lam(i, j)); // Sq distance to 'old' closest seed
            const real l2 = VD.Sy.at(VD.Vk.lam(i, j));
            real newMu = sqDist(s1, s2, j+1, i+1); // Sq distance to s*
            real oldMu = sqDist(l1, l2, j+1, i+1);

            if (newMu < oldMu) { // Pixel is in new region
                VD.Vk.lam(i, j) = VD.k;
                VD.Vk.v(i, j) = 0;
            } else if (newMu == oldMu) { // Pixel is part of skeleton K
                VD.Vk.v(i, j) = 1;
            }
        }
    }

    return true;
}