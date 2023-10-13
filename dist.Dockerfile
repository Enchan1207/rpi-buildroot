#
# Buildroot 配布イメージ
#

# 構築済みのベースイメージから始める
FROM enchan/buildroot_base

# SDKファイルをコピー
ARG SDK_PATH
COPY ${SDK_PATH} /buildroot/sdk.tar.gz

ENTRYPOINT [ "/bin/bash" ]
