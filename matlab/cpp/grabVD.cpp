#include <mex.h>
#include <math.h>
#include <eigen3/Eigen/Dense>
#include <string>
#include <map>

#ifndef GRABVD_H
#define GRABVD_H
#include "grabVD.h"
#endif

#ifndef AUX_H
#define AUX_H
#include "aux.h"
#endif

#ifndef SKIZEXCEPTION_H
#define SKIZEXCEPTION_H
#include "skizException.h"
#endif

#ifndef MAT
#define MAT
typedef Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

vd grabVD(const mxArray *prhs[]){
    double nc, nr, k;
    Mat lam, v, px, py;
    std::map<double, double> Sx, Sy, Sk;
    std::map<double, RealVec> Nk;
    W_struct W;
    S_struct S_str;

    // Get all input information from vd
    double nFields = mxGetNumberOfFields(prhs[0]);
    double nElements = mxGetNumberOfElements(prhs[0]);
    double rows;
    double col;

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
    mwIndex skLen = std::max(mxGetM(skIncomingArray), mxGetN(skIncomingArray));
    // Populate seed data unordered maps
    for (mwIndex i = 0; i < sxLen; ++i) {
        Sx[i + 1] = sxPtr[i];
        Sy[i + 1] = syPtr[i];
    }

    for (mwIndex i = 0; i < skLen; ++i){
        if(skPtr[i] == 0){
            mexPrintf("###########################################\n");
        }
        Sk[skPtr[i]] = skPtr[i];
    }

    // Populate neighbour relationships from ML data
    mwIndex nkLen = mxGetNumberOfElements(nkIncomingArray);
    mxArray *cellPtrs[nkLen];
    double *cellContentsPtrs;

    for (mwIndex i = 0; i < nkLen; ++i) {
        cellPtrs[i] = mxGetCell(nkIncomingArray, i);
        mwIndex cellLen = mxGetNumberOfElements(cellPtrs[i]);
        double *vals = mxGetDoubles(cellPtrs[i]);
        RealVec cellVec;
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
    VD.setSk(Sk);
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

    return VD;
}