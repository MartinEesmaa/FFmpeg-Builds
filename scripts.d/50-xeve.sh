#!/bin/bash

SCRIPT_REPO="https://github.com/mpeg5/xeve"

ffbuild_enabled() {
    [[ $TARGET == *arm64 ]] && return -1
    return 0
}

ffbuild_dockerbuild() {

    if [ ! -f "version.txt" ]; then
        echo v0.5.1 >> version.txt
    fi
    
    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" ..
    make -j$(nproc)
    make install

    mv "$FFBUILD_PREFIX"/lib/xeve/libxeve.a "$FFBUILD_PREFIX"/lib
    
    if [[ $TARGET == win* ]]; then
        rm "$FFBUILD_PREFIX"/bin/libxeve.dll
        rm "$FFBUILD_PREFIX"/lib/libxeve.dll.a
    elif [[ $TARGET == linux* ]]; then
        rm "$FFBUILD_PREFIX"/lib/libxeve.so*
    fi
}

ffbuild_configure() {
    echo --enable-libxeve
}

ffbuild_unconfigure() {
    (( $(ffbuild_ffver) > 601 )) || return 0
    echo --disable-libxeve
}