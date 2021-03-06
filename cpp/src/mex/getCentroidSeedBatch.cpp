/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m
 * Matlab script. Finds the pixel-intensity weighted centre of mass for all VRs
 * in a VD.
 *
 * @date Created 08/07/18
 * @author Jack Scantlebury
 */

#include "mexIncludes.h"

/**
 * @defgroup getCentroidSeedBatch getCentroidSeedBatch
 * @ingroup getCentroidSeedBatch
 * @brief Finds the centre of mass of VR. Used in regularisation phase of VOISE
 * [1] eq. 15:
 *
 * Centre of mass is equal to:
 * \f[
 *   \xi(s) = \frac{\sum_{\textbf{p} \in R(s)} \textbf{p} \rho(\textbf{p})}{
 *   \sum_{\textbf{p} \in R(s)} \rho(\textbf{p})}
 * \f]
 *
 * where the density function \f$\rho\f$ at pixel position \f$\textbf{p}\f$ is
 * the pixel intensity. This function is used in the regularisation phase of
 * VOISE. This is done via the getCentroid function; this is a MEX interface
 * function.
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
 * @param vd Voronoi diagram struct
 * @param W Matrix of pixel intensities
 * @param seeds Vector of seed IDs for which centres of mass (of the
 * corresponding VRs) are to be found
 * @returns Matrix of coordinates of centres of mass of each Voronoi region
 */
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]) {

    // Input checks
    if (nlhs != 1 || nrhs != 3) {
        mexErrMsgTxt(
                " Invalid number of input and output arguments");
        return;
    }

    // Get inputs
    vd VD = grabVD(prhs, 0);
    Mat W = grabW(prhs, 1);
    real *seed = mxGetDoubles(prhs[2]);

    /*
     * This does not affect results but avoids complications due to negative
     * pixel values
     */
    W -= W.minCoeff();

    // Number of seeds = length of matrix
    uint32 ns = std::max(mxGetN(prhs[2]), mxGetM(prhs[2]));
    RealVec seedVec(seed, seed + ns);

    // Find centres of mass
    Mat resultCoords = getCentroid(VD, W, seedVec);

    // Create space in memory for ns x 2 coordinates (results)
    plhs[0] = mxCreateDoubleMatrix(ns, 2, mxREAL);
    real *centroidPtr = mxGetDoubles(plhs[0]);

    // Map results into allocated Matlab memory
    Eigen::Map<Mat>(centroidPtr, ns, 2) = resultCoords;

}