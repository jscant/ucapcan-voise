#ifndef MEX_H
#define MEX_H
#include "/usr/local/MATLAB/R2018a/extern/include/mex.h"
#endif

#ifndef MATRIX_H
#define MATRIX_H
#include "/usr/local/MATLAB/R2018a/extern/include/matrix.h"
#endif

#ifndef EIGEN_DENSE_H
#define EIGEN_DENSE_H
#include "cpp/eigen/Eigen/Dense"
#endif

#ifndef STRING_H
#define STRING_H
#include <string>
#endif

#ifndef CSTRING_H
#define CSTRING_H
#include <cstring>
#endif

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

#ifndef MAP_H
#define MAP_H
#include <map>
#endif

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{

    if (nlhs != 1 || nrhs != 2) {
        mexErrMsgTxt(
                " Invalid number of input and output arguments");
        return;
    }

    // Get new seed information
    double *Sdoub = mxGetDoubles(prhs[1]);
    double s1 = Sdoub[0], s2 = Sdoub[1];

    // Grab VD data from ML struct
    vd outputVD = grabVD(prhs);

    // Add seed to VD
    try {
        addSeed(outputVD, s1, s2);
    } catch (SKIZException &e){
        mexErrMsgTxt(e.what());
    }

    // Push modified VD to ML VD struct (handles memory allocation etc)
    pushVD(outputVD, plhs);

}
