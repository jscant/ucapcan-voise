#ifndef GETCENTROID_H
#define GETCENTROID_H

#include <eigen3/Eigen/Dense>

#include "typedefs.cpp"
#include "vd.h"

Mat getCentroid(const vd &VD, const Mat &W, const real* seed, const uint32 ns);

#endif //GETCENTROID_H
