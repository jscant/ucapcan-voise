/**
 * @file
 * @brief Finds neighbouring Voronoi regions for new seeds
*/
#include <map>
#include <iostream>

#include "NSStar.h"
#include "pointInRegion.h"
#include "skizException.h"
#include "aux-functions/inVector.h"
#include "aux-functions/circumcentre.h"
#include "aux-functions/proposition2.h"
#include "aux-functions/arrayPosInVector.h"

/**
 * @defgroup nsStar nsStar
 * @ingroup nsStar
 * @brief Finds neighbouring Voronoi regions for new seed
 * @param VD Voronoi diagram
 * @returns Vector of the IDs of seeds with Voronoi regions bordering the
 * Voronoi region of the seed last added to the Voronoi diagram
 *
 * Method used is taken from "Discrete Voronoi Diagrams and the SKIZ
    Operator: A Dynamic Algorithm" [1], Section 3.1
*/
RealVec nsStar(const vd &VD) {
    const real s1 = VD.getSxByIdx(VD.getK());
    const real s2 = VD.getSyByIdx(VD.getK());

    real lam = VD.getLamByIdx(s2 - 1, s1 - 1); // Matlab-C++ array index offset
    const real lamOG = lam; // Closest seed to new seed, stored for later
    RealVec Ns = {lam}; // Initialise new neighbour list for s*

    RealVec startingSeeds;
    RealVec candidateStartingSeeds;
    RealVec ccIdx;
    std::vector<std::array<real, 2>> ccVec;

    /*
     * To begin, we look r in N(lambda). There will be either 1 or 2 points x'
     * such that x' = X(r, s*, lambda) lies in C(lambda, N(r)). These are the
     * starting points for building up N(s*); if there are 2 x', we must first
     * build up by going one way around the new region, then by restarting but
     * going the other way around.
     * If more than 1 neighbour of lambda make a circumcentre at x', we have 4
     * (or more) cocircular seeds. In this case, we use proposition 2 to pick
     * the seed in N(lambda) which we start off by using.
     */

    // Build a record of x' from [1]
    for (auto r : VD.getNkByIdx(lam)){
        std::array<real, 2> cc;
        const real r1 = VD.getSxByIdx(r);
        const real r2 = VD.getSyByIdx(r);

        try {
            cc = circumcentre(r1, r2, s1, s2, VD.getSxByIdx(lam),
                              VD.getSyByIdx(lam));
        } catch (SKIZLinearSeedsException &e) {
            continue; // Linear seeds mean this is not a neighbour
        }

        // Check if seed could be in N(s*)
        if (pointInRegion(VD, cc, r, VD.getNkByIdx(lam))) {
            real arrPos = arrayPosInVector(ccVec, cc);
            candidateStartingSeeds.push_back(r);
            if (arrPos == -1){
                ccVec.push_back(cc);
                ccIdx.push_back(ccVec.size() - 1);
            } else {
                ccIdx.push_back(arrPos);
            }
        }
    }

    // Sets of seeds with x' as the circumcentres
    RealVec set1;
    RealVec set2;

    // Build up lists of seeds with same circumcentre (for use with prop. 2)
    for (uint32 i = 0; i < ccIdx.size(); ++i){
        auto idx = ccIdx.at(i);
        if(idx == 0){
            set1.push_back(candidateStartingSeeds.at(i));
        } else {
            set2.push_back(candidateStartingSeeds.at(i));
        }
    }

    // Use prop. 2 to decide among seeds
    startingSeeds.push_back(proposition2(VD, lam, set1, ccVec[0]));

    // If there is more than 1 x', we need more than 1 starting seed
    if (set2.size() > 0){
        try {
            startingSeeds.push_back(proposition2(VD, lam, set2, ccVec[1]));
        } catch (SKIZProposition2Exception &e){
            std::cerr << e.what();
            exit(1);
        }
    }

    real unboundedEdges = 0;
    lam = startingSeeds.at(0);

    // Add relevant neighbours of lambda to N(s*)
    for(auto i : startingSeeds){
        Ns.push_back(i);
    }

    // Now build up N(s*)
    while (unboundedEdges < startingSeeds.size()) {

        bool noneFound = true; // Keep track of if we have found a seed to add

        // Reset vectors for later use
        ccIdx = {};
        ccVec = {};
        candidateStartingSeeds = {};


        for (auto r : VD.getNkByIdx(lam)) {
            if (inVector(Ns, r)) { // Don't add same seed multiple times
                continue;
            }

            // Coordinates of seed in question
            const real r1 = VD.getSxByIdx(r);
            const real r2 = VD.getSyByIdx(r);

            std::array<real, 2> cc = { -1, -1 };

            try {
                cc = circumcentre(r1, r2, s1, s2, VD.getSxByIdx(lam),
                        VD.getSyByIdx(lam));
            } catch (SKIZLinearSeedsException &e) {
                continue; // Linear seeds mean this is not a neighbour
            }

            // Check if seed could be in N(s*)
            if (pointInRegion(VD, cc, r, VD.getNkByIdx(lam))) {

                if (r == lamOG) { // Region is bounded and we are finished
                    return Ns;
                }
                Ns.push_back(r);
                lam = r;
                noneFound = false;
                break;
            }
        }

        /* If no seeds to be added, we are done if we have exhausted the
         * startingSeeds vector. Otherwise, we go the other way around the
         * perimeter of R(s*), starting with the other seed in startingSeeds.
         */
        if (noneFound){
            unboundedEdges += 1;
            try {
                lam = startingSeeds.at(unboundedEdges);
            } catch (std::out_of_range &e){
                return Ns;
            }
        }
    }

    // We are done
    return Ns;
}