#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use Teng;
use Teng::Schema::Loader;
use Time::Piece;
use Mojo::Util qw(trim);
use lib "./lib";
use Bulletin::Model;

helper model => sub { Bulletin::Model->new(); };
helper teng => sub { teng() };

sub teng {
    my $dsn_str = 'dbi:SQLite:./db/bulletin.db';
    if ( $ENV{MOJO_MODE} && $ENV{MOJO_MODE} eq 'testing' ) {
        $dsn_str = 'dbi:SQLite:./db/bulletin.testing.db';
    }
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

get '/' => sub ($c) {
    $c->render( template => 'index' );
};

get '/list' => sub ($c) {
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

get '/create' => sub ($c) {
    $c->render( template => 'create' );
};

post '/store' => sub ($c) {
    my $params = $c->req->params->to_hash;

    # 値が空の場合は登録しない
    my $comment = $params->{comment};
    my $trimmed = '';
    if ($comment) {
        $trimmed = trim($comment);
    }
    if ( !$trimmed ) {
        $c->flash( msg => "正しく値を入力してください" );
        $c->redirect_to('/create');
        return;
    }

    my $teng = teng();
    my $t    = localtime;
    my $date = $t->date;
    my $time = $t->time;
    $params = +{
        %{$params},
        deleted     => 0,
        created_ts  => "$date $time",
        modified_ts => "$date $time",
    };
    $teng->fast_insert( 'bulletin', $params );
    $c->redirect_to('/list');
};

post '/remove' => sub ($c) {
    my $params = $c->req->params->to_hash;
    my $teng = teng();
    my $t    = localtime;
    my $date = $t->date;
    my $time = $t->time;
    my $row  = $teng->single( 'bulletin', $params );
    return $c->redirect_to('/list') if !$row;

    $row->update(
        +{  deleted     => 1,
            modified_ts => "$date $time",
        }
    );

    $c->flash( msg => "削除しました" );
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
% if ( my $msg = flash('msg') ) {
  <p style="color:red"><%= $msg %></p>
% }
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
      <td>
        <form name="remove_<%= $bulletin->{id} %>" method="post" action="/remove">
        <input type="hidden" name="id" value="<%= $bulletin->{id} %>">
        <input type="submit" value="削除">
        </form>
      </td>
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
% if ( my $msg = flash('msg') ) {
  <p style="color:red"><%= $msg %></p>
% }
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
