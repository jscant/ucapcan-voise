/**
 * @file
 * @brief Struct so that we can return VD and lists of seeds to add for unit
 * testing.
 *
 * @date Created 01/07/18
 * @date Modified 25/07/18
 */
#ifndef STANDALONE_SKIZ_LOADSTRUCT_H
#define STANDALONE_SKIZ_LOADSTRUCT_H

#include <vector>
#include "../../typedefs.h"
#include "../../vd.h"

/**
 * @struct
 */
struct loadStruct{
    RealVec Sx; /// Vector of x coordinates of seeds
    RealVec Sy; /// Vector of y coordinates of seeds
    loadStruct(uint32 rows, uint32 cols) : VD(rows, cols) {};
    ~loadStruct() {} ;
    vd VD; /// Voronoi diagram with initial configuration
};

#endif //STANDALONE_SKIZ_LOADSTRUCT_H
