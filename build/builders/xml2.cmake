############################################################################
# xml2.cmake
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

set(AUTOGEN_COMMAND "PKG_CONFIG_LIBDIR=${PKG_CONFIG_LIBDIR}" "CONFIG_SITE=${AUTOTOOLS_CONFIG_SITE}" "./autogen.sh" "--prefix=${CMAKE_INSTALL_PREFIX}" "--host=$ENV{HOST}")
set(CONFIGURE_OPTIONS
	"--disable-static"
	"--enable-shared"
	"--disable-rebuild-docs"
	"--with-iconv=no"
	"--with-python=no"
	"--with-zlib=no"
	"--with-modules=no"
)
set(BUILD_COMMAND "PKG_CONFIG_LIBDIR=${PKG_CONFIG_LIBDIR}" "CONFIG_SITE=${AUTOTOOLS_CONFIG_SITE}" "make")

ExternalProject_Add(EP_xml2
	GIT_REPOSITORY git://git.gnome.org/libxml2
	GIT_TAG v2.8.0
	CONFIGURE_COMMAND ${AUTOGEN_COMMAND} ${CONFIGURE_OPTIONS}
	BUILD_COMMAND ${BUILD_COMMAND}
	BUILD_IN_SOURCE 1
)
