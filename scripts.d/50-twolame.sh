#!/bin/bash

SCRIPT_REPO="https://github.com/njh/twolame.git"
SCRIPT_COMMIT="6fced852d4d5cfad58cf9dbe3ea619b08e87d398"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {

    NOCONFIGURE=1 ./autogen.sh
    touch doc/twolame.1

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --with-pic
        --disable-shared
        --enable-static
        --disable-sndfile
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

    sed -i 's/Cflags:/Cflags: -DLIBTWOLAME_STATIC/' "$FFBUILD_DESTPREFIX"/lib/pkgconfig/twolame.pc
}

ffbuild_configure() {
    echo --enable-libtwolame
}

ffbuild_unconfigure() {
    echo --disable-libtwolame
}

ffbuild_cflags() {
    echo -DLIBTWOLAME_STATIC
}
