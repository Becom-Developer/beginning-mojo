# NAME

chapter2 - 開発環境を構築

```
この資料のサンプルコードを掲載しているgithubのリポジトリにtutorialというディレクトリがあります、
そのディレクトリを実習の作業場所にしましょう。
これから先の解説はすべてtutorialディレクトリの中で実行する想定ですすめます。
```

## SECTION1

___開発環境ついて参考になる資料___


開発環境の実行手順

- plenv: 2.3.0-10-gb8ca5d3
- perl: 5.30.0

こちらの記事参考

- <https://github.com/ykHakata/summary/blob/master/perl5_install.md> - perl5_install

## SECTION2

___具体的なコマンドの手順___

```sh
(perl 準備)
$ cd ~/.plenv/ && git pull
$ cd ~/.plenv/plugins/perl-build/ && git pull
$ plenv install 5.30.0
$ plenv rehash
$ plenv global 5.30.0
$ plenv install-cpanm
$ cpanm Carton

$ cd ~/github/beginning_mojo/tutorial/

(Perl のバージョンを固定 Mojolicious をインストール)
$ echo '5.30.0' > .perl-version;
$ echo "requires 'Mojolicious', '== 8.25';" >> cpanfile;
$ carton install

(雛形作成、パーミッションが 0744 の実行ファイルがつくられる)
$ carton exec -- mojo generate lite_app bulletin.pl

(git設定)
$ echo 'local/' >> .gitignore;
$ echo '.DS_Store' >> .gitignore;

(起動テスト)
$ carton exec -- morbo bulletin.pl

(終了は control + c)
```

完成形のディレクトリ構造をイメージしておくとよい

- [dir_history.md](/dir_history.md#chapter2): STEP3 を参照

# SUMMARY

-
-
-

# SEE ALSO

- [/README.md](/README.md) - beginning_mojo - Perl (Mojolicious) を使って web アプリ開発に挑戦
