#!/bin/bash
#
# SDKを作成する
#

# Raspberry Pi用の構成ファイルを作成
make O=/dist raspberrypi_defconfig

# SDKをビルド
make O=/dist sdk
