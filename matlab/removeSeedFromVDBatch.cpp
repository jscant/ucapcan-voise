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

#include <chrono>

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

    bool timing = false;

    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
                " Invalid number of input and output arguments");
        return;
    }
    real *SkArray = mxGetDoubles(prhs[1]);
    int nSeeds = mxGetNumberOfElements(prhs[1]);

    // Grab VD data from ML struct
    auto start = std::chrono::high_resolution_clock::now();
    vd outputVD = grabVD(prhs);
    auto elapsed = std::chrono::high_resolution_clock::now() - start;
    long long microseconds = std::chrono::duration_cast<std::chrono::microseconds>(elapsed).count();
    std::string str = "grabVD:\t\t" + std::to_string(microseconds) + "\n";
    if(timing) {
        mexPrintf(str.c_str());
    }

    // Add seeds to VD
    start = std::chrono::high_resolution_clock::now();
    for(auto i=0; i<nSeeds; ++i) {
        try {
            removeSeed(outputVD, SkArray[i]);
        } catch (SKIZException &e) {
            mexErrMsgTxt(e.what());
        }
    }
    elapsed = std::chrono::high_resolution_clock::now() - start;
    microseconds = std::chrono::duration_cast<std::chrono::microseconds>(elapsed).count();

    str = "removeSeed:\t" + std::to_string(microseconds) + "\n";
    if(timing) {
        mexPrintf(str.c_str());
    }
    // Push modified VD to ML VD struct (handles memory allocation etc)

    start = std::chrono::high_resolution_clock::now();
    pushVD(outputVD, plhs);
    elapsed = std::chrono::high_resolution_clock::now() - start;
    microseconds = std::chrono::duration_cast<std::chrono::microseconds>(elapsed).count();
    str = "pushVD:\t\t" + std::to_string(microseconds) + "\n";
    if(timing) {
        mexPrintf(str.c_str());
    }

}

