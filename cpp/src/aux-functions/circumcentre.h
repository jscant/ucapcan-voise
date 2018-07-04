/**
 * @file
 * @brief Finds the cirumcentre of the triangle formed by three given points (templated). Header only for
 * templating/linking reasons.
 */

#ifndef CIRCUMCENTRE_H
#define CIRCUMCENTRE_H

/**
 * @defgroup circumcentre circumcentre
 * @ingroup circumcentre
 * @{
 * @brief Finds the cirumcentre of the triangle formed by three given points
 * @param ax,ay x and y coordinates of first vertex
 * @param bx,by x and y coordinates of second vertex
 * @param cx,cy x and y coordinates of third vertex
 * @returns Circumcentre of points a, b and c
 *
 * The cirumcentre of a triangle is the unique point in \f$R^2\f$ that is equidistant from its three vertices. This is
 * the equivalent of X(a, b, c) as defined in Section 2 of reference [1].
 */
template <class T1, class T2, class T3, class T4, class T5, class T6>
std::array<real, 2> circumcentre(const T1 &ax, const T2 &ay, const T3 &bx, const T4 &by, const T5 &cx,
                                 const T6 &cy) {

    std::array<real, 2> result;
    real D = 2 * ((ax * (by - cy) + bx * (cy - ay) + cx * (ay - by)));
    if (D == 0) {
        // Message only for debugging, this is expected behaviour as cc does not exist, so cannot be 'within' any region
        std::string msg = "Collinear points:\n(" + std::to_string(ax) + ", " + std::to_string(ay) + ")\n" +
                          std::to_string(bx) + ", " + std::to_string(by) + ")\n" +
                          std::to_string(cx) + ", " + std::to_string(cy) + ")\n";
        throw SKIZLinearSeedsException(msg.c_str());
    }
    real Ux = ((pow(ax, 2) + pow(ay, 2)) * (by - cy) + (pow(bx, 2) + pow(by, 2)) * (cy - ay) +
               (pow(cx, 2) + pow(cy, 2)) * (ay - by)) / D;
    real Uy = ((pow(ax, 2) + pow(ay, 2)) * (cx - bx) + (pow(bx, 2) + pow(by, 2)) * (ax - cx) +
               (pow(cx, 2) + pow(cy, 2)) * (bx - ax)) / D;
    result.at(0) = Ux;
    result.at(1) = Uy;
    return result;
}

#endif // CIRCUMCENTRE_H
