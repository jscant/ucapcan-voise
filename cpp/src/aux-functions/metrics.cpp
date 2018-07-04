//
// Created by root on 03/07/18.
//

#include "metrics.h"

#ifdef MATLAB_MEX_FILE
#include <mex.h>
#include <matrix.h>
#endif

#include <vector>
#include <numeric>
#include <algorithm>

real mean(RealVec vec){
    return std::accumulate(vec.begin(), vec.end(), 0.0)/vec.size();
}

real median(RealVec vec){
    std::sort(vec.begin(), vec.end());
    uint32 size = vec.size();
    if(size % 2 == 0){
        return 0.5*(vec.at((size/2) - 1) + vec.at(size/2));
    }
    return vec.at((size - 1)/2);
}

real sqrtLen(RealVec vec){
    return sqrt(vec.size());
}

real maxMin(RealVec vec){
    real max = *max_element(vec.begin(), vec.end());
    real min = *min_element(vec.begin(), vec.end());
    return max - min;
}

real stdDev(RealVec vec){
    real N = vec.size();
    if(N == 1 || N == 0){
        return 0;
    }
    real sum = std::accumulate(vec.begin(), vec.end(), 0.0);
    real mean = sum/N;
    real sumOfSquares = 0.0;
    for(auto i = 0; i < N; ++i){
        sumOfSquares += pow(vec.at(i) - mean, 2);
    }
    return sqrt(sumOfSquares/(N-1));
}