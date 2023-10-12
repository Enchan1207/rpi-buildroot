#
# Buildroot ベースイメージ
#
FROM ubuntu:20.04

# パッケージマネージャの更新
RUN apt-get update
RUN apt-get -y upgrade

# ロケール設定
RUN apt-get -y install tzdata; \
    update-locale LANG=ja_JP.UTF8; \
    dpkg-reconfigure tzdata

# 依存パッケージのインストール
# ref: https://buildroot.org/downloads/manual/manual.html#requirement-optional
RUN apt-get -y install \
    git sed binutils build-essential diffutils patch gzip bzip2 perl tar cpio \
    unzip rsync file bc wget findutils libncursesw5-dev ssh

# Buildrootの取得
ARG buildroot_version="buildroot-2023.02.2"
RUN wget https://buildroot.org/downloads/${buildroot_version}.tar.gz
RUN tar xzf ${buildroot_version}.tar.gz
RUN rm ${buildroot_version}.tar.gz
RUN mv /${buildroot_version} /buildroot
WORKDIR /buildroot

ENTRYPOINT [ "/bin/bash" ]
