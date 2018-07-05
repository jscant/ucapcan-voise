/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m matlab script.
 * Removes single seed from Voronoi diagram.
 */
#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include "../vd.h"
#include "../removeSeed.h"
#include "../skizException.h"
#include "grabVD.h"
#include "pushVD.h"

/**
* @defgroup removeSeedFromVD removeSeedFromVD
* @brief Removes single seed from Voronoi diagram. This is a MEX function, and as such the inputs and outputs are
* constricted to the following:
* @param nlhs Number of outputs
* @param plhs Pointer to outputs
* @param nrhs Number of inputs
* @param prhs Pointer to inputs
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



