/**
 * @file
 * @brief Struct so that we can return VD and lists of seeds to add for unit
 * testing.
 *
 * @date Created 01/07/18
 * @date Modified 25/07/18
 * @author Jack Scantlebury
 */
#ifndef STANDALONE_SKIZ_LOADSTRUCT_H
#define STANDALONE_SKIZ_LOADSTRUCT_H

#include <vector>
#include "../../typedefs.h"
#include "../../vd.h"

/**
 * @struct loadStruct
 * @brief Used for loading and returning seed data for unit testing
 */
struct loadStruct{
    /// Vector of x coordinates of seeds
    RealVec Sx;

    /// Vector of y coordinates of seeds
    RealVec Sy;

    /// Voronoi diagram with initial configuration
    vd VD;

    loadStruct(uint32 rows, uint32 cols) : VD(rows, cols) {};
    ~loadStruct() {} ;
};

#endif //STANDALONE_SKIZ_LOADSTRUCT_H
