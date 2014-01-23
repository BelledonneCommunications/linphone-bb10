############################################################################
# builder-bb10-os.mk 
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
 
host?=arm-unknown-nto-qnx8.0.0
config_site:=bb10-config.site
library_mode:= --enable-shared --disable-static
linphone_configure_controls= \
	--disable-strict \
	--disable-nls \
	--with-readline=none \
	--enable-gtk_ui=no \
	--enable-console_ui=no \
	--disable-theora \
	--disable-sdl \
	--disable-x11 \
	--enable-bellesip \
	--with-gsm=$(prefix) \
	--disable-tests \
	--disable-tutorials \
	--disable-tools \
	--with-srtp=$(prefix) \
	--with-antlr=$(prefix) \
	--disable-msg-storage \
	--disable-video \
	--enable-broken-srtp


#path
BUILDER_SRC_DIR?=$(shell pwd)/../
ifeq ($(enable_debug),yes)
BUILDER_BUILD_DIR?=$(shell pwd)/../build-$(host)-debug
linphone_configure_controls += CFLAGS="-g"
prefix?=$(BUILDER_SRC_DIR)/../liblinphone-sdk/$(host)-debug
else
BUILDER_BUILD_DIR?=$(shell pwd)/../build-$(host)
prefix?=$(BUILDER_SRC_DIR)/../liblinphone-sdk/$(host)
endif

LINPHONE_SRC_DIR=$(BUILDER_SRC_DIR)/linphone
LINPHONE_BUILD_DIR=$(BUILDER_BUILD_DIR)/linphone

all: build-linphone
#TODO: build-msilbc build-msamr build-msx264 build-mssilk build-msbcg729 build-msisac

# setup the switches that might trigger a linphone reconfiguration

enable_gpl_third_parties?=yes
enable_ffmpeg?=yes
enable_zrtp?=yes

SWITCHES:=

ifeq ($(enable_gpl_third_parties),yes) 
	SWITCHES+= enable_gpl_third_parties

	ifeq ($(enable_ffmpeg), yes)
		linphone_configure_controls+= --enable-ffmpeg 
		SWITCHES += enable_ffmpeg
	else
		linphone_configure_controls+= --disable-ffmpeg 
		SWITCHES += disable_ffmpeg
	endif

	ifeq ($(enable_zrtp), yes)
		linphone_configure_controls+= --enable-zrtp
		SWITCHES += enable_zrtp
	else
		linphone_configure_controls+= --disable-zrtp
		SWITCHES += disable_zrtp
	endif

else # !enable gpl
	linphone_configure_controls+= --disable-ffmpeg 
	SWITCHES += disable_gpl_third_parties disable_ffmpeg
endif

SWITCHES := $(addprefix $(LINPHONE_BUILD_DIR)/,$(SWITCHES))

mode_switch_check: $(SWITCHES)

#generic rule to force recompilation of linphone if some options require it
$(LINPHONE_BUILD_DIR)/enable_% $(LINPHONE_BUILD_DIR)/disable_%:
	mkdir -p $(LINPHONE_BUILD_DIR)
	cd $(LINPHONE_BUILD_DIR) && rm -f *able_$*
	touch $@
	cd $(LINPHONE_BUILD_DIR) && rm -f Makefile && rm -f oRTP/Makefile && rm -f mediastreamer2/Makefile 

# end of switches parsing

speex_dir=speex

MSILBC_SRC_DIR:=$(BUILDER_SRC_DIR)/msilbc
MSILBC_BUILD_DIR:=$(BUILDER_BUILD_DIR)/msilbc

LIBILBC_SRC_DIR:=$(BUILDER_SRC_DIR)/libilbc-rfc3951
LIBILBC_BUILD_DIR:=$(BUILDER_BUILD_DIR)/libilbc-rfc3951

ifneq (,$(findstring arm,$(host)))
	#SPEEX_CONFIGURE_OPTION := --enable-fixed-point --disable-float-api
	CFLAGS := $(CFLAGS) -marm 
	SPEEX_CONFIGURE_OPTION := --disable-float-api --enable-arm5e-asm --enable-fixed-point
endif

ifneq (,$(findstring armv7,$(host)))
	SPEEX_CONFIGURE_OPTION += --enable-armv7neon-asm 
endif

clean-makefile: clean-makefile-linphone
#TODO: clean-makefile-msbcg729
clean: clean-linphone clean-msbcg729
init:
	mkdir -p $(prefix)/include
	mkdir -p $(prefix)/lib/pkgconfig

veryclean: veryclean-linphone
#TODO: veryclean-msbcg729
	rm -rf $(BUILDER_BUILD_DIR)

# list of the submodules to build
MS_MODULES      := 
#TODO: msilbc libilbc msamr mssilk msx264 msisac
SUBMODULES_LIST := polarssl libantlr belle-sip srtp speex libgsm opus libxml2
#TODO: zrtpcpp libvpx ffmpeg

.NOTPARALLEL build-linphone: init $(addprefix build-,$(SUBMODULES_LIST)) mode_switch_check $(LINPHONE_BUILD_DIR)/Makefile
	cd $(LINPHONE_BUILD_DIR)  && export PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig export CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) make newdate && make && make install
	mkdir -p $(prefix)/share/linphone/tutorials && cp -f $(LINPHONE_SRC_DIR)/coreapi/help/*.c $(prefix)/share/linphone/tutorials/

clean-linphone: $(addprefix clean-,$(SUBMODULES_LIST)) $(addprefix clean-,$(MS_MODULES))
	cd  $(LINPHONE_BUILD_DIR) && make clean

veryclean-linphone: $(addprefix veryclean-,$(SUBMODULES_LIST)) $(addprefix veryclean-,$(MS_MODULES))
#-cd $(LINPHONE_BUILD_DIR) && make distclean
	-cd $(LINPHONE_SRC_DIR) && rm -f configure

clean-makefile-linphone: $(addprefix clean-makefile-,$(SUBMODULES_LIST)) $(addprefix clean-makefile-,$(MS_MODULES))
	cd $(LINPHONE_BUILD_DIR) && rm -f Makefile && rm -f oRTP/Makefile && rm -f mediastreamer2/Makefile


$(LINPHONE_SRC_DIR)/configure:
	cd $(LINPHONE_SRC_DIR) && ./autogen.sh

$(LINPHONE_BUILD_DIR)/Makefile: $(LINPHONE_SRC_DIR)/configure
	mkdir -p $(LINPHONE_BUILD_DIR)
	@echo -e "\033[1mPKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) \
        $(LINPHONE_SRC_DIR)/configure -prefix=$(prefix) --host=$(host) ${library_mode} \
        ${linphone_configure_controls}\033[0m"
	cd $(LINPHONE_BUILD_DIR) && \
	PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) \
	$(LINPHONE_SRC_DIR)/configure -prefix=$(prefix) --host=$(host) ${library_mode} \
	${linphone_configure_controls}
	

#libphone only (asume dependencies are met)
build-liblinphone: $(LINPHONE_BUILD_DIR)/Makefile 
	cd $(LINPHONE_BUILD_DIR)  && export PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig export CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) make newdate &&  make  && make install

clean-makefile-liblinphone:  
	 cd $(LINPHONE_BUILD_DIR) && rm -f Makefile && rm -f oRTP/Makefile && rm -f mediastreamer2/Makefile	 
	 
clean-liblinphone: 
	 cd  $(LINPHONE_BUILD_DIR) && make clean

#speex

$(BUILDER_SRC_DIR)/$(speex_dir)/configure:
	 cd $(BUILDER_SRC_DIR)/$(speex_dir) && ./autogen.sh

$(BUILDER_BUILD_DIR)/$(speex_dir)/Makefile: $(BUILDER_SRC_DIR)/$(speex_dir)/configure
	mkdir -p $(BUILDER_BUILD_DIR)/$(speex_dir)
	cd $(BUILDER_BUILD_DIR)/$(speex_dir)/\
	&& CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) CFLAGS="$(CFLAGS) -O2" \
	$(BUILDER_SRC_DIR)/$(speex_dir)/configure -prefix=$(prefix) --host=$(host) ${library_mode} --disable-ogg  $(SPEEX_CONFIGURE_OPTION)

build-speex: $(BUILDER_BUILD_DIR)/$(speex_dir)/Makefile
	cd $(BUILDER_BUILD_DIR)/$(speex_dir) && make  && make install

clean-speex:
	cd  $(BUILDER_BUILD_DIR)/$(speex_dir)  && make clean

veryclean-speex:
#	-cd $(BUILDER_BUILD_DIR)/$(speex_dir) && make distclean
	-rm -f $(BUILDER_SRC_DIR)/$(speex_dir)/configure

clean-makefile-speex:
	cd $(BUILDER_BUILD_DIR)/$(speex_dir) && rm -f Makefile



# msilbc  plugin

$(MSILBC_SRC_DIR)/configure:
	cd $(MSILBC_SRC_DIR) && ./autogen.sh

$(MSILBC_BUILD_DIR)/Makefile: $(MSILBC_SRC_DIR)/configure
	mkdir -p $(MSILBC_BUILD_DIR)
	cd $(MSILBC_BUILD_DIR) && \
	PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) \
	$(MSILBC_SRC_DIR)/configure -prefix=$(prefix) --host=$(host) $(library_mode)

build-msilbc: build-libilbc $(MSILBC_BUILD_DIR)/Makefile
	cd $(MSILBC_BUILD_DIR) && make  && make install

clean-msilbc:
	cd  $(MSILBC_BUILD_DIR) && make  clean

veryclean-msilbc:
#	-cd $(MSILBC_BUILD_DIR) && make distclean
	-cd $(MSILBC_SRC_DIR) && rm configure

clean-makefile-msilbc:
	cd $(MSILBC_BUILD_DIR) && rm -f Makefile

# libilbc

$(LIBILBC_SRC_DIR)/configure:
	cd $(LIBILBC_SRC_DIR) && ./autogen.sh

$(LIBILBC_BUILD_DIR)/Makefile: $(LIBILBC_SRC_DIR)/configure
	mkdir -p $(LIBILBC_BUILD_DIR)
	cd $(LIBILBC_BUILD_DIR) && \
	PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) \
	$(LIBILBC_SRC_DIR)/configure -prefix=$(prefix) --host=$(host) $(library_mode)

build-libilbc: $(LIBILBC_BUILD_DIR)/Makefile
	cd $(LIBILBC_BUILD_DIR) && make  && make install

clean-libilbc:
	cd  $(LIBILBC_BUILD_DIR) && make clean

veryclean-libilbc:
	-cd $(LIBILBC_BUILD_DIR) && make distclean

clean-makefile-libilbc:
	cd $(LIBILBC_BUILD_DIR) && rm -f Makefile

#openssl
#srtp
#zrtp
include builders.d/*.mk

#sdk generation and distribution
delivery-sdk:
	cd $(BUILDER_SRC_DIR)/../ \
	&& zip  -r   $(BUILDER_SRC_DIR)/liblinphone-bb10-sdk.zip \
	liblinphone-sdk
