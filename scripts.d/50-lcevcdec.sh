#!/bin/bash

SCRIPT_REPO="https://github.com/v-novaltd/LCEVCdec.git"
SCRIPT_COMMIT="e295d8438ba554bc541fb269baa9cbd567b626a8"

ffbuild_enabled() {
    [[ $TARGET == winarm* ]] && return -1
    (( $(ffbuild_ffver) > 800 )) || return -1
    return -1
}

ffbuild_dockerbuild() {

    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF -DVN_SDK_FFMPEG_LIBS_PACKAGE="" -DVN_SDK_{JSON_CONFIG,EXECUTABLES,UNIT_TESTS,SAMPLE_SOURCE}=OFF .. -G Ninja

    ninja -j$(nproc)
    DESTDIR="$FFBUILD_DESTDIR" ninja install
}

ffbuild_configure() {
    echo --enable-liblcevc_dec
}

ffbuild_unconfigure() {
    (( $(ffbuild_ffver) > 701 )) || return 0
    echo --disable-liblcevc_dec
}
