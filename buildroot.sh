#!/bin/bash
#
# Buildroot configuration launcher
#

# Buildrootベースイメージを探す
baseImageName=enchan1207/buildroot
baseImageInfo=`docker images --format json | jq -r "select(.Repository == \"${baseImageName}\")"`
if [ -z "$baseImageInfo" ]; then
    echo "Please build enchan1207/buildroot using setup_buildroot_image.sh before invoke $0"
    exit 1
fi

# 成果物ディレクトリを作成
distributionDir=dist
mkdir -p $distributionDir

# コンフィグがあるならdistにコピーする
configFileName=${1:-".config"}
if [ -e $configFileName ]; then
    echo "Configuration file found. copy to ${distributionDir}..."
    cp $configFileName ${distributionDir}/.config
fi

# コンテナを起動
echo "Directory ${distributionDir} will be mounted to /${distributionDir}."
echo "While invoke make, please use instead:"
echo "    make O=/${distributionDir}"
docker run --rm -it -v ./${distributionDir}:/${distributionDir} $baseImageName

# 終了後、コンフィグが変更されていればdistディレクトリからコンフィグをローカルにコピーする
if [ -e ${distributionDir}/.config ]; then
    cmp ${distributionDir}/.config $configFileName
    if [ $? -ne 0 ]; then
        echo "Copy generated config from /${distributionDir} to ./${distributionDir}."
        echo "This operation needs super-user permission (password may be required)."

        # パスワードが必要になるかもしれない
        mv ${distributionDir}/.config $configFileName
        if [ $? -ne 0 ]; then
            sudo mv ${distributionDir}/.config $configFileName
        fi
    fi
fi
