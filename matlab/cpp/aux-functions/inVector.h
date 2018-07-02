/**
 * @file
 * @brief Checks whether item exists within a vector. Header only for templating/linking reasons.
 */

#ifndef INVECTOR_H
#define INVECTOR_H
#include <vector>
#include "../typedefs.cpp"

/**
 * @defgroup inVector inVector
 * @ingroup inVector
 * @{
 * @brief Checks whether or not item is in vector. Templated so inputs don't have to be of the same (numeric) type.
 * @param vec Vector to be checked for item
 * @param item Item to be looked for
 * @returns true: item is in vector
 * @returns false: item is not in vector
 *
 */
template <class T1, class T2>
bool inVector(const std::vector<T1> &vec, const T2 &item) {
    if (vec.size() < 1) {
        return false;
    }
    if (std::find(vec.begin(), vec.end(), (T1)item) != vec.end()) {
        return true;
    }
    return false;
}

#endif