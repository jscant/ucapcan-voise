//
// Created by root on 20/06/18.
//

#ifndef VECTOR_H
#define VECTOR_H
#include <vector>
#endif //VECTOR_H

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

RealVec Ns_star(const vd &VD);

