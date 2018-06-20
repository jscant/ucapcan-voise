#ifndef INF
#define INF std::numeric_limits<double>::infinity()
#endif

#ifndef MEX_H
#define MEX_H
#include "mex.h"
#endif

#ifndef MATRIX_H
#define MATRIX_H
#include "matrix.h"
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

vd addSeed(vd VD, double s1, double s2){
    VD.k += 1;
    VD.Sx[VD.k] = s1;
    VD.Sy[VD.k] = s2;
    VD.Sk[VD.k] = VD.k;

    VD.Nk[VD.k] = Ns_star(VD);
    std::map<double, std::vector<double>> newDict;

    for (int s : VD.Nk.at(VD.k)) {
        std::vector<double> v1 = VD.Nk.at(s);
        std::vector<double> v2 = VD.Nk.at(VD.k);
        std::vector<double> init;

        for (auto i : v1) {
            if (!inVector(v2, i)) {
                init.push_back(i);
            }
        }
        init.push_back(VD.k);
        newDict[s] = init;
    }


    for (auto s : VD.Nk.at(VD.k)) {
        for (auto r : VD.Nk.at(s)) {
            if (!inVector(VD.Nk.at(VD.k), r)) {
                continue;
            }
            if (inVector(newDict.at(r), s)) {
                continue;
            }
            std::vector<double> uList = VD.Nk.at(s);

            uList.push_back(VD.k);
            for (auto u : uList) {
                if (u == r) {
                    continue;
                }
                std::array<double, 2> cc;
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

    for (auto i : newDict) {
        VD.Nk[i.first] = i.second;
    }

    Mat bounds = getRegion(VD, VD.k);

    int count = 0;
    bool finish = false;
    for (auto i = 0; i < VD.nr; ++i) {
        if (bounds(i, 0) == -1){
            if (finish) {
                break;
            } else {
                continue;
            }
        } else {
            finish = true;
        }
        double lb = std::max(0.0, bounds(i, 0) - 1);
        double ub = std::min(VD.nc, bounds(i, 1));
        for (double j = lb; j < ub; ++j) {
            const double l1 = VD.Sx.at(VD.Vk.lam(i, j));
            const double l2 = VD.Sy.at(VD.Vk.lam(i, j));
            double newMu = sqDist(s1, s2, j+1, i+1);
            double oldMu = sqDist(l1, l2, j+1, i+1);

            if (newMu < oldMu) {
                VD.Vk.lam(i, j) = VD.k;
                VD.Vk.v(i, j) = 0;
            } else if (newMu == oldMu) {
                VD.Vk.v(i, j) = 1;
            }
        }
    }

    return VD;
}