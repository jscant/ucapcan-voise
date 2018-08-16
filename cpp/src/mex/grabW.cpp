/**
 * @file
 * @brief This is a requirement for a MEX function. It should only be compiled
 * by the compileMEX.m Matlab script. Gets params.W matrix from VD Matlab struct.
 */

#include "mexIncludes.h"

/**
 * @defgroup grabW grabW
 * @ingroup grabW
 *
 * @brief Takes matrix from Matlab and puts it in Eigen::Array<real>
 *
 * This is used in getVDOp.cpp to get params.W from the VD Matlab struct.
 *
 * @param prhs mxArray* which points to the start of the Matlab data
 * @param field Which Matlab argument to grab
 * @return Eigen::Array<real> with data from matrix
 */
Mat grabW(const mxArray *prhs[], const uint32 field){

    // Pointer to start of W matrix
    real *wPtr = mxGetDoubles(prhs[field]);

    // Get rows and cols information
    uint32 nRows = mxGetM(prhs[field]);
    uint32 nCols = mxGetN(prhs[field]);

    // Create W and map ML data to Eigen::Array
    Mat W(nRows, nCols);
    W = Eigen::Map<Mat>(wPtr, nRows, nCols);

    return W;

}