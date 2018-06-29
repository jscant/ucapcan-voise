#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif
#include <eigen3/Eigen/Dense>
#include <map>
#include <chrono>

#include "cpp/vd.h"
#include "cpp/aux.h"
#include "cpp/addSeed.h"
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

    // Get new seed information
    real *Sdoub = mxGetDoubles(prhs[1]);
    real s1 = Sdoub[0], s2 = Sdoub[1];

    // Grab VD data from ML struct
    auto start = std::chrono::high_resolution_clock::now();
    vd outputVD = grabVD(prhs);
    auto elapsed = std::chrono::high_resolution_clock::now() - start;
    long long milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(elapsed).count();
    std::string str = "grabVD:\t\t" + std::to_string(milliseconds) + "\n";
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
    str = "pushVD:\t\t" + std::to_string(milliseconds) + "\n";
    if(timing) {
        mexPrintf(str.c_str());
    }

}
