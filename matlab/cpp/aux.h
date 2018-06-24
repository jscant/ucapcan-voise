//
// Created by root on 12/06/18.
//
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


double sqDist(double p1, double p2, double q1, double q2);
std::array<double, 2> circumcentre(double ax, double ay, double bx, double by, double cx, double cy);
bool inVector(const std::vector<double> &vec, double item);
void updateDict(std::map<double, std::vector<double>> &d, double key, double value);


// Some useful general purpose printing fns
std::string toString(const char *&t);

std::string toString(const std::string &t);

template<class T>
std::string toString(const T &t);

namespace aux {
    template<class T>
    void print(T value);


    void print(double value);
}