//
// Created by root on 12/06/18.
//

#include "aux.h"

//Use square distance where possible to avoid floating point precision problems
double sqDist(double p1, double p2, double q1, double q2){
    return (pow((p1 - q1), 2) + pow((p2 - q2), 2));
}

std::array<double, 2> circumcentre(double ax, double ay, double bx, double by, double cx, double cy){
    std::array<double, 2> result;
    double D = 2*((ax*(by-cy) + bx*(cy-ay) + cx*(ay-by)));
    if(D == 0){
        throw skizException();
    }
    double Ux = ((pow(ax, 2) + pow(ay, 2))*(by-cy) + (pow(bx, 2) + pow(by, 2))*(cy-ay) +
          (pow(cx, 2) + pow(cy, 2))*(ay-by))/D;
    double Uy = ((pow(ax, 2) + pow(ay, 2))*(cx-bx) + (pow(bx, 2) + pow(by, 2))*(ax-cx) +
          (pow(cx, 2) + pow(cy, 2))*(bx-ax))/D;
    result.at(0) = Ux;
    result.at(1) = Uy;
    return result;
}

bool inVector(const std::vector<double> &vec, double item){
    if(vec.size() < 1){
        return false;
    }
    if(std::find(vec.begin(), vec.end(), item) != vec.end()) {
        return true;
    } else {
        return false;
    }
}

void updateDict(std::map<double, std::vector<double>> &d, double key, double value) {
    std::vector<double> lst = d[key];
    if(!inVector(lst, value)){
        lst.push_back(value);
        d[key] = lst;
    }
}

void printVector(std::vector<double> v) {
    for(double i=0; i<v.size(); ++i){
        std::cout << v[i] << "\n";
    }
}

void saveArray(const Eigen::Array<double, Eigen::Dynamic, Eigen::Dynamic> &arr, std::string filename) {
    std::ofstream file;
    file.open(filename.c_str());
    for(double i=0; i<arr.rows(); ++i){
        for(double j=0;j<arr.cols(); ++j){
            file << arr(i, j);
            if(j == arr.cols() - 1){
                file << "\n";
            } else {
                file << " ";
            }
        }
    }
}

