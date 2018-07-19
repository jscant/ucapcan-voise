/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m matlab script.
 * Uses one of six metrics (mean, median, standard deviation, range, normalised range, number of pixels) to
 * evaluate the merit function of a Voronoi region.
 */

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <eigen3/Eigen/Dense>

#include "../vd.h"
#include "../getRegion.h"
#include "../typedefs.cpp"
#include "grabVD.h"
#include "grabW.h"

/**
 * @defgroup getCentroidSeedBatch getCentroidSeedBatch
 * @ingroup getCentroidSeedBatch
 * @brief Finds the centre of mass of VR. Used in regularisation phase of VOISE [1] eq. 15.
 *
 * This is a MEX function. As such, the inputs and outputs are constricted to the following:
 *
 * nlhs: Number of outputs
 *
 * plhs: Pointer to outputs
 *
 * nrhs: Number of inputs
 *
 * prhs: Pointer to inputs
 *
 * In Matlab, this corresponds to the following parameters and outputs:
 * @param VD Voronoi diagram struct
 * @param W Matrix of pixel values
 * @param metricID Key from 1-6 indicating which metric to use: (1) Median (2) Mean (3) Range (4) Square root of the
 * number of pixels (5) Normalised range (6) Standard deviation
 * @param mult (For metricID = 5 and 6 only) Multiplier of each pixel. For metricID = 5, coefficient is 1/mult. For
 * metricID = 6, coefficient is equal to mult.
 * @returns Sop Vector of metric value for each Voronoi region
 * @returns Wop Matrix of metric values for each pixel. All pixels in same voronoi region have same Wop value. Pixels
 * equidistant from two or more closest seeds (with \f$ \nu_{ij} \f$ = 1) have Wop\f$_{ij} \f$ = NaN, as per the Matlab
 * implementation.
 */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]) {

    // Get inputs
    vd VD = grabVD(prhs, 0);
    Mat W = grabW(prhs, 1).abs();
    real *seed = mxGetDoubles(prhs[2]);
    uint32 ns = mxGetN(prhs[2]);

    // Create space in memory for ns x 2 coordinates (results)
    plhs[0] = mxCreateDoubleMatrix(ns, 2, mxREAL);
    real *centroidPtr = mxGetDoubles(plhs[0]);

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
            centroidPtr[sIdx] = round(x / pixels);
            centroidPtr[sIdx + ns] = round(y / pixels);
        } else { // Populate results matrix with COM coordinates
            centroidPtr[sIdx] = round(x / totalW);
            centroidPtr[sIdx + ns] = round(y / totalW);
        }
    }


}