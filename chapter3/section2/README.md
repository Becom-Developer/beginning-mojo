# NAME

section2 - 実装作業 (画面遷移を確認するための固定値を設定)

# SYNOPSIS

___出口である画面を実装する___

筋道立てて実装の説明をする場合は入り口から出口を説明するが、さきに出口をイメージしたほうが理解はしやすい

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

___この作業での完成形___

- [/chapter3/section2/bulletin.pl](/chapter3/section2/bulletin.pl)

# SEE ALSO

- [/chapter3](/chapter3) - 仕様案を参考に実装
