# NAME

chapter1 - 仕様案を作成

画面遷移

画面の遷移がイメージしにくい場合は図で草案を作っておく (今回は google スライドで作って jpg で出力した)

![画面遷移](/chapter1/borad.jpg)

```
ここで作る画面の遷移図と一般的にいうフローチャートとは違う
フローチャートはロジックを整理したものになるが、
web アプリは性質上仕様が頻繁に変更される
アプリの草案の段階で厳密にロジックを整理しても効果的にはならないことが多い
```

- アプリ名: bulletin
- URL:
    - GET - `/` - index 掲示板の紹介画面
    - GET - `/list` - list 掲示板の一覧表示
    - GET - `/create` - create 掲示板への書き込み入力画面
    - POST - `/store` - store 掲示板への書き込み実行
- 公開環境: 今回は準備しない
- データベース: sqlite3
- スキーマー:

```sql
DROP TABLE IF EXISTS bulletin;
CREATE TABLE bulletin (                                 -- 掲示板
    id              INTEGER PRIMARY KEY AUTOINCREMENT,  -- ID (例: 5)
    comment         TEXT,                               -- コメント (例: '明日は晴れそう')
    deleted         INTEGER,                            -- 削除フラグ (例: 0: 削除していない, 1: 削除済み)
    created_ts      TEXT,                               -- 登録日時 (例: '2019-08-22 17:01:29')
    modified_ts     TEXT                                -- 修正日時 (例: '2019-08-22 17:01:29')
);
```

# SUMMARY

-
-
-

# SEE ALSO

- [/README.md](/README.md) - beginning_mojo - Perl (Mojolicious) を使って web アプリ開発に挑戦
