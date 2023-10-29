#!/bin/bash
#
# Buildrootイメージのセットアップ
#

# コマンド確認
required_commands="gh jq"
which $required_commands > /dev/null
if [ $? -ne 0 ]; then
    echo "command requirement not satisfied: $required_commands"
    exit 1
fi

# Buildrootベースイメージを探し、なければpull
echo "Looking for Buildroot base image"
baseImageName=enchan1207/buildroot_base
baseImageInfo=`docker images --format json | jq -r "select(.Repository == \"${baseImageName}\")"`
if [ -z "$baseImageInfo" ]; then
    echo "Buildroot base image (${baseImageName}) not found. Try to pull..."

    pullLogFile=pull.log
    docker pull $baseImageName > $pullLogFile 2>&1
    if [ $? -ne 0 ]; then
        echo "An unexpected error occured while pull Buildroot base image:"
        cat $pullLogFile
        exit 1
    fi
    rm $pullLogFile
fi

# SDKをダウンロード
echo "Download Buildroot external toolchain for Raspberry Pi 3"
latestReleaseInfo=$(gh api \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/Enchan1207/rpi-buildroot/releases/latest)
assetURL=`echo $latestReleaseInfo | jq -r ".assets_url"`
assetInfo=`curl $assetURL`
sdkURL=`echo $assetInfo | jq -r ".[] | select(.name == \"sdk.tar.gz\") .browser_download_url"`
wget -q $sdkURL

# Dockerイメージをビルド
echo "Build Buildroot image"
buildLogFile=build.log
docker build -t enchan1207/buildroot -f dist.Dockerfile . > $buildLogFile 2>&1
if [ $? -ne 0 ]; then
    echo "An unexpected error occured while build Buildroot image:"
    cat $buildLogFile
    exit 1
fi
rm $buildLogFile

# キャッシュを削除
rm sdk.tar.gz

echo "finished."
