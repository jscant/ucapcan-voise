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

Mat readMatrix(std::string filename, int nr, int nc);
#endif