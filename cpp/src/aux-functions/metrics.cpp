/**
 * @file
 * @brief Series of metrics to be used in getVDOp (substitute for Matlab's
 * ability to pass function handles as arguments). Used in VOISE.
 *
 * @date Created 03/07/18
 * @date Modified 24/07/18
 *
 * @author Jack Scantlebury
 */

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include "metrics.h"
#include <vector>
#include <numeric>
#include <algorithm>
#include "../skizException.h"

namespace metrics {

    /**
     * @defgroup mean metrics::mean
     * @ingroup mean
     * @brief Finds the mean of reals in a vector
     * @param vec Vector holding values to be averaged
     * @return Mean of values in vec
     */
    real mean(RealVec vec) {
        if (vec.size() == 0) {
            throw SKIZException("Mean of an empty vector is invalid");
        }
        return std::accumulate(vec.begin(), vec.end(), 0.0) / vec.size();
    }

    /**
     * @defgroup median metrics::median
     * @ingroup median
     * @brief Finds the median of reals in a vector
     * @param vec Vector holding values from which the median is found
     * @return Median of values in vec
     */
    real median(RealVec vec) {
        if (vec.size() == 0) {
            throw SKIZException("Median of an empty vector is invalid");
        }
        std::sort(vec.begin(), vec.end());
        uint32 size = vec.size();
        if (size % 2 == 0) {
            return 0.5 * (vec.at((size / 2) - 1) + vec.at(size / 2));
        }
        return vec.at((size - 1) / 2);
    }

    /**
     * @defgroup sqrtLen metrics::sqrtLen
     * @ingroup sqrtLen
     * @brief Finds the square root of the length of a vector
     * @param vec Vector holding values of which the square root of the
     * length is calculated
     * @return Square root of the length of a vector
     */
    real sqrtLen(RealVec vec) {
        return sqrt(vec.size());
    }

    /**
     * @defgruop range metrics::range
     * @ingroup range
     * @brief Finds the range of values in a vector
     * @param vec Vector holding values of which the range is to be found
     * @return Range of the items in the vector (maximum - minimum)
     */
    real range(RealVec vec) {
        if (vec.size() == 0) {
            throw SKIZException("Range of an empty vector is invalid");
        }
        real max = *max_element(vec.begin(), vec.end());
        real min = *min_element(vec.begin(), vec.end());
        return max - min;
    }

    /**
     * @defgroup stdDev metrics::stdDev
     * @ingroup stdDev
     * @brief Finds the standard deviation of a vector of numbers
     * @param vec Vector holding values over which the standard deviation is
     * to be found
     * @return Standard deviation of items in vector, as defined by:
     * \f[
     * \sigma = \sum_{i=1}^{N-1}\sqrt{\frac{(x_i-\bar{x})}{N - 1}}
     * \f]
     * where \f$\bar{x}\f$ is the mean of the \f$N\f$ vector values \f$x\f$
     */
    real stdDev(RealVec vec) {
        if (vec.size() == 0) {
            throw SKIZException("Standard devaition of an empty set is "
                                "undefined");
        }
        real N = vec.size();
        if (N == 1) {
            return 0;
        }
        real sum = std::accumulate(vec.begin(), vec.end(), 0.0);
        real mean = sum / N;
        real sumOfSquares = 0.0;
        for (auto i = 0; i < N; ++i) {
            sumOfSquares += pow(vec.at(i) - mean, 2);
        }
        return sqrt(sumOfSquares / (N - 1));
    }
}