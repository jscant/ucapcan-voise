//
// Created by root on 12/06/18.
//

#include <math.h>
#include <array>
#include <vector>
#include <algorithm>
#include <map>
#include <iostream>
#include <fstream>
#include <string>
#include "skizException.h"
#include "eigen/Eigen/Dense"

#ifndef SKIZ_AUX_H
#define SKIZ_AUX_H

double sqDist(double p1, double p2, double q1, double q2);
std::array<double, 2> circumcentre(double ax, double ay, double bx, double by, double cx, double cy);
bool inVector(const std::vector<double> &vec, double item);
void updateDict(std::map<double, std::vector<double>> &d, double key, double value);
void saveArray(const Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> &arr, std::string filename);
void printVector(std::vector<double> v);

#endif //SKIZ_AUX_H