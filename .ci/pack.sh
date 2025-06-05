#!/bin/sh -ex

mkdir -p artifacts
cp linux-*/*AppImage* artifacts
cp android*/app-release.apk artifacts/azahar-$VERSION-universal.apk

for target in msys2 msvc
do
    zip -r artifacts/azahar-windows-$target-$VERSION-portable.zip windows-$target-portable/*
    if [ -d "windows-$target-installer" ]
    then
        mv windows-$target-installer/*.exe artifacts/azahar-windows-$target-$VERSION-installer.exe
    fi
done
