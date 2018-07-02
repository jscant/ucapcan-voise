#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <eigen3/Eigen/Dense>
#include <map>

#include "cpp/vd.h"
#include "cpp/addSeed.h"
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

    // Get new seed information
    real *Sdoub = mxGetDoubles(prhs[1]);
    real s1 = Sdoub[0], s2 = Sdoub[1];

    // Grab VD data from ML struct
    vd outputVD = grabVD(prhs);

    // Add seed to VD
    try {
        addSeed(outputVD, s1, s2);
    } catch (SKIZException &e) {
        mexErrMsgTxt(e.what());
    }

    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);

}
