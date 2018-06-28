cmake_minimum_required(VERSION 3.11)
project(standalone_skiz)

set(CMAKE_CXX_STANDARD 14)
message(STATUS "${CMAKE_CXX_STANDARD}")

set( CMAKE_CXX_FLAGS "-Wall -g -O1" )

add_executable(standalone_skiz main.cpp addSeed.cpp aux.cpp getRegion.cpp NSStar.cpp pointInRegion.cpp removeSeed.cpp skizException.cpp vd.cpp)