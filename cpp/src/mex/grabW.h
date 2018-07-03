//
// Created by root on 02/07/18.
//

#ifndef GRABW_H
#define GRABW_H

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <eigen3/Eigen/Dense>
#include "../typedefs.cpp"

Mat grabW(const mxArray *prhs[], const uint32 field);

#endif // GRABW_H
