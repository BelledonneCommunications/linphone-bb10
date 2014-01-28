############################################################################
# bb10-i486.cmake
# Copyright (C) 2014  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
############################################################################

# Building for BlackBerry is only available under UNIX systems
if (NOT UNIX)
	message(FATAL_ERROR "You need to build using a Linux or a Mac OS X system")
endif(NOT UNIX)

if ("$ENV{QNX_HOST}" STREQUAL "")
	message(FATAL_ERROR "Some environment variables need to be defined by using the bbndk-env*.sh delivered with the bbndk.")
endif()

include(CMakeForceCompiler)

set(CMAKE_CROSSCOMPILING TRUE)

# Define name of the target system
set(CMAKE_SYSTEM_NAME QNX)
set(CMAKE_SYSTEM_PROCESSOR i486)

# Define the compiler
CMAKE_FORCE_C_COMPILER($ENV{CC} GNU)
CMAKE_FORCE_CXX_COMPILER($ENV{CXX} GNU)

set(CMAKE_FIND_ROOT_PATH  $ENV{QNX_TARGET})

# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
