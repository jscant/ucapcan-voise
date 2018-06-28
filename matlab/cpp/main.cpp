/*
 * This is a 'standalone' version of the SKIZ algorithm for addition and removal of
 * seeds from a VD. The initial conditions are loaded from data saved in benchVD.m,
 * as well as the list of seeds to be added.
 * Profiling MEX files directly is difficult, especially on Linux, so this is both
 * with Callgrind and KCacheGrind to check for performance-reducing innefficiencies,
 * and with Valgrind to check for memory leaks. The reports of both can be found
 * at the end of the project report.
 */
#include <iostream>
#include <chrono>

#include "addSeed.h"

#ifndef VD_H
#define VD_H
#include "vd.h"
#endif

#include "removeSeed.h"
#include "getRegion.h"
#include "aux.h"
#include "skizException.h"

typedef std::chrono::high_resolution_clock now;
using namespace std::chrono;

int main() {
    int nc = 256, nr = 256;
    std::vector<RealVec> seeds = readSeeds("/home/jack/dev/standalone-skiz/benchVDSeeds.txt");
    Mat lam = readMatrix("/home/jack/dev/standalone-skiz/benchVDLambda.txt", nr, nc);
    Mat v = readMatrix("/home/jack/dev/standalone-skiz/benchVDV.txt", nr, nc);
    Mat px(nr, nc);
    Mat py(nr, nc);

    for (auto i = 0; i < nr; ++i) {
        for (auto j = 0; j < nc; ++j) {
            px(i, j) = j;
            py(i, j) = i;
        }
    }

    RealVec Sx = seeds.at(0);
    RealVec Sy = seeds.at(1);
    if (Sx.size() != Sy.size()) {
        throw (SKIZIOError("Lengths of Sx and Sy vectors not identical!"));
    }
    unsigned int ns = Sx.size();

    std::map<real, real> StartSx;
    std::map<real, real> StartSy;

    for (auto i = 0; i < 5; ++i) {
        StartSx[i + 1] = Sx.at(i);
        StartSy[i + 1] = Sy.at(i);
    }

    std::map<real, RealVec> Nk;
    Nk[1] = {5, 3, 4};
    Nk[2] = {5, 4};
    Nk[3] = {5, 4, 1};
    Nk[4] = {5, 3, 2, 1};
    Nk[5] = {3, 4, 2, 1};

    vd VD(nr, nc);
    VD.Vk.lam = lam;
    VD.Vk.v = v;
    VD.px = px;
    VD.py = py;
    VD.Sx = StartSx;
    VD.Sy = StartSy;
    VD.k = 5;
    VD.Nk = Nk;

    // addSeed timing
    auto start = now::now();
    for (auto i = 0; i < ns - 5; ++i) {
        addSeed(VD, Sx.at(i + 5), Sy.at(i + 5));
    }
    auto elapsed = now::now() - start;
    long long ms = duration_cast<microseconds>(elapsed).count() / (ns - 5);
    std::string str = "addSeed:\t\t" + std::to_string(ms) + " us per action\n";
    std::cout << str.c_str();

    // removeSeed timing
    start = now::now();
    for (auto i = ns - 5; i > 0; --i) {
        removeSeed(VD, i);
    }
    elapsed = now::now() - start;
    ms = duration_cast<microseconds>(elapsed).count() / (ns - 5);
    str = "removeSeed:\t\t" + std::to_string(ms) + " us per action\n";
    std::cout << str.c_str();
}