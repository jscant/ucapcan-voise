/*
 * Adds seed to voronoi diagram. Parameters:
 * vd VD: voronoi diagram object (definition inf vd.h)
 * real s1: first coordinate of seed to be added
 * real s2: second coordinate of seed to be added
 * Method used is taken from "Discrete Voronoi Diagrams and the SKIZ
    Operator: A Dynamic Algorithm" [doi: 10.1109/34.625128]
    All references to sections and equations in this file are from
    the above paper.
 */

#ifndef VD_H
#define VD_H
#include "vd.h"
#endif

bool addSeed(vd &VD, real s1, real s2);

