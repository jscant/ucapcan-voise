#include "getOp.h"
#include "aux-functions/metrics.h"
#include "getRegion.h"
#include <omp.h>

void getVDOp(const vd &VD, const Mat &W, std::function<real(RealVec)> metric, real mult, Mat &Wop, Mat &Sop){

    // Average for each VR is independent (embarrassingly parallel)
    #pragma omp parallel for
    for (uint32 f = 0; f < VD.getSk().size(); ++f) {
        real s = VD.getSk().at(f);
        Mat bounds = getRegion(VD, s); // Get upper and lower bounds for each row of VR
        bool finish = false;
        real val;
        RealVec pixelValues;

        // Scan for pixels in each row of bounds
        for (int j = 0; j < bounds.rows(); ++j) {
            if (bounds(j, 0) == -1) {
                if (finish) {
                    break; // R(s) convex so we are done
                } else {
                    continue; // We have not yet reached a row with pixels in R(s)
                }
            }
            finish = true; // Region has started, next empty row signals finish
            uint32 lb = std::max(0.0, bounds(j, 0) - 1); // Lower bound of pixels in row of VR
            uint32 ub = std::min(VD.getNc(), bounds(j, 1)); // Upper bound of pixels in row of VR
            for (uint32 i = lb; i < ub; ++i) {
                if (!VD.getVByIdx(j, i)){ // If there is only 1 closest seed to pixel
                    pixelValues.push_back(W(j, i));
                } else if (VD.getLamByIdx(j, i) == s) {
                    Wop(j, i) = mxGetNaN(); // For consistency with Matlab implementation
                }
            }
        }

        val = mult * metric(pixelValues); // Apply average to pixel values of VR
        Sop(f, 0) = val; // Add average to list of averages

        // Now that we know the average, we can set the values of the output matrix
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
                if (!VD.getVByIdx(j, i)){
                    Wop(j, i) = val;
                }
            }
        }
    }

}
