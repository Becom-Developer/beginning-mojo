# NAME

section1 - 実装作業 (最低限度の画面を作成)

```
目に見えるところから作業を始める方が理解はしやすい
```

## SUBSECTION1

___共通テンプレートを調整する___

- `__DATA__`配下がテンプレートとして読み込まれている
- 共通テンプレートは`layouts/default.html.ep`
- html のタグ情報などを調整しておく

```perl
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

## SUBSECTION2

___GET - `/` - index 掲示板の紹介画面のテンプレ修正___

```perl
...
@@ index.html.ep
% layout 'default';
% title '掲示板の紹介画面';
<h1>だれでも書込みできる掲示板</h1>
<p><a href="/list">掲示板の一覧表示へ</a></p>
...
```

## SUBSECTION3

___この作業での完成形を参考にして`/list`と`/create`のメソッドと画面を実装する___

## SUBSECTION4

___この作業での完成形___

- [/chapter3/section1/bulletin.pl](/chapter3/section1/bulletin.pl)

# SEE ALSO

- [/chapter3](/chapter3) - 仕様案を参考に実装
