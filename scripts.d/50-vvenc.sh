#!/bin/bash

SCRIPT_REPO="https://github.com/fraunhoferhhi/vvenc.git"
SCRIPT_COMMIT="5c2b2cbb5b5cda90bc05ebeb4333e73146c12525"

ffbuild_enabled() {
    [[ $TARGET == winarm* ]] && return -1
    (( $(ffbuild_ffver) > 700 )) || return -1
    return 0
    # vvenc force-enabled avx2 and equivalent compiler options, and uses a static initializer that promptly
    # runs such instructions. Making resulting binaries malfunction on any but the very latest CPUs.
    # Until upstream fixes this behaviour, force-disable vvenc.
    # I force enabled just in case cause BtBn force disabled vvenc for avx2 enabled reason.
}

ffbuild_dockerbuild() {

    mkdir build && cd build

    local armsimd=()
    if [[ $TARGET == *arm64 ]]; then
        armsimd+=( -DVVENC_ENABLE_ARM_SIMD=ON )

        if [[ "$CC" != *clang* ]]; then
            export CFLAGS="$CFLAGS -fpermissive -Wno-error=uninitialized -Wno-error=maybe-uninitialized"
            export CXXFLAGS="$CXXFLAGS -fpermissive -Wno-error=uninitialized -Wno-error=maybe-uninitialized"
        fi
    fi

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF -DVVENC_LIBRARY_ONLY=ON -DVVENC_ENABLE_LINK_TIME_OPT=OFF -DEXTRALIBS="-lstdc++" "${armsimd[@]}" ..

    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libvvenc
}

ffbuild_unconfigure() {
    (( $(ffbuild_ffver) > 700 )) || return 0
    echo --disable-libvvenc
}
