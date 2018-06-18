//
// Created by root on 16/06/18.
//

//#include "aux.h"
#include "aux.cpp"
#include "vd.h"

vd addSeed(vd VD, double s1, double s2);
std::vector<double> Ns_star(const vd &VD);
bool pointInRegion(const vd &VD, std::array<double, 2> pt, double s, std::vector<double> A);
Mat getRegion(const vd &VD, double s);

