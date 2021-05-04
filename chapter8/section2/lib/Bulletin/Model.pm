package Bulletin::Model;
use Mojo::Base 'Bulletin::Model::Base';
use Bulletin::Model::Bulletin;

# 各モデルにアクセスするためのアクセスメソッドを定義
has bulletin => sub { Bulletin::Model::Bulletin->new(); };

1;
