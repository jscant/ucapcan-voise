/**
 * @file
 * @brief Finds neighbouring Voronoi regions for new seeds
*/
#include <map>

#include "NSStar.h"
#include "aux.h"
#include "pointInRegion.h"
#include "skizException.h"

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
    const real s1 = VD.Sx.at(VD.k);
    const real s2 = VD.Sy.at(VD.k);

    real lam = VD.Vk.lam(s2 - 1, s1 - 1);
    const real lamOG = lam;
    RealVec Ns = {lam};
    bool onlyNeighbour = false;

    if (VD.Nk.at(lam).size() == 1) {
        onlyNeighbour = true;
    }

    real n = 0;
    while (true) {
        real NsLen = Ns.size();

        for (real nIdx = n; nIdx < VD.Nk.at(lam).size(); ++nIdx) {
            const real r = VD.Nk.at(lam)[nIdx];
            if (inVector(Ns, r)) {
                continue;
            }

            const real r1 = VD.Sx.at(r);
            const real r2 = VD.Sy.at(r);

            std::array<real, 2> cc;
            try {
                cc = circumcentre(r1, r2, s1, s2, VD.Sx.at(lam), VD.Sy.at(lam));
            } catch (SKIZLinearSeedsException &e) {
                continue;
            }

            bool pir = pointInRegion(VD, cc, lam, VD.Nk.at(lam));

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