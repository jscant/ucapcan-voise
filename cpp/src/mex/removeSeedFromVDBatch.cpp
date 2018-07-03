#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include "../vd.h"
#include "../removeSeed.h"
#include "../skizException.h"
#include "grabVD.h"
#include "pushVD.h"
 
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
    vd outputVD = grabVD(prhs, 0);

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
