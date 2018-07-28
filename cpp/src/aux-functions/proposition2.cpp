/**
 * @file
 * @brief Uses proposition 2 to decide between seeds for addition to N(s*)
 *
 * @date Created 22/07/18
 * @date Modified 24/07/18
 *
 * @author Jack Scantlebury
 */

#include "proposition2.h"
#include "../skizException.h"

/**
 * @brief Uses proposition 2 in [1] to decide between seeds for addition to N
 * (s*)
 *
 * Proposition 2 from [1] dictates that when there are cocircular seeds, the
 * neighbours of the seeds on the circumference are determined by taking the
 * angles made by the centre of the circle, the position of the seed in
 * question, and the other seeds on the circumference. The two seeds which
 * make the largest and smallest angles (clockwise or anticlockwise) are the
 * neighbours of that seed. In the context of seed addition, the new seed s*
 * has a neighbour which is the value of lambda at its coordinates, which
 * occupies either the largest or smallest angle as defined above. The
 * remaining seed must then be found, which is what this function does.
 * @param VD The Voronoi diagram
 * @param lam The value of lambda at the coordinates of the new seed
 * @param candidates The list of seeds whose circumcentre with lambda and s*
 * are coincidental (x' in 3.1.2 of [1])
 * @param cc std::array<real, 2> coordinates of circumcentre X(s*,
 * f\$lambda$\f$, s)
 * @return The ID of the other seed in the pair of neighbours creating
 * the largest and smallest angles s-x'-s* (the other being f\$lambda\f$)
 */
uint32 proposition2(const vd &VD, uint32 lam, const RealVec &candidates,
                    std::array<real, 2> cc){
    uint32 ns = candidates.size();
    if(ns == 1){
        return candidates.at(0); // 1 candidate, this is the most common result
    }

    RealVec angles;

    /*
     * atan2 gives angle between x axis and a point, with a given centre
     * (here X(s, lambda, s*) = x') as the origin. |atan2| is in [0, pi], with
     * negative values for y < 0. If we take atan2 of both seeds (s*, s) using
     * x' as the origin and then subtract one from the other, we find the
     * angle made by s*, x' and s in one direction or the other.
     * In order to make values comparable, they are shifted up by 2pi and the
     * remainder with 2pi is taken. This has no effect on y > 0, which still
     * maps to [0, pi], but for y < 0 with atan2 in (0, pi), this shifts to
     * (pi, 2pi), so we have a range of [0, 2pi). This is a more useful
     * measure, as it distinguishes between clockwise and anticlockwise, and
     * can be used in the context of proposition 2.
     */
    for(uint32 i = 0; i < ns; ++i){
        real angle1 = atan2(VD.getSyByIdx(candidates.at(i)) - cc[1],
                            VD.getSxByIdx(candidates.at(i)) - cc[0]);
        real angle2 = atan2(VD.getSyByIdx(VD.getK()) - cc[1],
                            VD.getSxByIdx(VD.getK()) - cc[0]);
        real angleDiff = fmod(angle1 - angle2 + 2*M_PI, 2*M_PI);
        angles.push_back(angleDiff);
    }

    // Find angle made by lambda seed, as this is definitely a neighbour
    real lamAngle1 = atan2(VD.getSyByIdx(lam) - cc[1],
                           VD.getSxByIdx(lam) - cc[0]);
    real lamAngle2 = atan2(VD.getSyByIdx(VD.getK()) - cc[1],
                           VD.getSxByIdx(VD.getK()) - cc[0]);
    real lamAngleDiff = fmod(lamAngle1 - lamAngle2 + 2*M_PI, 2*M_PI);

    /*
     * Check whether angle made by lambda is larger than max or lower than min
     * of angles made by other seeds. If it is the largest, we take the seed
     * making the smallest angle, and vice versa.
     */
    RealVec::iterator maxElementIt = std::max_element(angles.begin(),
            angles.begin() + ns);
    RealVec::iterator minElementIt = std::min_element(angles.begin(),
            angles.begin() + ns);
    uint32 result;
    if(lamAngleDiff >= *maxElementIt){
        result = candidates.at(std::distance(angles.begin(), maxElementIt));
    } else {// if (lamAngleDiff <= *minElementIt) {
        result = candidates.at(std::distance(angles.begin(), minElementIt));
    }// else {
     //   throw(SKIZException("???????"));
    //}
    return result;
}
