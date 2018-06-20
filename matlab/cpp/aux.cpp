#ifndef AUX_H
#define AUX_H
#include "aux.h"
#endif

#ifndef SKIZ_SKIZEXCEPTION_H
#define SKIZ_SKIZEXCEPTION_H
#include "skizException.h"
#endif

#ifndef MATH_H
#define MATH_H
#include <math.h>
#endif //MATH_H

#ifndef ALGORITHM_H
#define ALGORITHM_H
#include <algorithm>
#endif

#ifndef ARRAY_H
#define ARRAY_H
#include <array>
#endif //ARRAY_H

#ifndef VECTOR_H
#define VECTOR_H
#include <vector>
#endif //VECTOR_H

#ifndef MAP_H
#define MAP_H
#include <map>
#endif //MAP_H

#ifndef MEX_H
#define MEX_H
#include "mex.h"
#endif

//Use square distance where possible to avoid floating point precision problems
double sqDist(double p1, double p2, double q1, double q2){
    return (pow((p1 - q1), 2) + pow((p2 - q2), 2));
}

//Circumcentre of a triangle from cartesian coordinates
std::array<double, 2> circumcentre(double ax, double ay, double bx, double by, double cx, double cy){
    std::array<double, 2> result;
    double D = 2*((ax*(by-cy) + bx*(cy-ay) + cx*(ay-by)));
    if(D == 0){
        // Message not used, this is expected behaviour as cc does not exist, so cannot be 'within' any region
        std::string msg = "Collinear points:\n(" + std::to_string(ax) + ", " + std::to_string(ay) + ")\n" +
                std::to_string(bx) + ", " + std::to_string(by) + ")\n" +
                std::to_string(cx) + ", " + std::to_string(cy) + ")\n";
        throw SKIZLinearSeedsException(msg.c_str());
    }
    double Ux = ((pow(ax, 2) + pow(ay, 2))*(by-cy) + (pow(bx, 2) + pow(by, 2))*(cy-ay) +
          (pow(cx, 2) + pow(cy, 2))*(ay-by))/D;
    double Uy = ((pow(ax, 2) + pow(ay, 2))*(cx-bx) + (pow(bx, 2) + pow(by, 2))*(ax-cx) +
          (pow(cx, 2) + pow(cy, 2))*(bx-ax))/D;
    result.at(0) = Ux;
    result.at(1) = Uy;
    return result;
}

bool inVector(const std::vector<double> &vec, double item){
    if(vec.size() < 1){
        return false;
    }
    if(std::find(vec.begin(), vec.end(), item) != vec.end()) {
        return true;
    } else {
        return false;
    }
}

void updateDict(std::map<double, std::vector<double>> &d, double key, double value) {
    std::vector<double> lst = d[key];
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

template<class T>
void print(T value) {
    mexPrintf(toString(value).c_str());
    mexPrintf("\n");
}