/**
 * @file
 * @brief Small, useful auxilliary functions
*/

#include "aux.h"

// Overview page of Doxygen documentation has to go somewhere..:

/** @mainpage SKIZ Voronoi Diagram Tool and Matlab Bindings for VOISE Algorithm
 *
 * @section intro_sec Introduction
 *
 * The SKIZ operator algorithm, described by Sequeira and Preteux in [1], is an efficient way of calculating
 * and maintaining a Voronoi diagram in discrete 2D space. Unlike other, more popular algorithms such as Fortune's
 * Sweep, the SKIZ algorithm is dynamic so adding and removing seeds does not require recalculation of the entire graph.
 * Moreover, checking the bounds of a region R(s) and checking whether a pixel p belongs to a region R(s) is reduced
 * to evaluation of a small number of inequalities - a number which is bounded above by twice the number of neighbouring
 * seeds.
 *
 * The discrete nature of the SKIZ algorithm makes it well suited to image segmentation. The VOISE algorithm [2] relies
 * on a fast and dynamic method of recalculation of Voronoi diagrams upon addition and removal of seeds, so the two are
 * a natural fit. Although a standalone version of the SKIZ algorithm is included here (mostly for testing), the main
 * functionality is provided by the matlab bindings in pushVD, grabVD, addSeedToVD and removeSeedFromVD, which are
 * compiled into Matlab-readable MEX binaries and are tailored specifically for the code built and maintained by
 * P. Guio and N. Achilleos to aid faster image analysis through VOISE.
 *
 * @section install_sec Installation
 *
 * @subsection step1 Step 1: Installation
 *
 * Instructions: Cmake etc.
 *
 * @section references_sec References
 *
 * [1] R. E. Sequeira and F. J. Preteux. Discrete voronoi diagrams and the skiz
 * operator: a dynamic algorithm. IEEE Transactions on Pattern Analysis
 * and Machine Intelligence, 19(10):1165–1170, 1997. [doi: 10.1109/34.625128]
 *
 * [2] P. Guio and N. Achilleos. The voise algorithm: a versatile tool for automatic segmentation of astronomical images.
 * Monthly Notices of the Royal Astronomical Society, 398(3):1254–1262, 2009. [doi: 10.1111/j.1365-2966.2009.15218.x]
 */
