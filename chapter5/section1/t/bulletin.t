use Mojo::Base -strict;
use Test::More;
use Mojo::File qw(curfile);
use Test::Mojo;
use Mojo::Util qw{dumper};

# web アプリの実行スクリプトを指定
my $script = curfile->dirname->sibling('bulletin.pl');

# ルーティングテスト
my $t = Test::Mojo->new($script);
$t->get_ok('/')->status_is(200);

done_testing();
