# Creating a custom RPi image

## Overview

Raspberry Piのカスタムイメージをなるべく高速(CIで回せる程度のペース)に構成したい

## Discussion

### 1. 基本環境の構成

 - ✅ とりあえず最低限Buildrootが動作する状態のイメージを作る
 - ✅ RPi用に構成してSDKをビルドする
 - ✅ BuildrootイメージにRPiのSDKを同梱し、すぐにビルドできる状態のものを作る
 - ✅ ビルドしたDockerイメージをGoogleドライブにアップロード
 - ✅SDKとその法規情報をまとめてリリースアセットに追加し、自動でリリースドラフトを作成
   - アセットサイズは2GBまで
   - `make legal-info` で情報をまとめられる
   - アセットを追加するアクションがある
   - リリースドラフト作成時にSDKを追加した方が良いのでは?
