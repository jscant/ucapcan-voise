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
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

vd grabVD(const mxArray *prhs[]) {
    //mexPrintf("GRAB FLAG A\n");
    real nc=0, nr=0, k=0;
    Mat lam, v, px, py;
    std::map<real, real> Sx, Sy, Sk;
    std::map<real, RealVec> Nk;
    W_struct W;
    memset(&W, 0, sizeof(W));
    S_struct S_str = {0, 0, 0, 0};
    memset(&S_str, 0, sizeof(S_str));

    // Get all input information from vd
    real nFields = mxGetNumberOfFields(prhs[0]);
    real nElements = mxGetNumberOfElements(prhs[0]);
/*
    mxArray *nrIncomingArray, *ncIncomingArray, *wIncomingArray,
            *sIncomingArray, *xIncomingArray, *yIncomingArray,
            *nkIncomingArray, *kIncomingArray, *skIncomingArray,
            *sxIncomingArray, *syIncomingArray, *vkIncomingArray,
            *vIncomingArray, *lamIncomingArray, *wxmIncomingArray,
            *wxMIncomingArray, *wymIncomingArray, *wyMIncomingArray,
            *sxmIncomingArray, *sxMIncomingArray, *symIncomingArray,
            *syMIncomingArray;

    real *nrIncoming, *ncIncoming, *xIncoming, *yIncoming, *kIncoming,
         *skIncoming, *sxIncoming, *syIncoming, *wxmIncoming, *wxMIncoming,
         *wymIncoming, *wyMIncoming, *sxmIncoming, *sxMIncoming, *symIncoming,
         *syMIncoming;
*/
    // Populate mxArrays with data from VD ML struct
    mxArray *nrIncomingArray = mxGetField(prhs[0], 0, "nr");
    mxArray *ncIncomingArray = mxGetField(prhs[0], 0, "nc");
    mxArray *wIncomingArray = mxGetField(prhs[0], 0, "W");
    mxArray *sIncomingArray = mxGetField(prhs[0], 0, "S");
    mxArray *xIncomingArray = mxGetField(prhs[0], 0, "x");
    mxArray *yIncomingArray = mxGetField(prhs[0], 0, "y");
    mxArray *nkIncomingArray = mxGetField(prhs[0], 0, "Nk");
    mxArray *kIncomingArray = mxGetField(prhs[0], 0, "k");
    mxArray *skIncomingArray = mxGetField(prhs[0], 0, "Sk");
    mxArray *sxIncomingArray = mxGetField(prhs[0], 0, "Sx");
    mxArray *syIncomingArray = mxGetField(prhs[0], 0, "Sy");
    mxArray *vkIncomingArray = mxGetField(prhs[0], 0, "Vk");

    mxArray *lamIncomingArray = mxGetField(vkIncomingArray, 0, "lambda");
    mxArray *vIncomingArray = mxGetField(vkIncomingArray, 0, "v");

    mxArray *wxmIncomingArray = mxGetField(wIncomingArray, 0, "xm");
    mxArray *wxMIncomingArray = mxGetField(wIncomingArray, 0, "xM");
    mxArray *wymIncomingArray = mxGetField(wIncomingArray, 0, "ym");
    mxArray *wyMIncomingArray = mxGetField(wIncomingArray, 0, "yM");

    mxArray *sxmIncomingArray = mxGetField(sIncomingArray, 0, "xm");
    mxArray *sxMIncomingArray = mxGetField(sIncomingArray, 0, "xM");
    mxArray *symIncomingArray = mxGetField(sIncomingArray, 0, "ym");
    mxArray *syMIncomingArray = mxGetField(sIncomingArray, 0, "yM");
/*
    // Pointers declarations
    real *ncPtr, *nrPtr, *xPtr, *yPtr, *kPtr, *skPtr, *sxPtr,
         *syPtr, *lamPtr, *vPtr, *wxmPtr, *wxMPtr, *wymPtr,
         *wyMPtr, *sxmPtr, *sxMPtr, *symPtr, *syMPtr;
*/
    // Pointers to mxArrays containing ML data
    real *nrPtr = mxGetDoubles(nrIncomingArray);
    real *ncPtr = mxGetDoubles(ncIncomingArray);
    real *kPtr = mxGetDoubles(kIncomingArray);
    real *lamPtr = mxGetDoubles(lamIncomingArray);
    real *vPtr = mxGetDoubles(vIncomingArray);
    real *xPtr = mxGetDoubles(xIncomingArray);
    real *yPtr = mxGetDoubles(yIncomingArray);
    real *sxPtr = mxGetDoubles(sxIncomingArray);
    real *syPtr = mxGetDoubles(syIncomingArray);
    real *skPtr = mxGetDoubles(skIncomingArray);

    real *wxmPtr = mxGetDoubles(wxmIncomingArray);
    real *wxMPtr = mxGetDoubles(wxMIncomingArray);
    real *wymPtr = mxGetDoubles(wymIncomingArray);
    real *wyMPtr = mxGetDoubles(wyMIncomingArray);

    real *sxmPtr = mxGetDoubles(sxmIncomingArray);
    real *sxMPtr = mxGetDoubles(sxMIncomingArray);
    real *symPtr = mxGetDoubles(symIncomingArray);
    real *syMPtr = mxGetDoubles(syMIncomingArray);

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

    for (mwIndex i = 0; i < skLen; ++i) {
        Sk[skPtr[i]] = skPtr[i];
    }

    // Populate neighbour relationships from ML data
    mwIndex nkLen = mxGetNumberOfElements(nkIncomingArray);
    mxArray *cellPtrs[nkLen];
    real *cellContentsPtrs;

    for (mwIndex i = 0; i < nkLen; ++i) {
        cellPtrs[i] = mxGetCell(nkIncomingArray, i);
        mwIndex cellLen = mxGetNumberOfElements(cellPtrs[i]);
        real *vals = mxGetDoubles(cellPtrs[i]);
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