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

# 必須パッケージのインストール
# ref: https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
RUN apt-get -y install \
    git sed binutils build-essential diffutils patch gzip bzip2 perl tar cpio \
    unzip rsync file bc wget findutils libncursesw5-dev ssh

# オプションパッケージのインストール
# ref: https://buildroot.org/downloads/manual/manual.html#requirement-optional
RUN apt-get -y install \
    python3 asciidoc w3m graphviz python3-pip python3-setuptools
RUN pip3 install matplotlib

# Buildrootの取得・展開
ARG buildroot_name=buildroot-${buildroot_version}
RUN wget https://buildroot.org/downloads/${buildroot_name}.tar.gz
RUN tar xzf ${buildroot_name}.tar.gz
RUN rm ${buildroot_name}.tar.gz
RUN mv /${buildroot_name} /buildroot
WORKDIR /buildroot

ENTRYPOINT [ "/bin/bash" ]
