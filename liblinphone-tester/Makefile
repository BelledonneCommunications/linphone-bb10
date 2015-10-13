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

DEVICE?=169.254.0.1
PASSWORD?=1234
DEBUG_TOKEN?=~/.rim/debugtoken1.bar
PREPAREPY_PARAMS?=

WORKING_DIR=$(shell pwd)

all: build

build-arm:
	mkdir -p $(WORKING_DIR)/arm && \
	cd $(WORKING_DIR)/../build/ && \
	./prepare.py -c bb10-arm && ./prepare.py $(PREPAREPY_PARAMS) bb10-arm && \
	make -C WORK/bb10-arm/cmake -- $(filter -D%,$(MAKEFLAGS))
	cp ../build/WORK/bb10-arm/Build/linphone/tester/liblinphone_tester $(WORKING_DIR)/arm/

build-i486:
	mkdir -p $(WORKING_DIR)/i486 && \
	cd $(WORKING_DIR)/../build/ && \
	./prepare.py -c bb10-i486 && ./prepare.py $(PREPAREPY_PARAMS) bb10-i486 && \
        make -C WORK/bb10-i486/cmake -- $(filter -D%,$(MAKEFLAGS))
	cp ../build/WORK/bb10-i486/Build/linphone/tester/liblinphone_tester $(WORKING_DIR)/i486/

build: build-arm build-i486

clean-arm:
	rm -f $(WORKING_DIR)/arm/liblinphone_tester

clean-i486:
	rm -f $(WORKING_DIR)/i486/liblinphone_tester

clean: clean-arm clean-i486

package:
	blackberry-nativepackager -package -devMode -debugToken $(DEBUG_TOKEN) -configuration Device-Debug liblinphone-tester.bar bar-descriptor.xml

install: package
	blackberry-nativepackager -installApp -device $(DEVICE) -password $(PASSWORD) liblinphone-tester.bar

run: install
	blackberry-nativepackager -launchApp -device $(DEVICE) -password $(PASSWORD) liblinphone-tester.bar
	blackberry-deploy -terminateApp -device $(DEVICE) -password $(PASSWORD) liblinphone-tester.bar
	ssh bb10 'sh -c "cd /accounts/1000/appdata/com.belledonne_communications.liblinphone_tester* && LD_LIBRARY_PATH=app/native/lib app/native/liblinphone_tester --resource-dir app/native/assets/ --writable-dir tmp/ --verbose"'

uninstall:
	blackberry-deploy -uninstallApp -device $(DEVICE) -password $(PASSWORD) liblinphone-tester.bar
