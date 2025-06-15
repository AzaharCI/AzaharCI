#!/bin/sh -ex
cd azahar

../apply.sh

../.ci/windows/build.sh $@