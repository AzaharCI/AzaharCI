#!/bin/sh -ex

# This script assumes you're running from the source dir

ROOT=$PWD/..

git add .

git fetch --tags -f
git reset --hard $VERSION

# Main patches
# TODO: meta.patch is broken on windows
# git apply $ROOT/core/patch/meta.patch 
git apply $ROOT/core/patch/configSystem.patch
git apply $ROOT/core/patch/ticket.patch
git apply $ROOT/core/patch/am.patch # TODO: Make this a file injection
git apply $ROOT/core/patch/ci.patch
git apply $ROOT/core/patch/misc.patch
git apply $ROOT/core/patch/encryption.patch # TODO: This contains lots of unnecessary changes.
git apply $ROOT/core/patch/updateChecker.patch

cd src

# Injections
# FORMAT: srcFile destLoc
# srcFile is relative to extra_files, destLoc is relative to src

for file in $ROOT/core/inject/*
do
    ls $PWD/android/app
    while read src dest; do
        cp $ROOT/core/extra_files/$src $dest
    done < $file
done

# needed for aarch64
sed -i '/shader_setup.h/a#include <memory>' video_core/shader/shader_jit_a64_compiler.h

# Android
cd android/app/src/main

## Extra Files

## Concat files (android)
sed -i '/} \/\/ extern/d' jni/native.cpp
sed -i '/<\/resources>/d' res/values/arrays.xml
sed -i '/<\/resources>/d' res/values/strings.xml
sed -i '/setup_system_files/d' res/values*/strings.xml

cat $ROOT/core/concat/native.cat >> jni/native.cpp
cat $ROOT/core/concat/arrays.cat >> res/values/arrays.xml
cat $ROOT/core/concat/strings.cat >> res/values/strings.xml

cd java/org/citra/citra_emu/

# Additional sed patches

sed -i '/unlinkConsole/a    external fun downloadTitleFromNus(title: Long): InstallStatus' NativeLibrary.kt
sed -i 's/show3DSFileWarning: Boolean = true/show3DSFileWarning: Boolean = false/' fragments/GamesFragment.kt
sed -i 's/listOf("3dsx", "elf", "axf", "cci", "cxi", "app")/listOf("3ds", "3dsx", "elf", "axf", "cci", "cxi", "app")/' model/Game.kt

# TODO: Make more patches portable between versions

if [ "$DEVEL" = 'true' ]; then
    cd $ROOT/azahar-dev/src
else
    cd $ROOT/azahar/src
fi

# Extensions
# TODO: Make dev-patches more easily manageable
if [ "$DEVEL" != "true" ]
then
    git apply $ROOT/ext/patch/turboAndPerGame.patch
    git apply $ROOT/ext/patch/azaharAppID.patch
else
    git apply $ROOT/ext/patch/dev/turboAndPerGame.patch
    git apply $ROOT/ext/patch/dev/azaharAppID.patch
fi
# git apply $ROOT/ext/patch/multiplayer.patch
git apply $ROOT/ext/patch/configHotkeys.patch
git apply $ROOT/ext/patch/androidArmOnly.patch

## Extensions - Shell Scripts
$ROOT/ext/script/game-qt.sh
$ROOT/ext/script/appimage-shortcut.sh

## Update checker -- run this no matter what
sed -i 's|azahar-emu/azahar|AzaharCI/AzaharCI|g' citra_qt/update_checker.cpp
cd ..

# Make future patches easier to make
git add .
if [ "$(git config --get user.name)" = "" ]
then
    git config user.name AzaharCI
    git config user.email azahar.ci@example.com
fi

git commit -am "Applied patches" --no-verify

if [ "$DEVEL" != "true" ]
then
    git tag $VERSION -f
    git apply $ROOT/ext/patch/releaseTag.patch
fi
