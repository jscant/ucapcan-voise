/**
 * @file
 * @copydetails loadVD.cpp
 *
 * @date Created 01/07/18
 * @author Jack Scantlebury
 */

#ifndef STANDALONE_SKIZ_LOADVD_H
#define STANDALONE_SKIZ_LOADVD_H

#include "loadStruct.h"
#include <string>

loadStruct loadVD(std::string basePath, std::string seedsFname, std::string lambdaFname, std::string vFname);

#endif //STANDALONE_SKIZ_LOADVD_H
