#include <mex.h>
#include <matrix.h>

#ifndef VD_H
#define VD_H
#include "cpp/vd.h"
#endif

#ifndef REMOVESEED_H
#define REMOVESEED_H
#include "cpp/removeSeed.h"
#endif

#ifndef SKIZEXCEPTION_H
#define SKIZEXCEPTION_H
#include "cpp/skizException.h"
#endif

#ifndef GRABVD_H
#define GRABVD_H
#include "cpp/grabVD.h"
#endif

#ifndef PUSHVD_H
#define PUSHVD_H
#include "cpp/pushVD.h"
#endif

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    //mexPrintf("FLAG A\n");
    const mxArray *SArrPtr = prhs[1];
    real* SPtr = mxGetDoubles(SArrPtr);
    real S = SPtr[0];
    //mexPrintf("FLAG B\n");

    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
            " Invalid number of input and output arguments");
        return;
    }

    // Grab VD data from ML struct
    mexPrintf("FLAG C\n");
    vd outputVD = grabVD(prhs);
    mexPrintf("FLAG 0\n");
    // Add seed to VD
    try {
        removeSeed(outputVD, S);
    } catch (SKIZException &e) {
        mexErrMsgTxt(e.what());
    }
    mexPrintf("FLAG 16\n");
    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);
    mexPrintf("FLAG 17\n");
}

