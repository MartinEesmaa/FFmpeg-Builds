#!/bin/bash

SCRIPT_REPO="https://git.savannah.gnu.org/git/libcdio.git"

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
        --without-cd-drive
        --without-cd-info
        --without-cdda-player
        --without-cd-read
        --without-iso-info
        --without-iso-read
        --disable-cpp-progs
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
