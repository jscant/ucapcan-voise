#include "getCentroid.h"
#include "getRegion.h"

Mat getCentroid(const vd &VD, const Mat &W, const real* seed, const uint32 ns){

    Mat resultCoords(ns, 2);

    // For each seed
    for (uint32 sIdx = 0; sIdx < ns; ++sIdx) {
        real x = 0;
        real y = 0;
        real totalW = 0;
        real s = seed[sIdx];
        Mat bounds = getRegion(VD, s); // Find pixels in R(s)
        bool finish = false;
        for (int j = 0; j < bounds.rows(); ++j) {
            if (bounds(j, 0) == -1) {
                if (finish) {
                    break; // R(s) convex so we are done
                } else {
                    continue; // We have not yet reached a row with pixels in R(s)
                }
            }
            finish = true;
            uint32 lb = std::max(0.0, bounds(j, 0) - 1);
            uint32 ub = std::min(VD.getNc(), bounds(j, 1));

            // Pixel intensity-weighted centre of mass (eq. 15 of VOISE paper [1])
            for (uint32 i = lb; i < ub; ++i) {
                y += (j + 1) * W(j, i); // Matlab indexing begins at 1
                x += (i + 1) * W(j, i);
                totalW += W(j, i);
            }
        }

        // Degenerate case of 0 intensity for all pixels
        if (totalW == 0) {
            finish = false;
            real pixels = 0;
            for (int j = 0; j < bounds.rows(); ++j) {
                if (bounds(j, 0) == -1) {
                    if (finish) {
                        break; // R(s) convex so we are done
                    } else {
                        continue; // We have not yet reached a row with pixels in R(s)
                    }
                }
                finish = true;
                real lb = std::max(0.0, bounds(j, 0) - 1);
                real ub = std::min(VD.getNc(), bounds(j, 1));
                for (uint32 i = lb; i < ub; ++i) {
                    pixels += 1;
                    y += (j + 1);
                    x += (i + 1);
                }
            }

            //centroidPtr[sIdx] = round(x / pixels);
            //centroidPtr[sIdx + ns] = round(y / pixels);
            resultCoords(sIdx, 0) = round(x / pixels);
            resultCoords(sIdx, 1) = round(y / pixels);
        } else { // Populate results matrix with COM coordinates
            //centroidPtr[sIdx] = round(x / totalW);
            //centroidPtr[sIdx + ns] = round(y / totalW);
            resultCoords(sIdx, 0) = round(x / totalW);
            resultCoords(sIdx, 1) = round(y / totalW);
        }
    }

    return resultCoords;

}