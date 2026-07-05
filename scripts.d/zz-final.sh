#!/bin/bash

SCRIPT_SKIP="1"

ffbuild_depends() {
    echo libiconv
    echo zlib
    echo bzlib
    echo fribidi
    echo gmp
    echo libxml2
    echo openssl
    echo xz
    echo fonts
    echo lcevcdec
    echo libvorbis
    echo opencl
    echo pulseaudio
    echo vmaf
    echo x11
    echo vulkan
    echo amf
    echo aom
    echo aribb24
    echo audiotoolbox
    echo avisynth
    echo bs2b
    echo cdio
    echo chromaprint
    echo dav1d
    echo davs2
    echo decklink
    echo dvd
    echo fdk-aac
    echo ffnvcodec
    echo frei0r
    echo gme
    echo ilbc
    echo kvazaar
    echo lc3
    echo libaribcaption
    echo libass
    echo libbluray
    echo libcaca
    echo libcelt
    echo libgsm
    echo libcurl
    echo libjxl
    echo libmad
    echo libmp3lame
    echo libmysofa
    echo libopus
    echo libplacebo
    echo librist
    echo libssh
    echo libtheora
    echo libvpx
    echo libwebp
    echo libzmq
    echo lilv
    echo modplug
    echo mp3shine
    echo mpeghe
    echo onevpl
    echo openal
    echo openapv
    echo opencore-amr
    echo openh264
    echo openjpeg
    echo openmpt
    echo pocketsphinx
    echo qrencode
    echo quirc
    echo rav1e
    echo rubberband
    echo schannel
    echo sdl
    echo snappy
    echo soxr
    echo speex
    echo srt
    echo svtav1
    echo svthevc
    echo svtvp9
    echo twolame
    echo uavs3d
    echo uavs3e
    echo vaapi
    echo vidstab
    echo vo-amrwb
    echo vvdec
    echo vvenc
    echo whisper
    echo x264
    echo x265
    echo xavs
    echo xavs2
    echo xevd
    echo xeve
    echo xvid
    echo zimg
    echo zvbi

    echo rpath
}

ffbuild_enabled() {
    return 0
}

ffbuild_dockerfinal() {
    return 0
}

ffbuild_dockerdl() {
    return 0
}

ffbuild_dockerlayer() {
    return 0
}

ffbuild_dockerstage() {
    return 0
}

ffbuild_dockerbuild() {
    return 0
}

ffbuild_ldexeflags() {
    return 0
}
