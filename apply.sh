#!/bin/sh -ex

# This script assumes you're running from the source dir

ROOT=$PWD/..

git add .

if [ "$DEVEL" = "true" ]
then
    git reset --hard origin/master
else
    git fetch --tags -f
    git reset --hard $VERSION
fi

# Main patches
# TODO: meta.patch is broken on windows
# git apply $ROOT/core/patch/meta.patch 
git apply $ROOT/core/patch/homeSettings.patch
git apply $ROOT/core/patch/oldFiles.patch
git apply $ROOT/core/patch/configSystem.patch
git apply $ROOT/core/patch/ticket.patch
git apply $ROOT/core/patch/am.patch
git apply $ROOT/core/patch/ci.patch
git apply $ROOT/core/patch/misc.patch
git apply $ROOT/core/patch/encryption.patch
git apply $ROOT/core/patch/ticketFix.patch
git apply $ROOT/core/patch/updateChecker.patch

## Extra Files
# cp $ROOT/core/extra_files/per_game_config.h src/common

# Android
cd src/android/app/src/main

## Extra Files
cp $ROOT/core/extra_files/fragment_system_files.xml res/layout
cp -f $ROOT/core/extra_files/SystemFilesFragment.kt java/org/citra/citra_emu/fragments

## Concat files (android)
sed -i '/} \/\/ extern/d' jni/native.cpp
sed -i '/<\/resources>/d' res/values/arrays.xml
sed -i '/<\/resources>/d' res/values/strings.xml

cat $ROOT/core/concat/native.cat >> jni/native.cpp
cat $ROOT/core/concat/arrays.cat >> res/values/arrays.xml
cat $ROOT/core/concat/strings.cat >> res/values/strings.xml

cd java/org/citra/citra_emu/

# Additional sed patches

sed -i '/unlinkConsole/a    external fun downloadTitleFromNus(title: Long): InstallStatus' NativeLibrary.kt
sed -i 's/show3DSFileWarning: Boolean = true/show3DSFileWarning: Boolean = false/' fragments/GamesFragment.kt
sed -i 's/listOf("3dsx", "elf", "axf", "cci", "cxi", "app")/listOf("3ds", "3dsx", "elf", "axf", "cci", "cxi", "app")/' model/Game.kt

# TODO: Make more patches portable between versions

cd $ROOT/azahar/src

# Extensions
git apply $ROOT/ext/patch/turboAndPerGame.patch
# git apply $ROOT/ext/patch/multiplayer.patch
# git apply $ROOT/ext/patch/perGameDefaults.patch
git apply $ROOT/ext/patch/configHotkeys.patch
git apply $ROOT/ext/patch/azaharAppID.patch
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
