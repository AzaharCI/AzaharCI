#!/bin/sh -ex

mkdir build && cd build

if [ "$DEVEL" != "true" ]; then
	export EXTRA_CMAKE_FLAGS=(-DENABLE_QT_UPDATE_CHECKER=ON)
fi

cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DENABLE_QT_TRANSLATION=ON \
    -DUSE_DISCORD_PRESENCE=ON \
    -DENABLE_TESTS=OFF \
	"${EXTRA_CMAKE_FLAGS[@]}"

ninja
ninja bundle
strip -s bundle/*.exe

ccache -s -v