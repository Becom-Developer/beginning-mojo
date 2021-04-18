use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use FindBin;
use lib "$FindBin::Bin/../lib";

# web アプリを実行からテスト用DB準備まで
my $t = Test::Mojo->with_roles('+Basic')->new;
$t->init;

subtest '/' => sub {
    $t->get_ok('/')->status_is(200);
};

done_testing();
