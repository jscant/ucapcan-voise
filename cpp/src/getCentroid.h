#ifndef GETCENTROID_H
#define GETCENTROID_H

#include <eigen3/Eigen/Dense>

#include "typedefs.h"
#include "vd.h"

Mat getCentroid(const vd &VD, const Mat &W, const RealVec seeds);

#endif //GETCENTROID_H
