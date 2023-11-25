#!/bin/bash
#
# Buildroot configuration launcher
#

# コマンド確認
required_commands="docker jq"
which $required_commands > /dev/null
if [ $? -ne 0 ]; then
    echo "command requirement not satisfied: $required_commands"
    exit 1
fi

# Buildrootベースイメージを探し、なければpullする
baseImageName=enchan1207/buildroot_base
baseImageInfo=`docker images --format json | jq -r "select(.Repository == \"${baseImageName}\")"`
if [ -z "$baseImageInfo" ]; then
    echo "Docker image $baseImageName not found. pulling..."
    docker pull $baseImageName
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

# 終了後、コンフィグが変更されているか確認
if [ -e ${distributionDir}/.config -a -e $configFileName ]; then
    cmp ${distributionDir}/.config $configFileName
    if [ $? -ne 0 ]; then
        echo "Copy generated config from /${distributionDir} to ./${distributionDir}."
        echo "This operation needs super-user permission (password may be required)."

        # 変更されていれば、configファイルをdistディレクトリから元の場所に戻し、
        # 所有者を現在のユーザとグループに書き換える
        mv ${distributionDir}/.config $configFileName
        if [ $? -ne 0 ]; then
            sudo mv ${distributionDir}/.config $configFileName
            currentUser=`whoami`
            currentGroup=`id -g -n`
            sudo chown $currentUser:$currentGroup $configFileName
        fi
    fi
fi
