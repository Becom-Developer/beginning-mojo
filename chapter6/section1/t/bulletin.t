use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use FindBin;
use lib "$FindBin::Bin/../lib";

# web アプリを実行からテスト用DB準備まで
my $t = Test::Mojo->with_roles('+Basic')->new;
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
    $t->get_ok('/')->status_is(200);

    # [top -> list] リンクURLの存在確認
    my $list_link_ele = "a[href=/list]";
    my $list_link_url = $t->tx->res->dom->at($list_link_ele)->attr('href');
    $t->get_ok($list_link_url)->status_is(200);

    # [list -> create] リンクURLの存在確認
    my $create_link_ele = "a[href=/create]";
    my $create_link_url = $t->tx->res->dom->at($create_link_ele)->attr('href');
    $t->get_ok($create_link_url)->status_is(200);

    # [create -> store -> list] 値埋め込み後送信
    my $store_form    = "form[method=post][action=/store]";
    my $input_comment = "input[name=comment]";
    my $val           = 'テストコメント';

    # フォームの存在確認
    $t->element_exists($store_form);

    # form の中の input に値を埋め込むテスト
    my $input_ele = "$store_form $input_comment";
    $t->tx->res->dom->at($input_ele)->attr( 'value' => $val );

    # dom の中からリクエストする値を作り出す
    my $store_link_url = $t->tx->res->dom->at($store_form)->attr('action');
    my $store_params =
      +{ comment => $t->tx->res->dom->at($input_ele)->attr('value'), };
    $t->post_ok( $store_link_url => form => $store_params )->status_is(302);

    # リダイレクト成功後の画面
    my $location_url = $t->tx->res->headers->location;
    $t->get_ok($location_url)->status_is(200);
    $t->content_like(qr{\Q$val\E});
};

done_testing();
