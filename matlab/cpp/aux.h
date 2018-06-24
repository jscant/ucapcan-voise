#include <array>
#include <vector>
#include <map>

#ifndef REALVEC
#define REALVEC
typedef std::vector<double> RealVec;
#endif

double sqDist(double p1, double p2, double q1, double q2);
std::array<double, 2> circumcentre(double ax, double ay, double bx, double by, double cx, double cy);
bool inVector(const RealVec &vec, double item);
void updateDict(std::map<double, RealVec> &d, double key, double value);


// Some useful general purpose printing fns
std::string toString(const char *&t);

std::string toString(const std::string &t);

template<class T>
std::string toString(const T &t);

namespace aux {
    template<class T>
    void print(T value);


    void print(double value);
}