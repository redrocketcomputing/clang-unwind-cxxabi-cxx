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
# clang-standalone.mk
# Created on: 28/11/12
# Author: Stephen Street (stephen@redrocketcomputing.com)
#

export PATCH_ROOT := ${CURDIR}/patches/${TARGET_VERSION}

export BOOTSTRAP_CC := ${BUILD_ROOT}/compiler/bootstrap/bin/clang
export BOOTSTRAP_CXX := ${BUILD_ROOT}/compiler/bootstrap/bin/clang++

include ${MKTARGETS}
