#!/bin/sh -x
git clone https://github.com/azahar-emu/azahar.git --recursive

cd azahar

if [ "$DEVEL" != 'true' ]
then
    AZAHAR_TAG=$(git describe --tags --abbrev=0)
    git checkout $AZAHAR_TAG
    export VERSION=$AZAHAR_TAG
else
    export VERSION=$(git rev-parse --short HEAD)
fi

echo $VERSION > ~/version
echo "VERSION=$VERSION" >> $GITHUB_ENV
