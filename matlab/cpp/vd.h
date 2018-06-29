//
// Created by root on 12/06/18.
//
// CHANGE FILENAME TO VD.H
#ifndef VD_H
#define VD_H

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif
#include <vector>
#include <map>
#include <algorithm>
#include <eigen3/Eigen/Dense>

#include "typedefs.cpp"

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
    void setVk(V_struct val);
    void setW(W_struct val);
    void setS(S_struct val);
    void setLam(Mat newLam);
    void setV(Mat newV);
    void setLamByIdx(uint32 i, uint32 j, real val);
    void setVByIdx(uint32 i, uint32 j, real val);
    void setSeeds(Mat s);
    void setPx(Mat x);
    void setPy(Mat y);
    void setK(real val);
    void setSx(std::map<real, real> val);
    void setSy(std::map<real, real> val);
    void setSk(std::map<real, real> val);
    void setSxByIdx(uint32 idx, real val);
    void setSyByIdx(uint32 idx, real val);
    void setSkByIdx(uint32 idx, real val);
    void setNk(std::map<real, RealVec> val);
    void setNkByIdx(uint32 idx, RealVec val);
    void incrementK();

    V_struct getVk() const;
    W_struct getW() const;
    S_struct getS() const;
    Mat getLam() const;
    Mat getV() const;
    real getLamByIdx(uint32 i, uint32 j) const;
    real getVByIdx(uint32 i, uint32 j) const;
    Mat getSeeds() const;
    Mat getPx() const;
    Mat getPy() const;
    real getK() const;
    real getNr() const;
    real getNc() const;
    std::map<real, real> getSx() const;
    std::map<real, real> getSy() const;
    std::map<real, real> getSk() const;
    std::map<real, RealVec> getNk() const;
    real getSxByIdx(uint32 idx) const;
    real getSyByIdx(uint32 idx) const;
    real getSkByIdx(uint32 idx) const;
    RealVec getNkByIdx(uint32 idx) const;

    vd(real rows, real cols);
    ~vd();
};

#endif