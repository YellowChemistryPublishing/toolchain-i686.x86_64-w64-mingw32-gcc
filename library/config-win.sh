
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2023 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
# All rights reserved.
#
# Project: MinGW-Builds ( https://github.com/niXman/mingw-builds )
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'MinGW-W64' nor the names of its contributors may
#     be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# **************************************************************************

readonly HOST_MINGW_VERSION=15.1.0
readonly HOST_MINGW_RT_VERSION=12
readonly HOST_MINGW_BUILD_REV=0
readonly i686_HOST_MINGW_PATH_URL="https://github.com/niXman/mingw-builds-binaries/releases/download/$HOST_MINGW_VERSION-rt_v$HOST_MINGW_RT_VERSION-rev$HOST_MINGW_BUILD_REV/i686-$HOST_MINGW_VERSION-release-posix-{exceptions}-{msvcrt}-rt_v$HOST_MINGW_RT_VERSION-rev$HOST_MINGW_BUILD_REV.7z"
readonly x86_64_HOST_MINGW_PATH_URL="https://github.com/niXman/mingw-builds-binaries/releases/download/$HOST_MINGW_VERSION-rt_v$HOST_MINGW_RT_VERSION-rev$HOST_MINGW_BUILD_REV/x86_64-$HOST_MINGW_VERSION-release-posix-{exceptions}-{msvcrt}-rt_v$HOST_MINGW_RT_VERSION-rev$HOST_MINGW_BUILD_REV.7z"

# **************************************************************************

function func_get_host { echo "$1-w64-mingw32"; }
function func_get_build { echo "$1-w64-mingw32"; }
function func_get_target { echo "$1-w64-mingw32"; }

readonly CROSS_BUILDS=no

# **************************************************************************

readonly REPOSITORY_FILE="$PROJECT_ROOT_URL/files/Toolchains targetting Win32/Personal Builds/mingw-builds/installer/repository.txt"

# **************************************************************************

readonly LOGVIEWERS=(
	"c:/progra~2/notepad++/notepad++.exe"
	"c:/progra~1/notepad++/notepad++.exe"
	"$USERPROFILE/AppData/Local/Microsoft/WindowsApps/notepad"
	"notepad"
)

# **************************************************************************

[[ -d /mingw ]] && {
	die "please remove \"/mingw\" directory. terminate."
}

[[ -n $(which "gcc.exe" 2>/dev/null) || \
	-n $(which "i686-pc-mingw32-gcc.exe" 2>/dev/null) || \
	-n $(which "i686-w64-mingw32-gcc.exe" 2>/dev/null) || \
	-n $(which "x86_64-w64-mingw32-gcc.exe" 2>/dev/null) \
]] && {
	die "remove from PATH any gcc.exe or MingW gcc.exe. terminate."
}

# **************************************************************************

function func_test_installed_packages {
	local required_packages=(
		lndir
		git
		subversion
		tar
		zip
		p7zip
		make
		patch
		automake-wrapper
		autoconf
		autoconf-archive
		libtool
		flex
		bison
		gettext
		gettext-devel
		wget
		sshpass
		texinfo
		autogen
		dejagnu
		pkgconf
	)

	echo "--> installing required packages..."
	pacman -Sy --noconfirm --needed$(printf " %s" "${required_packages[@]}") ||
		return 1

	return 0
}

# **************************************************************************
