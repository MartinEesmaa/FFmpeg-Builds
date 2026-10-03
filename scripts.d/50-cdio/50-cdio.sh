#!/bin/bash

SCRIPT_REPO="https://github.com/libcdio/libcdio-paranoia.git"
SCRIPT_COMMIT="384f4dac7e211cce67a14f3df53fc596965b6c94"

ffbuild_enabled() {
    [[ $TARGET == winarm* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    autoreconf -if

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --disable-maintainer-mode
        --disable-example-progs
        --with-pic
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
}

ffbuild_configure() {
    echo --enable-libcdio
}

ffbuild_unconfigure() {
    echo --disable-libcdio
}
