#ifndef VD_H
#define VD_H
#include "vd.h"
#endif

#ifndef VECTOR_H
#define VECTOR_H
#include <vector>
#endif //VECTOR_H

#ifndef REALVEC
#define REALVEC
typedef std::vector<double> RealVec;
#endif

bool pointInRegion(const vd &VD, std::array<double, 2> pt, double s, RealVec A);