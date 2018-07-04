/**
 * @file
 * @brief Routine for adding to the vector in a dictionary of vectors only if the item does not already exist
 * (templated). Header only for templating/linking reasons.
 */

#ifndef UPDATEDICT_H
#define UPDATEDICT_H

#include <vector>
#include <map>

/**
 * @defgroup updateDict updateDict
 * @ingroup updateDict
 * @brief Custom routine for adding to the vector in a dictionary of vectors only if the item does not already exist
 * @param d Dictionary
 * @param key Key to be added
 * @param value Value to be added to vector
 */
template <class T1, class T2, class T3, class T4>
void updateDict(std::map<T1, std::vector<T2>> &d, const T3 &key, const T4 &value) {
    /// If key and corresponding vector do not exist, we create both and populate vector with value
    try{
        d.at(key);
    } catch (std::out_of_range &e){
        d[key] = std::vector<T2>();
        d.at(key).push_back((T2)value);
        return;
    }
    if (!inVector(d.at(key), (T2)value)) {
        d.at(key).push_back((T2)value);
    }
}

#endif // UPDATEDICT_H
