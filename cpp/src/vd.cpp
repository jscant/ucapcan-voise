/**
 * @file
 * @brief Voronoi diagram class method implementation
 */

#include "vd.h"

/**
 * @brief Constructor
 * @param rows Number of rows in pixel matrix
 * @param cols Number of cols in pixel matrix
 */
vd::vd(real rows, real cols) {
    nr = rows;
    nc = cols;
}

/**
 * @brief Default destructor
 */
vd::~vd() { }

/**
 * @brief Set Vk
 * @param val
 */
void vd::setVk(V_struct val) {
    Vk = val;
};

/**
 * @brief Set W, as defined in [1], Section 2.2. Only for use with VOISE
 * algorithm Matlab interface.
 * @param val W_struct containing information about restricted space
 */
void vd::setW(W_struct val) {
    W = val;
};

/**
 * @brief Set S. Only for use with VOISE algorithm Matlab interface.
 * @param val W_struct containing information about S
 */
void vd::setS(W_struct val) {
    S = val;
};

/**
 * @brief Set \f$ \lambda \f$ matrix, as defined in [1] Section 3
 * @param newLam Eigen array containing \f$ \lambda \f$
 */
void vd::setLam(Mat newLam) {
    Vk.lam = newLam;
};

/**
 * @brief Set \f$\nu\f$ matrix, as defined in [1] Section 3
 * @param newV Eigen array containing \f$\nu\f$
 */
void vd::setV(Mat newV) {
    Vk.v = newV;
};

/**
 * @brief Set individual element of \f$\lambda\f$ matrix, as defined in [1]
 * Section 3
 * @param i Row index of \f$\lambda\f$
 * @param j Column index of \f$\lambda\f$
 * @param val Value to set \f$\lambda_{ij}\f$
 */
void vd::setLamByIdx(uint32 i, uint32 j, real val) {
    Vk.lam(i, j) = val;
};

/**
 * @brief Set individual element of \f$\nu\f$ matrix, as defined in [1]
 * Section 3
 * @param i Row index of \f$\nu\f$
 * @param j Column index of \f$\nu\f$
 * @param val Value to set \f$\nu{ij}\f$
 */
void vd::setVByIdx(uint32 i, uint32 j, real val) {
    Vk.v(i, j) = val;
};

/**
 * @brief Set coordinates of all seeds in Voronoi diagram
 * @param s (ns x 2) Eigen::Array<double> containing coordinates of ns seeds
 */
void vd::setSeeds(Mat s) {
    seeds = s;
};

/**
 * @brief Set x coordinates of each pixel.
 * @param x Eigen::Array<double> containing x coordinates of each pixel
 */
void vd::setPx(Mat x) {
    px = x;
};

/**
 * @brief Set y coordinates of each pixel
 * @param y Eigen::Array<double> containing y coordinates of each pixel
 */
void vd::setPy(Mat y) {
    py = y;
};

/**
 * @brief Set iteration number (k) as defined in [1], Section 3
 * @param val Value to which k is set
 */
void vd::setK(real val) {
    k = val;
};

/**
 * @brief Set Sx, the vector of x coordinates of all seeds
 * @param val RealVec (Sx)
 */
void vd::setSx(RealVec val) {
    Sx = val;
};

/**
 * @brief Set Sy, the vector of y coordinates of all seeds
 * @param val RealVec (Sy)
 */
void vd::setSy(RealVec val) {
    Sy = val;
};

/**
 * @brief Set Sk, the vector of active seed IDs
 * @param val RealVec (Sk)
 */
void vd::setSk(RealVec val) {
    Sk = val;
};

/**
 * @brief Set neighbour relationships dictionary, as defined in [1] Section 3
 * @param val Dictionary of vectors
 * { seed ID : Vector (RealVec) of neighbouring seed IDs }
 */
void vd::setNk(std::map<real, RealVec> val) {
    Nk = val;
};

/**
 * @brief Set individual element in neighbour relationships dictionary, as
 * defined in [1] Section 3
 * @param idx Key (seed ID)
 * @param val Vector (RealVec) of neighbouring seed IDs
 */
void vd::setNkByIdx(uint32 idx, RealVec val) {
    Nk[idx] = val;
};

/**
 * @brief Increment iteration count (k) by 1, as defined in [1] Section 3
 * @return void
 */
void vd::incrementK() {
    k += 1;
};

/**
 * @brief Get Vk struct, as defined in [1] Section 3.
 * @return Vk
 */
V_struct vd::getVk() const {
    return Vk;
};

/**
 * @brief Get W struct, as defined in [1] Section 3. Only for use with VOISE
 * algorithm matlab interface.
 * @return W
 */
W_struct vd::getW() const {
    return W;
};

/**
 * @brief Get S struct, as defined in [1] Section 3. Only for use with VOISE
 * algorithm matlab interface.
 * @return S
 */
W_struct vd::getS() const {
    return S;
};

/**
 * @brief Get \f$\lambda\f$ matrix, as defined in [1] Section 3
 * @returns Eigen::Array of values of \f$\lambda_{ij}\f$ at each pixel.
 * \f$\lambda_{ij}\f$ is the seed which is closest to pixel
 * (i, j)
 */
Mat vd::getLam() const {
    return Vk.lam;
};

/**
 * @brief Get \f$\nu\f$ matrix, as defined in [1] Section 3
 * @returns Eigen::Array of values of \f$\nu\f$ at each pixel.
 * \f$\nu_{ij}\f$ = 1 iff there exist two or more closest seeds,
 * else 0.
 */
Mat vd::getV() const {
    return Vk.v;
};

/**
 * @brief Get element of \f$\lambda\f$ matrix, as defined in [1] Section 3
 * @param i Row
 * @param j Column
 * @returns Value of \f$\lambda_{ij}\f$ of pixel in the \f$ i^{th} \f$ row and
 * \f$ j^{th} \f$ column. \f$\lambda_{ij}\f$ is the seed which is closest to
 * pixel (i, j).
 */
real vd::getLamByIdx(uint32 i, uint32 j) const {
    return Vk.lam(i, j);
};

/**
 * @brief Get element of \f$\nu\f$ matrix, as defined in [1] Section 3
 * @returns Value of \f$\nu\f$ at each pixel in the \f$ i^{th} \f$ row and
 * \f$ j^{th} \f$ column. \f$\nu_{ij}\f$ = 1 iff there exist two or more
 * closest seeds, else 0
 */
real vd::getVByIdx(uint32 i, uint32 j) const {
    return Vk.v(i, j);
};

/**
 * @brief Returns a (ns x 2) Eigen::Array of all seed coordinates, where ns
 * is the number of seeds in the Voronoi diagram.
 * @returns (ns x 2) Eigen::Array of all seed coordinates. The first column
 * is x coordinates; the second is y coordinates.
 */
Mat vd::getSeeds() const {
    return seeds;
};

/**
 * @brief Returns a (nr x nc) Eigen:Array of x coordinates of each pixel
 * @returns (nr x nc) Eigen:Array of x coordinates of each pixel
 */
Mat vd::getPx() const {
    return px;
};

/**
 * @brief Returns a (nr x nc) Eigen:Array of y coordinates of each pixel
 * @returns (nr x nc) Eigen:Array of y coordinates of each pixel
 */
Mat vd::getPy() const {
    return py;
};

/**
 * @brief Get iteration count (k) as defined in [1] Section 3.
 * @return Iteration count (k)
 */
uint32 vd::getK() const {
    return k;
};

/**
 * @brief Get the number of rows of pixels
 * @returns nr: the number of rows of pixels
 */
uint32 vd::getNr() const {
    return nr;
};

/**
 * @brief Get the number of columns of pixels
 * @returns nc: the number of columns of pixels
 */
uint32 vd::getNc() const {
    return nc;
};

/**
 * @brief Get Sx, the vector of x coordinates of seeds
 * @returns Sx vector of x coordinates of seeds
 */
RealVec vd::getSx() const {
    return Sx;
};

/**
 * @brief Get Sy, the vector of y coordinates of seeds
 * @returns Sy vector of y coordinates of seeds
 */
RealVec vd::getSy() const {
    return Sy;
};

/**
 * @brief Get Sk, the vector of active seed IDs
 * @returns Sk vector of active seed IDs
 */
RealVec vd::getSk() const {
    return Sk;
};

/**
 * @brief Get neighbour relationships dictionary, as defined in [1] Section 3.
 * @returns Nk, a dictionary of vectors { seed ID : vector of neighbouring
 * seed IDs }
 */
std::map<real, RealVec> vd::getNk() const {
    return Nk;
};

/**
 * @brief Get element of Sx, the vector of x coordinates of seeds
 * @param idx Seed ID for which coordinate is to be retrieved
 * @returns x coordinate if seed with ID = idx
 */
real vd::getSxByIdx(uint32 idx) const {
    return Sx.at(idx - 1);
};

/**
 * @brief Get element of Sy, the vector of y coordinates of seeds
 * @param idx Seed ID for which coordinate is to be retrieved
 * @returns y coordinate if seed with ID = idx
 */
real vd::getSyByIdx(uint32 idx) const {
    return Sy.at(idx - 1);
};

/**
 * @brief Get element of Sk, vector of active seed IDs
 * @param idx Index of seed
 * @returns ID of seed at index idx
 */
real vd::getSkByIdx(uint32 idx) const {
    return Sk.at(idx);
};

/**
 * @brief Get neighbour relationship for seed, as defined in [1] Section 3.
 * @param idx ID of seed for which neighbour relationships are to be retrieved
 * @returns Vector of neighbouring seeds
 */
RealVec vd::getNkByIdx(uint32 idx) const {
    return Nk.at(idx);
}

/**
 * @brief Erases an entry in the seed index vector Sk
 * @param seedID ID of seed to erase from active seed vector
 */
void vd::eraseSk(uint32 seedID) {
    Sk.erase(std::remove(Sk.begin(), Sk.end(), seedID), Sk.end());
}

/**
 * @brief Add x coordinate to Sx
 * @param val x component of coordinates of new seed
 */
void vd::addSx(real val) {
    Sx.push_back(val);
};

/**
 * @brief Add y coordinate to Sy
 * @param val y component of coordinates of new seed
 */
void vd::addSy(real val) {
    Sy.push_back(val);
};

/**
 * @brief Add seed ID to vector of active seeds
 * @param val ID of seed to add
 */
void vd::addSk(real val) {
    Sk.push_back(val);
};