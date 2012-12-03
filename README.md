clang-unwind-cxxabi-cxx
=======================

This is a build project to assembly a trunk version of LLVMClang with libunwind, libcxxabi and libcxx.

To build:

git clone git://github.com/redrocketcomputing/clang-unwind-cxxab-cxx.git somedirectory

cd somedirectory

source ./workspace-rc

make

./images/clang-trunk.tar.bz2 contains a relocatable clang toolchain for the host system.

The build tree contains a useable tool chain at ./build/compiler/final/bin

