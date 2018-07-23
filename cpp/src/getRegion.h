/**
 * @file
 * @copydetails getRegion.cpp
 */
#ifndef GETREGION_H
#define GETREGION_H

#include <eigen3/Eigen/Dense>

#include "vd.h"
#include "typedefs.h"

Mat getRegion(const vd &VD, const real &s);

#endif