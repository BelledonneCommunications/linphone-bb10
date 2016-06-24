#!/usr/bin/env python

############################################################################
# prepare.py
# Copyright (C) 2015  Belledonne Communications, Grenoble France
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

import os
import sys
from logging import error, warning, info
from subprocess import Popen
sys.dont_write_bytecode = True
sys.path.insert(0, 'submodules/cmake-builder')
try:
    import prepare
except Exception as e:
    error(
        "Could not find prepare module: {}, probably missing submodules/cmake-builder? Try running:\n"
        "git submodule sync && git submodule update --init --recursive".format(e))
    exit(1)



class BB10Target(prepare.Target):

    def __init__(self, arch):
        prepare.Target.__init__(self, 'bb10-' + arch)
        current_path = os.path.dirname(os.path.realpath(__file__))
        self.config_file = 'configs/config-bb10-' + arch + '.cmake'
        self.toolchain_file = 'toolchains/toolchain-bb10-' + arch + '.cmake'
        self.output = 'liblinphone-bb10-sdk/' + arch
        self.external_source_path = os.path.join(current_path, 'submodules')


class BB10i486Target(BB10Target):

    def __init__(self):
        BB10Target.__init__(self, 'i486')


class BB10armTarget(BB10Target):

    def __init__(self):
        BB10Target.__init__(self, 'arm')


bb10_targets = {
    'i486': BB10i486Target(),
    'arm': BB10armTarget()
}

class BB10Preparator(prepare.Preparator):

    def __init__(self, targets=bb10_targets):
        prepare.Preparator.__init__(self, targets)
        self.veryclean = True
        self.show_gpl_disclaimer = True

    def clean(self):
        prepare.Preparator.clean(self)
        if os.path.isfile('Makefile'):
            os.remove('Makefile')
        if os.path.isdir('WORK') and not os.listdir('WORK'):
            os.rmdir('WORK')
        if os.path.isdir('liblinphone-bb10-sdk') and not os.listdir('liblinphone-bb10-sdk'):
            os.rmdir('liblinphone-bb10-sdk')

    def generate_makefile(self, generator, project_file=''):
        platforms = self.args.target
        arch_targets = ""
        for arch in platforms:
            arch_targets += """
{arch}: {arch}-build

{arch}-build:
\t{generator} WORK/bb10-{arch}/cmake
\t@echo "Done"

WORK/bb10-{arch}/build.done:
\t$(MAKE) {arch}-build && touch WORK/bb10-{arch}/build.done

{arch}-dev: WORK/bb10-{arch}/build.done
\t{generator} WORK/bb10-{arch}/Build/linphone_builder install
\t@echo "Done"
""".format(arch=arch, generator=generator)
        multiarch = ""
        for arch in platforms[1:]:
            multiarch += \
            """\tif test -f "$${arch}_path"; then \\
\t\tall_paths=`echo $$all_paths $${arch}_path`; \\
\t\tall_archs="$$all_archs,{arch}" ; \\
\telse \\
\t\techo "WARNING: archive `basename $$archive` exists in {first_arch} tree but does not exists in {arch} tree: $${arch}_path."; \\
\tfi; \\
""".format(first_arch=platforms[0], arch=arch)
        makefile = """
archs={archs}
LINPHONE_BB10_VERSION=$(shell git describe --always)

.PHONY: all
.SILENT: sdk
all: build

dev: $(addsuffix -dev, $(archs))
\t$(MAKE) sdk

sdk: build

build: $(addsuffix -build, $(archs))

zipsdk: sdk
\techo "Generating SDK zip file for version $(LINPHONE_BB10_VERSION)"
\tzip -r liblinphone-bb10-sdk-$(LINPHONE_BB10_VERSION).zip \\
\tliblinphone-bb10-sdk

pull-transifex:
\t@echo "TODO"

push-transifex:
\t@echo "TODO"

{arch_targets}

help-prepare-options:
\t@echo "prepare.py was previously executed with the following options:"
\t@echo "   {options}"

help: help-prepare-options
\t@echo ""
\t@echo "(please read the README.md file first)"
\t@echo ""
\t@echo "Available architectures: {archs}"
\t@echo ""
\t@echo "Available targets:"
\t@echo ""
\t@echo "   * all, build or sdk: builds all architectures and creates the liblinphone SDK."
\t@echo "   * zipsdk: generates a ZIP archive of liblinphone-bb10-sdk containing the SDK."
\t@echo ""
\t@echo "=== Advanced usage ==="
\t@echo ""
\t@echo "   * build: builds for all architectures"
\t@echo ""
\t@echo "   * [{arch_opts}]-build: builds for the selected architecture"
\t@echo ""
""".format(archs=' '.join(platforms), arch_opts='|'.join(platforms),
           first_arch=platforms[0], options=' '.join(sys.argv),
           arch_targets=arch_targets,
           multiarch=multiarch, generator=generator)
        f = open('Makefile', 'w')
        f.write(makefile)
        f.close()



def main():
    preparator = BB10Preparator()
    preparator.parse_args()
    if preparator.check_environment() != 0:
        preparator.show_environment_errors()
        return 1
    return preparator.run()

if __name__ == "__main__":
    sys.exit(main())
