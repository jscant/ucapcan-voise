#include <array>
#include <vector>
#include <map>
#include <eigen3/Eigen/Dense>

#ifndef TYPEDEFS
#define TYPEDEFS
typedef double real;
typedef std::vector<real> RealVec;
typedef Eigen::Array<real, Eigen::Dynamic, Eigen::Dynamic> Mat;
#endif

real sqDist(real p1, real p2, real q1, real q2);
std::array<real, 2> circumcentre(real ax, real ay, real bx, real by, real cx, real cy);
bool inVector(const RealVec &vec, real item);
void updateDict(std::map<real, RealVec> &d, real key, real value);


// Some useful general purpose printing fns
std::string toString(const char *&t);

std::string toString(const std::string &t);

template<class T>
std::string toString(const T &t);

namespace aux {
    template<class T>
    void print(T value);


    void print(real value);
}