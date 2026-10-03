#!/bin/bash

SCRIPT_REPO="https://github.com/MartinEesmaa/uavs3e.git"
SCRIPT_COMMIT="eca828b2cf05ebb7fef2e2505e3ee2a2156ba2b1"

ffbuild_enabled() {
    [[ $TARGET == win32 ]] && return -1
    [[ $TARGET == winarm64 ]] && return -1
    [[ $TARGET == linuxarm64 ]] && return -1
    return 0
}

ffbuild_dockerdl() {
    echo "git clone \"$SCRIPT_REPO\" . && git checkout \"$SCRIPT_COMMIT\""
}

ffbuild_dockerbuild() {
    mkdir build/linux
    cd build/linux

    export CFLAGS="$CFLAGS -Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration"
    export CXXFLAGS="$CXXFLAGS -Wno-error=incompatible-pointer-types -Wno-error=implicit-function-declaration"

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DCOMPILE_10BIT=1 -DCOMPILE_FFMPEG=ON -DBUILD_SHARED_LIBS=NO -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ../..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"


    # Just in case to detect header files default before FFmpeg
    cp -f "$FFBUILD_DESTPREFIX"/include/uavs3e/uavs3e.h "$FFBUILD_DESTPREFIX"/include
    cp -f "$FFBUILD_DESTPREFIX"/include/uavs3e/com_api.h "$FFBUILD_DESTPREFIX"/include
}

ffbuild_configure() {
    echo --enable-libuavs3e
}

ffbuild_unconfigure() {
    (( $(ffbuild_ffver) > 700 )) || return 0
    echo --disable-libuavs3e
}
