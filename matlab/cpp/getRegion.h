
#ifndef EIGEN_DENSE_H
#define EIGEN_DENSE_H
#include "eigen/Eigen/Dense"
#endif

#ifndef VD_H
#define VD_H
#include "vd.h"
#endif

#ifndef MAT
#define MAT
typedef Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

Mat getRegion(const vd &VD, double s);
