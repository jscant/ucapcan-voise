//
// Created by root on 01/07/18.
//

#ifndef STANDALONE_SKIZ_LOADSTRUCT_H
#define STANDALONE_SKIZ_LOADSTRUCT_H

#include <vector>
#include "../../typedefs.h"
#include "../../vd.h"


struct loadStruct{
    RealVec Sx;
    RealVec Sy;
    loadStruct(uint32 rows, uint32 cols) : VD(rows, cols) {};
    ~loadStruct() {} ;
    vd VD;
};

#endif //STANDALONE_SKIZ_LOADSTRUCT_H
