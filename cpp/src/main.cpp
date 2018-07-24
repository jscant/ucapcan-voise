/**
 * This is a 'standalone' version of the SKIZ algorithm for addition and
 * removal of seeds from a VD. The initial conditions are loaded from data
 * saved in benchVD.m, as well as the list of seeds to be added. Profiling
 * MEX files directly is difficult, especially on Linux, so this is both
 * with Callgrind and KCacheGrind to check for performance-reducing
 * innefficiencies, and with Valgrind to check for memory leaks.
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
#include "typedefs.h"
#include "aux-functions/readSeeds.h"
#include "aux-functions/readMatrix.h"
#include "aux-functions/metrics.h"
#include "test/test-help-fns/loadStruct.h"
#include "test/test-help-fns/loadVD.h"

typedef std::chrono::high_resolution_clock now;

using namespace std::chrono;

int main() {

    // Load VD and seed data
    std::string path = "../src/test/resources/";
    loadStruct loadResults = loadVD(path, "benchVDSeeds256.txt",
            "benchVDLambda256.txt", "benchVDV256.txt");
    RealVec Sx = loadResults.Sx;
    RealVec Sy = loadResults.Sy;
    vd VD = loadResults.VD;
    auto k = VD.getK();
    unsigned long initSeedCount = VD.getSx().size();
    unsigned long ns = Sx.size();

    // addSeed timing
    auto start = now::now();
    for (uint32 i = 0; i < ns - initSeedCount; ++i) {
        addSeed(VD, Sx.at(i + initSeedCount), Sy.at(i + initSeedCount));
    }

    // Calculate and print average time per seed (add)
    auto elapsed = now::now() - start;
    long long ms = duration_cast<microseconds>(elapsed).count() / (ns - k);
    std::string str = "addSeed:\t\t" + std::to_string(ms) + " us per seed\n";
    std::cout << str.c_str();

    // removeSeed timing
    start = now::now();
    for (auto i = ns - k; i > 0; --i) {
        if(i == 1000){ // For profiling the removal of the 1000th seed
            CALLGRIND_START_INSTRUMENTATION;
        }
        removeSeed(VD, i);
        if(i == 1000){
            CALLGRIND_STOP_INSTRUMENTATION;
        }
    }

    // Calculate and print average time per seed (remove)
    elapsed = now::now() - start;
    ms = duration_cast<microseconds>(elapsed).count() / (ns - k);
    str = "removeSeed:\t\t" + std::to_string(ms) + " us per seed\n";
    std::cout << str.c_str();

}