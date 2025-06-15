#!/bin/sh -ex
cd azahar

../apply.sh

../.ci/linux/build.sh $@
../.ci/linux/package.sh $@
