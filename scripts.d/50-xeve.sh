#!/bin/bash

SCRIPT_REPO="https://github.com/mpeg5/xeve.git"
SCRIPT_COMMIT="4eda6ca8e0c72fcc814f51800fde267769f9c118"

ffbuild_enabled() {
    [[ $TARGET == *arm64 ]] && return -1
    return 0
}

ffbuild_dockerbuild() {

    if [ ! -f "version.txt" ]; then
        echo v0.7.0 >> version.txt
    fi
    
    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

    mv "$FFBUILD_DESTPREFIX"/lib/xeve/libxeve.a "$FFBUILD_DESTPREFIX"/lib
    
    if [[ $TARGET == win* ]]; then
        rm "$FFBUILD_DESTPREFIX"/bin/libxeve.dll
        rm "$FFBUILD_DESTPREFIX"/lib/libxeve.dll.a
    elif [[ $TARGET == linux* ]]; then
        rm "$FFBUILD_DESTPREFIX"/lib/libxeve.so*
    fi
}

ffbuild_configure() {
    echo --enable-libxeve
}

ffbuild_unconfigure() {
    (( $(ffbuild_ffver) > 601 )) || return 0
    echo --disable-libxeve
}