# NAME

work_01.md - 実装作業 (最低限度の画面を作成)

# SYNOPSIS

共通テンプレートを調整する

- `__DATA__`配下がテンプレートとして読み込まれている
- 共通テンプレートは`layouts/default.html.ep`
- html のタグ情報などを調整しておく

```
...
@@ layouts/default.html.ep
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8">
    <title><%= title %></title>
  </head>
  <body><%= content %></body>
</html>
...
```

GET - `/` - index 掲示板の紹介画面のテンプレ修正

```
@@ index.html.ep
% layout 'default';
% title '掲示板の紹介画面';
<h1>だれでも書込みできる掲示板</h1>
<p><a href="/list">掲示板の一覧表示へ</a></p>
```

この作業での完成形を参考にして`/list`と`/create`のメソッドと画面を実装する

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
    my $c = shift;
    $c->render( template => 'list' );
};

get '/create' => sub {
    my $c = shift;
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
```

# SEE ALSO
