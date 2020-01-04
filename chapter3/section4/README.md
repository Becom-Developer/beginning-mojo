# NAME

section4 - 実装作業 (全体の調整)

# SYNOPSIS

現在の仕様は値が空でも登録ができてしまう

値が入力されない場合は登録しないようにする(バリデーション)

両端の空文字を削除するトリムと呼ばれるやり方を使う

```
use Mojo::Util qw(trim);

...

post '/store' => sub {
    ...

    # 値が空の場合は登録しない
    my $comment = $params->{comment};
    my $trimmed = trim($comment);
    if ( !$trimmed ) {
        $c->flash( msg => "正しく値を入力してください" );
        $c->redirect_to('/create');
        return;
    }
    ...

```

正しく入力されない場合は入力画面にリダイレクトしたメッセージを表示

```
...
@@ create.html.ep
% layout 'default';
% title '掲示板への書き込み入力画面';
<h1>書き込み入力画面</h1>
% if ( my $msg = flash('msg') ) {
  <p style="color:red"><%= $msg %></p>
% }
<form method="post" action="/store">
...
```

# COMPLETE

___この作業での完成形___

- [/chapter3/section4/bulletin.pl](/chapter3/section4/bulletin.pl)

# SEE ALSO

- [/chapter3](/chapter3) - 仕様案を参考に実装
