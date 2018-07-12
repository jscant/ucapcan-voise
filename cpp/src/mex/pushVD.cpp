/**
 * @file
 * @brief This is a requirement for a MEX function. It should only be compiled by the compileMEX.m matlab script.
 * Allocates memory and populates Matlab struct with data from vd object. Only for use with Matlab mex compiler.
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
#include "../skizException.h"
#include "../typedefs.cpp"

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

    // Field names for outgoing Matlab struct
    const char *vdFnames[] = {"nr", "nc", "W", "S", "x", "y", "Nk", "k", "Sk", "Sx", "Sy", "Vk"};
    const char *vkFnames[] = {"lambda", "v"};
    const char *wFnames[] = {"xm", "xM", "ym", "yM"};

    const mwSize nkDims[2] = {outputVD.getNk().size(), 1}; // Cell dimentions of outgoing neighbour cell array
    int nCols = outputVD.getNc();
    int nRows = outputVD.getNr();

    // Create space in memory for result struct (VD)
    mxArray *nrOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *ncOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *xOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    mxArray *yOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    mxArray *nkOutgoingArray = mxCreateCellArray(1, nkDims);
    mxArray *kOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxArray *skOutgoingArray = mxCreateDoubleMatrix(outputVD.getSk().size(), 1, mxREAL);
    mxArray *sxOutgoingArray = mxCreateDoubleMatrix(outputVD.getSx().size(), 1, mxREAL);
    mxArray *syOutgoingArray = mxCreateDoubleMatrix(outputVD.getSy().size(), 1, mxREAL);
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

    // Avoid costly copying of data: use Eigen::Map to point directly to underlying arrays
    Eigen::Map<Mat>(lamPtr, outputVD.getNr(), outputVD.getNc()) = outputVD.getLam();
    Eigen::Map<Mat>(vPtr, outputVD.getNr(), outputVD.getNc()) = outputVD.getV();
    Eigen::Map<Mat>(xPtr, outputVD.getNr(), outputVD.getNc()) = outputVD.getPx() + 1;
    Eigen::Map<Mat>(yPtr, outputVD.getNr(), outputVD.getNc()) = outputVD.getPy() + 1;

    // Populate Matlab VD.Sx, VD.Sy struct data. Re-apply offset (array indexing starts at 1 in ML)
    int sxLen = outputVD.getSx().size();
    int skLen = outputVD.getSk().size();

    memcpy(sxPtr, outputVD.getSx().data(), sxLen*sizeof(real));
    memcpy(syPtr, outputVD.getSy().data(), sxLen*sizeof(real));
    memcpy(skPtr, outputVD.getSk().data(), skLen*sizeof(real));
    //for (int i = 0; i < sxLen; ++i) {
    //    sxPtr[i] = outputVD.getSxByIdx(i + 1);
    //    syPtr[i] = outputVD.getSyByIdx(i + 1);
    //}

    // Populate VD.Sk (index of 'active' seeds)
    //int pos = 0;
    //for(auto const &s: outputVD.getSk()) {
    //    skPtr[pos] = s;
    //    pos += 1;
    //}

    // Populate VD.Nk (cell array of neighbour relationships)
    int nkLen = mxGetNumberOfElements(nkOutgoingArray);
    mxArray *cellPtrs[nkLen];
    for (int i = 0; i < nkLen; ++i) {
        cellPtrs[i] = mxGetCell(nkOutgoingArray, i);
        int cellLen = outputVD.getNkByIdx(i + 1).size();
        mxArray *tmpArr = mxCreateDoubleMatrix(cellLen, 1, mxREAL);
        real *tmpPtr = mxGetDoubles(tmpArr);
        memcpy(tmpPtr, outputVD.getNkByIdx(i + 1).data(), cellLen*sizeof(real));
        //std::copy(outputVD.getNkByIdx(i + 1).data(), outputVD.getNkByIdx(i + 1).data() + cellLen, tmpPtr);
        //for (int j = 0; j < cellLen; ++j) {
        //    tmpPtr[j] = outputVD.getNkByIdx(i + 1).at(j);
        //}
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

    ncPtr[0] = outputVD.getNc();
    nrPtr[0] = outputVD.getNr();
    kPtr[0] = outputVD.getK();

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

    // We are done! All memory freed by Matlab.
}
