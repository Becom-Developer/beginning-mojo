# NAME

work_03.md - 実装作業 (データーベースと接続)

# SYNOPSIS

データベースアプリケーションは様々な選択肢があるが今回は`sqlite3`を活用する

スキーマーファイルを作成

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
$ cd ~/github/sakura_developers/beginning_mojo/db
$ sqlite3 ./bulletin.db < ./bulletin_schema.sql
```

昨今ではデータベースとの接続はORM(オーアールマッピング)と言われる手法を使うことが多い

Perl の Teng モジュールを活用する

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

この作業での完成形

`/beginning_mojo/bulletin.pl`

```perl
#!/usr/bin/env perl
use Mojolicious::Lite;
use Teng;
use Teng::Schema::Loader;
use Time::Piece;

sub teng {
    my $dsn_str = 'dbi:SQLite:./db/bulletin.db';
    my $user    = '';
    my $pass    = '';
    my $option  = +{
        RaiseError     => 1,
        PrintError     => 0,
        AutoCommit     => 1,
        sqlite_unicode => 1,
    };

    my $dbh  = DBI->connect( $dsn_str, $user, $pass, $option );
    my $teng = Teng::Schema::Loader->load(
        dbh       => $dbh,
        namespace => 'DB::Teng',
    );
    return $teng;
}

get '/' => sub {
    my $c = shift;
    $c->render( template => 'index' );
};

get '/list' => sub {
    my $c    = shift;
    my $teng = teng();

    my @bulletin_rows = $teng->search( 'bulletin', +{ deleted => 0 } );
    my $bulletin_list = [];
    for my $row (@bulletin_rows) {
        push @{$bulletin_list}, $row->get_columns;
    }
    $c->stash->{bulletin_list} = $bulletin_list;
    my $total = scalar @{$bulletin_list};
    $c->stash->{total} = $total;
    $c->render( template => 'list' );
};

get '/create' => sub {
    my $c = shift;
    $c->render( template => 'create' );
};

post '/store' => sub {
    my $c      = shift;
    my $params = $c->req->params->to_hash;
    my $teng   = teng();
    my $t      = localtime;
    my $date   = $t->date;
    my $time   = $t->time;
    $params = +{
        %{$params},
        deleted     => 0,
        created_ts  => "$date $time",
        modified_ts => "$date $time",
    };
    $teng->fast_insert( 'bulletin', $params );
    $c->redirect_to('/list');
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title '掲示板の紹介画面';
<h1>だれでも書込みできる掲示板</h1>
<p><a href="/list">掲示板の一覧表示へ</a></p>

@@ list.html.ep
% layout 'default';
% title '掲示板の一覧表示';
<h1>一覧表示</h1>
<table border="1">
  <caption>掲示板</caption>
  <thead>
    <tr>
      <th>コメント</th>
      <th>投稿時刻</th>
    </tr>
  </thead>
  <tbody>
  % for my $bulletin (@{$c->stash->{bulletin_list}}) {
    <tr>
      <td><%= $bulletin->{comment} %></td>
      <td><%= $bulletin->{created_ts} %></td>
    </tr>
  % }
  </tbody>
  <tfoot>
    <tr>
      <th>投稿数の合計</th>
      <td><%= $c->stash->{total} %></td>
    </tr>
  </tfoot>
</table>
<p><a href="/">掲示板の紹介画面へ</a></p>
<p><a href="/create">掲示板への書き込み入力画面へ</a></p>

@@ create.html.ep
% layout 'default';
% title '掲示板への書き込み入力画面';
<h1>書き込み入力画面</h1>

<form method="post" action="/store">
<p>コメント:<input type="text" name="comment"></p>
<p><input type="submit" value="送信する"></p>
</form>

<p><a href="/list">掲示板の一覧表示へ</a></p>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8">
    <title><%= title %></title>
  </head>
  <body><%= content %></body>
</html>
```

# SEE ALSO
