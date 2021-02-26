# Name

bulletin - 簡易的な掲示板

```text
開発課題
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
  - 実装について参考になりそうな資料を用意

### Screen

![画面遷移](/chapter1/borad.jpg)

### URL

- アプリ名: bulletin
- URL:
  - GET - `/` - index 掲示板の紹介画面
  - GET - `/list` - list 掲示板の一覧表示
  - GET - `/create` - create 掲示板への書き込み入力画面
  - POST - `/store` - store 掲示板への書き込み実行
- 公開環境: 今回は準備しない

### DB

- データベース: sqlite3

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
