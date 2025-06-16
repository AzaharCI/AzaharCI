#!/bin/sh -ex
cd azahar

../apply.sh

case "$1" in
    amd64)
        echo "Making x86-64-v3 optimized build of azahar"
        ARCH="amd64_v3"
        ARCH_FLAGS="-march=x86-64-v3"
        ;;
    steamdeck)
        echo "Making Steam Deck (Zen 2) optimized build of azahar"
        ARCH="steamdeck"
        ARCH_FLAGS="-march=znver2 -mtune=znver2"
        ;;
    rog-ally)
        echo "Making ROG Ally X (Zen 4) optimized build of azahar"
        ARCH="rog-ally-x"
        ARCH_FLAGS="-march=znver2 -mtune=znver4" # TODO(cortex): Appears to be a limitation of the actions runner
        ;;
    amd64-legacy)
        echo "Making x86-64 generic build of azahar"
        ARCH=amd64
        ARCH_FLAGS="-march=x86-64 -mtune=generic"
        ;;
    aarch64)
        echo "Making armv8-a build of azahar"
        ARCH=aarch64
        ARCH_FLAGS="-march=armv8-a -mtune=generic"
        ;;
    # TODO(cortex): Test this
    # armv9)
    #     echo "Making armv9-a build of azahar"
    #     ARCH=armv9
    #     ARCH_FLAGS="-march=armv9-a -mtune=generic"
    #     ;;
esac

export ARCH
export ARCH_FLAGS="$ARCH_FLAGS -O3"

lscpu | grep Model

../.ci/linux/build.sh $@
../.ci/linux/package.sh $@
