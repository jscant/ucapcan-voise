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
