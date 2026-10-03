#!/bin/bash

SCRIPT_REPO="https://github.com/cacalabs/libcaca.git"
SCRIPT_COMMIT="de48e1a0888caabdc6276afdea46e9096d0adb05"

ffbuild_enabled() {
    [[ $TARGET == linux* ]] || return 1
    return 0
}

ffbuild_dockerbuild() {
    ./bootstrap

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --host="$FFBUILD_TOOLCHAIN"
        --disable-shared
        --enable-static
        --disable-extra-programs
        --disable-csharp 
        --disable-java 
        --disable-cxx 
        --disable-python 
        --disable-ruby 
        --disable-doc 
        --disable-cocoa 
        --disable-ncurses
    )

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
}

ffbuild_configure() {
    echo --enable-libcaca
}

ffbuild_unconfigure() {
    echo --disable-libcaca
}
