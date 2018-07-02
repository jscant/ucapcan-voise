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

/**
 * @defgroup nsStar nsStar
 * @ingroup nsStar
 * @brief Finds neighbouring Voronoi regions for new seeds
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
    
    real lam = VD.getLamByIdx(s2 - 1, s1 - 1);
    const real lamOG = lam;
    RealVec Ns = {lam};
    bool onlyNeighbour = VD.getNkByIdx(lam).size() == 1 ? true : false;

    real n = 0;
    while (true) {
        real NsLen = Ns.size();

        for (real nIdx = n; nIdx < VD.getNkByIdx(lam).size(); ++nIdx) {
            const real r = VD.getNkByIdx(lam)[nIdx];
            if (inVector(Ns, r)) {
                continue;
            }

            const real r1 = VD.getSxByIdx(r);
            const real r2 = VD.getSyByIdx(r);

            std::array<real, 2> cc;
            try {
                cc = circumcentre(r1, r2, s1, s2, VD.getSxByIdx(lam), VD.getSyByIdx(lam));
            } catch (SKIZLinearSeedsException &e) {
                continue;
            }

            bool pir = pointInRegion(VD, cc, lam, VD.getNkByIdx(lam));

            if (pir) {
                if (r == lamOG) { // region is bounded!
                    return Ns;
                }
                lam = r;
                Ns.push_back(r);
                n = 0;
                break;
            }

        }
        if (NsLen == Ns.size()) {
            if (onlyNeighbour || n > 0) {
                return Ns;
            }
            n += 1;
            lam = lamOG;
        }
    }
    return Ns;
}