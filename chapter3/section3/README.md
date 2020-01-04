# NAME

section3 - 実装作業 (データーベースと接続)

# SYNOPSIS

___データベースアプリケーションは様々な選択肢があるが今回は`sqlite3`を活用する___

```
(データベース用のディレクトリの中にスキーマーファイル用意)
$ mkdir ~/github/beginning_mojo/tutorial/db
$ touch ~/github/beginning_mojo/tutorial/db/bulletin_schema.sql
```

スキーマーファイルを任意のテキストエディタで作成

`/db/bulletin_schema.sql`

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

スキーマーファイルを読み込んでデータベースファイルを作成

```
$ cd ~/github/beginning_mojo/tutorial/db
$ sqlite3 ./bulletin.db < ./bulletin_schema.sql

(db ファイルは環境によって異なるので大抵は git で管理をしない)
$ cd ~/github/beginning_mojo/tutorial/
$ echo 'db/*.db' >> .gitignore;
```

昨今ではデータベースとの接続はORM(オーアールマッピング)と言われる手法を使うことが多い

Perl の Teng モジュールを活用する

```
(Perl のバージョンを固定 Mojolicious をインストール)
$ cd ~/github/beginning_mojo/tutorial/
$ echo "requires 'Teng', '0.31';" >> cpanfile;
$ echo "requires 'DBD::SQLite', '1.64';" >> cpanfile;
$ carton install
```

`/bulletin.pl`

```
(データベースのスキーマーを自動取得する、実行速度は遅くはなる)
...
use Teng;
use Teng::Schema::Loader;

sub teng {
    my $dsn_str = 'dbi:SQLite:./db/bulletin.db';
    ...
    return $teng;
}
```

ダミーの値をデータベースから取得に切り替える

```
get '/list' => sub {
    my $c    = shift;
    my $teng = teng();

    my @bulletin_rows = $teng->search( 'bulletin', +{ deleted => 0 } );
    ...
};
```

書き込みを登録できるようにする

```
...
use Time::Piece;
...
post '/store' => sub {
    my $c      = shift;
    my $params = $c->req->params->to_hash;
    ...
    $c->redirect_to('/list');
};
```

- ORMを使うと実行速度は落ちるがメンテナンスはしやすくなる
- データを作成するときにタイムスタンプを作るのはよくあるやり方

# COMPLETE

___この作業での完成形___

- [/chapter3/section3/bulletin.pl](/chapter3/section3/bulletin.pl)

# SEE ALSO

- [/chapter3](/chapter3) - 仕様案を参考に実装
