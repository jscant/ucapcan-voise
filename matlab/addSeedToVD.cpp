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
#include "cpp/eigen/Eigen/Dense"
#endif

#ifndef STRING_H
#define STRING_H
#include <string>
#endif

#ifndef CSTRING_H
#define CSTRING_H
#include <cstring>
#endif

#ifndef VD_H
#define VD_H
#include "cpp/vd.h"
#endif

#ifndef AUX_H
#define AUX_H
#include "cpp/aux.h"
#endif

#ifndef ADDSEED_H
#define ADDSEED_H
#include "cpp/addSeed.h"
#endif

#ifndef SKIZEXCEPTION_H
#define SKIZEXCEPTION_H
#include "cpp/skizException.h"
#endif

#ifndef MAP_H
#define MAP_H
#include <map>
#endif

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
                " Invalid number of input and output arguments");
        return;
    }
    //std::chrono::high_resolution_clock::time_point t1 = std::chrono::high_resolution_clock::now();
    double nc, nr, k;
    Mat lam, v, px, py;
    std::map<double, double> Sx, Sy, Sk;
    std::map<double, std::vector<double>> Nk;
    W_struct W;
    S_struct S_str;

    // Get all input information from vd
    double nFields = mxGetNumberOfFields(prhs[0]);
    double nElements = mxGetNumberOfElements(prhs[0]);
    double rows;
    double col;
    double *Sdoub;
    double s1, s2;

    mxArray *nrIncomingArray, *ncIncomingArray, *wIncomingArray,
            *sIncomingArray, *xIncomingArray, *yIncomingArray,
            *nkIncomingArray, *kIncomingArray, *skIncomingArray,
            *sxIncomingArray, *syIncomingArray, *vkIncomingArray,
            *vIncomingArray, *lamIncomingArray, *wxmIncomingArray,
            *wxMIncomingArray, *wymIncomingArray, *wyMIncomingArray,
            *sxmIncomingArray, *sxMIncomingArray, *symIncomingArray,
            *syMIncomingArray;

    double *nrIncoming, *ncIncoming, *xIncoming, *yIncoming, *kIncoming,
            *skIncoming, *sxIncoming, *syIncoming, *wxmIncoming, *wxMIncoming,
            *wymIncoming, *wyMIncoming, *sxmIncoming, *sxMIncoming, *symIncoming,
            *syMIncoming;

    // Get new seed information
    Sdoub = mxGetDoubles(prhs[1]);
    s1 = Sdoub[0];
    s2 = Sdoub[1];

    // Populate mxArrays with data from VD ML struct
    nrIncomingArray = mxGetField(prhs[0], 0, "nr");
    ncIncomingArray = mxGetField(prhs[0], 0, "nc");
    wIncomingArray = mxGetField(prhs[0], 0, "W");
    sIncomingArray = mxGetField(prhs[0], 0, "S");
    xIncomingArray = mxGetField(prhs[0], 0, "x");
    yIncomingArray = mxGetField(prhs[0], 0, "y");
    nkIncomingArray = mxGetField(prhs[0], 0, "Nk");
    kIncomingArray = mxGetField(prhs[0], 0, "k");
    skIncomingArray = mxGetField(prhs[0], 0, "Sk");
    sxIncomingArray = mxGetField(prhs[0], 0, "Sx");
    syIncomingArray = mxGetField(prhs[0], 0, "Sy");
    vkIncomingArray = mxGetField(prhs[0], 0, "Vk");

    lamIncomingArray = mxGetField(vkIncomingArray, 0, "lambda");
    vIncomingArray = mxGetField(vkIncomingArray, 0, "v");

    wxmIncomingArray = mxGetField(wIncomingArray, 0, "xm");
    wxMIncomingArray = mxGetField(wIncomingArray, 0, "xM");
    wymIncomingArray = mxGetField(wIncomingArray, 0, "ym");
    wyMIncomingArray = mxGetField(wIncomingArray, 0, "yM");


    sxmIncomingArray = mxGetField(sIncomingArray, 0, "xm");
    sxMIncomingArray = mxGetField(sIncomingArray, 0, "xM");
    symIncomingArray = mxGetField(sIncomingArray, 0, "ym");
    syMIncomingArray = mxGetField(sIncomingArray, 0, "yM");

    // Pointers declarations
    double *ncPtr, *nrPtr, *xPtr, *yPtr, *kPtr, *skPtr, *sxPtr,
            *syPtr, *lamPtr, *vPtr, *wxmPtr, *wxMPtr, *wymPtr,
            *wyMPtr, *sxmPtr, *sxMPtr, *symPtr, *syMPtr;

    // Pointers to mxArrays containing ML data
    nrPtr = mxGetDoubles(nrIncomingArray);
    ncPtr = mxGetDoubles(ncIncomingArray);
    kPtr = mxGetDoubles(kIncomingArray);
    lamPtr = mxGetDoubles(lamIncomingArray);
    vPtr = mxGetDoubles(vIncomingArray);
    xPtr = mxGetDoubles(xIncomingArray);
    yPtr = mxGetDoubles(yIncomingArray);
    sxPtr = mxGetDoubles(sxIncomingArray);
    syPtr = mxGetDoubles(syIncomingArray);
    skPtr = mxGetDoubles(skIncomingArray);

    wxmPtr = mxGetDoubles(wxmIncomingArray);
    wxMPtr = mxGetDoubles(wxMIncomingArray);
    wymPtr = mxGetDoubles(wymIncomingArray);
    wyMPtr = mxGetDoubles(wyMIncomingArray);


    sxmPtr = mxGetDoubles(sxmIncomingArray);
    sxMPtr = mxGetDoubles(sxMIncomingArray);
    symPtr = mxGetDoubles(symIncomingArray);
    syMPtr = mxGetDoubles(syMIncomingArray);

    // Populate variables with data in mxArrays and their pointers
    nr = nrPtr[0];
    nc = ncPtr[0];
    k = kPtr[0];
    W.xm = wxmPtr[0];
    W.xM = wxMPtr[0];
    W.ym = wymPtr[0];
    W.yM = wyMPtr[0];
    S_str.xm = sxmPtr[0];
    S_str.xM = sxMPtr[0];
    S_str.ym = symPtr[0];
    S_str.yM = syMPtr[0];

    mwIndex nRows = mxGetM(lamIncomingArray);
    mwIndex nCols = mxGetN(lamIncomingArray);

    // Eigen arrays to put matrix data in
    lam.resize(nRows, nCols);
    v.resize(nRows, nCols);
    px.resize(nRows, nCols);
    py.resize(nRows, nCols);

    // Populate Eigen arrays with ML data
    for (mwIndex i = 0; i < nRows; ++i) {
        for (mwIndex j = 0; j < nCols; ++j) {
            lam(i, j) = lamPtr[j * nCols + i];
            v(i, j) = vPtr[j * nCols + i];
            px(i, j) = xPtr[j * nCols + i] - 1; // Array indexing in ML starts at 1
            py(i, j) = yPtr[j * nCols + i] - 1;
        }
    }

    mwIndex sxLen = std::max(mxGetM(sxIncomingArray), mxGetN(sxIncomingArray));

    // Populate seed data unordered maps
    for (mwIndex i = 0; i < sxLen; ++i) {
        Sx[i + 1] = sxPtr[i];
        Sy[i + 1] = syPtr[i];
        Sk[i + 1] = skPtr[i];
    }

    // Populate neighbour relationships from ML data
    mwIndex nkLen = mxGetNumberOfElements(nkIncomingArray);
    mxArray *cellPtrs[nkLen];
    double *cellContentsPtrs;

    for (mwIndex i = 0; i < nkLen; ++i) {
        cellPtrs[i] = mxGetCell(nkIncomingArray, i);
        mwIndex cellLen = mxGetNumberOfElements(cellPtrs[i]);
        double *vals = mxGetDoubles(cellPtrs[i]);
        std::vector<double> cellVec;
        for (mwIndex j = 0; j < cellLen; ++j) {
            cellVec.push_back(vals[j]);
        }
        Nk[i + 1] = cellVec;
    }

    // Create and populate vd
    vd VD = vd(nr, nc);

    /*
    VD.setK(k);
    VD.setLam(lam);
    VD.setV(v);
    VD.setPx(px);
    VD.setPy(py);
    VD.setSx(Sx);
    VD.setSy(Sy);
    VD.setNk(Nk);
    VD.setW(W);
    VD.setS(S_str);
    */

    VD.k = k;
    VD.Vk.lam = lam;
    VD.Vk.v = v;
    VD.px = px;
    VD.py = py;
    VD.Sx = Sx;
    VD.Sy = Sy;
    VD.Sk = Sk;
    VD.Nk = Nk;
    VD.W = W;
    VD.S = S_str;

    // Create result vd, which is result of addSeed acting on input vd
    vd result(VD.nr, VD.nc);

    try {
        result = addSeed(VD, s1, s2);
    } catch (SKIZException &e){
        mexErrMsgTxt(e.what());
    }

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

    const mwSize nkDims[2] = {result.Nk.size(), 1};

    // Create space in memory for result struct (VD)
    nrOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    ncOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    xOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    yOutgoingArray = mxCreateDoubleMatrix(nRows, nCols, mxREAL);
    nkOutgoingArray = mxCreateCellArray(1, nkDims);
    kOutgoingArray = mxCreateDoubleMatrix(1, 1, mxREAL);
    skOutgoingArray = mxCreateDoubleMatrix(result.Sk.size(), 1, mxREAL);
    sxOutgoingArray = mxCreateDoubleMatrix(result.Sx.size(), 1, mxREAL);
    syOutgoingArray = mxCreateDoubleMatrix(result.Sy.size(), 1, mxREAL);
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
    nCols = result.nc;
    nRows = result.nr;
    for (mwIndex i = 0; i < nRows; ++i) {
        for (mwIndex j = 0; j < nCols; ++j) {
            lamPtr[j * nCols + i] = result.Vk.lam(i, j);
            vPtr[j * nCols + i] = result.Vk.v(i, j);
            xPtr[j * nCols + i] = result.px(i, j) + 1;
            yPtr[j * nCols + i] = result.py(i, j) + 1;
        }
    }

    sxLen = result.Sx.size();
    for (mwIndex i = 0; i < sxLen; ++i) {
        sxPtr[i] = result.Sx.at(i + 1);
        syPtr[i] = result.Sy.at(i + 1);
        skPtr[i] = result.Sk.at(i + 1);
    }

    nkLen = mxGetNumberOfElements(nkOutgoingArray);
    for (mwIndex i = 0; i < nkLen; ++i) {
        cellPtrs[i] = mxGetCell(nkOutgoingArray, i);
        mwIndex cellLen = result.Nk.at(i + 1).size();
        mxArray *tmpArr = mxCreateDoubleMatrix(cellLen, 1, mxREAL);
        double *tmpPtr = mxGetDoubles(tmpArr);
        for (mwIndex j = 0; j < cellLen; ++j) {
            tmpPtr[j] = result.Nk.at(i + 1).at(j);
        }
        mxSetFieldByNumber(nkOutgoingArray, 0, i, tmpArr);
    }

    // These are somewhat redundant for addSeed but here for consistency
    wxmPtr[0] = result.W.xm;
    wxMPtr[0] = result.W.xM;
    wymPtr[0] = result.W.ym;
    wyMPtr[0] = result.W.yM;
    sxmPtr[0] = result.S.xm;
    sxMPtr[0] = result.S.xM;
    symPtr[0] = result.S.ym;
    syMPtr[0] = result.S.yM;

    ncPtr[0] = result.nc;
    nrPtr[0] = result.nr;
    kPtr[0] = result.k;

    //std::chrono::high_resolution_clock::time_point t2 = std::chrono::high_resolution_clock::now();
    //std::chrono::duration<double> time_span = std::chrono::duration_cast<std::chrono::duration<double>>(t2 - t1);
    //print("Time taken:");
    //print(1000 * time_span.count());

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
