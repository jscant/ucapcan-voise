/**
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
#include "NSStar.h"
#include "skizException.h"
#include "typedefs.cpp"
#include "aux-functions/readSeeds.h"
#include "aux-functions/readMatrix.h"
#include "aux-functions/metrics.h"
#include <valgrind/callgrind.h>
typedef std::chrono::high_resolution_clock now;

using namespace std::chrono;

int main() {
    int nr = 1024, nc = 1024;
    std::vector<RealVec> seeds = readSeeds("../src/test/resources/benchVDSeeds" + std::to_string(nr) + ".txt");
    Mat lam = readMatrix("../src/test/resources/benchVDLambda" + std::to_string(nr) + ".txt", nr, nc);
    Mat v = readMatrix("../src/test/resources/benchVDV" + std::to_string(nr) + ".txt", nr, nc);

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
        throw (SKIZIOException("Lengths of Sx and Sy vectors not identical!"));
    }
    uint32 ns = Sx.size();

    RealVec StartSx;
    RealVec StartSy;
    RealVec StartSk;


    for (auto i = 0; i < 3; ++i) {
        StartSx.push_back(Sx.at(i));
        StartSy.push_back(Sy.at(i));
        StartSk.push_back(i + 1);
    }

    std::map<real, RealVec> Nk;
    Nk[1] = {3, 2};
    Nk[2] = {3, 1};
    Nk[3] = {1, 2};

    vd VD(nr, nc);
    VD.setLam(lam);
    VD.setV(v);
    VD.setPx(px);
    VD.setPy(py);
    VD.setSx(StartSx);
    VD.setSy(StartSy);
    VD.setSk(StartSk);
    VD.setK(3);
    VD.setNk(Nk);



    // addSeed timing
    auto start = now::now();
    auto elapsed = now::now() - start;
    long long ms = duration_cast<nanoseconds>(elapsed).count();
    std::string str = std::to_string(10) + "\t" + std::to_string(ms) + "\n";
    int x = 0;
    for (uint32 i = 0; i < ns - 3; ++i) {
        if(x == 0) {
            start = now::now();
        }
        x += 1;
        addSeed(VD, Sx.at(i + 3), Sy.at(i + 3));
        if(x == 1) {
            x = 0;
            elapsed = now::now() - start;
            ms = duration_cast<microseconds>(elapsed).count();
            str = std::to_string(i) + "\t" + std::to_string(ms) + "\n";
           // std::cout << str.c_str();
        }
    }

    //auto elapsed = now::now() - start;
    //long long ms = duration_cast<microseconds>(elapsed).count() / (ns - 3);
    //std::string str = "addSeed:\t\t" + std::to_string(ms) + " us per seed\n";
    //std::cout << str.c_str();


    // removeSeed timing
    //start = now::now();
            x = 0;
    for (auto i = ns - 3; i > 0; --i) {
        if(x == 0) {
            start = now::now();
        }
        x += 1;
        removeSeed(VD, i);
        if(x == 1) {
            x = 0;
            elapsed = now::now() - start;
            ms = duration_cast<microseconds>(elapsed).count();
            str = std::to_string(i) + "\t" + std::to_string(ms) + "\n";
            std::cout << str.c_str();
        }
    }


    //elapsed = now::now() - start;
    //ms = duration_cast<microseconds>(elapsed).count() / (ns - 3);
    //str = "removeSeed:\t\t" + std::to_string(ms) + " us per seed\n";
    //std::cout << str.c_str();

}