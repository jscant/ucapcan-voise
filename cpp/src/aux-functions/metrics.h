/**
 * @file
 * @copydetails metrics.cpp
 */
#ifndef METRICS_H
#define METRICS_H

#include "../typedefs.h"

namespace metrics {
    real mean(RealVec vec);
    real median(RealVec vec);
    real sqrtLen(RealVec vec);
    real range(RealVec vec);
    real stdDev(RealVec vec);
}

#endif // METRICS_H
