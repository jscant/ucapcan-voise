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
    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
            " Invalid number of input and output arguments");
        return;
    }
    real S = mxGetScalar(prhs[1]);
    mexPrintf(std::to_string(S).c_str());
    mexPrintf("\n");

    // Grab VD data from ML struct
    vd outputVD = grabVD(prhs);
    // Add seed to VD
    try {
        removeSeed(outputVD, S);
    } catch (SKIZException &e) {
        mexErrMsgTxt(e.what());
    }
    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);
}

