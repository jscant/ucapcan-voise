/**
 * @file
 * @brief Function to check whether coordinate array exists in vector of
 * coordinate arrays.
 *
 * @date Created 25/08/18
 * @author Jack Scantlebury
 */

#ifndef ARRAYPOSINVECTOR_H
#define ARRAYPOSINVECTOR_H

#include "../typedefs.h"

/**
 * @defgroup arrayPosInVector arrayPosInVector
 * @ingroup arrayPosInVector
 * @brief Checks for presence and position of array in vector. Used for checking
 * whether or not coordinates exist in vector of coordinates (NSStar.cpp)
 * @tparam T1 Numerical type
 * @param vec Vector of std::array<real, 2> coordinates
 * @param arr Coordinate to check
 * @return -1 if arr not in vec, position of arr in vec otherwise
 */
template <class T1>
int arrayPosInVector(std::vector<std::array<T1, 2>> vec, std::array<T1, 2> arr){
    int pos = -1; // -1 if not in vector
    for(uint32 i = 0; i < vec.size(); ++i){
        if(fabs(vec[i][0] - arr[0]) < EPS && fabs(vec[i][1] - arr[1]) < EPS){
            return i;
        }
    }
    return pos;
}

#endif
