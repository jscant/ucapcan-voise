/**
 * @file
 * @brief Finds average pixel intensity of VRs in VD.
 *
 * @date Created 31/07/18
 * @author Jack Scantlebury
 */
#include "getOp.h"
#include "aux-functions/metrics.h"
#include "getRegion.h"
#include "typedefs.h"
#include <omp.h>

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

/**
 * @defgroup getVDOp getVDOp
 * @ingroup getVDOp
 * @brief Finds average pixel intensity of VRs in VD.
 *
 * Given a matrix of pixel intensities W partitioned into a Voronoi diagram,
 * for each Voronoi region R(s), every pixel in each region is assigned the
 * average intensity of pixels in R(s). This gives the VOISE representation of
 * the image. Can use any type of average. Once average for VR has been
 * calculated, all corresponding pixels in result are assigned that value.
 * Pixels with \f$\nu\f$ = 1 are assigned either NaN (if used as MEX binary) or
 * -INF (otherwise).
 *
 * @param vd Voronoi Diagram
 * @param W Eigen::Array of pixel intensities
 * @param metric std::function<real(RealVec)> Function handle for type of
 * average to use
 * @param mult Multiplier of return value.
 * @param Wop Empty Eigen::Array for storage of average pixel intensity
 * (matrix of pixel intensities)
 * @param Sop Empty Eigen::Array for storage of averge pixel intensity (list
 * of VR averages)
 * @returns Wop Eigen::Array containing average pixel intensity (matrix of
 * pixel intensities)
 * @returns Sop Eigen::Array for storage of average pixel intensity (list of
 * VR averages)
 */
void getVDOp(const vd &VD, const Mat &W, std::function<real(RealVec)> metric,
             real mult, Mat &Wop, Mat &Sop){

    // Average for each VR is independent (embarrassingly parallel)
    #pragma omp parallel for
    for (uint32 f = 0; f < VD.getSk().size(); ++f) {
        real s = VD.getSk().at(f);
        Mat bounds = getRegion(VD, s); // Upper and lower bounds for rows of VR
        bool finish = false;
        real val;
        RealVec pixelValues;

        // Scan for pixels in each row of bounds 
        for (int j = 0; j < bounds.rows(); ++j) {
            if (bounds(j, 0) == -1) {
                if (finish) {
                    break; // R(s) convex so we are done
                } else { // We have not yet reached a row with pixels in R(s)
                    continue;
                }
            }
            finish = true; // Region has started, next empty row signals finish

            // Lower and upper bounds of pixels in row of R(s)
            uint32 lb = std::max(0.0, bounds(j, 0) - 1);
            uint32 ub = std::min((real)VD.getNc(), bounds(j, 1));
            for (uint32 i = lb; i < ub; ++i) {
                if (!VD.getVByIdx(j, i)){ // Closest seed is unique
                    pixelValues.push_back(W(j, i));
                } else {
                    /*
                     * There are 2 or more closest seeds to pixel. In matlab,
                     * we use NaN (inkeeping with rest of VOISE algorithms and
                     * pre-existing VOISE functions). For unit testing, where
                     * mxGetNan is not defined, we use -infinity in place of
                     * NaN.                     *
                     */
                    #ifdef MATLAB_MEX_FILE // Running MEX compiler or 'normal'?
                        Wop(j, i) = mxGetNaN(); // For consistency with Matlab implementation
                    #else
                        Wop(j, i) = -INF;
                    #endif
                }
            }
        }

        val = mult * metric(pixelValues); // Apply average to pixel values of VR
        Sop(f, 0) = val; // Add average to list of averages

        /*
         * Now that we know the average for each region, we can set the values
         * of the output matrix.
        */
        finish = false;
        for (int j = 0; j < bounds.rows(); ++j) {
            if (bounds(j, 0) == -1) {
                if (finish) {
                    break; // R(s) convex so we are done
                } else {
                    continue;
                }
            }
            finish = true;
            real lb = std::max(0.0, bounds(j, 0) - 1);
            real ub = std::min((real)VD.getNc(), bounds(j, 1));
            for (real i = lb; i < ub; ++i) {
                if (!VD.getVByIdx(j, i)){
                    Wop(j, i) = val; // All pixels in VR populated with average
                }
            }
        }
    }

}
