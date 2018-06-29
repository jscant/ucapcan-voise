#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <chrono>

#include "cpp/vd.h"
#include "cpp/removeSeed.h"
#include "cpp/skizException.h"
#include "cpp/grabVD.h"
#include "cpp/pushVD.h"

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
    long long milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(elapsed).count();
    std::string str = "grabVD:\t\t" + std::to_string(milliseconds) + "\n";
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
    milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(elapsed).count();

    str = "removeSeed:\t" + std::to_string(milliseconds) + "\n";
    if(timing) {
        mexPrintf(str.c_str());
    }
    // Push modified VD to ML VD struct (handles memory allocation etc)

    start = std::chrono::high_resolution_clock::now();
    pushVD(outputVD, plhs);
    elapsed = std::chrono::high_resolution_clock::now() - start;
    milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(elapsed).count();
    str = "pushVD:\t\t" + std::to_string(milliseconds) + "\n------------------\n";
    if(timing) {
        mexPrintf(str.c_str());
    }

}

