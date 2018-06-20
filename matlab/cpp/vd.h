//
// Created by root on 12/06/18.
//
// CHANGE FILENAME TO VD.H

#ifndef MEX_H
#define MEX_H
#include "mex.h"
#endif

#ifndef MATRIX_H
#define MATRIX_H
#include "matrix.h"
#endif

#ifndef VECTOR_H
#define VECTOR_H
#include <vector>
#endif

#ifndef MAP_H
#define MAP_H
#include <map>
#endif

#ifndef ALGORITHM_H
#define ALGORITHM_H
#include <algorithm>
#endif

#ifndef EIGEN_DENSE_H
#define EIGEN_DENSE_H
#include "eigen/Eigen/Dense"
#endif

#ifndef MAT
#define MAT
typedef Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

struct W_struct {
    double xm;
    double ym;
    double xM;
    double yM;
};

struct S_struct {
    double xm;
    double ym;
    double xM;
    double yM;
};

struct V_struct {
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
    void setVk(V_struct val) { Vk = val; };
    void setW(W_struct val) { W = val; };
    void setS(S_struct val) { S = val; };
    void setLam(Mat newLam) { Vk.lam = newLam; };
    void setV(Mat newV) { Vk.v = newV; };
    void setLamByIdx(mwIndex i, mwIndex j, double val) { Vk.lam(i, j) = val; };
    void setVByIdx(mwIndex i, mwIndex j, double val) { Vk.v(i, j) = val; };
    void setSeeds(Mat s) { seeds = s; };
    void setPx(Mat x) { px = x; };
    void setPy(Mat y) { py = y; };
    void setK(double val) { k = val; };
    void setSx(std::map<double, double> val) { Sx = val; };
    void setSy(std::map<double, double> val) { Sy = val; };
    void setSk(std::map<double, double> val) { Sk = val; };
    void setSxByIdx(mwIndex idx, double val) { Sx[idx] = val; };
    void setSyByIdx(mwIndex idx, double val) { Sy[idx] = val; };
    void setSkByIdx(mwIndex idx, double val) { Sk[idx] = val; };
    void setNk(std::map<double, std::vector<double>> val) { Nk = val; };
    void setNkByValue(mwIndex idx, std::vector<double> val) { Nk[idx] = val; };

    V_struct getVk() const { return Vk; };
    W_struct getW() const { return W; };
    S_struct getS() const { return S; };
    Mat getLam() const { return Vk.lam; };
    Mat getV() const { return Vk.v; };
    double getLamByIdx(mwIndex i, mwIndex j) const { return Vk.lam(i, j); };
    double getVByIdx(mwIndex i, mwIndex j) const { return Vk.v(i, j); };
    Mat getSeeds() const { return seeds; };
    Mat getPx() const { return px; };
    Mat getPy() const { return py; };
    double getK() const { return k; };
    double getNr() const { return nr; };
    double getNc() const { return nc; };
    std::map<double, double> getSx() const { return Sx; };
    std::map<double, double> getSy() const { return Sy; };
    std::map<double, double> getSk() const { return Sk; };
    std::map<double, std::vector<double>> getNk() const { return Nk; };

    vd(double rows, double cols);
    ~vd();
};