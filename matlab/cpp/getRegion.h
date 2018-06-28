#include <eigen3/Eigen/Dense>

#ifndef VD_H
#define VD_H
#include "vd.h"
#endif

#ifndef TYPEDEFS
#define TYPEDEFS
typedef double real;
typedef std::vector<real> RealVec;
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

Mat getRegion(const vd &VD, real s);
