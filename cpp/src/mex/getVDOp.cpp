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

#include <omp.h>
#include <eigen3/Eigen/Dense>
#include <map>
#include <functional>
#include <string>

#include "../vd.h"
#include "../skizException.h"
#include "../getRegion.h"
#include "../aux-functions/metrics.h"
#include "grabVD.h"
#include "pushVD.h"
#include "grabW.h"

/**
 * @defgroup getVDOp getVDOp
 * @ingroup getVDOp
 * @brief This is a MEX function, and as such the inputs and outputs are constricted to the following:
 * @param nlhs Number of outputs
 * @param plhs Pointer to outputs
 * @param nrhs Number of inputs
 * @param prhs Pointer to inputs
 *
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

    // Check for valid number of arguments
    if (nrhs != 3 && nrhs != 4) {
        mexErrMsgTxt(
                " Invalid number of input arguments");
        return;
    }

    // Initialise mult = 1 so that if it remains unspecified
    // multiplication has no effect
    real mult = 1;
    vd VD = grabVD(prhs, 0);
    Mat W = grabW(prhs, 1);
    std::function<real(RealVec)> metric;
    real *multiplier;

    // metric will be a different function depending on metricID
    int opChar = (int) mxGetScalar(prhs[2]);
    switch (opChar) {
        case 1 :
            metric = metrics::median;
            break;
        case 2 :
            metric = metrics::mean;
            break;
        case 3 :
            metric = metrics::range;
            break;
        case 4 :
            metric = metrics::sqrtLen;
            break;
        case 5 :
            metric = metrics::range;
            multiplier = mxGetDoubles(prhs[3]);
            mult = 1 / multiplier[0];
            break;
        case 6 :
            metric = metrics::stdDev;
            multiplier = mxGetDoubles(prhs[3]);
            mult = multiplier[0];
            break;
    }

    // Outputs
    Mat Wop(W.rows(), W.cols());
    Mat Sop(VD.getSk().size(), 1);

    // Average for each VR is independent (embarrassingly parallel)
    #pragma omp parallel for
    for (uint32 f = 0; f < VD.getSk().size(); ++f) {
        real s = VD.getSk().at(f);
        Mat bounds = getRegion(VD, s); // Get upper and lower bounds for each row of VR
        bool finish = false;
        real val;
        RealVec pixelValues;

        // Scan for pixels in each row of bounds
        for (int j = 0; j < bounds.rows(); ++j) {
            if (bounds(j, 0) == -1) {
                if (finish) {
                    break; // R(s) convex so we are done
                } else {
                    continue; // We have not yet reached a row with pixels in R(s)
                }
            }
            finish = true; // Region has started, next empty row signals finish
            uint32 lb = std::max(0.0, bounds(j, 0) - 1); // Lower bound of pixels in row of VR
            uint32 ub = std::min(VD.getNc(), bounds(j, 1)); // Upper bound of pixels in row of VR
            for (uint32 i = lb; i < ub; ++i) {
                if (!VD.getVByIdx(j, i)){ // If there is only 1 closest seed to pixel
                    pixelValues.push_back(W(j, i));
                } else if (VD.getLamByIdx(j, i) == s) {
                    Wop(j, i) = mxGetNaN(); // For consistency with Matlab implementation
                }
            }
        }

        val = mult * metric(pixelValues); // Apply average to pixel values of VR
        Sop(f, 0) = val; // Add average to list of averages

        // Now that we know the average, we can set the values of the output matrix
        finish = false;
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
            for (real i = lb; i < ub; ++i) {
                if (!VD.getVByIdx(j, i)){
                    Wop(j, i) = val;
                }
            }
        }
    }

    // Populate output mxArrays with results
    plhs[0] = mxCreateDoubleMatrix(Wop.rows(), Wop.cols(), mxREAL);
    real *wopPtr = mxGetDoubles(plhs[0]);
    Eigen::Map<Mat>(wopPtr, Wop.rows(), Wop.cols()) = Wop; // Map directly is fast
    if (nlhs == 2) {
        plhs[1] = mxCreateDoubleMatrix(Sop.rows(), Sop.cols(), mxREAL);
        real *sopPtr = mxGetDoubles(plhs[1]);
        Eigen::Map<Mat>(sopPtr, Sop.rows(), Sop.cols()) = Sop; // Map directly
    }
}