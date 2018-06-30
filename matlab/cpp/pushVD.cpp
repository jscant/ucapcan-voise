/**
 * @file
 * @brief Allocates memory and populates Matlab struct with data from vd object. Only for use with Matlab mex compiler.
 */
#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif
#include <eigen3/Eigen/Dense>
#include <string>
#include <map>

#include "pushVD.h"
#include "grabVD.h"
#include "aux.h"
#include "skizException.h"
#include "typedefs.cpp"

/**
 * @defgroup pushVD pushVD
 * @ingroup pushVD
 * @brief Allocates memory and populates Matlab struct with data from vd object. Only for use with Matlab mex compiler.
 *
 * @param[in] outputVD Voronoi diagram from which data is read
 * @param[out] plhs Pointer to mxArray object which is the start of the section of memory to be populated with data and
 * which Matlab will interpret as a struct containing all of the information from outputVD.
 * This is part of the Matlab bindings for the VOISE algorithm [2], and is only compatible with the code written to this
 * end by P. Guio and N. Achilleos.
 */
void pushVD(vd outputVD, mxArray *plhs[]) {
    // Output arrays
    //mexPrintf("PUSH FLAG A\n");
    /*mxArray *nrOutgoingArray, *ncOutgoingArray, *wOutgoingArray,
            *sOutgoingArray, *xOutgoingArray, *yOutgoingArray,
            *nkOutgoingArray, *kOutgoingArray, *skOutgoingArray,
            *sxOutgoingArray, *syOutgoingArray, *vkOutgoingArray,
            *vOutgoingArray, *lamOutgoingArray, *wxmOutgoingArray,
            *wxMOutgoingArray, *wymOutgoingArray, *wyMOutgoingArray,
            *sxmOutgoingArray, *sxMOutgoingArray, *symOutgoingArray,
            *syMOutgoingArray;
    */
    // Field names for ML struct
    const char *vdFnames[] = {"nr", "nc", "W", "S", "x", "y", "Nk", "k", "Sk", "Sx", "Sy", "Vk"};
    const char *vkFnames[] = {"lambda", "v"};
    const char *wFnames[] = {"xm", "xM", "ym", "yM"};

    const mwSize nkDims[2] = {outputVD.getNk().size(), 1};
    int nCols = outputVD.nc;
    int nRows = outputVD.nr;

    // Create space in memory for result struct (VD)
    mxArray *nrOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *ncOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *xOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    mxArray *yOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    mxArray *nkOutgoingArray = mxCreateCellArray(1, nkDims);
    mxArray *kOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *skOutgoingArray = mxCreateDoubleMatrix(outputVD.Sk.size(), 1, mxREAL);
    mxArray *sxOutgoingArray = mxCreateDoubleMatrix(outputVD.Sx.size(), 1, mxREAL);
    mxArray *syOutgoingArray = mxCreateDoubleMatrix(outputVD.Sy.size(), 1, mxREAL);
    mxArray *vOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    mxArray *lamOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    mxArray *wxmOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *wxMOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *wymOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *wyMOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *sxmOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *sxMOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *symOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *syMOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);

    mxArray *vkOutgoingArray = mxCreateStructMatrix(1, 1, 2, vkFnames);
    mxArray *wOutgoingArray = mxCreateStructMatrix(1, 1, 4, wFnames);
    mxArray *sOutgoingArray = mxCreateStructMatrix(1, 1, 4, wFnames);

    // Pointers declarations
//    real *ncPtr, *nrPtr, *xPtr, *yPtr, *kPtr, *skPtr, *sxPtr,
 //        *syPtr, *lamPtr, *vPtr, *wxmPtr, *wxMPtr, *wymPtr,
  //       *wyMPtr, *sxmPtr, *sxMPtr, *symPtr, *syMPtr;

    // Get pointers to relevant mxArrays
    real *lamPtr = mxGetDoubles(lamOutgoingArray);
    real *vPtr = mxGetDoubles(vOutgoingArray);
    real *xPtr = mxGetDoubles(xOutgoingArray);
    real *yPtr = mxGetDoubles(yOutgoingArray);
    real *wxmPtr = mxGetDoubles(wxmOutgoingArray);
    real *wxMPtr = mxGetDoubles(wxMOutgoingArray);
    real *wymPtr = mxGetDoubles(wymOutgoingArray);
    real *wyMPtr = mxGetDoubles(wyMOutgoingArray);
    real *sxmPtr = mxGetDoubles(sxmOutgoingArray);
    real *sxMPtr = mxGetDoubles(sxMOutgoingArray);
    real *symPtr = mxGetDoubles(symOutgoingArray);
    real *syMPtr = mxGetDoubles(syMOutgoingArray);
    real *ncPtr = mxGetDoubles(ncOutgoingArray);
    real *nrPtr = mxGetDoubles(nrOutgoingArray);
    real *skPtr = mxGetDoubles(skOutgoingArray);
    real *sxPtr = mxGetDoubles(sxOutgoingArray);
    real *syPtr = mxGetDoubles(syOutgoingArray);
    real *kPtr = mxGetDoubles(kOutgoingArray);

    /*
    // Populate ML struct matrices with results
    for (int i = 0; i < nRows; ++i) {
        for (int j = 0; j < nCols; ++j) {
            lamPtr[j * nCols + i] = outputVD.Vk.lam(i, j);
            vPtr[j * nCols + i] = outputVD.Vk.v(i, j);
            xPtr[j * nCols + i] = outputVD.px(i, j) + 1;
            yPtr[j * nCols + i] = outputVD.py(i, j) + 1;
        }
    }
    */

    Eigen::Map<Mat>(lamPtr, outputVD.Vk.lam.rows(), outputVD.Vk.lam.cols()) = outputVD.Vk.lam;
    Eigen::Map<Mat>(vPtr, outputVD.Vk.v.rows(), outputVD.Vk.v.cols()) = outputVD.Vk.v;
    Eigen::Map<Mat>(xPtr, outputVD.px.rows(), outputVD.px.cols()) = outputVD.px + 1;
    Eigen::Map<Mat>(yPtr, outputVD.py.rows(), outputVD.py.cols()) = outputVD.py + 1;

    int sxLen = outputVD.Sx.size();
    int count = 0;
    std::map<real, real>::iterator it = outputVD.Sk.begin();
    for (int i = 0; i < sxLen; ++i) {
        sxPtr[i] = outputVD.Sx.at(i + 1);
        syPtr[i] = outputVD.Sy.at(i + 1);
        if (count < outputVD.Sk.size()) {
            skPtr[i] = it->first;
            ++it;
            ++count;
        }
    }

    int pos = 0;
    for(auto const &s: outputVD.Sk) {
        skPtr[pos] = s.second;
        pos += 1;
    }

    int nkLen = mxGetNumberOfElements(nkOutgoingArray);
    mxArray *cellPtrs[nkLen];
    for (int i = 0; i < nkLen; ++i) {
        cellPtrs[i] = mxGetCell(nkOutgoingArray, i);
        int cellLen = outputVD.getNkByIdx(i + 1).size();
        mxArray *tmpArr = mxCreateDoubleMatrix(cellLen, 1, mxREAL);
        real *tmpPtr = mxGetDoubles(tmpArr);
        for (int j = 0; j < cellLen; ++j) {
            tmpPtr[j] = outputVD.getNkByIdx(i + 1).at(j);
        }
        mxSetFieldByNumber(nkOutgoingArray, 0, i, tmpArr);
        //mexPrintf("Nk Flag 2\n");
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

   // mexPrintf("PUSH FLAG B\n");
}
