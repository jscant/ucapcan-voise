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
include CMakeFiles/my_test.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/my_test.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/my_test.dir/flags.make

CMakeFiles/my_test.dir/test/test_case_1.cpp.o: CMakeFiles/my_test.dir/flags.make
CMakeFiles/my_test.dir/test/test_case_1.cpp.o: ../test/test_case_1.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/my_test.dir/test/test_case_1.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/my_test.dir/test/test_case_1.cpp.o -c /home/jack/dev/project/voise-1.3/matlab/cpp/test/test_case_1.cpp

CMakeFiles/my_test.dir/test/test_case_1.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/my_test.dir/test/test_case_1.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/matlab/cpp/test/test_case_1.cpp > CMakeFiles/my_test.dir/test/test_case_1.cpp.i

CMakeFiles/my_test.dir/test/test_case_1.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/my_test.dir/test/test_case_1.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/matlab/cpp/test/test_case_1.cpp -o CMakeFiles/my_test.dir/test/test_case_1.cpp.s

CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.o: CMakeFiles/my_test.dir/flags.make
CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.o: ../test/Catch2/test_main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.o -c /home/jack/dev/project/voise-1.3/matlab/cpp/test/Catch2/test_main.cpp

CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jack/dev/project/voise-1.3/matlab/cpp/test/Catch2/test_main.cpp > CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.i

CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jack/dev/project/voise-1.3/matlab/cpp/test/Catch2/test_main.cpp -o CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.s

# Object files for target my_test
my_test_OBJECTS = \
"CMakeFiles/my_test.dir/test/test_case_1.cpp.o" \
"CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.o"

# External object files for target my_test
my_test_EXTERNAL_OBJECTS =

my_test: CMakeFiles/my_test.dir/test/test_case_1.cpp.o
my_test: CMakeFiles/my_test.dir/test/Catch2/test_main.cpp.o
my_test: CMakeFiles/my_test.dir/build.make
my_test: CMakeFiles/my_test.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX executable my_test"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/my_test.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/my_test.dir/build: my_test

.PHONY : CMakeFiles/my_test.dir/build

CMakeFiles/my_test.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/my_test.dir/cmake_clean.cmake
.PHONY : CMakeFiles/my_test.dir/clean

CMakeFiles/my_test.dir/depend:
	cd /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/jack/dev/project/voise-1.3/matlab/cpp /home/jack/dev/project/voise-1.3/matlab/cpp /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug /home/jack/dev/project/voise-1.3/matlab/cpp/cmake-build-debug/CMakeFiles/my_test.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/my_test.dir/depend

