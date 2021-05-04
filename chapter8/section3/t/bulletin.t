use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use FindBin;
use lib "$FindBin::Bin/../lib";

# web アプリを実行からテスト用DB準備まで
my $t = Test::Mojo->with_roles('+Basic')->new('Bulletin');
$t->init;

# ルーティングごとにテスト
subtest '/'       => sub { $t->get_ok('/')->status_is(200); };
subtest '/list'   => sub { $t->get_ok('/list')->status_is(200); };
subtest '/create' => sub { $t->get_ok('/create')->status_is(200); };
subtest '/store'  => sub {
    my $params = +{};
    $t->post_ok( '/store' => form => $params )->status_is(302);
};

# トップページから登録、一覧までの挙動
subtest 'top -> list -> create -> store -> list' => sub {
    $t->store_ok();
};

done_testing();
