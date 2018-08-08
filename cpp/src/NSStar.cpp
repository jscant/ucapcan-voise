/**
 * @file
 * @brief Finds neighbouring Voronoi regions for new seeds
*/
#include <map>

#include "NSStar.h"
#include "pointInRegion.h"
#include "skizException.h"
#include "aux-functions/inVector.h"
#include "aux-functions/circumcentre.h"
#include "aux-functions/proposition2.h"

/**
 * @defgroup nsStar nsStar
 * @ingroup nsStar
 * @brief Finds neighbouring Voronoi regions for new seed
 * @param VD Voronoi diagram
 * @returns Vector of the IDs of seeds with Voronoi regions bordering the Voronoi region of the seed last added to the
 * Voronoi diagram
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
    bool onlyNeighbour = VD.getNkByIdx(lam).size() == 1;

    // First pass starts from lambda going one way around perimeter, second goes other way around
    real unboundedEdges = 0;
    while (unboundedEdges < 2) {

        RealVec candidates; // Storage in case x' is not unique (from [1])

        // Used in case of cocircular seeds
        std::array<real, 2> ccOG = { -1, -1 };
        std::array<real, 2> cc = { -1, -1 };
        bool ccOGExists = false;

        // Choose which of the neighbours of last seed added to N(s*) to add next
        for (real nIdx = unboundedEdges; nIdx < VD.getNkByIdx(lam).size();
                ++nIdx) {
            const real r = VD.getNkByIdx(lam)[nIdx];
            if (inVector(Ns, r)) { // Don't add same seed multiple times
                continue;
            }

            // Coordinates of seed in question
            const real r1 = VD.getSxByIdx(r);
            const real r2 = VD.getSyByIdx(r);

            try {
                cc = circumcentre(r1, r2, s1, s2, VD.getSxByIdx(lam),
                        VD.getSyByIdx(lam));
            } catch (SKIZLinearSeedsException &e) {
                continue; // Linear seeds mean this is not a neighbour
            }

            // Check if seed could be in N(s*)
            if (pointInRegion(VD, cc, lam, VD.getNkByIdx(r))) {
                if (r == lamOG) { // Region is bounded and we are finished
                    return Ns;
                }

                /*
                 * If there are no candidates, initialise conditions for
                 * checking subsequent candidates
                 */
                if(!ccOGExists){
                    ccOGExists = true;
                    ccOG = cc;
                    candidates.push_back(r);
                } else if(fabs(ccOG[0] - cc[0]) < 1e-6 &&
                       fabs(ccOG[1] - cc[1]) < 1e-6){

                    /*
                     * Seed is not unique, and seeds are cocircular. We must
                     * use Proposition 2 from [1]
                     */
                    candidates.push_back(r);
                }
                unboundedEdges = 0;
            }
        }

        /*
            Usually, candidates has 1 element. In this case, proposition2
            just returns that element. If not, it uses Proposition 2 from
            [1] to determine which one should be in neighbour list. If there
            are no candidates to add to N(s*), either return Ns if this is
            our second pass or start again from lambda and go around the
            perimeter of R(s*) in the other direction.
        */
        if(candidates.size() > 0){
            uint32 winningSeed = proposition2(VD, lam, candidates, cc);
            lam = winningSeed;
            Ns.push_back(winningSeed);
        } else {
            if (onlyNeighbour || unboundedEdges > 0) {
                return Ns;
            }
            unboundedEdges += 1;
            lam = lamOG;
        }
    }

    // If we are here, something has gone seriously wrong.
    throw SKIZException("Failure of nsStar to find all neighbours");
}