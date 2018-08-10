/**
 * @file
 * @brief This is a MEX function. It should only be compiled by the compileMEX.m
 * Matlab script. Allocates memory and populates vd object with data from Matlab
 * VD struct. Only for use with Matlab mex compiler.
 */

#include "mexIncludes.h"

/**
 * @defgroup grabVD grabVD
 * @ingroup grabVD
 * @brief Allocates memory and populates vd object with data from Matlab VD
 * struct. Only for use with Matlab mex compiler.
 *
 * @param[in] prhs Voronoi diagram in the form of a Matlab struct with the
 * relevant fields filled in the correct manner.
 * @returns Voronoi diagram (vd) object containing all relevant information.
 *
 * The larger matrices (\f$ \lambda, \nu \f$ in [1] as well as px and py) are
 * not copied but mapped using Eigen's map functionality for reasons of speed.
 *
 * This is part of the Matlab bindings for the VOISE algorithm [2], and is
 * only compatible with the code written to this end by P. Guio and N.
 * Achilleos.
 */
vd grabVD(const mxArray *prhs[], const uint32 field) {

    // Initialisation
    real nc, nr;
    real k = 0;
    std::map <real, RealVec> Nk;
    W_struct W;
    memset(&W, 0, sizeof(W));
    W_struct S_struct = {0, 0, 0, 0};
    memset(&S_struct, 0, sizeof(S_struct));

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
    S_struct.xm = sxmPtr[0];
    S_struct.xM = sxMPtr[0];
    S_struct.ym = symPtr[0];
    S_struct.yM = syMPtr[0];

    // Get rows/cols from lambda matrix
    mwIndex nRows = mxGetM(lamIncomingArray);
    mwIndex nCols = mxGetN(lamIncomingArray);

    // Compatible with row/column vectors in ML
    mwIndex sxLen = std::max(mxGetM(sxIncomingArray), mxGetN(sxIncomingArray));
    mwIndex skLen = std::max(mxGetM(skIncomingArray), mxGetN(skIncomingArray));

    // Populate Sx Sy Sk vectors
    RealVec Sx(sxPtr, sxPtr + sxLen);
    RealVec Sy(syPtr, syPtr + sxLen);
    RealVec Sk(skPtr, skPtr + skLen);

    // Populate neighbour relationships from ML data
    mwIndex nkLen = mxGetNumberOfElements(nkIncomingArray);
    for (mwIndex i = 0; i < nkLen; ++i) {
        mxArray *cellPtr = mxGetCell(nkIncomingArray, i); // Pointer to cell
        mwIndex cellLen = mxGetNumberOfElements(cellPtr); // Elements in cell
        real *vals = mxGetDoubles(cellPtr); // Pointer to cell contents
        RealVec cellVec(vals, vals + cellLen); // Faster than looping
        Nk[i + 1] = cellVec; // Seed indexes begin at 1
    }

    // Create and populate vd
    vd VD = vd(nr, nc);

    /*
     * Eigen Maps give pointers to memory, no copying large matrices. Offsetting
     * due to difference between Matlab and C++ array indexing (1- and 0- based
     * respectively)
     */
    VD.setLam(Eigen::Map<Mat>(lamPtr, nRows, nCols));
    VD.setV(Eigen::Map<Mat>(vPtr, nRows, nCols));
    VD.setPx(Eigen::Map<Mat>(xPtr, nRows, nCols) - 1);
    VD.setPy(Eigen::Map<Mat>(yPtr, nRows, nCols) - 1);

    // Set remaining attributes of VD
    VD.setK(k);
    VD.setSx(Sx);
    VD.setSy(Sy);
    VD.setSk(Sk);
    VD.setNk(Nk);
    VD.W = W;
    VD.S = S_struct;

    return VD;
}