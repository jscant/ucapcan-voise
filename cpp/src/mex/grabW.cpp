/**
 * @file
 * @brief This is a requirement for a MEX function. It should only be compiled by the compileMEX.m Matlab script. Gets
 * params.W matrix from VD Matlab struct.
 */
#include "grabW.h"

/**
 * @defgroup grabW
 * @brief Takes matrix from matlab and puts it in Eigen::Array<real>
 * @param prhs mxArray* which points to the start of the Matlab data
 * @param field Which Matlab argument to grab
 * @return Eigen::Array<real> with data from matrix
 */
Mat grabW(const mxArray *prhs[], const uint32 field){

    real *wPtr = mxGetDoubles(prhs[field]);
    uint32 nRows = mxGetM(prhs[field]);
    uint32 nCols = mxGetN(prhs[field]);

    Mat W(nRows, nCols);
    W = Eigen::Map<Mat>(wPtr, nRows, nCols);

    return W;

}