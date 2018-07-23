#include "proposition2.h"
#include <iostream>

uint32 proposition2(const vd &VD, uint32 lam, const RealVec &candidates, std::array<real, 2> cc){
    uint32 ns = candidates.size();
    if(ns == 1){
        return candidates.at(0);
    }
    RealVec angles;
    for(uint32 i = 0; i < ns; ++i){
        real angle1 = atan2(VD.getSyByIdx(candidates.at(i)) - cc[1], VD.getSxByIdx(candidates.at(i)) - cc[0]);
        real angle2 = atan2(VD.getSyByIdx(VD.getK()) - cc[1], VD.getSxByIdx(VD.getK()) - cc[0]);
        real angleDiff = fmod(angle1 - angle2 + 2*M_PI, M_PI);
        angles.push_back(angleDiff);
    }
    real lamAngle1 = atan2(VD.getSyByIdx(lam) - cc[1], VD.getSxByIdx(lam) - cc[0]);
    real lamAngle2 = atan2(VD.getSyByIdx(VD.getK()) - cc[1], VD.getSxByIdx(VD.getK()) - cc[0]);
    real lamAngleDiff = fmod(lamAngle1 - lamAngle2 + 2*M_PI, M_PI);

    RealVec::iterator maxElementIt = std::max_element(angles.begin(), angles.begin() + ns);
    uint32 result;
    if(lamAngleDiff >= *maxElementIt){
        result = candidates.at(std::distance(angles.begin(), maxElementIt));
    } else {
        result = candidates.at(std::distance(angles.begin(), std::min_element(angles.begin(), angles.begin() + ns)));
    }
    std::cout << result << "\n";
    return result;
}