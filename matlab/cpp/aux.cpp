#include <mex.h>
#include <math.h>
#include <algorithm>
#include <array>
#include <vector>
#include <map>

#ifndef AUX_H
#define AUX_H
#include "aux.h"
#endif

#ifndef SKIZ_SKIZEXCEPTION_H
#define SKIZ_SKIZEXCEPTION_H
#include "skizException.h"
#endif

//Use square distance where possible to avoid floating point precision problems
real sqDist(real p1, real p2, real q1, real q2){
    return (pow((p1 - q1), 2) + pow((p2 - q2), 2));
}

//Circumcentre of a triangle from cartesian coordinates
std::array<real, 2> circumcentre(real ax, real ay, real bx, real by, real cx, real cy){
    std::array<real, 2> result;
    real D = 2*((ax*(by-cy) + bx*(cy-ay) + cx*(ay-by)));
    if(D == 0){
        // Message not used, this is expected behaviour as cc does not exist, so cannot be 'within' any region
        std::string msg = "Collinear points:\n(" + std::to_string(ax) + ", " + std::to_string(ay) + ")\n" +
                std::to_string(bx) + ", " + std::to_string(by) + ")\n" +
                std::to_string(cx) + ", " + std::to_string(cy) + ")\n";
        throw SKIZLinearSeedsException(msg.c_str());
    }
    real Ux = ((pow(ax, 2) + pow(ay, 2))*(by-cy) + (pow(bx, 2) + pow(by, 2))*(cy-ay) +
          (pow(cx, 2) + pow(cy, 2))*(ay-by))/D;
    real Uy = ((pow(ax, 2) + pow(ay, 2))*(cx-bx) + (pow(bx, 2) + pow(by, 2))*(ax-cx) +
          (pow(cx, 2) + pow(cy, 2))*(bx-ax))/D;
    result.at(0) = Ux;
    result.at(1) = Uy;
    return result;
}

bool inVector(const RealVec &vec, real item){
    if(vec.size() < 1){
        return false;
    }
    if(std::find(vec.begin(), vec.end(), item) != vec.end()) {
        return true;
    } else {
        return false;
    }
}

void updateDict(std::map<real, RealVec> &d, real key, real value) {
    RealVec lst = d[key];
    if(!inVector(lst, value)){
        lst.push_back(value);
        d[key] = lst;
    }
}

std::string toString(const char *&t) {
    return t;
}

std::string toString(const std::string &t) {
    return t;
}

template<class T>
std::string toString(const T &t) {
    return std::to_string(t);
}

namespace aux {
    template<class T>
    void print(T value) {
        mexPrintf(toString(value).c_str());
        mexPrintf("\n");
    }

    void print(real value) {
        mexPrintf(toString(value).c_str());
        mexPrintf("\n");
    }
}