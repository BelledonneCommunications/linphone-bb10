############################################################################
# gsm.mk 
# Copyright (C) 2014  Belledonne Communications,Grenoble France
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

gsm_dir?=gsm
enable_gsm?=yes

update-tree-libgsm:  $(BUILDER_SRC_DIR)/$(gsm_dir)/Makefile
	mkdir -p $(BUILDER_BUILD_DIR)/$(gsm_dir)
	cd $(BUILDER_BUILD_DIR)/$(gsm_dir)/ && \
	rsync -rvLpgoc --exclude ".git" $(BUILDER_SRC_DIR)/$(gsm_dir)/ .

build-libgsm: update-tree-libgsm
	cd $(BUILDER_BUILD_DIR)/$(gsm_dir) \
	&& mkdir -p $(prefix)/include/gsm \
	&& host_alias=$(host)  . $(BUILDER_SRC_DIR)/build/$(config_site) \
	&&  make -j1 CC="$${CC}" INSTALL_ROOT=$(prefix)  GSM_INSTALL_INC=$(prefix)/include/gsm  install \
	&& chmod u+w $(prefix)/lib/libgsm.a \
	&& chmod u+w -R $(prefix)/include/gsm

clean-libgsm:
	cd $(BUILDER_BUILD_DIR)/$(gsm_dir)\
	&& make clean

veryclean-libgsm: 
	 -cd $(BUILDER_BUILD_DIR)/$(gsm_dir) \
	&& make uninstall
