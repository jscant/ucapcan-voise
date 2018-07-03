/**
 * @file
 * @brief Gets params.W matrix from VD Matlab struct.
 */
#include "grabW.h"

Mat grabW(const mxArray *prhs[], const uint32 field){

    real *wPtr = mxGetDoubles(prhs[field]);
    uint32 nRows = mxGetM(prhs[field]);
    uint32 nCols = mxGetN(prhs[field]);

    Mat W(nRows, nCols);
    W = Eigen::Map<Mat>(wPtr, nRows, nCols);

    return W;

}