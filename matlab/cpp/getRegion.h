#include <eigen3/Eigen/Dense>

#ifndef VD_H
#define VD_H
#include "vd.h"
#endif

#ifndef MAT
#define MAT
typedef Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

Mat getRegion(const vd &VD, double s);
