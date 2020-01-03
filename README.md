# NAME

beginning_mojo - Perl (Mojolicious) を使って web アプリ開発に挑戦

# INTRODUCTION

```
インターネット黎明期とよばれているころ、webアプリケーションの開発には
プログラミング言語 Perl が活用されることが多く CGI と呼ばれる
手法でほとんどの web アプリケーションが開発されていました。
最近(2019年現在)では CGI という手法で開発されることは少なくなり、
web アプリケーション自体も複雑化し、 web アプリの作り方を説明、指導する方も
なにから説明するべきなのか大変難しくなりました。
言語の選択肢として Perl 以外の選択肢も沢山用意されており Perl を活用した事例の
紹介も少なくなったような気がします。
この資料では言語自体の特性より、web アプリを開発する場合の進め方に着眼点を置き
解説とサンプルコードを紹介しています。
```

- この資料の対象者
- 資料で学べること

# MENU

- [CHAPTER0](#chapter0): やることを整理しておく
- [CHAPTER1](/chapter1): 仕様案を作成
- [CHAPTER2](/chapter2): 開発環境を構築
- [CHAPTER3](/chapter3): 仕様案を参考に実装
- [CHAPTER4](/chapter4): 完成品に対しての課題をまとめる
- [CHAPTER5](/chapter5): 完成品に対してテストコードを実装
- [CHAPTER6](/chapter6): テストコードと機能追加実装を同時にすすめる
- [CHAPTER7](/chapter7): 保守と拡張性が高い構造体に変更する準備
- [CHAPTER8](/chapter8): Mojolicious ベースにリファクタリングをする
- [CHAPTER9](/chapter9): 新しい機能を追加する

---

- [TUTORIAL](/tutorial): 新しくコードを記述するスペース

# CHAPTER0

___やることを整理しておくとは?___

```
システムを開発するにあたって、やることを整理とは言い方をかえると段取りを組む
ということになると思います。
うまい段取りを組む能力というのは教えることが大変難しく、経験によって培われる部分が大きいです。
何をやればいいのかわからないので、物事を始められず、始められないので経験値がたまりません。
結果、いつまでたっても開発できるようにならなかったりします。
これでは話は堂々巡りとなります。
したがって、まずは一歩踏み出すということからはじまります。
```

- なにをつくるか
    - 簡易的な掲示板 web アプリ
- どうつくるか
    - アプリの仕様案
    - 開発環境の案
        - サーバーサイド
            - システム Linux を想定
            - プログラミング言語: Perl
            - web フレームワーク: mojo
        - クライアント
            - web ブラウザ google chrome のみを想定
            - 今回は java script による画面の装飾はしない
        - 開発環境(手元のPC)
            - システム MacOS
            - プログラミング言語: Perl
            - web フレームワーク: mojo
    - 実装について参考になりそうな資料を用意

# SEE ALSO

- <https://github.com/ykHakata/summary/blob/master/perl5_install.md> - perl5_install
- <https://metacpan.org/pod/Mojolicious> - Mojolicious
- <https://github.com/yuki-kimoto/mojolicious-guides-japanese/wiki#___top> - Mojoliciousドキュメント 日本語訳
- <http://perldoc.jp/> - Perl doc 日本語訳
- <https://www.perl.org/> - Perl
