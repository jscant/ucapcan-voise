#include <mex.h>
#include <matrix.h>
#include <eigen3/Eigen/Dense>
#include <map>

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

    // Get new seed information
    real *Sdoub = mxGetDoubles(prhs[1]);
    real s1 = Sdoub[0], s2 = Sdoub[1];

    // Grab VD data from ML struct
    auto start = std::chrono::high_resolution_clock::now();
    vd outputVD = grabVD(prhs);
    auto elapsed = std::chrono::high_resolution_clock::now() - start;
    long long microseconds = std::chrono::duration_cast<std::chrono::microseconds>(elapsed).count();
    std::string str = "grabVD:\t\t" + std::to_string(microseconds) + "\n";
    if(timing) {
        mexPrintf(str.c_str());
    }

    // Add seed to VD
    start = std::chrono::high_resolution_clock::now();
    try {
        addSeed(outputVD, s1, s2);
    } catch (SKIZException &e) {
        mexErrMsgTxt(e.what());
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
