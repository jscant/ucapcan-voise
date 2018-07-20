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

loadStruct loadVD(std::string basePath, std::string seedsFname, std::string lambdaFname, std::string vFname){

    std::vector<RealVec> seeds = readSeeds(basePath + seedsFname);
    Mat lam = readMatrix(basePath + lambdaFname);
    Mat v = readMatrix(basePath + vFname);
    unsigned long nr = lam.rows();
    unsigned long nc = lam.cols();
    Mat px(nr, nc);
    Mat py(nr, nc);

    for (unsigned long i = 0; i < nr; ++i) {
        for (unsigned long j = 0; j < nc; ++j) {
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

    for (auto i = 0; i < 2; ++i) {
        StartSx.push_back(Sx.at(i));
        StartSy.push_back(Sy.at(i));
        StartSk.push_back(i + 1);
    }

    std::map<real, RealVec> Nk;
    Nk[1] = {2};
    Nk[2] = {1};

    vd VD(nr, nc);
    VD.setLam(lam);
    VD.setV(v);
    VD.setPx(px);
    VD.setPy(py);
    VD.setSx(StartSx);
    VD.setSy(StartSy);
    VD.setSk(StartSk);
    VD.setK(2);
    VD.setNk(Nk);

    loadStruct result = loadStruct(nr, nc);
    result.Sx = Sx;
    result.Sy = Sy;
    result.VD = VD;

    return result;
}