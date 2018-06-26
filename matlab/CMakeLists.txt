cmake_minimum_required(VERSION 3.11)
project(matlab)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_MODULE_PATH "/usr/local/bin/cmake-3.11.2/Modules")

add_executable(matlab addSeedToVD.cpp)
target_link_libraries (matlab cpp/addSeed.cpp cpp/getRegion.cpp cpp/NSStar.cpp, cpp/aux.cpp, cpp/skizException.cpp,
        cpp/vd.cpp /usr/local/MATLAB/R2018a/extern/include/mex.cpp)