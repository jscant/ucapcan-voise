/**
 * @defgroup mexFunctions
 * @inpackage mexFunctions
 * @return void
 * @fn mexFunction
 */

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

    bool timing = false;

    // Get new seed information
    real *Sdoub = mxGetDoubles(prhs[1]);
    int nRows = mxGetM(prhs[1]);

    // Grab VD data from ML struct
    vd outputVD = grabVD(prhs);

    // Add seed to VD
    for(int i=0; i<nRows; ++i) {
        real s1 = Sdoub[i];
        real s2 = Sdoub[i+nRows];
        try {
            addSeed(outputVD, s1, s2);
        } catch (SKIZException &e) {
            mexErrMsgTxt(e.what());
        }
    }

    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);

}
