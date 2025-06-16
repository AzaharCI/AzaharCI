#!/bin/bash -ex

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
