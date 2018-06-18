//
// Created by root on 12/06/18.
//
// CHANGE FILENAME TO VD.H

#include <vector>
#include <map>
#include <algorithm>
#include "eigen/Eigen/Dense"
#include "aux.h"
#ifndef SKIZ_VD_H
#define SKIZ_VD_H

typedef Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> Mat;
typedef Eigen::Matrix<double, Eigen::Dynamic, 1> Vec;

struct W_struct
{
    double xm;
    double ym;
    double xM;
    double yM;
};

struct S_struct
{
    double xm;
    double ym;
    double xM;
    double yM;
};

struct V_struct
{
    Mat lam;
    Mat v;
};

class vd {
public:
    V_struct Vk;
    W_struct W;
    S_struct S;
    double nc, nr, k;
    Mat seeds, px, py;
    std::map<double, double> Sx, Sy, Sk;
    std::map<double, std::vector<double>> Nk;
    vd(double rows, double cols);
    ~vd();
};

#endif //SKIZ_VD_H
