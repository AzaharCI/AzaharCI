#!/bin/sh -x
cd azahar

../apply.sh

../.ci/android/build.sh $@

cd ..

mkdir artifacts
cp app-release.apk artifacts