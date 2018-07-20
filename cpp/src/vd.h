/**
 * @file
 * @copydetails vd.cpp
 */
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

/**
 * @struct W_struct
 * @brief as defined in [1], Section 2.2. Only for use with VOISE algorithm matlab interface. Unused but here for
 * consistency.
 * @var xm Lowest value of x in W
 * @var xM Highest value of x in W
 * @var ym Lowest value of y in W
 * @var yM Highest value of y in W
 */
struct W_struct {
    real xm;
    real ym;
    real xM;
    real yM;
};

/**
 * @struct V_struct
 * @brief as defined in [1], Section 3 (Vk).
 * @var lam Eigen::Array matrix of \f$ \lambda \f$ for each pixel
 * @var v Eigen::Array matrix of \f$ \nu \f$ for each pixel
 */
struct V_struct {
    Mat lam;
    Mat v;
};

/**
 * @class vd
 * @brief Contains all information about voronoi diagram needed to perform SKIZ algorithm from [1]
 */
class vd {
private:
    real nc, nr, k;
    std::map<real, RealVec> Nk;
    V_struct Vk;
    Mat seeds, px, py;
    RealVec Sx, Sy, Sk;
public:
    W_struct W;
    W_struct S;
    void setVk(V_struct val);
    void setW(W_struct val);
    void setS(W_struct val);
    void setLam(Mat newLam);
    void setV(Mat newV);
    void setLamByIdx(uint32 i, uint32 j, real val);
    void setVByIdx(uint32 i, uint32 j, real val);
    void setSeeds(Mat s);
    void setPx(Mat x);
    void setPy(Mat y);
    void setK(real val);
    void setSx(RealVec val);
    void setSy(RealVec val);
    void setSk(RealVec val);
    void setSxByIdx(uint32 idx, real val);
    void setSyByIdx(uint32 idx, real val);
    void setSkByIdx(uint32 idx, real val);
    void setNk(std::map<real, RealVec> val);
    void setNkByIdx(uint32 idx, RealVec val);
    void incrementK();
    void eraseSk(uint32 idx);

    V_struct getVk() const;
    W_struct getW() const;
    W_struct getS() const;
    Mat getLam() const;
    Mat getV() const;
    real getLamByIdx(uint32 i, uint32 j) const;
    real getVByIdx(uint32 i, uint32 j) const;
    Mat getSeeds() const;
    Mat getPx() const;
    Mat getPy() const;
    uint32 getK() const;
    uint32 getNr() const;
    uint32 getNc() const;
    RealVec getSx() const;
    RealVec getSy() const;
    RealVec getSk() const;
    std::map<real, RealVec> getNk() const;
    real getSxByIdx(uint32 idx) const;
    real getSyByIdx(uint32 idx) const;
    real getSkByIdx(uint32 idx) const;
    RealVec getNkByIdx(uint32 idx) const;
    real getPxByIdx(uint32 i, uint32 j);
    real getPyByIdx(uint32 i, uint32 j);

    void addSx(real val);
    void addSy(real val);
    void addSk(real val);

    vd(real rows, real cols);
    ~vd();
};

#endif