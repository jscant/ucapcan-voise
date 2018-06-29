//
// Created by root on 12/06/18.
//

#include "vd.h"

vd::vd(real rows, real cols) {
    nr = rows;
    nc = cols;
}

vd::~vd() {
    return;
}

void vd::setVk(V_struct val) {
    Vk = val;
};

void vd::setW(W_struct val) {
    W = val;
};

void vd::setS(S_struct val) {
    S = val;
};

void vd::setLam(Mat newLam) {
    Vk.lam = newLam;
};

void vd::setV(Mat newV) {
    Vk.v = newV;
};

void vd::setLamByIdx(uint32 i, uint32 j, real val) {
    Vk.lam(i, j) = val;
};

void vd::setVByIdx(uint32 i, uint32 j, real val) {
    Vk.v(i, j) = val;
};

void vd::setSeeds(Mat s) {
    seeds = s;
};

void vd::setPx(Mat x) {
    px = x;
};

void vd::setPy(Mat y) {
    py = y;
};

void vd::setK(real val) {
    k = val;
};

void vd::setSx(std::map<real, real> val) {
    Sx = val;
};

void vd::setSy(std::map<real, real> val) {
    Sy = val;
};

void vd::setSk(std::map<real, real> val) {
    Sk = val;
};

void vd::setSxByIdx(uint32 idx, real val) {
    Sx[idx] = val;
};

void vd::setSyByIdx(uint32 idx, real val) {
    Sy[idx] = val;
};

void vd::setSkByIdx(uint32 idx, real val) {
    Sk[idx] = val;
};

void vd::setNk(std::map<real, RealVec> val) {
    Nk = val;
};

void vd::setNkByIdx(uint32 idx, RealVec val) {
    Nk[idx] = val;
};

void vd::incrementK() {
    k += 1;
};

V_struct vd::getVk() const {
    return Vk;
};

W_struct vd::getW() const {
    return W;
};

S_struct vd::getS() const {
    return S;
};

Mat vd::getLam() const {
    return Vk.lam;
};

Mat vd::getV() const {
    return Vk.v;
};

real vd::getLamByIdx(uint32 i, uint32 j) const {
    return Vk.lam(i, j);
};

real vd::getVByIdx(uint32 i, uint32 j) const {
    return Vk.v(i, j);
};

Mat vd::getSeeds() const {
    return seeds;
};

Mat vd::getPx() const {
    return px;
};

Mat vd::getPy() const {
    return py;
};

real vd::getK() const {
    return k;
};

real vd::getNr() const {
    return nr;
};

real vd::getNc() const {
    return nc;
};

std::map<real, real> vd::getSx() const {
    return Sx;
};

std::map<real, real> vd::getSy() const {
    return Sy;
};

std::map<real, real> vd::getSk() const {
    return Sk;
};

std::map<real, RealVec> vd::getNk() const {
    return Nk;
};

real vd::getSxByIdx(uint32 idx) const {
    return Sx.at(idx);
};

real vd::getSyByIdx(uint32 idx) const {
    return Sy.at(idx);
};

real vd::getSkByIdx(uint32 idx) const {
    return Sk.at(idx);
};

RealVec vd::getNkByIdx(uint32 idx) const {
    return Nk.at(idx);
};