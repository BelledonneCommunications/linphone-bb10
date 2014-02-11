############################################################################
# Makefile
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

PWD=$(shell pwd)

all: build

build-arm:
	mkdir -p $(PWD)/arm && \
	cd $(PWD)/../build/ && \
	make build-bb10-arm
	cp ../build/liblinphonesdk/bb10-arm/bin/mediastream $(PWD)/arm/

build-i486:
	mkdir -p $(PWD)/i486 && \
	cd $(PWD)/../build/ && \
	make build-bb10-i486
	cp ../build/liblinphonesdk/bb10-i486/bin/mediastream $(PWD)/i486/

build: build-arm build-i486

clean-arm:
	rm -f $(PWD)/arm/mediastream

clean-i486:
	rm -f $(PWD)/i486/mediastream

clean: clean-arm clean-i486

package:
	blackberry-nativepackager -package -devMode -debugToken ~/.rim/debugtoken1.bar -configuration Device-Debug mediastream.bar bar-descriptor.xml

install: package
	blackberry-nativepackager -installApp -device 169.254.0.1 -password 1234 mediastream.bar

run: install
	blackberry-nativepackager -launchApp -device 169.254.0.1 -password 1234 mediastream.bar

uninstall:
	blackberry-deploy -uninstallApp -device 169.254.0.1 -password 1234 mediastream.bar
