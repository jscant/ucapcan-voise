/**
 * @file
 * @brief Takes a vector of values with which to populate each VR with for
 * displaying clustering results.
 */

#include "mexIncludes.h"
#include <iostream>

/**
* @defgroup stopToWop stopToWop
* @ingroup stopToWop
* @brief Generates a tiled image W where tiles are filled with a given vector
* of values
*
* This is a MEX function. As such, the inputs and outputs are constricted to
* the following:
*
* - nlhs: Number of outputs
*
* - plhs: Pointer to outputs
*
* - nrhs: Number of inputs
*
* - prhs: Pointer to inputs
*
* In Matlab, this corresponds to the following parameters and outputs:
* @param VD Voronoi diagram struct
* @param Sop Vector of median intensities for active seeds
* @returns void
*/
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]) {

    // Input checks
    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
                " Invalid number of input and output arguments");
        return;
    }

    real *sopReals = mxGetDoubles(prhs[1]);
    vd VD = grabVD(prhs, 0);

    Mat Wop(VD.getNr(), VD.getNc());

    // Average for each VR is independent (embarrassingly parallel)
    //#pragma omp parallel for
    for (uint32 f = 0; f < VD.getSk().size(); ++f) {
        real s = VD.getSk().at(f);
        bool finish = false;
        real val = sopReals[f];
        Mat bounds = getRegion(VD, s); // Get upper and lower bounds
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
            real ub = std::min((real) VD.getNc(), bounds(j, 1));
            for (real i = lb; i < ub; ++i) {
                if (!VD.getVByIdx(j, i)) {
                    Wop(j, i) = val; // All pixels in VR populated with avg
                } else {
                    #ifdef MATLAB_MEX_FILE // Running MEX compiler or normal?
                        Wop(j, i) = mxGetNaN(); // For consistency with Matlab
                    #else
                        Wop(j, i) = -INF; // For use in unit testing where mxGetNaN is invalid
                    #endif
                }
            }
        }
    }

    // Populate output mxArrays with results
    plhs[0] = mxCreateDoubleMatrix(Wop.rows(), Wop.cols(), mxREAL);
    real *wopPtr = mxGetDoubles(plhs[0]);
    Eigen::Map<Mat>(wopPtr, Wop.rows(), Wop.cols()) = Wop; // Map directly is fast

}