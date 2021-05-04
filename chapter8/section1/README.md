# Name

bulletin - 簡易的な掲示板

```md
chapter8/section1 - モデルロジック
モデルロジックを切り分ける
```

## Command

忘れてしまいがちなコマンドのメモ

```zsh
(アプリケーションの開始)
% docker-compose up

(テストコード実行、アプリケーションが実行されている状態で別のウインドウから)
% docker-compose exec web carton exec -- prove

(テストコード実行、アプリケーションが実行されていない状態で)
% docker-compose --env-file ./etc/.env.test up
```

## Todo

今後の課題メモ

- バグ
  - ~~入力値が空でも入力できてしまう問題~~
- 機能改善
  - ファビコンをオリジナルの画像に変更
- 機能追加
  - ~~投稿したコメントを削除する機能~~
- 作業効率
  - ~~自動テストコードを実行できる仕組み~~
  - Mojolicious ベースの構造体に変更

## Setting

ローカル開発環境、初期の構築手順 (MacOS)

```zsh
(任意のディレクリを作成、今回は ~/tmp/bulletin/)
% mkdir -p ~/tmp/bulletin/ && cd ~/tmp/bulletin/

(ファイルの中身は下記の記事参考)
% touch Dockerfile docker-compose.yml compose-cmd.bash && \
chmod +x compose-cmd.bash && \
echo "requires 'Mojolicious', '== 9.01';" > cpanfile && \
echo "local/\n.DS_Store\ndb/*.db" > .gitignore

(データベースのファイルを作っておく、内容は下記の DB のスキーマ)
mkdir db && touch ./db/bulletin.sql

(最初はイメージがないので build オプションで実行)
% docker-compose up --build

(ビルドがすべておわったら web ブラウザで localhost:3000 で確認)

(2回目からはこちらで実行)
% docker-compose up
```

Dockerfile

```docker
FROM perl:5.32.1
RUN cpanm Carton && mkdir -p /usr/src/app && \
apt-get update && \
apt-get install -y sqlite3
WORKDIR /usr/src/app
```

docker-compose.yml

```docker
version: '3.8'
services:
  web:
    container_name: ctr-beginning-mojo
    build:
      context: .
    image: img-beginning-mojo
    volumes:
      - .:/usr/src/app
    ports:
      - '3000:3000'
    command: './compose-cmd.bash'
```

compose-cmd.bash

```bash
#!/usr/bin/env bash
carton install && \
carton exec -- mojo generate lite-app bulletin.pl
if [ -f ./db/bulletin.sql ] && [ -f ./db/bulletin.db ]; then
    carton exec -- morbo bulletin.pl
elif [ -s ./db/bulletin.sql ]; then
    sqlite3 ./db/bulletin.db < ./db/bulletin.sql
    carton exec -- morbo bulletin.pl
else
    echo "not exist bulletin.sql !!"
fi
```

完成形のファイル構成

```md
dir                       # Application directory
|- bin                    # docker-compose の中で実行するコマンド
|- db                     # データベース関連ファイル
|- doc                    # 参考資料各種
|- etc                    # 設定ファイル
|- lib                    # 読み込みファイル各種
|  |- BeginningMojo       # アプリケーションファイル各種
|  |  +- Controller       # アプリケーションコントローラー
|  |  +- DB               # データベースオブジェクトロジック各種
|  |  +- Model            # コントローラーロジック
|  |  +- DB.pm            # データベースオブジェクトロジック呼び出し
|  |  +- Model.pm         # コントローラーロジック呼び出し
|  |- Test                # テストコード拡張モジュール
|  +- BeginningMojo.pm    # アプリケーション定義
|- local                  # 拡張モジュール各種
|- public                 # 静的なファイル各種
|- script                 # 実行ファイル各種
|  +- bulletin            # アプリケーション実行ファイル
|- t                      # テストコード各種
|- templates              # 画面表示用テンプレート各種
|- .gitignore             # git で管理しないリスト
|- .perl-version          # 実行するPerlのバージョン情報
|- cpanfile               # インストールするモジュールリスト
|- cpanfile.snapshot      # モジュールインストール履歴
|- docker-compose.yml     # docker compose 実行
|- Dockerfile             # docker イメージ作成
+- README.md              # はじめに読む資料
```

## Draft

### Overview

- なにをつくるか
  - 簡易的な掲示板 web アプリ
- どうつくるか
  - アプリの仕様案
  - 開発環境の案
    - サーバーサイド
      - システム Linux を想定
      - プログラミング言語: Perl
      - web フレームワーク: mojo
    - クライアント
      - web ブラウザ google chrome のみを想定
      - 今回は java script による画面の装飾はしない
    - 開発環境(手元のPC)
      - システム MacOS
      - プログラミング言語: Perl
      - web フレームワーク: mojo
      - docker 環境を活用
  - 実装について参考になりそうな資料を用意

### Screen

![画面遷移](/img/borad.jpg)

### URL

- アプリ名: bulletin
- URL:
  - GET - `/` - index 掲示板の紹介画面
  - GET - `/list` - list 掲示板の一覧表示
  - GET - `/create` - create 掲示板への書き込み入力画面
  - POST - `/store` - store 掲示板への書き込み実行
  - POST - `/remove` - remove 掲示板の削除実行
- 公開環境: 今回は準備しない

### DB

- データベース: sqlite3 `bulletin.sql`

```sql
DROP TABLE IF EXISTS bulletin;
CREATE TABLE bulletin (                                 -- 掲示板
    id              INTEGER PRIMARY KEY AUTOINCREMENT,  -- ID (例: 5)
    comment         TEXT,                               -- コメント (例: '明日は晴れそう')
    deleted         INTEGER,                            -- 削除フラグ (例: 0: 削除していない, 1: 削除済み)
    created_ts      TEXT,                               -- 登録日時 (例: '2021-02-26 17:01:29')
    modified_ts     TEXT                                -- 修正日時 (例: '2021-02-26 17:01:29')
);
```
