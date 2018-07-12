/**
 * @file
 * @brief Loads Voronoi diagram saved by Matlab in ascii format.
 */
#include <string>
#include <iostream>
#include "loadVD.h"
#include "loadStruct.h"
#include "../../removeSeed.h"
#include "../../getRegion.h"
#include "../../skizException.h"
#include "../../typedefs.cpp"
#include "../../aux-functions/readSeeds.h"
#include "../../aux-functions/readMatrix.h"

loadStruct loadVD(std::string basePath){
    int nc = 256, nr = 256;
    std::vector<RealVec> seeds = readSeeds(basePath + "benchVDSeeds.txt");
    Mat lam = readMatrix(basePath + "benchVDLambda.txt", nr, nc);
    Mat v = readMatrix(basePath + "benchVDV.txt", nr, nc);
    Mat px(nr, nc);
    Mat py(nr, nc);

    for (auto i = 0; i < nr; ++i) {
        for (auto j = 0; j < nc; ++j) {
            px(i, j) = j;
            py(i, j) = i;
        }
    }

    RealVec Sx = seeds.at(0);
    RealVec Sy = seeds.at(1);

    if (Sx.size() != Sy.size()) {
        throw (SKIZIOException("Lengths of Sx and Sy vectors not identical!"));
    }

    RealVec StartSx;
    RealVec StartSy;
    RealVec StartSk;


    for (auto i = 0; i < 5; ++i) {
        StartSx.push_back(Sx.at(i));
        StartSy.push_back(Sy.at(i));
        StartSk.push_back(i + 1);
    }

    std::map<real, RealVec> Nk;
    Nk[1] = {5, 3, 4};
    Nk[2] = {5, 4};
    Nk[3] = {5, 4, 1};
    Nk[4] = {5, 3, 2, 1};
    Nk[5] = {3, 4, 2, 1};

    vd VD(nr, nc);
    VD.setLam(lam);
    VD.setV(v);
    VD.setPx(px);
    VD.setPy(py);
    VD.setSx(StartSx);
    VD.setSy(StartSy);
    VD.setSk(StartSk);
    VD.setK(5);
    VD.setNk(Nk);

    loadStruct result = loadStruct(nr, nc);
    result.Sx = Sx;
    result.Sy = Sy;
    result.VD = VD;

    return result;
}