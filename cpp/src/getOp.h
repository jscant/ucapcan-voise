#ifndef GETOP_H
#define GETOP_H

#include "typedefs.h"
#include "vd.h"

void getVDOp(const vd &VD, const Mat &W, std::function<real(RealVec)> metric, real mult, Mat &Wop, Mat &Sop);

#endif // GETOP_H
