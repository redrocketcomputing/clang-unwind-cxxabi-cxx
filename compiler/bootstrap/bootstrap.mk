#
# Copyright (C) 2012 Red Rocket Computing
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# bootstrap.mk
# Created on: 29/11/12
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

REPOSITORY_PATH := ${REPOSITORY_ROOT}
PATCH_PATH := ${PATCH_ROOT}

BUILD_PATH := $(subst ${WORKSPACE},${BUILD_ROOT},${CURDIR})/tmp
SOURCE_PATH := $(subst ${WORKSPACE},${BUILD_ROOT},${CURDIR})/src
INSTALL_PATH := $(subst ${WORKSPACE},${BUILD_ROOT},${CURDIR})

LLVM_BUILD_PATH := ${BUILD_PATH}/llvm
LLVM_SOURCE_PATH := ${SOURCE_PATH}/llvm
LLVM_INSTALL_PATH := ${INSTALL_PATH}

LIBUNWIND_BUILD_PATH := ${BUILD_PATH}/libunwind
LIBUNWIND_SOURCE_PATH := ${SOURCE_PATH}/libunwind
LIBUNWIND_INSTALL_PATH := ${INSTALL_PATH}

LIBCXXABI_BUILD_PATH := ${SOURCE_PATH}/libcxxabi
LIBCXXABI_SOURCE_PATH := ${SOURCE_PATH}/libcxxabi
LIBCXXABI_INSTALL_PATH := ${INSTALL_PATH}

LIBCXX_BUILD_PATH := ${SOURCE_PATH}/libcxx
LIBCXX_SOURCE_PATH := ${SOURCE_PATH}/libcxx
LIBCXX_INSTALL_PATH := ${INSTALL_PATH}

all: ${LLVM_INSTALL_PATH}/bin/clang ${LIBUNWIND_INSTALL_PATH}/lib/libunwind.a ${LIBCXXABI_INSTALL_PATH}/lib/libc++abi.a ${LIBCXX_INSTALL_PATH}/lib/libc++.a

clean: ${LLVM_SOURCE_PATH}/config.log
	${MAKE} -C ${LLVM_SOURCE_PATH} clean

distclean:
	rm -rf ${INSTALL_PATH}

debug:
	@echo "BUILD_ROOT=${BUILD_ROOT}"
	@echo "SOURCE_PATH=${SOURCE_PATH}"
	@echo "BUILD_PATH=${BUILD_PATH}"

.PHONY: ${LLVM_INSTALL_PATH}/bin/clang
${LLVM_INSTALL_PATH}/bin/clang: ${LLVM_BUILD_PATH}/config.log
	${MAKE} -C ${LLVM_BUILD_PATH} -j 10 install
	
${LLVM_BUILD_PATH}/config.log: ${LLVM_SOURCE_PATH}
	mkdir -p ${LLVM_BUILD_PATH}
	cd ${LLVM_BUILD_PATH} && ${LLVM_SOURCE_PATH}/configure --prefix=${LLVM_INSTALL_PATH} --enable-bindings=none --enable-optimized --disable-jit --enable-targets=host

${LLVM_SOURCE_PATH}:
	git clone ${REPOSITORY_PATH}/llvm.git ${LLVM_SOURCE_PATH}
	git clone ${REPOSITORY_PATH}/compiler-rt.git ${LLVM_SOURCE_PATH}/projects/compiler-rt
	git clone ${REPOSITORY_PATH}/libcxx.git ${LLVM_SOURCE_PATH}/projects/libcxx
	git clone ${REPOSITORY_PATH}/clang.git ${LLVM_SOURCE_PATH}/tools/clang
#	cd ${LLVM_SOURCE_PATH}/projects/libcxx && patch -p1 < ${PATCH_PATH}/libcxx-do-not-require-ownership-change.patch
	cd ${LLVM_SOURCE_PATH}/tools/clang && patch -p1 < ${PATCH_PATH}/clang-libcxx-path.patch

.PHONY: ${LIBUNWIND_INSTALL_PATH}/lib/libunwind.a
${LIBUNWIND_INSTALL_PATH}/lib/libunwind.a: ${LIBUNWIND_BUILD_PATH}/config.log
	${MAKE} -C ${LIBUNWIND_BUILD_PATH} install
	
${LIBUNWIND_BUILD_PATH}/config.log: ${LIBUNWIND_SOURCE_PATH}
	mkdir -p ${LIBUNWIND_BUILD_PATH}
	cd ${LIBUNWIND_BUILD_PATH} && ${LIBUNWIND_SOURCE_PATH}/configure CC=${LLVM_INSTALL_PATH}/bin/clang --prefix=${LIBUNWIND_INSTALL_PATH} --includedir=${LIBUNWIND_INSTALL_PATH}/include/c++/v1

${LIBUNWIND_SOURCE_PATH}:
	git clone ${REPOSITORY_PATH}/libunwind.git ${LIBUNWIND_SOURCE_PATH} 
	cd ${LIBUNWIND_SOURCE_PATH} && autoreconf -i

${LIBCXXABI_INSTALL_PATH}/lib/libc++abi.a: ${LIBCXXABI_BUILD_PATH}/lib/libc++abi.a
	install -D ${LIBCXXABI_BUILD_PATH}/include/mach-o/*.h ${LIBCXXABI_INSTALL_PATH}/include/c++/v1/mach-o
	install -D ${LIBCXXABI_BUILD_PATH}/include/*.h ${LIBCXXABI_INSTALL_PATH}/include/c++/v1
	install -D ${LIBCXXABI_BUILD_PATH}/lib/libc++abi.a ${LIBCXXABI_INSTALL_PATH}/lib
	install -D ${LIBCXXABI_BUILD_PATH}/lib/libc++abi.so.1.0 ${LIBCXXABI_INSTALL_PATH}/lib
	cd ${LIBCXXABI_INSTALL_PATH}/lib && ln -sf libc++abi.so.1.0 libc++abi.so.1
	cd ${LIBCXXABI_INSTALL_PATH}/lib && ln -sf libc++abi.so.1.0 libc++abi.so

${LIBCXXABI_BUILD_PATH}/lib/libc++abi.a: ${LIBCXXABI_SOURCE_PATH}/lib/buildit
	cd ${LIBCXXABI_BUILD_PATH}/lib && CC=${LLVM_INSTALL_PATH}/bin/clang CXX=${LLVM_INSTALL_PATH}/bin/clang++ SYSROOT=${LLVM_INSTALL_PATH} ./buildit

${LIBCXXABI_SOURCE_PATH}/lib/buildit:
	mkdir -p ${LIBCXXABI_SOURCE_PATH}
	git clone ${REPOSITORY_PATH}/libcxxabi.git ${LIBCXXABI_SOURCE_PATH}
	cd ${LIBCXXABI_SOURCE_PATH} && patch -p1 < ${PATCH_PATH}/libcxxabi-buildit.patch

${LIBCXX_INSTALL_PATH}/lib/libc++.a: ${LIBCXX_BUILD_PATH}/lib/libc++.a
	mkdir -p ${LIBCXX_INSTALL_PATH}/include/c++/v1
	cp -r ${LIBCXX_SOURCE_PATH}/include/* ${LIBCXX_INSTALL_PATH}/include/c++/v1
	rm -rf ${LIBCXX_INSTALL_PATH}/include/c++/v1/support
	install -D ${LIBCXX_BUILD_PATH}/lib/libc++.a ${LIBCXX_INSTALL_PATH}/lib
	install -D ${LIBCXX_BUILD_PATH}/lib/libc++.so.1.0 ${LIBCXX_INSTALL_PATH}/lib
	cd ${LIBCXX_INSTALL_PATH}/lib && ln -sf libc++.so.1.0 libc++.so.1
	cd ${LIBCXX_INSTALL_PATH}/lib && ln -sf libc++.so.1.0 libc++.so

${LIBCXX_BUILD_PATH}/lib/libc++.a: ${LIBCXX_SOURCE_PATH}/lib/buildit
	cd ${LIBCXX_BUILD_PATH}/lib && CC=${LLVM_INSTALL_PATH}/bin/clang CXX=${LLVM_INSTALL_PATH}/bin/clang++ SYSROOT=${LLVM_INSTALL_PATH} ./buildit

${LIBCXX_SOURCE_PATH}/lib/buildit:
	mkdir -p ${LIBCXX_SOURCE_PATH}
	git clone ${REPOSITORY_PATH}/libcxx.git ${LIBCXX_SOURCE_PATH}
	cd ${LIBCXX_SOURCE_PATH} && patch -p1 < ${PATCH_PATH}/libcxx-buildit.patch

.PHONY: distclean
