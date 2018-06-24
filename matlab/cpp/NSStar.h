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

#ifndef REALVEC
#define REALVEC
typedef std::vector<double> RealVec;
#endif

RealVec Ns_star(const vd &VD);

