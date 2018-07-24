#include "generateProposition2VD.h"
#include "../../skizException.h"
#include "../../aux-functions/sqDist.h"
#include <iostream>
#include "../../aux-functions/inVector.h"

loadStruct generateProposition2VD(uint32 dim) {
    if (dim < 5 || dim % 2 == 0) {
        throw SKIZException("dim must be odd and greater than 4");
    }
    Mat lam = Mat::Zero(dim, dim);
    Mat v = Mat::Zero(dim, dim);
    RealVec Sx;
    RealVec Sy;

    Sx.push_back(0);
    Sx.push_back(dim - 1);
    Sx.push_back(0);
    Sx.push_back(dim - 1);
    Sy.push_back(0);
    Sy.push_back(0);
    Sy.push_back(dim - 1);
    Sy.push_back(dim - 1);

    for (uint32 i = 0; i < dim; ++i) {
        for (uint32 j = 0; j < dim; ++j) {
            real minDist = sqDist(Sx.at(0), Sy.at(0), i, j);
            lam(j, i) = 1;
            for (uint32 k = 1; k < Sx.size(); ++k) {
                real dist = sqDist(Sx.at(k), Sy.at(k), i, j);
                if (dist < minDist) {
                    minDist = dist;
                    lam(j, i) = k + 1;
                    v(j, i) = 0;
                } else if (dist == minDist) {
                    v(j, i) = 1;
                }
            }
        }
    }

    std::map<real, RealVec> Nk;
    Nk[1] = {2, 3};
    Nk[2] = {1, 4};
    Nk[3] = {1, 4};
    Nk[4] = {2, 3};

    for(auto i = 0; i < Sx.size(); ++i){
        Sx[i] += 1;
        Sy[i] += 1;
    }

    vd VD(dim, dim);
    VD.setV(v);
    VD.setLam(lam);
    VD.setK(4);
    VD.setSx(Sx);
    VD.setSy(Sy);
    VD.setSk({1, 2, 3, 4});
    VD.setNk(Nk);

    Sx.push_back((dim - 1) / 2);
    Sy.push_back((dim - 1) / 2);
    Sx.push_back((dim - 1) / 4);
    Sy.push_back((dim - 1) / 4);
    Sx.push_back(3 * (dim - 1) / 4);
    Sy.push_back((dim - 1) / 4);
    Sx.push_back((dim - 1) / 4);
    Sy.push_back(3 * (dim - 1) / 4);
    Sx.push_back(3 * (dim - 1) / 4);
    Sy.push_back(3 * (dim - 1) / 4);

    for(int i = 4; i < Sx.size(); ++i){
        Sx[i] += 1;
        Sy[i] += 1;
    }

    loadStruct ls(dim, dim);
    ls.VD = VD;
    ls.Sx = Sx;
    ls.Sy = Sy;
    return ls;

}