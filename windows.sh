#!/bin/sh -ex

if [ "$DEVEL" = 'true' ]; then
    cd azahar-dev
else
    cd azahar
fi

../apply.sh

../.ci/windows/build.sh $@