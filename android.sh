#!/bin/sh -ex

if [ "$DEVEL" = 'true' ]; then
    cd azahar-dev
else
    cd azahar
fi

../apply.sh

../.ci/android/build.sh $@

cd ..

mkdir artifacts
cp app-release.apk artifacts