#!/bin/bash
#
# SDKを作成する
#

# Raspberry Pi用の構成ファイルを出力ディレクトリにコピー
cp /host/rpi3_sdk.config /dist/.config

# SDKをビルド
make O=/dist sdk
