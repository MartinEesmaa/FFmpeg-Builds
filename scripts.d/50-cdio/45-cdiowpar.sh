#!/bin/bash

SCRIPT_REPO="https://github.com/libcdio/libcdio-C.git"
SCRIPT_COMMIT="68ea374f83d5e63122168e4e182b15ba10e0d2eb"

ffbuild_enabled() {
    [[ $TARGET == win* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    autoreconf -if

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --disable-maintainer-mode
        --without-cd-drive
        --without-cd-info
        --without-cdda-player
        --without-cd-read
        --without-iso-info
        --without-iso-read
        --disable-cpp-progs
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
    cd doc && make stamp-vti && cd ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
}
