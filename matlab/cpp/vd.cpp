/**
 * @file
 * @brief Voronoi diagram class
 */

#include "vd.h"

/**
 * @param rows Number of rows in pixel matrix
 * @param cols Number of cols in pixel matrix
 */
vd::vd(real rows, real cols) {
    nr = rows;
    nc = cols;
}

vd::~vd() {
    return;
}

/**
 * Set Vk
 * @param val
 */
void vd::setVk(V_struct val) {
    Vk = val;
};

/**
 * Set W, as defined in [1], Section 2.2. Only for use with VOISE algorithm matlab interface.
 * @param val W_struct containing information about restricted space
 */
void vd::setW(W_struct val) {
    W = val;
};

/**
 * Set S. Only for use with VOISE algorithm matlab interface.
 * @param val W_struct containing information about S
 */
void vd::setS(W_struct val) {
    S = val;
};

/**
 * Set \f$ \lambda \f$ matrix, as defined in [1] Section 3
 * @param newLam Eigen array containing \f$ \lambda \f$
 */
void vd::setLam(Mat newLam) {
    Vk.lam = newLam;
};

/**
 * Set \f$\nu\f$ matrix, as defined in [1] Section 3
 * @param newV Eigen array containing \f$\nu\f$
 */
void vd::setV(Mat newV) {
    Vk.v = newV;
};

/**
 * Set individual element of \f$\lambda\f$ matrix, as defined in [1] Section 3
 * @param i Row index of \f$\lambda\f$
 * @param j Column index of \f$\lambda\f$
 * @param val Value to set \f$\lambda_{ij}\f$
 */
void vd::setLamByIdx(uint32 i, uint32 j, real val) {
    Vk.lam(i, j) = val;
};

/**
 * Set individual element of \f$\nu\f$ matrix, as defined in [1] Section 3
 * @param i Row index of \f$\nu\f$
 * @param j Column index of \f$\nu\f$
 * @param val Value to set \f$\nu{ij}\f$
 */
void vd::setVByIdx(uint32 i, uint32 j, real val) {
    Vk.v(i, j) = val;
};

/**
 * Set coordinates of all seeds in Voronoi diagram
 * @param s (ns x 2) Eigen::Array<double> containing coordinates of ns seeds
 */
void vd::setSeeds(Mat s) {
    seeds = s;
};

/**
 * Set x coordinates of each pixel.
 * @param x Eigen::Array<double> containing x coordinates of each pixel
 */
void vd::setPx(Mat x) {
    px = x;
};

/**
 * Set y coordinates of each pixel
 * @param y Eigen::Array<double> containing y coordinates of each pixel
 */
void vd::setPy(Mat y) {
    py = y;
};

/**
 * Set iteration number (k) as defined in [1], Section 3
 * @param val Value to which k is set
 */
void vd::setK(real val) {
    k = val;
};

/**
 * Set Sx, the dictionary which maps seed ID to x coordinate
 * @param val Dictionary (Sx)
 */
void vd::setSx(std::map<real, real> val) {
    Sx = val;
};

/**
 * Set Sy, the dictionary which maps seed ID to y coordinate
 * @param val Dictionary (Sy)
 */
void vd::setSy(std::map<real, real> val) {
    Sy = val;
};

/**
 * Set Sk, the dictionary which maps seed ID to seed ID. A map is used for uniqueness and consistensy with other
 * functions and methods.
 * @param val Dictionary (Sk). All keys should be equal to their values.
 */
void vd::setSk(std::map<real, real> val) {
    Sk = val;
};

/**
 * Set individual element in Sx dictionary
 * @param idx Key
 * @param val x coordinate
 */
void vd::setSxByIdx(uint32 idx, real val) {
    Sx[idx] = val;
};

/**
 * Set individual element in Sy dictionary
 * @param idx Key
 * @param val y coordinate
 */
void vd::setSyByIdx(uint32 idx, real val) {
    Sy[idx] = val;
};

/**
 * Set individual element in Sk dictionary
 * @param idx Key
 * @param val k
 */
void vd::setSkByIdx(uint32 idx, real val) {
    Sk[idx] = val;
};

/**
 * Set neighbour relationships dictionary, as defined in [1] Section 3
 * @param val Dictionary of vectors { seed ID : Vector of neighbouring seed IDs }
 */
void vd::setNk(std::map<real, RealVec> val) {
    Nk = val;
};

/**
 * Set individual element in neighbour relationships dictionary, as defined in [1] Section 3
 * @param idx Key (seed ID)
 * @param val Vector of neighbouring seed IDs
 */
void vd::setNkByIdx(uint32 idx, RealVec val) {
    Nk[idx] = val;
};

/**
 * Increment iteration count (k) by 1, as defined in [1] Section 3
 */
void vd::incrementK() {
    k += 1;
};

/**
 * Get Vk struct, as defined in [1] Section 3. Only for use with VOISE algorithm matlab interface.
 * @return Vk
 */
V_struct vd::getVk() const {
    return Vk;
};

/**
 * Get W struct, as defined in [1] Section 3. Only for use with VOISE algorithm matlab interface.
 * @return W
 */
W_struct vd::getW() const {
    return W;
};

/**
 * Get S struct, as defined in [1] Section 3. Only for use with VOISE algorithm matlab interface.
 * @return S
 */
W_struct vd::getS() const {
    return S;
};

/**
 * Get \f$\lambda\f$ matrix, as defined in [1] Section 3
 * @returns Eigen::Array of values of \f$\lambda_{ij}\f$ at each pixel. \f$\lambda_{ij}\f$ is the seed which is closest to pixel
 * (i, j)
 */
Mat vd::getLam() const {
    return Vk.lam;
};

/**
 * Get \f$\nu\f$ matrix, as defined in [1] Section 3
 * @returns Eigen::Array of values of \f$\nu\f$ at each pixel. \f$\nu_{ij}\f$ = 1 iff there exist two or more closest seeds,
 * else 0.
 */
Mat vd::getV() const {
    return Vk.v;
};

/**
 * Get element of \f$\lambda\f$ matrix, as defined in [1] Section 3
 * @param i Row
 * @param j Column
 * @returns Value of \f$\lambda_{ij}\f$ of pixel in the \f$ i^{th} \f$ row and \f$ j^{th} \f$ column. \f$\lambda_{ij}\f$
 * is the seed which is closest to pixel (i, j).
 */
real vd::getLamByIdx(uint32 i, uint32 j) {
    return Vk.lam(i, j);
};

/**
 * Get element of \f$\nu\f$ matrix, as defined in [1] Section 3
 * @returns Value of \f$\nu\f$ at each pixel in the \f$ i^{th} \f$ row and \f$ j^{th} \f$ column. \f$\nu_{ij}\f$ = 1
 * iff there exist two or more closest seeds, else 0
 */
real vd::getVByIdx(uint32 i, uint32 j) {
    return Vk.v(i, j);
};

/**
 * Returns a (ns x 2) Eigen::Array of all seed coordinates, where ns is the number of seeds in the Voronoi diagram.
 * @returns (ns x 2) Eigen::Array of all seed coordinates. The first column is x coordinates; the second is y coordinates.
 */
Mat vd::getSeeds() const {
    return seeds;
};

/**
 * Returns a (nr x nc) Eigen:Array of x coordinates of each pixel
 * @returns (nr x nc) Eigen:Array of x coordinates of each pixel
 */
Mat vd::getPx() const {
    return px;
};

/**
 * Returns a (nr x nc) Eigen:Array of y coordinates of each pixel
 * @returns (nr x nc) Eigen:Array of y coordinates of each pixel
 */
Mat vd::getPy() const {
    return py;
};

/**
 * Get iteration count (k) as defined in [1] Section 3.
 * @return Iteration count (k)
 */
real vd::getK() const {
    return k;
};

/**
 * Get the number of rows of pixels
 * @returns nr: the number of rows of pixels
 */
real vd::getNr() const {
    return nr;
};

/**
 * Get the number of columns of pixels
 * @returns nc: the number of columns of pixels
 */
real vd::getNc() const {
    return nc;
};

/**
 * Get Sx, the dictionary which maps seed ID to x coordinate
 * @returns Sx dictionary { seed ID : x coordinate }
 */
std::map<real, real> vd::getSx() const {
    return Sx;
};

/**
 * Get Sy, the dictionary which maps seed ID to y coordinate
 * @returns Sy dictionary { seed ID : y coordinate }
 */
std::map<real, real> vd::getSy() const {
    return Sy;
};

/**
 * Get Sk, the dictionary which maps seed ID to seed ID. Dictionary is used for consistency with other methods and
 * functions and to ensure uniqueness of keys/values.
 * @returns Sk dictionary { seed ID : seed ID }
 */
std::map<real, real> vd::getSk() const {
    return Sk;
};

/**
 * Get neighbour relationships dictionary, as defined in [1] Section 3.
 * @returns Nk, a dictionary of vectors { seed ID : vector of neighbouring seed IDs }
 */
std::map<real, RealVec> vd::getNk() const {
    return Nk;
};

/**
 * Get element of Sx, the dictionary which maps seed ID to x coordinate.
 * @param idx Index of seed for which coordinate is to be retrieved
 * @returns x coordinate if seed with ID = idx
 */
real vd::getSxByIdx(uint32 idx) const {
    return Sx.at(idx);
};

/**
 * Get element of Sy, the dictionary which maps seed ID to y coordinate.
 * @param idx Index of seed for which coordinate is to be retrieved
 * @returns y coordinate if seed with ID = idx
 */
real vd::getSyByIdx(uint32 idx) const {
    return Sy.at(idx);
};

/**
 * Get element of Sk, the dictionary which maps seed ID to seed ID. Dictionary is used for consistency with other
 * methods and functions and to ensure uniqueness of keys/values. (Unused)
 * @param idx Index of seed
 * @returns Index of seed
 */
real vd::getSkByIdx(uint32 idx) const {
    return Sk.at(idx);
};

/**
 * Get neighbour relationship for seed, as defined in [1] Section 3.
 * @param idx ID of seed for which neighbour relationships are to be retrieved
 * @returns Vector of neighbouring seeds
 */
RealVec vd::getNkByIdx(uint32 idx) const {
    return Nk.at(idx);
}

/**
 * Returns x coordinate of pixel
 * @returns x coordinate of pixel (i, j)
 */
real vd::getPxByIdx(uint32 i, uint32 j) {
    return px(i, j);
}

/**
 * Returns y coordinate of pixel
 * @returns y coordinate of pixel (i, j)
 */
real vd::getPyByIdx(uint32 i, uint32 j) {
    return py(i, j);
}

/**
 * Erases an entry in the seed index dictionary Sk
 * @param idx Entry to erase
 */
void vd::eraseSk(uint32 idx) {
    Sk.erase(idx);
};