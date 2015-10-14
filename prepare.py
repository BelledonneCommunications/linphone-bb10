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

import argparse
import os
import re
import shutil
import tempfile
import sys
from logging import *
from distutils.spawn import find_executable
from subprocess import Popen, PIPE
sys.dont_write_bytecode = True
sys.path.insert(0, 'submodules/cmake-builder')
try:
    import prepare
except Exception as e:
    error(
        "Could not find prepare module: {}, probably missing submodules/cmake-builder? Try running:\ngit submodule update --init --recursive".format(e))
    exit(1)


class BB10Target(prepare.Target):

    def __init__(self, arch):
        prepare.Target.__init__(self, 'bb10-' + arch)
        current_path = os.path.dirname(os.path.realpath(__file__))
        self.config_file = 'configs/config-bb10-' + arch + '.cmake'
        self.toolchain_file = 'toolchains/toolchain-bb10-' + arch + '.cmake'
        self.output = 'liblinphone-bb10-sdk/' + arch
        self.additional_args = [
            '-DLINPHONE_BUILDER_GROUP_EXTERNAL_SOURCE_PATH_BUILDERS=YES',
            '-DLINPHONE_BUILDER_EXTERNAL_SOURCE_PATH=' + current_path + '/submodules'
        ]

    def clean(self):
        if os.path.isdir('WORK'):
            shutil.rmtree(
                'WORK', ignore_errors=False, onerror=self.handle_remove_read_only)
        if os.path.isdir('liblinphone-bb10-sdk'):
            shutil.rmtree(
                'liblinphone-bb10-sdk', ignore_errors=False, onerror=self.handle_remove_read_only)


class BB10i486Target(BB10Target):

    def __init__(self):
        BB10Target.__init__(self, 'i486')


class BB10armTarget(BB10Target):

    def __init__(self):
        BB10Target.__init__(self, 'arm')


targets = {
    'i486': BB10i486Target(),
    'arm': BB10armTarget()
}
archs_device = ['arm']
archs_simu = ['i486']
platforms = ['all', 'devices', 'simulators'] + archs_device + archs_simu


class PlatformListAction(argparse.Action):

    def __call__(self, parser, namespace, values, option_string=None):
        if values:
            for value in values:
                if value not in platforms:
                    message = ("invalid platform: {0!r} (choose from {1})".format(
                        value, ', '.join([repr(platform) for platform in platforms])))
                    raise argparse.ArgumentError(self, message)
            setattr(namespace, self.dest, values)


def gpl_disclaimer(platforms):
    cmakecache = 'WORK/bb10-{arch}/cmake/CMakeCache.txt'.format(arch=platforms[0])
    gpl_third_parties_enabled = "ENABLE_GPL_THIRD_PARTIES:BOOL=YES" in open(
        cmakecache).read() or "ENABLE_GPL_THIRD_PARTIES:BOOL=ON" in open(cmakecache).read()

    if gpl_third_parties_enabled:
        warning("\n***************************************************************************"
                "\n***************************************************************************"
                "\n***** CAUTION, this liblinphone SDK is built using 3rd party GPL code *****"
                "\n***** Even if you acquired a proprietary license from Belledonne      *****"
                "\n***** Communications, this SDK is GPL and GPL only.                   *****"
                "\n***** To disable 3rd party gpl code, please use:                      *****"
                "\n***** $ ./prepare.py -DENABLE_GPL_THIRD_PARTIES=NO                    *****"
                "\n***************************************************************************"
                "\n***************************************************************************")
    else:
        warning("\n***************************************************************************"
                "\n***************************************************************************"
                "\n***** Linphone SDK without 3rd party GPL software                     *****"
                "\n***** If you acquired a proprietary license from Belledonne           *****"
                "\n***** Communications, this SDK can be used to create                  *****"
                "\n***** a proprietary linphone-based application.                       *****"
                "\n***************************************************************************"
                "\n***************************************************************************")


missing_dependencies = {}


def check_is_installed(binary, prog=None, warn=True):
    if not find_executable(binary):
        if warn:
            missing_dependencies[binary] = prog
            # error("Could not find {}. Please install {}.".format(binary, prog))
        return False
    return True


def check_tools():
    # TODO
    return 0


def generate_makefile(platforms, generator):
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

sdk:
\t@echo "TODO"

build: $(addsuffix -build, $(archs))
\t$(MAKE) sdk

zipsdk: sdk
\t@echo "TODO"

pull-transifex:
\ttx pull -af

push-transifex:
\t./Tools/i18n_generate_strings_files.sh && \\
\ttx push -s -f --no-interactive

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
\t@echo "   * all or build: builds all architectures and creates the liblinphone SDK"
\t@echo "   * sdk: creates the liblinphone SDK. Use this only after a full build"
\t@echo "   * zipsdk: generates a ZIP archive of liblinphone-bb10-sdk containing the SDK. Use this only after SDK is built."
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
    gpl_disclaimer(platforms)


def main(argv=None):
    basicConfig(format="%(levelname)s: %(message)s", level=INFO)

    if argv is None:
        argv = sys.argv
    argparser = argparse.ArgumentParser(
        description="Prepare build of Linphone and its dependencies.")
    argparser.add_argument(
        '-c', '-C', '--clean', help="Clean a previous build instead of preparing a build.", action='store_true')
    argparser.add_argument(
        '-d', '--debug', help="Prepare a debug build, eg. add debug symbols and use no optimizations.", action='store_true')
    argparser.add_argument(
        '-dv', '--debug-verbose', help="Activate ms_debug logs.", action='store_true')
    argparser.add_argument(
        '-f', '--force', help="Force preparation, even if working directory already exist.", action='store_true')
    argparser.add_argument(
        '--disable-gpl-third-parties', help="Disable GPL third parties such as FFMpeg, x264.", action='store_true')
    argparser.add_argument(
        '--enable-non-free-codecs', help="Enable non-free codecs such as OpenH264, MPEG4, etc.. Final application must comply with their respective license (see README.md).", action='store_true')
    argparser.add_argument(
        '-G', '--generator', help="CMake build system generator (default: Unix Makefiles, use cmake -h to get the complete list).", default='Unix Makefiles', dest='generator')
    argparser.add_argument(
        '-L', '--list-cmake-variables', help="List non-advanced CMake cache variables.", action='store_true', dest='list_cmake_variables')
    argparser.add_argument(
        '-lf', '--list-features', help="List optional features and their default values.", action='store_true', dest='list_features')
    argparser.add_argument(
        '-t', '--tunnel', help="Enable Tunnel.", action='store_true')
    argparser.add_argument('platform', nargs='*', action=PlatformListAction, default=[
                           'all'], help="The platform to build for (default is 'devices'). Space separated architectures in list: {0}.".format(', '.join([repr(platform) for platform in platforms])))

    args, additional_args = argparser.parse_known_args()

    additional_args += ["-G", args.generator]

    if check_tools() != 0:
        return 1

    if args.debug_verbose is True:
        additional_args += ["-DENABLE_DEBUG_LOGS=YES"]
    if args.enable_non_free_codecs is True:
        additional_args += ["-DENABLE_NON_FREE_CODECS=YES"]
    if args.disable_gpl_third_parties is True:
        additional_args += ["-DENABLE_GPL_THIRD_PARTIES=NO"]

    if args.tunnel or os.path.isdir("submodules/tunnel"):
        if not os.path.isdir("submodules/tunnel"):
            info("Tunnel wanted but not found yet, trying to clone it...")
            p = Popen("git clone gitosis@git.linphone.org:tunnel.git submodules/tunnel".split(" "))
            p.wait()
            if p.retcode != 0:
                error("Could not clone tunnel. Please see http://www.belledonne-communications.com/voiptunnel.html")
                return 1
        warning("Tunnel enabled, disabling GPL third parties.")
        additional_args += ["-DENABLE_TUNNEL=ON", "-DENABLE_GPL_THIRD_PARTIES=OFF"]

    if args.list_features:
        tmpdir = tempfile.mkdtemp(prefix="linphone-bb10")
        tmptarget = BB10armTarget()
        tmptarget.abs_cmake_dir = tmpdir

        option_regex = re.compile("ENABLE_(.*):(.*)=(.*)")
        option_list = [""]
        build_type = 'Debug' if args.debug else 'Release'
        for line in Popen(tmptarget.cmake_command(build_type, False, True, additional_args),
                          cwd=tmpdir, shell=False, stdout=PIPE).stdout.readlines():
            match = option_regex.match(line)
            if match is not None:
                option_list.append("ENABLE_{} (is currently {})".format(match.groups()[0], match.groups()[2]))
        info("Here is the list of available features: {}".format("\n\t".join(option_list)))
        info("To enable some feature, please use -DENABLE_SOMEOPTION=ON")
        info("Similarly, to disable some feature, please use -DENABLE_SOMEOPTION=OFF")
        shutil.rmtree(tmpdir)
        return 0

    selected_platforms_dup = []
    for platform in args.platform:
        if platform == 'all':
            selected_platforms_dup += archs_device + archs_simu
        elif platform == 'devices':
            selected_platforms_dup += archs_device
        elif platform == 'simulators':
            selected_platforms_dup += archs_simu
        else:
            selected_platforms_dup += [platform]
    # unify platforms but keep provided order
    selected_platforms = []
    for x in selected_platforms_dup:
        if x not in selected_platforms:
            selected_platforms.append(x)

    for platform in selected_platforms:
        target = targets[platform]

        if args.clean:
            target.clean()
        else:
            retcode = prepare.run(target, args.debug, False, args.list_cmake_variables, args.force, additional_args)
            if retcode != 0:
                if retcode == 51:
                    Popen("make help-prepare-options".split(" "))
                    retcode = 0
                return retcode

    if args.clean:
        if os.path.isfile('Makefile'):
            os.remove('Makefile')
    elif selected_platforms:
        # only generated makefile if we are using Ninja or Makefile
        if args.generator == 'Ninja':
            if not check_is_installed("ninja", "it"):
                return 1
            generate_makefile(selected_platforms, 'ninja -C')
        elif args.generator == "Unix Makefiles":
            generate_makefile(selected_platforms, '$(MAKE) -C')
        else:
            print("Not generating meta-makefile for generator {}.".format(args.generator))

    return 0

if __name__ == "__main__":
    sys.exit(main())
