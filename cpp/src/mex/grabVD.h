/**
 * @file
 * @copydetails grabVD.cpp
 */
#ifndef GRABVD_H
#define GRABVD_H

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include "../vd.h"

vd grabVD(const mxArray *prhs[], const uint32 field);

#endif