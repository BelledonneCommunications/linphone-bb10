polarssl_dir?=polarssl

$(BUILDER_SRC_DIR)/$(polarssl_dir)/configure:
	cd $(BUILDER_SRC_DIR)/$(polarssl_dir) && ./autogen.sh

$(BUILDER_BUILD_DIR)/$(polarssl_dir)/Makefile: $(BUILDER_SRC_DIR)/$(polarssl_dir)/configure
	mkdir -p $(BUILDER_BUILD_DIR)/$(polarssl_dir)
	cd $(BUILDER_BUILD_DIR)/$(polarssl_dir)/ \
	&& PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site) \
	$(BUILDER_SRC_DIR)/$(polarssl_dir)/configure --prefix=$(prefix) --host=$(host) ${library_mode}

build-polarssl: $(BUILDER_BUILD_DIR)/$(polarssl_dir)/Makefile
	cd $(BUILDER_BUILD_DIR)/$(polarssl_dir) && PKG_CONFIG_LIBDIR=$(prefix)/lib/pkgconfig CONFIG_SITE=$(BUILDER_SRC_DIR)/build/$(config_site)  make && make install

clean-polarssl:
	cd  $(BUILDER_BUILD_DIR)/$(polarssl_dir) && make clean

veryclean-polarssl:
	-cd $(BUILDER_BUILD_DIR)/$(polarssl_dir) && make distclean
	rm -f $(BUILDER_SRC_DIR)/$(polarssl_dir)/configure

clean-makefile-polarssl:
	cd $(BUILDER_BUILD_DIR)/$(polarssl_dir) && rm -f Makefile
