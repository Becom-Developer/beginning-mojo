# NAME

dir_history.md - 参考資料 (ディレクトリ構造のイメージ)

# SYNOPSIS

完成形のディレクトリ構造のイメージ

# STEP3

Mojolicious::Lite

```
beginning_mojo        # Application directory
|- db                 # データベース関連ファイル
|- doc                # 参考資料各種
|- local              # 拡張モジュール各種
|- .gitignore         # git で管理しないリスト
|- .perl-version      # 実行するPerlのバージョン情報
|- bulletin.pl        # 実行スクリプト
|- cpanfile           # インストールするモジュールリスト
|- cpanfile.snapshot  # モジュールインストール履歴
+- README.md          # はじめに読む資料
```

# STEP6

テストコードを拡張

```
beginning_mojo          # Application directory
|- db                   # データベース関連ファイル
|- doc                  # 参考資料各種
|- lib                  # 読み込みファイル各種
|  +- Test              # テストコード拡張モジュール
|     +- Mojo           # Mojo 用
|        +- Role        # Role 関連
|          +- Basic.pm  # テスト拡張モジュール
|- local                # 拡張モジュール各種
|- t                    # テストコード各種
|- .gitignore           # git で管理しないリスト
|- .perl-version        # 実行するPerlのバージョン情報
|- bulletin.pl          # 実行スクリプト
|- cpanfile             # インストールするモジュールリスト
|- cpanfile.snapshot    # モジュールインストール履歴
+- README.md            # はじめに読む資料
```

# STEP8

Mojolicious

```
beginning_mojo            # Application directory
|- db                     # データベース関連ファイル
|- doc                    # 参考資料各種
|- etc                    # 設定ファイル
|- lib                    # 読み込みファイル各種
|  |- BeginningMojo       # アプリケーションファイル各種
|  |  +- Controller       # アプリケーションコントローラー
|  |  +- DB               # データベースオブジェクトロジック各種
|  |  +- Model            # コントローラーロジック
|  |  +- DB.pm            # データベースオブジェクトロジック呼び出し
|  |  +- Model.pm         # コントローラーロジック呼び出し
|  |- Test                # テストコード拡張モジュール
|  +- BeginningMojo.pm    # アプリケーション定義
|- local                  # 拡張モジュール各種
|- public                 # 静的なファイル各種
|- script                 # 実行ファイル各種
|  +- beginning_mojo      # アプリケーション実行ファイル
|- t                      # テストコード各種
|- templates              # 画面表示用テンプレート各種
|- .gitignore             # git で管理しないリスト
|- .perl-version          # 実行するPerlのバージョン情報
|- cpanfile               # インストールするモジュールリスト
|- cpanfile.snapshot      # モジュールインストール履歴
+- README.md              # はじめに読む資料
```

# SEE ALSO

- [/README.md](/README.md) - beginning_mojo - Perl (Mojolicious) を使って web アプリ開発に挑戦
