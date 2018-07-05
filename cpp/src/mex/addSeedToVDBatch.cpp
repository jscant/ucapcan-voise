/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m matlab script.
 * Adds multiple seeds to Voronoi diagram.
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
* @defgroup addSeedToVDBatch addSeedToVDBatch
* @brief Adds multiple seeds to Voronoi diagram. This is a MEX function, and as such the inputs and outputs are
* constricted to the following:
* @param nlhs Number of outputs
* @param plhs Pointer to outputs
* @param nrhs Number of inputs
* @param prhs Pointer to inputs
*
* In Matlab, this corresponds to the following parameters and outputs:
* @param VD Voronoi diagram struct
* @param Sk n x 2 array of x and y coordinates of seeds to be added
* @returns void
*/
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

    // Sanity checks on inputs
    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
                " Invalid number of input and output arguments");
        return;
    }

    bool timing = false;

    // Get new seed information
    real *Sdoub = mxGetDoubles(prhs[1]);
    int nRows = mxGetM(prhs[1]);
    if (nRows == 2){
        if (mxGetN(prhs[1]) != 2){
            nRows = mxGetN(prhs[1]); // Able to take n x 2 or 2 x n, but for 2 x 2 we 'guess' that rows are seeds
        }
    }

    // Grab VD data from ML struct
    vd outputVD = grabVD(prhs, 0);

    // Add seed to VD
    for(int i=0; i<nRows; ++i) {
        real s1 = Sdoub[i];
        real s2 = Sdoub[i+nRows];
        try {
            addSeed(outputVD, s1, s2);
        } catch (SKIZException &e) {
            mexErrMsgTxt(e.what());
        }
    }

    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);

}
