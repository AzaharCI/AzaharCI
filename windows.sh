#!/bin/sh -x
cd azahar

../apply.sh

../.ci/windows/build.sh $@

ls

echo
echo

ls *