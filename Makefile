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
# Makefile
# Created on: 30/10/12
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

EXCLUDEGOALS = distclean realclean update $(wildcard ${REPOSITORY_ROOT}/*.git) tools


export WORKSPACE ?= ${CURDIR}
export REPOSITORY_ROOT ?= ${WORKSPACE}/repositories
export TOOLS_ROOT ?= ${WORKSPACE}/local
export IMAGE_ROOT ?= ${WORKSPACE}/images
export BUILD_ROOT ?= ${WORKSPACE}/build
export CROSS_ROOT ?= ${WORKSPACE}/rootfs

export MKSUPPORT_PATH := ${CURDIR}/tools/makefiles
export MKTARGETS := ${MKSUPPORT_PATH}/targets.mk

export TARGET_VERSION ?= master

include ${MKTARGETS}

.PHONY: update
update: ${REPOSITORY_ROOT} $(wildcard ${REPOSITORY_ROOT}/*.git)

.PHONY: $(wildcard ${REPOSITORY_ROOT}/*.git)
$(wildcard ${REPOSITORY_ROOT}/*.git):
	git --git-dir=$@ remote update

.PHONY: distclean
distclean:
	rm -rf ${BUILD_ROOT} ${CROSS_ROOT} ${IMAGE_ROOT} ${TOOLS_ROOT}

.PHONY: realclean
realclean: distclean
	rm -rf ${REPOSITORY_ROOT}

debug:
	@echo "REPOSITORY_ROOT=${REPOSITORY_ROOT}"
	@echo "TOOLS_ROOT=${TOOLS_ROOT}"
	@echo "IMAGE_ROOT=${IMAGE_ROOT}"
	@echo "BUILD_ROOT=${BUILD_ROOT}"
	@echo "CROSS_ROOT=${CROSS_ROOT}"
	@echo "TARGET_VERSION=${TARGET_VERSION}"
	@echo "MKSUPPORT_PATH=${MKSUPPORT_PATH}"
