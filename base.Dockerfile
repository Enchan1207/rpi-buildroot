#
# Buildroot ベースイメージ
#
FROM ubuntu:20.04

# Buildrootのバージョンが指定されていることを確認
ARG buildroot_version
RUN test -n "$buildroot_version" || (echo "required argument 'buildroot_version' does not specified." && false)

# パッケージマネージャの更新
RUN apt-get update
RUN apt-get -y upgrade

# ロケール設定
RUN apt-get -y install tzdata; \
    update-locale LANG=en_US.UTF8; \
    dpkg-reconfigure tzdata

# 依存パッケージのインストール
# ref: https://buildroot.org/downloads/manual/manual.html#requirement-optional
RUN apt-get -y install \
    git sed binutils build-essential diffutils patch gzip bzip2 perl tar cpio \
    unzip rsync file bc wget findutils libncursesw5-dev ssh

# ビルド中に必要となることが予想されるパッケージ群のインストール
RUN apt-get -y install \
    cmake pkgconf zstd ccache m4 libtool autoconf automake zlib1g util-linux \
    e2fsprogs attr acl fakeroot dosfstools kmod mtools lzip patchelf bison flex \
    libssl-dev
RUN git clone https://github.com/redis/hiredis; \
    cd hiredis; \
    make -j4 && make install; \
    cd ..; rm -rf hiredis
RUN git clone https://github.com/libconfuse/libconfuse;\
    cd libconfuse; \
    ./configure && make -j4 && make install; \
    ldconfig; \
    cd ..; rm -rf libconfuse
RUN git clone https://github.com/pengutronix/genimage; \
    cd genimage;\
    ./autogen.sh && ./configure && make -j4 && make install; \
    cd ..; rm -rf genimage
RUN git clone https://github.com/sabotage-linux/gettext-tiny; \
    cd gettext-tiny; \
    make -j4 && make install; \
    cd ..; rm -rf gettext-tiny

# Buildrootの取得・展開
ARG buildroot_name=buildroot-${buildroot_version}
RUN wget https://buildroot.org/downloads/${buildroot_name}.tar.gz
RUN tar xzf ${buildroot_name}.tar.gz
RUN rm ${buildroot_name}.tar.gz
RUN mv /${buildroot_name} /buildroot
WORKDIR /buildroot

ENTRYPOINT [ "/bin/bash" ]
