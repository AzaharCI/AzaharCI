#!/bin/sh -x

GRON="https://raw.githubusercontent.com/xonixx/gron.awk/refs/heads/main/gron.awk"
REPO="https://github.com/azahar-emu/azahar.git"

if [ "$DEVEL" = 'true' ]; then
    LOCAL=azahar-dev
else
    LOCAL=azahar
fi


if [ "$DEVEL" = 'true' ]; then
	echo "Making nightly build of azahar..."
	VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9)"
else
	echo "Making stable build of azahar..."
    if [ ! -f gron.awk ]; then
        wget "$GRON" -O ./gron.awk
    fi
	chmod +x ./gron.awk
	VERSION=$(wget https://api.github.com/repos/azahar-emu/azahar/tags -O - \
		| ./gron.awk | awk -F'=|"' '/name/ {print $3; exit}')
fi

if [ ! -d "$LOCAL" ]; then
    if [ "$DEVEL" = 'true' ]; then
        git clone --recursive -j$(nproc) "$REPO" ./azahar-dev
    else
        git clone --recursive -j$(nproc) --branch "$VERSION" "$REPO" ./azahar
    fi
else
    cd $LOCAL

    git fetch
    git checkout $VERSION
    git submodule update --init --recursive
fi

echo $VERSION > ~/version
export VERSION
echo "VERSION=$VERSION" >> $GITHUB_ENV


# OLD:
# git clone https://github.com/azahar-emu/azahar.git --recursive

# cd azahar

# if [ "$DEVEL" != 'true' ]
# then
#     AZAHAR_TAG=$(git describe --tags --abbrev=0)
#     git checkout $AZAHAR_TAG
#     export VERSION=$AZAHAR_TAG
# else
#     export VERSION=$(git rev-parse --short HEAD)
# fi
