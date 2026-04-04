#!/bin/bash

SCRIPT_REPO="https://github.com/google/snappy.git"
SCRIPT_COMMIT="6281a07b7e08629884ec93a89fea6e05c62e599c"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git submodule update --init --recursive --depth=1
    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DSNAPPY_BUILD_TESTS=OFF -DSNAPPY_BUILD_BENCHMARKS=OFF \
    -DSNAPPY_REQUIRE_AVX=ON -DSNAPPY_REQUIRE_AVX2=ON ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
}

ffbuild_configure() {
    echo --enable-libsnappy
}

ffbuild_unconfigure() {
    echo --disable-libsnappy
}
