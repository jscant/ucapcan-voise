/**
 * @file
 * @copydoc pointInRegion.cpp
 */

#ifndef POINTINREGION_H
#define POINTINREGION_H

#include <vector>

#include "vd.h"
#include "typedefs.h"

bool pointInRegion(const vd &VD, std::array<real, 2> pt, real s,
                   RealVec A = {});

#endif