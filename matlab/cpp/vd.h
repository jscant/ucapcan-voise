//
// Created by root on 12/06/18.
//
// CHANGE FILENAME TO VD.H
#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif
#include <vector>
#include <map>
#include <algorithm>
#include <eigen3/Eigen/Dense>

#ifndef TYPEDEFS
#define TYPEDEFS
typedef double real;
typedef std::vector<real> RealVec;
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

struct W_struct {
    real xm;
    real ym;
    real xM;
    real yM;
};

struct S_struct {
    real xm;
    real ym;
    real xM;
    real yM;
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
    real nc, nr, k;
    Mat seeds, px, py;
    std::map<real, real> Sx, Sy, Sk;
    std::map<real, RealVec> Nk;
    void setVk(V_struct val) {
        Vk = val;
    };
    void setW(W_struct val) {
        W = val;
    };
    void setS(S_struct val) {
        S = val;
    };
    void setLam(Mat newLam) {
        Vk.lam = newLam;
    };
    void setV(Mat newV) {
        Vk.v = newV;
    };
    void setLamByIdx(unsigned int i, unsigned int j, real val) {
        Vk.lam(i, j) = val;
    };
    void setVByIdx(unsigned int i, unsigned int j, real val) {
        Vk.v(i, j) = val;
    };
    void setSeeds(Mat s) {
        seeds = s;
    };
    void setPx(Mat x) {
        px = x;
    };
    void setPy(Mat y) {
        py = y;
    };
    void setK(real val) {
        k = val;
    };
    void setSx(std::map<real, real> val) {
        Sx = val;
    };
    void setSy(std::map<real, real> val) {
        Sy = val;
    };
    void setSk(std::map<real, real> val) {
        Sk = val;
    };
    void setSxByIdx(unsigned int idx, real val) {
        Sx[idx] = val;
    };
    void setSyByIdx(unsigned int idx, real val) {
        Sy[idx] = val;
    };
    void setSkByIdx(unsigned int idx, real val) {
        Sk[idx] = val;
    };
    void setNk(std::map<real, RealVec> val) {
        Nk = val;
    };
    void setNkByValue(unsigned int idx, RealVec val) {
        Nk[idx] = val;
    };

    V_struct getVk() const {
        return Vk;
    };
    W_struct getW() const {
        return W;
    };
    S_struct getS() const {
        return S;
    };
    Mat getLam() const {
        return Vk.lam;
    };
    Mat getV() const {
        return Vk.v;
    };
    real getLamByIdx(unsigned int i, unsigned int j) const {
        return Vk.lam(i, j);
    };
    real getVByIdx(unsigned int i, unsigned int j) const {
        return Vk.v(i, j);
    };
    Mat getSeeds() const {
        return seeds;
    };
    Mat getPx() const {
        return px;
    };
    Mat getPy() const {
        return py;
    };
    real getK() const {
        return k;
    };
    real getNr() const {
        return nr;
    };
    real getNc() const {
        return nc;
    };
    std::map<real, real> getSx() const {
        return Sx;
    };
    std::map<real, real> getSy() const {
        return Sy;
    };
    std::map<real, real> getSk() const {
        return Sk;
    };
    std::map<real, RealVec> getNk() const {
        return Nk;
    };

    vd(real rows, real cols);
    ~vd();
};