# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.11

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/cmake-3.11.2/bin/cmake

# The command to remove a file.
RM = /opt/cmake-3.11.2/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/jack/dev/project/voise-1.3/cpp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/jack/dev/project/voise-1.3/cpp/build

# Include any dependencies generated for this target.
include CMakeFiles/GetVDOpC.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/GetVDOpC.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/GetVDOpC.dir/flags.make

CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.o: ../src/test/testGetVDOp.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/test/testGetVDOp.cpp

CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/test/testGetVDOp.cpp > CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.i

CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/test/testGetVDOp.cpp -o CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.s

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.o: ../src/test/test-help-fns/bruteForceCheckLambda.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/bruteForceCheckLambda.cpp

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/bruteForceCheckLambda.cpp > CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.i

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/bruteForceCheckLambda.cpp -o CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.s

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.o: ../src/test/test-help-fns/bruteForceCheckV.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/bruteForceCheckV.cpp

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/bruteForceCheckV.cpp > CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.i

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/bruteForceCheckV.cpp -o CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.s

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.o: ../src/test/test-help-fns/loadVD.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/loadVD.cpp

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/loadVD.cpp > CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.i

CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/test/test-help-fns/loadVD.cpp -o CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.s

CMakeFiles/GetVDOpC.dir/src/vd.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/vd.cpp.o: ../src/vd.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/GetVDOpC.dir/src/vd.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/vd.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/vd.cpp

CMakeFiles/GetVDOpC.dir/src/vd.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/vd.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/vd.cpp > CMakeFiles/GetVDOpC.dir/src/vd.cpp.i

CMakeFiles/GetVDOpC.dir/src/vd.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/vd.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/vd.cpp -o CMakeFiles/GetVDOpC.dir/src/vd.cpp.s

CMakeFiles/GetVDOpC.dir/src/skizException.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/skizException.cpp.o: ../src/skizException.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object CMakeFiles/GetVDOpC.dir/src/skizException.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/skizException.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/skizException.cpp

CMakeFiles/GetVDOpC.dir/src/skizException.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/skizException.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/skizException.cpp > CMakeFiles/GetVDOpC.dir/src/skizException.cpp.i

CMakeFiles/GetVDOpC.dir/src/skizException.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/skizException.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/skizException.cpp -o CMakeFiles/GetVDOpC.dir/src/skizException.cpp.s

CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.o: ../src/addSeed.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/addSeed.cpp

CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/addSeed.cpp > CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.i

CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/addSeed.cpp -o CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.s

CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.o: ../src/NSStar.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building CXX object CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/NSStar.cpp

CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/NSStar.cpp > CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.i

CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/NSStar.cpp -o CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.s

CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.o: ../src/pointInRegion.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building CXX object CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/pointInRegion.cpp

CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/pointInRegion.cpp > CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.i

CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/pointInRegion.cpp -o CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.s

CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.o: ../src/getRegion.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Building CXX object CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/getRegion.cpp

CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/getRegion.cpp > CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.i

CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/getRegion.cpp -o CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.s

CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.o: ../src/removeSeed.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_11) "Building CXX object CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/removeSeed.cpp

CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/removeSeed.cpp > CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.i

CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/removeSeed.cpp -o CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.s

CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.o: ../src/aux-functions/readSeeds.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_12) "Building CXX object CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/readSeeds.cpp

CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/readSeeds.cpp > CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.i

CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/readSeeds.cpp -o CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.s

CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.o: ../src/aux-functions/readMatrix.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_13) "Building CXX object CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/readMatrix.cpp

CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/readMatrix.cpp > CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.i

CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/readMatrix.cpp -o CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.s

CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.o: CMakeFiles/GetVDOpC.dir/flags.make
CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.o: ../src/aux-functions/metrics.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_14) "Building CXX object CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.o -c /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/metrics.cpp

CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/metrics.cpp > CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.i

CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/cpp/src/aux-functions/metrics.cpp -o CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.s

# Object files for target GetVDOpC
GetVDOpC_OBJECTS = \
"CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/vd.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/skizException.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.o" \
"CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.o"

# External object files for target GetVDOpC
GetVDOpC_EXTERNAL_OBJECTS =

GetVDOpC: CMakeFiles/GetVDOpC.dir/src/test/testGetVDOp.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckLambda.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/bruteForceCheckV.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/test/test-help-fns/loadVD.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/vd.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/skizException.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/addSeed.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/NSStar.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/pointInRegion.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/getRegion.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/removeSeed.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/aux-functions/readSeeds.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/aux-functions/readMatrix.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/src/aux-functions/metrics.cpp.o
GetVDOpC: CMakeFiles/GetVDOpC.dir/build.make
GetVDOpC: CMakeFiles/GetVDOpC.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_15) "Linking CXX executable GetVDOpC"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/GetVDOpC.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/GetVDOpC.dir/build: GetVDOpC

.PHONY : CMakeFiles/GetVDOpC.dir/build

CMakeFiles/GetVDOpC.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/GetVDOpC.dir/cmake_clean.cmake
.PHONY : CMakeFiles/GetVDOpC.dir/clean

CMakeFiles/GetVDOpC.dir/depend:
	cd /home/jack/dev/project/voise-1.3/cpp/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/jack/dev/project/voise-1.3/cpp /home/jack/dev/project/voise-1.3/cpp /home/jack/dev/project/voise-1.3/cpp/build /home/jack/dev/project/voise-1.3/cpp/build /home/jack/dev/project/voise-1.3/cpp/build/CMakeFiles/GetVDOpC.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/GetVDOpC.dir/depend
