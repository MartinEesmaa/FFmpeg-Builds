#!/bin/bash

SCRIPT_REPO="https://github.com/OpenMPT/openmpt"
SCRIPT_COMMIT="4b04c0366f186dde9263a4b22873b995633ecbc5"

ffbuild_enabled() {
    [[ $TARGET == winarm64 ]] && return -1
    return 0
}

ffbuild_dockerbuild() {

    local myconf=(
        PREFIX="$FFBUILD_PREFIX"
        CXXSTDLIB_PCLIBSPRIVATE="-lstdc++"
        VERBOSE=2
        STATIC_LIB=1
        SHARED_LIB=0
        DYNLINK=0
        EXAMPLES=0
        OPENMPT123=0
        IN_OPENMPT=0
        XMP_OPENMPT=0
        DEBUG=0
        OPTIMIZE=1
        TEST=0
        MODERN=1
        FORCE_DEPS=1
        NO_MINIMP3=0
        NO_ZLIB=0
        NO_OGG=0
        NO_VORBIS=0
        NO_VORBISFILE=0
        NO_MPG123=1
        NO_SDL2=1
        NO_PULSEAUDIO=1
        NO_SNDFILE=1
        NO_PORTAUDIO=1
        NO_PORTAUDIOCPP=1
        NO_FLAC=1
    )

    if [[ $TARGET == winarm64 ]]; then
        myconf+=(
            CONFIG=mingw64-win64
            WINDOWS_ARCH=arm64
        )
        export CPPFLAGS="$CPPFLAGS -DMPT_WITH_MINGWSTDTHREADS"
    elif [[ $TARGET == win* ]]; then
        myconf+=(
            CONFIG=mingw64-"$TARGET"
        )
        export CPPFLAGS="$CPPFLAGS -DMPT_WITH_MINGWSTDTHREADS"
    elif [[ $TARGET == linux* ]]; then
        myconf+=(
            CONFIG=gcc
            TOOLCHAIN_PREFIX="$FFBUILD_CROSS_PREFIX"
        )
    else
        echo "Unknown target"
        return -1
    fi

    make -j$(nproc) "${myconf[@]}" all install
    rm -r "$FFBUILD_PREFIX"/share/doc/libopenmpt
}

ffbuild_configure() {
    echo --enable-libopenmpt
}

ffbuild_unconfigure() {
    echo --disable-libopenmpt
}
