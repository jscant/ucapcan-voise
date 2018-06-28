/*
 * Useful auxilliary functions - used in many higher level functions.
 */
#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif
#include <algorithm>
#include <array>
#include <vector>
#include <map>
#include <fstream>

#ifndef AUX_H
#define AUX_H

#include "aux.h"

#endif

#ifndef SKIZ_SKIZEXCEPTION_H
#define SKIZ_SKIZEXCEPTION_H

#include "skizException.h"

#endif

// Use square distance where possible to avoid floating point precision problems
real sqDist(const real &p1, const real &p2, const real &q1, const real &q2) {
    return (pow((p1 - q1), 2) + pow((p2 - q2), 2));
}

// Circumcentre of a triangle from cartesian coordinates
std::array<real, 2> circumcentre(const real &ax, const real &ay, const real &bx, const real &by, const real &cx,
                                 const real &cy) {

    std::array<real, 2> result;
    real D = 2 * ((ax * (by - cy) + bx * (cy - ay) + cx * (ay - by)));
    if (D == 0) {
        // Message only for debugging, this is expected behaviour as cc does not exist, so cannot be 'within' any region
        std::string msg = "Collinear points:\n(" + std::to_string(ax) + ", " + std::to_string(ay) + ")\n" +
                          std::to_string(bx) + ", " + std::to_string(by) + ")\n" +
                          std::to_string(cx) + ", " + std::to_string(cy) + ")\n";
        throw SKIZLinearSeedsException(msg.c_str());
    }
    real Ux = ((pow(ax, 2) + pow(ay, 2)) * (by - cy) + (pow(bx, 2) + pow(by, 2)) * (cy - ay) +
               (pow(cx, 2) + pow(cy, 2)) * (ay - by)) / D;
    real Uy = ((pow(ax, 2) + pow(ay, 2)) * (cx - bx) + (pow(bx, 2) + pow(by, 2)) * (ax - cx) +
               (pow(cx, 2) + pow(cy, 2)) * (bx - ax)) / D;
    result.at(0) = Ux;
    result.at(1) = Uy;
    return result;
}

// Boilerplate for checking for value in a vector (supports different types)
template<class T1, class T2>
bool inVector(const std::vector<T1> &vec, const T2 &item) {
    if (vec.size() < 1) {
        return false;
    }
    if (std::find(vec.begin(), vec.end(), (T1)item) != vec.end()) {
        return true;
    }
    return false;
}

// Adds value to dictionary ONLY if it does not already exist.
void updateDict(std::map<real, RealVec> &d, const real &key, const real &value) {
    RealVec lst = d[key];
    if (!inVector(lst, value)) {
        lst.push_back(value);
        d[key] = lst;
    }
}

std::vector<RealVec> readSeeds(std::string filename) {
    std::ifstream afile;
    afile.open(filename.c_str());
    RealVec Sx;
    RealVec Sy;
    unsigned int x = 0;
    real number;
    while(afile >> number){
        if(x % 2 == 0){
            Sx.push_back(number);
        } else {
            Sy.push_back(number);
        }
        x += 1;
    }
    std::vector<RealVec> result;
    result.push_back(Sx);
    result.push_back(Sy);
    return result;
}

Mat readMatrix(std::string filename, int nr, int nc) {
    std::ifstream afile;
    afile.open(filename.c_str());
    Mat result(nr, nc);
    unsigned int row = 0;
    unsigned int col = 0;
    real number;
    while(afile >> number){
        result(row, col) = number;
        if(col == 255){
            row += 1;
            col = 0;
        } else {
            ++col;
        }
    }
    return result;
}
