#
# Buildroot ビルドイメージ
#
FROM enchan1207/buildroot_base

# SDKを同梱
COPY sdk.tar.gz /buildroot/sdk.tar.gz
