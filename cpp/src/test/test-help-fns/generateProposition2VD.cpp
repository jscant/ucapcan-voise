/**
 * @file
 * @brief Generates a regular grid of seeds on a VD for checking seed
 * addition under degenerate (cocircular) seed conditions.
 */

#include "generateProposition2VD.h"
#include "../../skizException.h"
#include "../../aux-functions/sqDist.h"
#include <iostream>
#include "../../aux-functions/inVector.h"

/**
 * @defGroup generateProposition2VD generateProposition2VD
 * @ingroup generateProposition2VD
 *
 * @brief Generates a regular grid of seeds on a VD for checking seed
 * addition under degenerate (cocircular) seed conditions.
 * @param dim Dimention of (square) VD grid
 * @return Struct containing initial VD and a list of seeds to add
 */
loadStruct generateProposition2VD(uint32 dim) {

    // Initialise matrices and seed lists
    Mat lam = Mat::Zero(dim, dim);
    Mat v = Mat::Zero(dim, dim);
    RealVec Sx;
    RealVec Sy;

    // Initial seeds (top left and bottom right corner, Matlab indexing)
    Sx.push_back(1);
    Sx.push_back(dim);
    Sy.push_back(1);
    Sy.push_back(dim);

    // Set lambda and v values for initial configuration
    for (uint32 i = 0; i < dim; ++i) {
        for (uint32 j = 0; j < dim; ++j) {
            real minDist = sqDist(Sx.at(0) - 1, Sy.at(0) - 1, i, j);
            lam(j, i) = 1;
            for (uint32 k = 1; k < Sx.size(); ++k) {
                real dist = sqDist(Sx.at(k) - 1, Sy.at(k) - 1, i, j);
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

    // Initial neighbour relationships
    std::map<real, RealVec> Nk;
    Nk[1] = {2};
    Nk[2] = {1};

    // Active seeds
    RealVec Sk;
    for(unsigned long i = 0; i < Sx.size(); ++i){
        Sk.push_back(i + 1);
    }

    // Populate VD
    vd VD(dim, dim);
    VD.setV(v);
    VD.setLam(lam);
    VD.setK(Sx.size());
    VD.setSx(Sx);
    VD.setSy(Sy);
    VD.setSk(Sk);
    VD.setNk(Nk);

    Sx = {};
    Sy = {};

    // Generate regular grid, add seeds to Sx and Sy
    uint32 spacing = 6;
    for(unsigned long i = 0; i < dim / spacing; ++i){
        auto ipt = i * spacing + 1;
        for(unsigned long j = 0; j < dim / spacing; ++j){
            auto jpt = j * spacing + 1;
            if(!((jpt == 1 && ipt == 1) || (jpt == dim && ipt == dim))){
                Sx.push_back(ipt);
                Sy.push_back(jpt);
            }
        }
    }

    // Create and return struct with VD and Sx, Sy
    loadStruct ls(dim, dim);
    ls.VD = VD;
    ls.Sx = Sx;
    ls.Sy = Sy;

    return ls;
}