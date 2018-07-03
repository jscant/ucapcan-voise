/**
 * @file
 * @brief Finds the mean or median pixel value for voronoi regions
 */

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <eigen3/Eigen/Dense>
#include <map>
#include <functional>
#include <string>

#include "../vd.h"
#include "../skizException.h"
#include "../getRegion.h"
#include "../aux-functions/metrics.h"
#include "grabVD.h"
#include "pushVD.h"
#include "grabW.h"

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[]) {

    if (nrhs != 3 && nrhs != 4) {
        mexErrMsgTxt(
                " Invalid number of input arguments");
        return;
    }

    real mult = 1;
    vd VD = grabVD(prhs, 0);
    Mat W = grabW(prhs, 1);
    std::function<real(RealVec)> metric;
    real *multiplier;

    int opChar = (int) mxGetScalar(prhs[2]);
    switch (opChar) {
        case 1 :
            metric = median;
            break;
        case 2 :
            metric = mean;
            break;
        case 3 :
            metric = maxMin;
            break;
        case 4 :
            metric = sqrtLen;
            break;
        case 5 :
            metric = maxMin;
            multiplier = mxGetDoubles(prhs[3]);
            mult = 1 / multiplier[0];
            break;
        case 6 :
            metric = stdDev;
            multiplier = mxGetDoubles(prhs[3]);
            mult = multiplier[0];
            break;
    }
    Mat Wop(W.rows(), W.cols());
    Mat Sop(VD.getSk().size(), 1);
    uint32 is = 0;
    for (auto s : VD.getSk()) {
        Mat bounds = getRegion(VD, s.second);
        bool finish = false;
        real val;
        RealVec pixelValues;
        for (int j = 0; j < bounds.rows(); ++j) {
            if (bounds(j, 0) == -1) {
                if (finish) {
                    break; // R(s) convex so we are done
                } else {
                    continue; // We have not yet reached a row with pixels in R(s)
                }
            }
            finish = true;
            real lb = std::max(0.0, bounds(j, 0) - 1);
            real ub = std::min(VD.getNc(), bounds(j, 1));
            for (uint32 i = lb; i < ub; ++i) {
                if (!VD.getVByIdx(j, i)){// && VD.getLamByIdx(j, i) == s.second) {
                    pixelValues.push_back(W(j, i));
                } else if (VD.getLamByIdx(j, i) == s.second) {
                    Wop(j, i) = mxGetNaN();
                }
            }
        }
        val = mult * metric(pixelValues);
        Sop(is, 0) = val;
        finish = false;
        for (int j = 0; j < bounds.rows(); ++j) {
            if (bounds(j, 0) == -1) {
                if (finish) {
                    break; // R(s) convex so we are done
                } else {
                    continue; // We have not yet reached a row with pixels in R(s)
                }
            }
            finish = true;
            real lb = std::max(0.0, bounds(j, 0) - 1);
            real ub = std::min(VD.getNc(), bounds(j, 1));
            for (real i = lb; i < ub; ++i) {
                if (!VD.getVByIdx(j, i)){// && VD.getLamByIdx(j, i) == s.second) {
                    Wop(j, i) = val;
                }
            }
        }
        ++is;
    }

    plhs[0] = mxCreateDoubleMatrix(Wop.rows(), Wop.cols(), mxREAL);
    real *wopPtr = mxGetDoubles(plhs[0]);
    Eigen::Map<Mat>(wopPtr, Wop.rows(), Wop.cols()) = Wop;
    if (nlhs == 2) {
        plhs[1] = mxCreateDoubleMatrix(Sop.rows(), Sop.cols(), mxREAL);
        real *sopPtr = mxGetDoubles(plhs[1]);
        Eigen::Map<Mat>(sopPtr, Sop.rows(), Sop.cols()) = Sop;
    }
}