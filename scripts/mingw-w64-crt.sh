
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

PKG_NAME=mingw-w64-crt-${RUNTIME_VERSION}
PKG_DIR_NAME=mingw-w64${MINGW_PKG_DIR_VERSION_SUFFIX}/mingw-w64-crt

[[ $USE_MULTILIB == yes ]] && {
	PKG_NAME=$BUILD_ARCHITECTURE-$PKG_NAME-multi
} || {
	PKG_NAME=$BUILD_ARCHITECTURE-$PKG_NAME-nomulti
}

PKG_PRIORITY=runtime

#

PKG_PATCHES=(
	$( [[ $RUNTIME_VERSION == v10.0.0 ]] && \
		[[ $MSVCRT_VERSION == ucrt ]] && {
			echo "mingw-w64/89bacd2be60fa92dd74d3b5f2074b06a32d8c784.patch"
			echo "mingw-w64/bceadc54d8f32b3f14c69074892e2718eac08e3b.patch"
		}
	)
	$( [[ $RUNTIME_MAJOR_VERSION -ge 11 ]] && {
		[[ $RUNTIME_MAJOR_VERSION -le 12 ]] && {
			echo "mingw-w64/9001-v11-crt-Mark-atexit-as-DATA-because-it-s-always-overridd.patch"
		}
		[[ $RUNTIME_MAJOR_VERSION -ge 13 ]] && {
			echo "mingw-w64/9002-v13-crt-Provide-wrappers-for-exit-in-libmingwex.patch"
		} || {
			[[ $RUNTIME_MAJOR_VERSION -ge 12 ]] && {
				echo "mingw-w64/9002-v12-crt-Provide-wrappers-for-exit-in-libmingwex.patch"
			} || {
				echo "mingw-w64/9002-v11-crt-Provide-wrappers-for-exit-in-libmingwex.patch"
			}
		}
		[[ $RUNTIME_MAJOR_VERSION -ge 13 ]] && {
			echo "mingw-w64/9003-v13-crt-Implement-standard-conforming-termination-support.patch"
		} || {
			echo "mingw-w64/9003-v11-crt-Implement-standard-conforming-termination-support.patch"
		}
	})
)

#

PKG_EXECUTE_AFTER_PATCH=(
	"automake"
)

#

[[ $USE_MULTILIB == yes ]] && {
	LIBCONF="--enable-lib32 --enable-lib64"
	CRTPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-${RUNTIME_VERSION}-multi
} || {
	CRTPREFIX=$RUNTIME_DIR/$BUILD_ARCHITECTURE-mingw-w64-${RUNTIME_VERSION}-nomulti
	[[ $BUILD_ARCHITECTURE == i686 ]] && {
		LIBCONF="--enable-lib32 --disable-lib64"
	} || {
		LIBCONF="--disable-lib32 --enable-lib64"
	}
}

[[ -d $PREREQ_DIR ]] && {
	pushd $PREREQ_DIR > /dev/null
	PREREQW_DIR=`pwd -W`
	popd > /dev/null
}

MY_CPPFLAGS=$( [[ $THREADS_MODEL == mcf ]] && echo "-D__USING_MCFGTHREAD__ -I$PREREQW_DIR/$BUILD_ARCHITECTURE-mcfgthread/include" )

PKG_CONFIGURE_FLAGS=(
	--host=$HOST
	--build=$BUILD
	--target=$TARGET
	#
	--prefix=$CRTPREFIX
	--with-sysroot=$CRTPREFIX
	#
	$LIBCONF
	$( [[ $CRT_GLOB == yes ]] \
		&& echo "--enable-wildcard" \
	)
	--with-default-msvcrt=$MSVCRT_VERSION
	#
	CFLAGS="$COMMON_CFLAGS"
	CXXFLAGS="$COMMON_CXXFLAGS"
	CPPFLAGS="$COMMON_CPPFLAGS $MY_CPPFLAGS"
	LDFLAGS="$COMMON_LDFLAGS"
)

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	all
)

#

PKG_TESTSUITE_FLAGS=(
	-j$JOBS
	check
)

#

PKG_INSTALL_FLAGS=(
	-j$JOBS
	$( [[ $STRIP_ON_INSTALL == yes ]] && echo install-strip || echo install )
)

# **************************************************************************
