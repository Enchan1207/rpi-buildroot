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
    if [ $? -ne 0 ]; then
        echo "Failed to pull $baseImageName"
        exit 1
    fi
fi

# 成果物ディレクトリを作成
distributionDir=dist
mkdir -p $distributionDir

# コンフィグがあるならdistにコピーする
configFileName=${1:-""}
if [ -n "$configFileName" -a -e "$configFileName" ]; then
    echo "Configuration file found. copy to ${distributionDir}..."
    cp $configFileName ${distributionDir}/.config
fi

# コンテナ内外でdistのパスが変わるので、それを通知
echo -e "Directory \x1b[35;1m${distributionDir}\x1b[0m will be mounted to \x1b[35;1m/${distributionDir}\x1b[0m."
echo -e "While invoke \x1b[;1mmake\x1b[0m, please use it instead:"
echo "    make O=/${distributionDir}"

# スクリプト実行時と同じUID:GIDでコンテナを起動
docker run --rm -it -u $(id -u):$(id -g) -v ./${distributionDir}:/${distributionDir} $baseImageName

# 構成ファイル名が渡されていなければ終了
if [ -z "$configFileName" ]; then
    echo "No configuration file passed."
    echo "exit"
    exit
fi

# 構成ファイルを更新
touch "$configFileName"

# 構成ファイルが生成された?
if [ ! -e "${distributionDir}/.config" ]; then
    echo "No configuration file generated."
    echo "exit"
    exit
fi

# 渡された構成ファイルと現在手元にあるものを比較
cmp "${distributionDir}/.config" "$configFileName" > /dev/null 2>&1; isNotModified=$?
if [ $isNotModified -ne 0 ];then
    # 変更されていれば、configファイルをdistディレクトリから元の場所にコピー
    echo "Copy generated config from /${distributionDir} to ./${distributionDir}."
    mv "${distributionDir}/.config" "$configFileName"
fi
