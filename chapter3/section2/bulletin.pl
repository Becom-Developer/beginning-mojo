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
