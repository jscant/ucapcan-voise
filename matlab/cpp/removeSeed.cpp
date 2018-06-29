/**
 * @file
 * @brief Removes seed from voronoi diagram
 */

#include <set>
#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#ifndef ADDSEED_H
#define ADDSEED_H
#include "addSeed.h"
#endif

#ifndef SKIZEXCEPTION_H
#define SKIZEXCEPTION_H
#include "skizException.h"
#endif

#ifndef NSSTAR_H
#define NSSTAR_H
#include "NSStar.h"
#endif

#ifndef POINTINREGION_H
#define POINTINREGION_H
#include "pointInRegion.h"
#endif

#ifndef GETREGION_H
#define GETREGION_H
#include "getRegion.h"
#endif

#ifndef AUX_H
#define AUX_H
#include "aux.h"
#endif

#ifndef INF
#define INF std::numeric_limits<real>::infinity()
#endif

#ifndef TYPEDEFS
#define TYPEDEFS
typedef double real;
typedef std::vector<real> RealVec;
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

#include "removeSeed.h"

/**
 * @brief Removes seed from voronoi diagram
 * @param vd Voronoi Diagram
 * @param Sk ID of seed to be removed
 * Method used is taken from "Discrete Voronoi Diagrams and the SKIZ Operator: A Dynamic Algorithm" [1], Section 3.2.
 *
*/
bool removeSeed(vd &VD, real Sk) {

    VD.k += 1;

    // Get list of row-wise bounds on R(Sk)
    Mat bounds = getRegion(VD, Sk);
    RealVec Ns = VD.Nk.at(Sk); // Neighbours of seed to be removed
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
        real ub = std::min(VD.nc, bounds(j, 1) + 1);
        for (real i = lb; i < ub; ++i) {
//            std::array<real, 2> pt = {(real) i + 1, (real) j + 1};
            //if(!pointInRegion(VD, pt, Sk, Ns)){
            //    continue;
            //}
            VD.Vk.lam(j, i) = Ns.at(0);
            VD.Vk.v(j, i) = 0;
            real lam = Ns.at(0);
            for (unsigned int idx=1; idx<Ns.size(); ++idx) {
                unsigned int r = Ns.at(idx);
                real newDist = sqDist(i+1, j+1, VD.Sx[r], VD.Sy[r]);
                real oldDist = sqDist(i+1, j+1, VD.Sx[lam], VD.Sy[lam]);
                if((int)newDist < (int)oldDist){
                    VD.Vk.lam(j, i) = r;
                    lam = r;
                    VD.Vk.v(j, i) = 0;
                } else if ((int)newDist == (int)oldDist){
                    VD.Vk.lam(j, i) = r;
                    lam = r;
                    VD.Vk.v(j, i) = 1;
                }
            }
        }
    }
    //mexPrintf("FLAG 8\n");
    std::map<real, RealVec> newDict;
    for (unsigned int r : VD.Nk.at(Sk)) {
        RealVec Ns = VD.Nk.at(r);
        Ns.erase(std::remove(Ns.begin(), Ns.end(), Sk), Ns.end());
        newDict[r] = Ns;
    }
    //mexPrintf("FLAG 9\n");
    for (auto s : VD.Nk.at(Sk)) {
        if(s == Sk) {
            continue;
        }
        //mexPrintf("FLAG 10\n");
        RealVec A = VD.Nk.at(s);
        A.insert(A.end(), VD.Nk.at(Sk).begin(), VD.Nk.at(Sk).end());
        A.erase(std::remove(A.begin(), A.end(), s), A.end());
        A.erase(std::remove(A.begin(), A.end(), Sk), A.end());
        for (auto r : VD.Nk.at(Sk)) {
            if (r == Sk || r == s || inVector(VD.Nk.at(s), r)) {
                continue;
            }
            for(int u : A) {
                if(u == r) {
                    continue;
                }
                std::array<real, 2> cc = { -1, -1 };
                try {
                    cc = circumcentre(VD.Sx.at(s), VD.Sy.at(s), VD.Sx.at(r),
                                      VD.Sy.at(r), VD.Sx.at(u), VD.Sy.at(u));
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
        VD.Nk.at(i.first) = i.second;
    }
    VD.Sk.erase((real)Sk);
    VD.Nk.at(Sk) = {};
    return false;
}