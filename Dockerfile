# REF: https://github.com/livingbio/ffmpeg-gl-transition

FROM python:3

RUN apt update \
    && apt -y install unzip \
        libxext-dev libx11-dev x11proto-gl-dev \
    && wget https://github.com/NVIDIA/libglvnd/archive/master.zip \
    && unzip -q master.zip \
    && cd libglvnd-master && ./autogen.sh && ./configure && make && make install

RUN apt install -y libglu1-mesa libglu1-mesa-dev

RUN apt install -y build-essential libxmu-dev libxi-dev libgl-dev cmake git \
    && apt install -y libegl1-mesa-dev \
    && wget https://github.com/nigels-com/glew/releases/download/glew-2.1.0/glew-2.1.0.zip \
    && unzip -q glew-2.1.0.zip \
    && cd glew-2.1.0 && make SYSTEM=linux-egl && make install

COPY . /ffmpeg-gl-transition

RUN wget -q https://github.com/FFmpeg/FFmpeg/archive/n4.1.zip \
    && unzip -q n4.1.zip \
    && cd FFmpeg-n4.1 && ln -s /ffmpeg-gl-transition/vf_gltransition.c libavfilter/ \
    && git apply /ffmpeg-gl-transition/ffmpeg.diff \
    && ./configure \
        --prefix=/usr/local --enable-gpl --enable-nonfree --enable-libass \
        --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libtheora \
        --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 \
        --enable-libopus --enable-libxvid \
        --enable-opengl --enable-filter=gltransition --extra-libs='-lGLEW -lEGL' \
    && make

RUN ./ffmpeg -v 0 -filters | grep gltransition
