# NAME

chapter2 - 開発環境を構築

# CONTENT

開発環境ついて参考になる資料

具体的なコマンドの手順

開発環境の実行手順

- plenv: 2.3.0-10-gb8ca5d3
- perl: 5.30.0

こちらの記事参考

- <https://github.com/ykHakata/summary/blob/master/perl5_install.md> - perl5_install

```
(perl 準備)
$ cd ~/.plenv/ && git pull
$ cd ~/.plenv/plugins/perl-build/ && git pull
$ plenv install 5.30.0
$ plenv rehash
$ plenv global 5.30.0
$ plenv install-cpanm
$ cpanm Carton
$ cpanm Perl::Tidy

$ cd ~/github/beginning_mojo/tutorial/

(mojo ほか、準備、理解を深めるために一行づつ書き込み実行)
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

- [dir_history.md](/beginning_mojo/doc/dir_history.md#step3): STEP3 を参照
