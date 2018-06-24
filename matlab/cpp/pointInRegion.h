#ifndef VD_H
#define VD_H
#include "vd.h"
#endif

#ifndef VECTOR_H
#define VECTOR_H
#include <vector>
#endif //VECTOR_H

#ifndef TYPEDEFS
#define TYPEDEFS
typedef double real;
typedef std::vector<real> RealVec;
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

bool pointInRegion(const vd &VD, std::array<real, 2> pt, real s, RealVec A);