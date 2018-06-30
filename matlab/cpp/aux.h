/**
 * @file
 * @copydetails aux.cpp
 */
#ifndef AUX_H
#define AUX_H

#include <array>
#include <vector>
#include <map>
#include <eigen3/Eigen/Dense>

#include "typedefs.cpp"

real sqDist(const real &p1, const real &p2, const real &q1, const real &q2);
std::array<real, 2> circumcentre(const real &ax, const real &ay, const real &bx, const real &by, const real &cx,
                                 const real &cy);
template <class T1, class T2>
bool inVector(const std::vector<T1> &vec, const T2 &item);

void updateDict(std::map<real, RealVec> &d, const real &key, const real &value);

std::vector<RealVec> readSeeds(std::string filename);

Mat readMatrix(std::string filename, int nr, int nc);
#endif