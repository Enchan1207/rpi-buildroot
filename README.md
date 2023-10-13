# Creating a custom RPi image

## Overview

Raspberry Piのカスタムイメージをなるべく高速(CIで回せる程度のペース)に構成したい

## Discussion

### 1. 基本環境の構成

 - ✅ とりあえず最低限Buildrootが動作する状態のイメージを作る
 - ✅ RPi用に構成してSDKをビルドする
 - ✅ BuildrootイメージにRPiのSDKを同梱し、すぐにビルドできる状態のものを作る
 - ✅ ビルドしたDockerイメージをGoogleドライブにアップロード
