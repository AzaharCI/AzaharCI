#!/bin/bash -ex

ARCH="$(uname -m)"

if [ "$ARCH" = 'x86_64' ]; then
	if [ "$1" = 'v3' ]; then
		echo "Making x86-64-v3 optimized build of azahar"
		ARCH="${ARCH}_v3"
		ARCH_FLAGS="-march=x86-64-v3 -O3"
  elif [ "$1" = 'steamdeck' ]; then
    echo "Making Steam Deck (Zen 2) optimized build of azahar"
    ARCH="steamdeck"
    ARCH_FLAGS="-march=znver2 -mtune=znver2 -O3"
  elif [ "$1" = 'allyx' ]; then
    echo "Making ROG Ally X (Zen 4) optimized build of azahar"
    ARCH="rog-ally-x"
    ARCH_FLAGS="-march=znver4 -mtune=znver4 -O3"
  # TODO(cortex): Add a znver5 target for that new Xbox handheld
	else
		echo "Making x86-64 generic build of azahar"
		ARCH_FLAGS="-march=x86-64 -mtune=generic -O3"
	fi
else
	echo "Making aarch64 build of azahar"
	ARCH_FLAGS="-march=armv8-a -mtune=generic -O3"
fi

export ARCH

if [ "$TARGET" = "appimage" ]; then
    export EXTRA_CMAKE_FLAGS=(-DCMAKE_LINKER=/etc/bin/ld.lld
                              -DENABLE_ROOM_STANDALONE=OFF)
else
    # For the linux-fresh verification target, verify compilation without PCH as well.
    export EXTRA_CMAKE_FLAGS=(-DCITRA_USE_PRECOMPILED_HEADERS=OFF)
fi

if [ "$DEVEL" != "true" ]; then
    export EXTRA_CMAKE_FLAGS=("${EXTRA_CMAKE_FLAGS[@]}" -DENABLE_QT_UPDATE_CHECKER=ON)
fi

mkdir -p build
cd build

cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="$ARCH_FLAGS" \
    -DCMAKE_C_FLAGS="$ARCH_FLAGS" \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DENABLE_QT_TRANSLATION=ON \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DENABLE_ROOM_STANDALONE=OFF \
    -DUSE_DISCORD_PRESENCE=ON \
    -DENABLE_TESTS=OFF \
    -DENABLE_ROOM_STANDALONE=OFF \
    "${EXTRA_CMAKE_FLAGS[@]}"
ninja

if [ -d "bin/Release" ]; then
  strip -s bin/Release/*
else
  strip -s bin/*
fi
