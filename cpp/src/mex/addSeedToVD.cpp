/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m
 * matlab script. Adds single seeds to Voronoi diagram.
 */
#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <eigen3/Eigen/Dense>
#include <map>

#include "../vd.h"
#include "../addSeed.h"
#include "../skizException.h"
#include "grabVD.h"
#include "pushVD.h"

/**
* @defgroup addSeedToVD addSeedToVD
* @brief Adds single seed to Voronoi diagram.
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
* @param s 2 x 1 array containing x and y coordinates of seed to be added
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

    // Get new seed information
    real *Sdoub = mxGetDoubles(prhs[1]);
    real s1 = Sdoub[0], s2 = Sdoub[1];

    // Grab VD data from ML struct
    vd outputVD = grabVD(prhs, 0);

    // Add seed to VD
    try {
        addSeed(outputVD, s1, s2);
    } catch (SKIZException &e) {
        mexErrMsgTxt(e.what());
    }

    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);

}
