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
#include "../../typedefs.h"
#include "../../aux-functions/readSeeds.h"
#include "../../aux-functions/readMatrix.h"

/**
 * @brief Loads VD from text files saved using Matlab's save command.
 * @param basePath Directory containing text files to load
 * @param seedsFname Name of text file containing seed coordinates (space
 * delimited)
 * @param lambdaFname  Name of text file containing \f$\lambda\f$ matrix (space
 * delimited)
 * @param vFname Name of text file containing \f$\nu\f$ matrix (space
 * delimited)
 * @return loadStruct containing initial VD and vectors of seed coordinates
 * Sx and Sy
 */
loadStruct loadVD(std::string basePath, std::string seedsFname, std::string lambdaFname, std::string vFname){

    // Load seeds
    std::vector<RealVec> seeds = readSeeds(basePath + seedsFname);

    // Load matrices
    Mat lam = readMatrix(basePath + lambdaFname);
    Mat v = readMatrix(basePath + vFname);

    // Determine dimensions
    unsigned long nr = lam.rows();
    unsigned long nc = lam.cols();

    // Create px, py
    Mat px(nr, nc);
    Mat py(nr, nc);
    for (unsigned long i = 0; i < nr; ++i) {
        for (unsigned long j = 0; j < nc; ++j) {
            px(i, j) = j;
            py(i, j) = i;
        }
    }

    // Load Sx and Sy from seeds lists
    RealVec Sx = seeds.at(0);
    RealVec Sy = seeds.at(1);
    if (Sx.size() != Sy.size()) {
        throw (SKIZIOException("Lengths of Sx and Sy vectors not identical!"));
    }

    // Instantiate VD
    vd VD(nr, nc);

    // Populate VD with 2 seeds
    for (auto i = 0; i < 2; ++i) {
        VD.addSx(Sx.at(i));
        VD.addSy(Sy.at(i));
        VD.addSk(i + 1);
    }

    // Neighbour relationships
    std::map<real, RealVec> Nk;
    Nk[1] = {2};
    Nk[2] = {1};

    // Set other VD fields
    VD.setLam(lam);
    VD.setV(v);
    VD.setPx(px);
    VD.setPy(py);
    VD.setK(2);
    VD.setNk(Nk);

    // Populate result struct
    loadStruct result = loadStruct(nr, nc);
    result.Sx = Sx;
    result.Sy = Sy;
    result.VD = VD;

    return result;
}