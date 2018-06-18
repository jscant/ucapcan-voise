//
// Created by root on 16/06/18.
//

#ifndef MATLAB_CPP_TEST_ADDSEED_H
#define MATLAB_CPP_TEST_ADDSEED_H

#define INF std::numeric_limits<double>::infinity()

#include "mex.h"
#include "addSeed.h"

std::string toString(const char *&t) {
    return t;
}

std::string toString(const std::string &t) {
    return t;
}

template<class T>
std::string toString(const T &t) {
    return std::to_string(t);
}

template<class T>
void print(T value) {
    mexPrintf(toString(value).c_str());
    mexPrintf("\n");
}

vd addSeed(vd VD, double s1, double s2){
    VD.k += 1;
    VD.Sx[VD.k] = s1;
    VD.Sy[VD.k] = s2;
    VD.Sk[VD.k] = VD.k;

    VD.Nk[VD.k] = Ns_star(VD);
    std::map<double, std::vector<double>> newDict;

    for (int s : VD.Nk.at(VD.k)) {
        std::vector<double> v1 = VD.Nk.at(s);
        std::vector<double> v2 = VD.Nk.at(VD.k);
        std::vector<double> init;

        for (auto i : v1) {
            if (!inVector(v2, i)) {
                init.push_back(i);
            }
        }
        init.push_back(VD.k);
        newDict[s] = init;
    }


    for (auto s : VD.Nk.at(VD.k)) {
        for (auto r : VD.Nk.at(s)) {
            if (!inVector(VD.Nk.at(VD.k), r)) {
                continue;
            }
            if (inVector(newDict.at(r), s)) {
                continue;
            }
            std::vector<double> uList = VD.Nk.at(s);

            uList.push_back(VD.k);
            for (auto u : uList) {
                if (u == r) {
                    continue;
                }
                std::array<double, 2> cc;
                try {
                    cc = circumcentre(VD.Sx.at(s), VD.Sy.at(s), VD.Sx.at(r),
                                      VD.Sy.at(r), VD.Sx.at(u), VD.Sy.at(u));
                } catch (skizException &e) {
                    continue;
                }
                if (pointInRegion(VD, cc, s, uList)) {
                    updateDict(newDict, s, r);
                    updateDict(newDict, r, s);
                    break;
                }
            }
        }
    }

    for (auto i : newDict) {
        VD.Nk[i.first] = i.second;
    }



    Mat bounds = getRegion(VD, VD.k);

    int count = 0;
    bool finish = false;
    for (auto i = 0; i < VD.nr; ++i) {
        if (bounds(i, 0) == -1){// && i != VD.nc) {
            if (finish) {
                break;
            } else {
                continue;
            }
        } else {
            finish = true;
        }
        double lb = std::max(0.0, bounds(i, 0) - 2);
        double ub = std::min(VD.nc, bounds(i, 1) + 2);
        for (double j = lb; j < ub; ++j) {
            const double l1 = VD.Sx.at(VD.Vk.lam(i, j));
            const double l2 = VD.Sy.at(VD.Vk.lam(i, j));
            double newMu = sqDist(s1, s2, j+1, i+1);
            double oldMu = sqDist(l1, l2, j+1, i+1);

            if (newMu < oldMu) {
                VD.Vk.lam(i, j) = VD.k;
                VD.Vk.v(i, j) = 0;
            } else if (newMu == oldMu) {
                VD.Vk.v(i, j) = 1;
            }
        }
    }

    return VD;
}

std::vector<double> Ns_star(const vd &VD) {
    const double s1 = VD.Sx.at(VD.k);
    const double s2 = VD.Sy.at(VD.k);

    double lam = VD.Vk.lam(s2, s1);
    const double lamOG = lam;
    std::vector<double> Ns = {lam};
    bool onlyNeighbour = false;

    if (VD.Nk.at(lam).size() == 1) {
        onlyNeighbour = true;
    }

    double n = 0;
    while (true) {
        double NsLen = Ns.size();

        for (double nIdx = n; nIdx < VD.Nk.at(lam).size(); ++nIdx) {
            const double r = VD.Nk.at(lam)[nIdx];
            if (inVector(Ns, r)) {
                continue;
            }

            const double r1 = VD.Sx.at(r);
            const double r2 = VD.Sy.at(r);

            std::array<double, 2> cc;
            try {
                cc = circumcentre(r1, r2, s1, s2, VD.Sx.at(lam), VD.Sy.at(lam));
            } catch (skizException &e) {
                continue;
            }

            bool pir = pointInRegion(VD, cc, lam, VD.Nk.at(lam));

            if (pir) {
                if (r == lamOG) { // region is bounded!
                    return Ns;
                }
                lam = r;
                Ns.push_back(r);
                n = 0;
                break;
            }

        }
        if (NsLen == Ns.size()) {
            if (onlyNeighbour || n > 0) {
                return Ns;
            }
            n += 1;
            lam = lamOG;
        }
    }
    return Ns;
}

bool pointInRegion(const vd &VD, std::array<double, 2> pt, double s, std::vector<double> A) {
    if (A.size() < 1) {
        A = VD.Nk.at(s);
    }
    const double pt1 = pt[0];
    const double pt2 = pt[1];
    const double s1 = VD.Sx.at(s);
    const double s2 = VD.Sy.at(s);

    auto f = [](double p1, double p2, double q1, double q2, double i) -> double {
        return ((p2 - q2) * i + 0.5 * (pow(p1, 2) + pow(p2, 2) - pow(q1, 2) - pow(q2, 2))) / (p1 - q1);
    };

    std::vector<double> lb, ub;

    for (double r : A) {
        if (r != s) {
            const double r1 = VD.Sx.at(r);
            const double r2 = VD.Sy.at(r);
            if (r1 == s1) {
                if (s2 > r2) {
                    if (pt2 < ((r2 + s2) / 2)) {
                        return false;
                    }
                } else if (r2 > s2) {
                    if (pt2 > ((r2 + s2) / 2)) {
                        return false;
                    }
                } else {
                    std::cout << "SHOULD BE AN ERROR HERE...\n";
                    // Raise an exception
                }
                continue;
            } else if ((s1 - r1) < 0) {
                ub.push_back(f(s1, s2, r1, r2, -pt2));
            } else if ((s1 - r1) > 0) {
                lb.push_back(f(s1, s2, r1, r2, -pt2));
            }
        }
    }

    double highestLB, lowestUB;
    try {
        if (lb.size() > 0) {
            highestLB = *std::max_element(lb.begin(), lb.end());
        } else {
            highestLB = -INF;
        }
    } catch (const std::exception &e) {
        // PUT ERR MSG HERE
        highestLB = -INF;
    }
    try {
        if (ub.size() > 0) {
            lowestUB = *std::min_element(ub.begin(), ub.end());
        } else {
            lowestUB = INF;
        }
    } catch (const std::exception &e) {
        // PUT ERR MSG HERE
        lowestUB = INF;
    }
    if (highestLB - 10e-7 <= pt1 && pt1 <= lowestUB + 10e-7) {
        return true;
    }
    return false;
}

Mat getRegion(const vd &VD, double s) {
    const double s1 = VD.Sx.at(s);
    const double s2 = VD.Sy.at(s);
    auto f = [](double p1, double p2, double q1, double q2, double i) -> double {
        return ((p2 - q2) * i + 0.5 * (pow(p1, 2) + pow(p2, 2) - pow(q1, 2) - pow(q2, 2))) / (p1 - q1);
    };
    std::vector<double> A = VD.Nk.at(s);
    Mat boundsUp, boundsDown;
    boundsUp.resize(VD.nc - s2, 2);
    boundsDown.resize(s2, 2);
    boundsUp.setOnes();
    boundsDown.setOnes();
    boundsUp *= -1;
    boundsDown *= -1;

    // Upward sweep including s2 row
    for (double i = s2; i < VD.nc; ++i) {
        std::vector<double> lb, ub;

        const double boundsIdx = i - s2 + 1;
        bool killLine = false;
        for (double j = 0; j < A.size(); ++j) {
            const double r = A[j];
            const double r1 = VD.Sx.at(r);
            const double r2 = VD.Sy.at(r);

            if (s1 > r1) {
                lb.push_back(f(s1, s2, r1, r2, -i));
            } else if (r1 > s1) {
                ub.push_back(f(s1, s2, r1, r2, -i));
            } else {
                if (s2 > r2 && i < 0.5 * (s2 + r2)) {
                    killLine = true;
                    break;
                }
                if (r2 > s2 && i > 0.5 * (s2 + r2)) {
                    killLine = true;
                    break;
                }
            }
        }
        double highestLB, lowestUB;
        if (!killLine) {
            highestLB = 0;
            lowestUB = 0;
            try {
                if (lb.size() > 0) {
                    highestLB = std::max(0.0, floor(*std::max_element(lb.begin(), lb.end())));
                } else {
                    highestLB = 0;
                }
            } catch (const std::exception &e) {
                highestLB = 0;
            }
            try {
                if (ub.size() > 0) {
                    lowestUB = std::min(VD.nc, ceil(*std::min_element(ub.begin(), ub.end())));
                } else {
                    lowestUB = VD.nc;
                }
            } catch (const std::exception &e) {
                lowestUB = VD.nc;
            }
            if (lowestUB < highestLB) {
                break;
            }
            boundsUp(boundsIdx - 1, 0) = highestLB;
            boundsUp(boundsIdx - 1, 1) = lowestUB;
        } else {
            break;
        }
    }

    // Downward sweep excluding s2 row
    for (double i = s2 - 1; i > -1; --i) {
        std::vector<double> lb, ub;
        bool killLine = false;
        for (auto r : A) {
            const double r1 = VD.Sx.at(r);
            const double r2 = VD.Sy.at(r);
            if (s1 > r1) {
                lb.push_back(f(s1, s2, r1, r2, -i - 1));
            } else if (r1 > s1) {
                ub.push_back(f(s1, s2, r1, r2, -i - 1));
            } else {
                if (s2 > r2 && i < 0.5 * (s2 + r2)) {
                    killLine = true;
                    break;
                }
                if (r2 > s2 && i > 0.5 * (s2 + r2)) {
                    killLine = true;
                    break;
                }
            }
        }
        double highestLB, lowestUB;
        if (!killLine) {
            highestLB = 0;
            lowestUB = 0;
            try {
                if (lb.size() > 0) {
                    highestLB = std::max(0.0, floor(*std::max_element(lb.begin(), lb.end())));
                } else {
                    highestLB = 0;
                }
            } catch (const std::exception &e) {
                highestLB = 0;
            }

            try {
                if (ub.size() > 0) {
                    lowestUB = std::min(VD.nc, ceil(*std::min_element(ub.begin(), ub.end())));
                } else {
                    lowestUB = VD.nc;
                }
            } catch (const std::exception &e) {
                lowestUB = VD.nc;
            }
            if (lowestUB < highestLB) {

                break;
            }
            boundsDown(s2 - i - 1, 0) = highestLB;
            boundsDown(s2 - i - 1, 1) = lowestUB;
        } else {
            break;
        }
    }

    Mat result(boundsUp.rows() + boundsDown.rows(), 2);

    result << boundsDown.colwise().reverse(),
            boundsUp;

    return result;
}

#endif //MATLAB_CPP_TEST_ADDSEED_H
