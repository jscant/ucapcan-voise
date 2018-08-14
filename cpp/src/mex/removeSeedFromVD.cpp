/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m
 * Matlab script. Removes single seed from Voronoi diagram.
 *
 * @date Created 06/07/18
 * @author Jack Scantlebury
 */

#include "mexIncludes.h"

/**
* @defgroup removeSeedFromVD removeSeedFromVD
* @brief Removes single seed from Voronoi diagram.
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
* @param s ID of seed to remove
* @returns void
*/
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

    // Input checks
    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
            " Invalid number of input and output arguments");
        return;
    }

    real S = mxGetScalar(prhs[1]);

    // Grab VD data from ML struct
    vd outputVD = grabVD(prhs, 0);

    // Add seed to VD
    try {
        removeSeed(outputVD, S);
    } catch (SKIZException &e) {
        mexErrMsgTxt(e.what());
    }

    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);

}



