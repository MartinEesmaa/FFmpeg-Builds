#!/bin/bash

SCRIPT_REPO="https://svn.code.sf.net/p/xavs/code/trunk"
SCRIPT_REV="55"

ffbuild_enabled() {
    [[ $TARGET == *arm64 ]] && return -1
    return 0
}

ffbuild_dockerdl() {
    echo "retry-tool sh -c \"rm -rf xavs && svn checkout '${SCRIPT_REPO}@${SCRIPT_REV}' xavs\" && cd xavs"
}

ffbuild_dockerbuild() {

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --enable-pic
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
            --cross-prefix="$FFBUILD_CROSS_PREFIX"
            --extra-cflags="-Wno-error=int-conversion -Wno-error=declaration-missing-parameter-type"
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
    echo --enable-libxavs
}

ffbuild_unconfigure() {
    echo --disable-libxavs
}
