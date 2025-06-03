#!/bin/sh

# This script assumes you're in the source directory
set -ex

export APPIMAGE_EXTRACT_AND_RUN=1
export BASE_ARCH="$(uname -m)"
export ARCH="$BASE_ARCH"

export BUILDDIR="$2"

LIB4BN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"
URUNTIME="https://github.com/VHSgunzo/uruntime/releases/latest/download/uruntime-appimage-dwarfs-$ARCH"

if [ "$ARCH" = 'x86_64' ]; then
	if [ "$1" = 'v3' ]; then
		ARCH="${ARCH}_v3"
	fi
fi

if [ "$BUILDDIR" = '' ]
then
	BUILDDIR=build
fi

if [ -d "$BUILDDIR/bin/Release" ]; then
  mv $BUILDDIR/bin/Release/* $BUILDDIR/bin
  rmdir $BUILDDIR/bin/Release
fi

# NOW MAKE APPIMAGE
mkdir -p ./AppDir
cd ./AppDir

cp ../dist/azahar.svg ./org.azahar_emu.Azahar.svg
cp ../../azahar.desktop ./org.azahar_emu.Azahar.desktop

if [ "$DEVEL" = 'true' ]; then
	sed -i 's|Name=Azahar|Name=Azahar nightly|' ./org.azahar_emu.Azahar.desktop
	UPINFO="$(echo "$UPINFO" | sed 's|latest|nightly|')"
fi

ln -sf ./org.azahar_emu.Azahar.svg ./.DirIcon

UPINFO='gh-releases-zsync|Sneedplex|AzaharCI|latest|*.AppImage.zsync'

LIBDIR="/usr/lib"

if [ ! -d "$LIBDIR/dri" ]
then
    LIBDIR="/usr/lib/${BASE_ARCH}-linux-gnu"
fi

# Bundle all libs
wget --retry-connrefused --tries=30 "$LIB4BN" -O ./lib4bin
chmod +x ./lib4bin
xvfb-run -a -- ./lib4bin -p -v -e -s -k \
	../$BUILDDIR/bin/azahar* \
	$LIBDIR/lib*GL*.so* \
	$LIBDIR/dri/* \
	$LIBDIR/vdpau/* \
	$LIBDIR/libvulkan* \
	$LIBDIR/libXss.so* \
	$LIBDIR/libdecor-0.so* \
	$LIBDIR/libgamemode.so* \
	$LIBDIR/qt6/plugins/audio/* \
	$LIBDIR/qt6/plugins/bearer/* \
	$LIBDIR/qt6/plugins/imageformats/* \
	$LIBDIR/qt6/plugins/iconengines/* \
	$LIBDIR/qt6/plugins/platforms/* \
	$LIBDIR/qt6/plugins/platformthemes/* \
	$LIBDIR/qt6/plugins/platforminputcontexts/* \
	$LIBDIR/qt6/plugins/styles/* \
	$LIBDIR/qt6/plugins/xcbglintegrations/* \
	$LIBDIR/qt6/plugins/wayland-*/* \
	$LIBDIR/pulseaudio/* \
	$LIBDIR/pipewire-0.3/* \
	$LIBDIR/spa-0.2/*/* \
	$LIBDIR/alsa-lib/*

# Prepare sharun
if [ "$ARCH" = 'aarch64' ]; then
	echo 'SHARUN_ALLOW_SYS_VKICD=1' > ./.env
fi

wget https://github.com/VHSgunzo/sharun/releases/download/v0.6.3/sharun-x86_64 -O sharun
chmod a+x sharun

if [ "$ARCH" = 'aarch64' ]; then # allow using host vk for aarch64 given the sad situation
	echo 'SHARUN_ALLOW_SYS_VKICD=1' >> ./.env
fi

ln -f ./sharun ./AppRun
./sharun -g

# turn appdir into appimage
cd ..
wget -q "$URUNTIME" -O ./uruntime
chmod +x ./uruntime

echo "Adding update information \"$UPINFO\" to runtime..."
./uruntime --appimage-addupdinfo "$UPINFO"

echo "Generating AppImage..."
./uruntime --appimage-mkdwarfs -f \
	--set-owner 0 --set-group 0 \
	--no-history --no-create-timestamp \
	--compression zstd:level=22 -S26 -B32 \
	--header uruntime \
	-i ./AppDir -o Azahar-"$VERSION"-"$ARCH".AppImage

echo "Generating zsync file..."
zsyncmake *.AppImage -u *.AppImage
echo "All Done!"

# Cleanup

#rm -rf AppDir
#rm uruntime
