package BeginningMojo::Model;
use Mojo::Base 'BeginningMojo::Model::Base';
use BeginningMojo::Model::Bulletin;

# 各モデルにアクセスするためのアクセスメソッドを定義
has bulletin =>
  sub { BeginningMojo::Model::Bulletin->new( conf => shift->conf ); };

1;
