#!/usr/bin/env perl
use Mojolicious::Lite -signatures;

get '/' => sub ($c) {
    $c->render( template => 'index' );
};

get '/list' => sub ($c) {
    $c->render( template => 'list' );
};

get '/create' => sub ($c) {
    $c->render( template => 'create' );
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
