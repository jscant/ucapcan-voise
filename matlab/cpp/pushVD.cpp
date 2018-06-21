//
// Created by root on 21/06/18.
//

#include "pushVD.h"

//
// Created by root on 21/06/18.
//

#include "grabVD.h"

#ifndef MEX_H
#define MEX_H
#include "/usr/local/MATLAB/R2018a/extern/include/mex.h"
#endif

#ifndef MATRIX_H
#define MATRIX_H
#include "/usr/local/MATLAB/R2018a/extern/include/matrix.h"
#endif

#ifndef EIGEN_DENSE_H
#define EIGEN_DENSE_H
#include "eigen/Eigen/Dense"
#endif

#ifndef STRING_H
#define STRING_H
#include <string>
#endif

#ifndef AUX_H
#define AUX_H
#include "aux.h"
#endif

#ifndef SKIZEXCEPTION_H
#define SKIZEXCEPTION_H
#include "skizException.h"
#endif

#ifndef MAP_H
#define MAP_H
#include <map>
#endif

#ifndef MAT
#define MAT
typedef Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

void pushVD(vd outputVD, mxArray *plhs[]){
    // Output arrays
    mxArray *nrOutgoingArray, *ncOutgoingArray, *wOutgoingArray,
            *sOutgoingArray, *xOutgoingArray, *yOutgoingArray,
            *nkOutgoingArray, *kOutgoingArray, *skOutgoingArray,
            *sxOutgoingArray, *syOutgoingArray, *vkOutgoingArray,
            *vOutgoingArray, *lamOutgoingArray, *wxmOutgoingArray,
            *wxMOutgoingArray, *wymOutgoingArray, *wyMOutgoingArray,
            *sxmOutgoingArray, *sxMOutgoingArray, *symOutgoingArray,
            *syMOutgoingArray;

    // Field names for ML struct
    const char *vdFnames[] = {"nr", "nc", "W", "S", "x", "y", "Nk", "k", "Sk", "Sx", "Sy", "Vk"};
    const char *vkFnames[] = {"lambda", "v"};
    const char *wFnames[] = {"xm", "xM", "ym", "yM"};

    const mwSize nkDims[2] = {outputVD.Nk.size(), 1};
    mwIndex nCols = outputVD.nc;
    mwIndex nRows = outputVD.nr;

    // Create space in memory for result struct (VD)
    nrOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    ncOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    xOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    yOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    nkOutgoingArray = mxCreateCellArray(1, nkDims);
    kOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    skOutgoingArray = mxCreateDoubleMatrix(outputVD.Sk.size(), 1, mxREAL);
    sxOutgoingArray = mxCreateDoubleMatrix(outputVD.Sx.size(), 1, mxREAL);
    syOutgoingArray = mxCreateDoubleMatrix(outputVD.Sy.size(), 1, mxREAL);
    vOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    lamOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    wxmOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    wxMOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    wymOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    wyMOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    sxmOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    sxMOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    symOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    syMOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);

    vkOutgoingArray = mxCreateStructMatrix(1, 1, 2, vkFnames);
    wOutgoingArray = mxCreateStructMatrix(1, 1, 4, wFnames);
    sOutgoingArray = mxCreateStructMatrix(1, 1, 4, wFnames);

    // Pointers declarations
    double *ncPtr, *nrPtr, *xPtr, *yPtr, *kPtr, *skPtr, *sxPtr,
            *syPtr, *lamPtr, *vPtr, *wxmPtr, *wxMPtr, *wymPtr,
            *wyMPtr, *sxmPtr, *sxMPtr, *symPtr, *syMPtr;

    // Get pointers to relevant mxArrays
    lamPtr = mxGetDoubles(lamOutgoingArray);
    vPtr = mxGetDoubles(vOutgoingArray);
    xPtr = mxGetDoubles(xOutgoingArray);
    yPtr = mxGetDoubles(yOutgoingArray);
    wxmPtr = mxGetDoubles(wxmOutgoingArray);
    wxMPtr = mxGetDoubles(wxMOutgoingArray);
    wymPtr = mxGetDoubles(wymOutgoingArray);
    wyMPtr = mxGetDoubles(wyMOutgoingArray);
    sxmPtr = mxGetDoubles(sxmOutgoingArray);
    sxMPtr = mxGetDoubles(sxMOutgoingArray);
    symPtr = mxGetDoubles(symOutgoingArray);
    syMPtr = mxGetDoubles(syMOutgoingArray);
    ncPtr = mxGetDoubles(ncOutgoingArray);
    nrPtr = mxGetDoubles(nrOutgoingArray);
    skPtr = mxGetDoubles(skOutgoingArray);
    sxPtr = mxGetDoubles(sxOutgoingArray);
    syPtr = mxGetDoubles(syOutgoingArray);
    kPtr = mxGetDoubles(kOutgoingArray);

    // Populate ML struct matrices with results
    for (mwIndex i = 0; i < nRows; ++i) {
        for (mwIndex j = 0; j < nCols; ++j) {
            lamPtr[j * nCols + i] = outputVD.Vk.lam(i, j);
            vPtr[j * nCols + i] = outputVD.Vk.v(i, j);
            xPtr[j * nCols + i] = outputVD.px(i, j) + 1;
            yPtr[j * nCols + i] = outputVD.py(i, j) + 1;
        }
    }

    mwIndex sxLen = outputVD.Sx.size();
    for (mwIndex i = 0; i < sxLen; ++i) {
        sxPtr[i] = outputVD.Sx.at(i + 1);
        syPtr[i] = outputVD.Sy.at(i + 1);
        skPtr[i] = outputVD.Sk.at(i + 1);
    }

    mwIndex nkLen = mxGetNumberOfElements(nkOutgoingArray);
    mxArray *cellPtrs[nkLen];
    for (mwIndex i = 0; i < nkLen; ++i) {
        cellPtrs[i] = mxGetCell(nkOutgoingArray, i);
        mwIndex cellLen = outputVD.Nk.at(i + 1).size();
        mxArray *tmpArr = mxCreateDoubleMatrix(cellLen, 1, mxREAL);
        double *tmpPtr = mxGetDoubles(tmpArr);
        for (mwIndex j = 0; j < cellLen; ++j) {
            tmpPtr[j] = outputVD.Nk.at(i + 1).at(j);
        }
        mxSetFieldByNumber(nkOutgoingArray, 0, i, tmpArr);
    }

    // These are somewhat redundant for addSeed but here for consistency
    wxmPtr[0] = outputVD.W.xm;
    wxMPtr[0] = outputVD.W.xM;
    wymPtr[0] = outputVD.W.ym;
    wyMPtr[0] = outputVD.W.yM;
    sxmPtr[0] = outputVD.S.xm;
    sxMPtr[0] = outputVD.S.xM;
    symPtr[0] = outputVD.S.ym;
    syMPtr[0] = outputVD.S.yM;

    ncPtr[0] = outputVD.nc;
    nrPtr[0] = outputVD.nr;
    kPtr[0] = outputVD.k;

    // Create ML struct with 12 fields
    plhs[0] = mxCreateStructMatrix(1, 1, 12, vdFnames);

    // Repopulate the LHS (ML return value) with mxArrays we have
    // created above
    mxSetField(plhs[0], 0, "Nk", nkOutgoingArray);
    mxSetField(plhs[0], 0, "Vk", vkOutgoingArray);
    mxSetField(plhs[0], 0, "nc", ncOutgoingArray);
    mxSetField(plhs[0], 0, "nr", nrOutgoingArray);
    mxSetField(plhs[0], 0, "W", wOutgoingArray);
    mxSetField(plhs[0], 0, "S", sOutgoingArray);
    mxSetField(plhs[0], 0, "x", xOutgoingArray);
    mxSetField(plhs[0], 0, "y", yOutgoingArray);
    mxSetField(plhs[0], 0, "k", kOutgoingArray);
    mxSetField(plhs[0], 0, "Sk", skOutgoingArray);
    mxSetField(plhs[0], 0, "Sx", sxOutgoingArray);
    mxSetField(plhs[0], 0, "Sy", syOutgoingArray);

    // Populate substructs
    mxSetField(wOutgoingArray, 0, "xm", wxmOutgoingArray);
    mxSetField(wOutgoingArray, 0, "xM", wxMOutgoingArray);
    mxSetField(wOutgoingArray, 0, "ym", wymOutgoingArray);
    mxSetField(wOutgoingArray, 0, "yM", wyMOutgoingArray);

    mxSetField(sOutgoingArray, 0, "xm", sxmOutgoingArray);
    mxSetField(sOutgoingArray, 0, "xM", sxMOutgoingArray);
    mxSetField(sOutgoingArray, 0, "ym", symOutgoingArray);
    mxSetField(sOutgoingArray, 0, "yM", syMOutgoingArray);

    mxSetField(vkOutgoingArray, 0, "v", vOutgoingArray);
    mxSetField(vkOutgoingArray, 0, "lambda", lamOutgoingArray);
}
