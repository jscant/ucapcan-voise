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
CMAKE_SOURCE_DIR = /home/jack/dev/project/voise-1.3/matlab/cpp

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/testTest.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/testTest.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/testTest.dir/flags.make

CMakeFiles/testTest.dir/src/tests/testTest.cpp.o: CMakeFiles/testTest.dir/flags.make
CMakeFiles/testTest.dir/src/tests/testTest.cpp.o: ../src/tests/testTest.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/testTest.dir/src/tests/testTest.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/testTest.dir/src/tests/testTest.cpp.o -c /home/jack/dev/project/voise-1.3/matlab/cpp/src/tests/testTest.cpp

CMakeFiles/testTest.dir/src/tests/testTest.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/testTest.dir/src/tests/testTest.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/matlab/cpp/src/tests/testTest.cpp > CMakeFiles/testTest.dir/src/tests/testTest.cpp.i

CMakeFiles/testTest.dir/src/tests/testTest.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/testTest.dir/src/tests/testTest.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/matlab/cpp/src/tests/testTest.cpp -o CMakeFiles/testTest.dir/src/tests/testTest.cpp.s

# Object files for target testTest
testTest_OBJECTS = \
"CMakeFiles/testTest.dir/src/tests/testTest.cpp.o"

# External object files for target testTest
testTest_EXTERNAL_OBJECTS =

build/testTest: CMakeFiles/testTest.dir/src/tests/testTest.cpp.o
build/testTest: CMakeFiles/testTest.dir/build.make
build/testTest: CMakeFiles/testTest.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable build/testTest"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/testTest.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/testTest.dir/build: build/testTest

.PHONY : CMakeFiles/testTest.dir/build

CMakeFiles/testTest.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/testTest.dir/cmake_clean.cmake
.PHONY : CMakeFiles/testTest.dir/clean

CMakeFiles/testTest.dir/depend:
	cd /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/jack/dev/project/voise-1.3/matlab/cpp /home/jack/dev/project/voise-1.3/matlab/cpp /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug/CMakeFiles/testTest.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/testTest.dir/depend

