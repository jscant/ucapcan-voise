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

    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
                " Invalid number of input and output arguments");
        return;
 
    }
 
    real *SkArray = mxGetDoubles(prhs[1]);
    int nSeeds = mxGetNumberOfElements(prhs[1]);

    // Grab VD data from ML struct
    vd outputVD = grabVD(prhs);

    // Add seeds to VD
    for(auto i=0; i<nSeeds; ++i) {
        try {
            removeSeed(outputVD, SkArray[i]);
        } catch (SKIZException &e) {
            mexErrMsgTxt(e.what());
        }
    }

    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);

}
