#!/bin/bash

SCRIPT_REPO="https://github.com/MartinEesmaa/celt.git"
SCRIPT_COMMIT="1bc7188fb8d33dc6e5ba0948a975b8836b430249"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    ./autogen.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --disable-oggtest
        --with-ogg=no
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
    echo --enable-libcelt
}

ffbuild_unconfigure() {
    echo --disable-libcelt
}
