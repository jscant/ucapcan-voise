/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m matlab script. Allocates memory and
 * populates vd object with data from matlab VD struct. Only for use with Matlab mex compiler.
 */

#include <eigen3/Eigen/Dense>
#include <string>
#include <map>

#include "grabVD.h"
#include "../skizException.h"
#include "../typedefs.cpp"

/**
 * @defgroup grabVD grabVD
 * @ingroup grabVD
 * @brief Allocates memory and populates vd object with data from matlab VD struct. Only for use with Matlab mex compiler.
 *
 * @param[in] prhs Voronoi diagram in the form of a Matlab struct with the relevant fields filled in the correct manner.
 * @returns Voronoi diagram (vd) object containing all relevant information.
 *
 * The larger matrices (\f$ \lambda, \nu \f$ in [1] as well as px and py) are not copied but mapped using Eigen's map
 * class for reasons of speed.
 *
 * This is part of the Matlab bindings for the VOISE algorithm [2], and is only compatible with the code written to this
 * end by P. Guio and N. Achilleos.
 */
vd grabVD(const mxArray *prhs[], const uint32 field) {

    real nc=0, nr=0, k=0;

    std::map<real, real> Sx, Sy, Sk;
    std::map<real, RealVec> Nk;
    W_struct W;
    memset(&W, 0, sizeof(W));
    W_struct S_str = {0, 0, 0, 0};
    memset(&S_str, 0, sizeof(S_str));

    // Get all input information from vd
    real nFields = mxGetNumberOfFields(prhs[field]);
    real nElements = mxGetNumberOfElements(prhs[field]);

    // Create mxArrays with data from VD ML struct
    mxArray *nrIncomingArray = mxGetField(prhs[field], 0, "nr");
    mxArray *ncIncomingArray = mxGetField(prhs[field], 0, "nc");
    mxArray *wIncomingArray = mxGetField(prhs[field], 0, "W");
    mxArray *sIncomingArray = mxGetField(prhs[field], 0, "S");
    mxArray *xIncomingArray = mxGetField(prhs[field], 0, "x");
    mxArray *yIncomingArray = mxGetField(prhs[field], 0, "y");
    mxArray *nkIncomingArray = mxGetField(prhs[field], 0, "Nk");
    mxArray *kIncomingArray = mxGetField(prhs[field], 0, "k");
    mxArray *skIncomingArray = mxGetField(prhs[field], 0, "Sk");
    mxArray *sxIncomingArray = mxGetField(prhs[field], 0, "Sx");
    mxArray *syIncomingArray = mxGetField(prhs[field], 0, "Sy");
    mxArray *vkIncomingArray = mxGetField(prhs[field], 0, "Vk");

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

    // Create and populate vd
    vd VD = vd(nr, nc);

    VD.setLam(Eigen::Map<Mat>(lamPtr, nRows, nCols));
    VD.setV(Eigen::Map<Mat>(vPtr, nRows, nCols));
    VD.setPx(Eigen::Map<Mat>(xPtr, nRows, nCols) - 1);
    VD.setPy(Eigen::Map<Mat>(yPtr, nRows, nCols) - 1);

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

    VD.setK(k);
    VD.setSx(Sx);
    VD.setSy(Sy);
    VD.setSk(Sk);
    VD.setNk(Nk);
    VD.W = W;
    VD.S = S_str;

    return VD;
}