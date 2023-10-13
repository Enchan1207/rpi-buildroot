#!/bin/bash
#
# SDKを作成する
#

# Raspberry Pi用の構成ファイルを出力ディレクトリにコピー
cp /host/rpi3_sdk.config /dist/.config

# SDKをビルド
make O=/dist sdk

# ライセンス情報等をビルドし、ディレクトリごと圧縮
make O=/dist legal-info
cd /dist
tar czf legal-info.tar.gz legal-info
