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
#include <valgrind/callgrind.h>
#include <string>

#include "addSeed.h"
#include "vd.h"
#include "removeSeed.h"
#include "getRegion.h"
#include "NSStar.h"
#include "skizException.h"
#include "typedefs.cpp"
#include "aux-functions/readSeeds.h"
#include "aux-functions/readMatrix.h"
#include "aux-functions/metrics.h"
#include "test/test-help-fns/loadStruct.h"
#include "test/test-help-fns/loadVD.h"


typedef std::chrono::high_resolution_clock now;

using namespace std::chrono;

int main() {

    std::string path = "../src/test/resources/";
    loadStruct loadResults = loadVD(path, "benchVDSeeds512.txt", "benchVDLambda512.txt", "benchVDV512.txt");
    RealVec Sx = loadResults.Sx;
    RealVec Sy = loadResults.Sy;
    vd VD = loadResults.VD;
    unsigned long initSeedCount = VD.getSx().size();
    unsigned long ns = Sx.size();

    // addSeed timing
    auto start = now::now();
    for (uint32 i = 0; i < ns - initSeedCount; ++i) {
        addSeed(VD, Sx.at(i + initSeedCount), Sy.at(i + initSeedCount));

    }

    auto elapsed = now::now() - start;
    long long ms = duration_cast<microseconds>(elapsed).count() / (ns - 3);
    std::string str = "addSeed:\t\t" + std::to_string(ms) + " us per seed\n";
    std::cout << str.c_str();


    // removeSeed timing
    start = now::now();
    for (auto i = ns - 3; i > 0; --i) {
        if(i == 1000){
            CALLGRIND_START_INSTRUMENTATION;
        }
        removeSeed(VD, i);
        if(i == 1000){
            CALLGRIND_STOP_INSTRUMENTATION;
        }
    }

    elapsed = now::now() - start;
    ms = duration_cast<microseconds>(elapsed).count() / (ns - 3);
    str = "removeSeed:\t\t" + std::to_string(ms) + " us per seed\n";
    std::cout << str.c_str();

}