/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m matlab script.
 * Finds the pixel-intensity weighted centre of mass for all VRs in a VD.
 */

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <eigen3/Eigen/Dense>

#include "../vd.h"
#include "../getRegion.h"
#include "../typedefs.cpp"
#include "../getCentroid.h"
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
@@@@@@@@@@@@@@@@@@@@@@@@@@ DO THIS @@@@@@@@@@@@@@@@@@@@@@@@@@@
 */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]) {

    // Get inputs
    vd VD = grabVD(prhs, 0);
    Mat W = grabW(prhs, 1).abs();
    real *seed = mxGetDoubles(prhs[2]);
    uint32 ns = mxGetN(prhs[2]);
    Mat resultCoords = getCentroid(VD, W, seed, ns);

    // Create space in memory for ns x 2 coordinates (results)
    plhs[0] = mxCreateDoubleMatrix(ns, 2, mxREAL);
    real *centroidPtr = mxGetDoubles(plhs[0]);

    Eigen::Map<Mat>(centroidPtr, ns, 2) = resultCoords;

}