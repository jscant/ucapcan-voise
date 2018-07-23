/**
 * @file
 * @brief All includes for MEX functions. All files here have include guards.
 */

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <eigen3/Eigen/Dense>
#include <map>
#include <functional>
#include <string>

#include "grabVD.h"
#include "pushVD.h"
#include "grabW.h"

#include "../vd.h"
#include "../addSeed.h"
#include "../skizException.h"
#include "../getRegion.h"
#include "../typedefs.h"
#include "../getCentroid.h"
#include "../getOp.h"
#include "../removeSeed.h"

#include "../aux-functions/metrics.h"
