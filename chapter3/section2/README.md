# NAME

work_02.md - 実装作業 (画面遷移を確認するための固定値を設定)

# SYNOPSIS

筋道立てて実装の説明をする場合は入り口から出口を説明するが、さきに出口をイメージしたほうが理解はしやすい

出口である画面を実装する

```
@@ list.html.ep
% layout 'default';
% title '掲示板の一覧表示';
<h1>一覧表示</h1>
<table border="1">
  <caption>掲示板</caption>
  ...
</table>
<p><a href="/">掲示板の紹介画面へ</a></p>
<p><a href="/create">掲示板への書き込み入力画面へ</a></p>
```

`list` に出力するデータはデータベースから取得するが暫定的に固定値を設定

```
get '/list' => sub {
    ...
    my $dummy_list = [
    ...
    ];
    $c->stash->{bulletin_list} = $dummy_list;
    my $total = scalar @{$dummy_list};
    $c->stash->{total} = $total;
    $c->render( template => 'list' );
};
```

- `$c`はmojoのコントローラーオブジェクト
- `$c->stash`メソッドで画面に引き渡す値を設定
- テンプレ側でも`$c`から`stash`メソッドが利用できる

画面遷移を完成させるために書き込みを実行せずに遷移

```
post '/store' => sub {
    my $c = shift;
    $c->redirect_to('/list');
};
```

# COMPLETE

この作業での完成形

`/beginning_mojo/bulletin.pl`

```perl
#!/usr/bin/env perl
use Mojolicious::Lite;

get '/' => sub {
    my $c = shift;
    $c->render( template => 'index' );
};

get '/list' => sub {
    my $c          = shift;
    my $dummy_list = [
        +{  id          => 1,
            comment     => 'はじめての投稿',
            deleted     => 0,
            created_ts  => '2019-10-10 16:20:25',
            modified_ts => '2019-10-10 16:20:25',
        },
        +{  id          => 2,
            comment     => '今日は晴れでした',
            deleted     => 0,
            created_ts  => '2019-10-11 16:20:25',
            modified_ts => '2019-10-11 16:20:25',
        },
        +{  id          => 3,
            comment     => 'アイスがうまかった',
            deleted     => 0,
            created_ts  => '2019-10-12 16:20:25',
            modified_ts => '2019-10-12 16:20:25',
        },
        +{  id          => 4,
            comment     => 'あいつはうまいこと言うなぁ',
            deleted     => 0,
            created_ts  => '2019-10-13 16:20:25',
            modified_ts => '2019-10-13 16:20:25',
        },
    ];
    $c->stash->{bulletin_list} = $dummy_list;
    my $total = scalar @{$dummy_list};
    $c->stash->{total} = $total;
    $c->render( template => 'list' );
};

get '/create' => sub {
    my $c = shift;
    $c->render( template => 'create' );
};

post '/store' => sub {
    my $c = shift;
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
