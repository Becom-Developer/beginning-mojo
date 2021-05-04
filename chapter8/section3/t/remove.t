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

subtest '/remove' => sub {
    $t->post_ok( '/remove' => form => +{} )->status_is(302);
};

# 画面遷移
# トップページから登録、削除までの挙動
subtest 'top -> list -> create -> store -> list -> remove -> list' => sub {
    # トップページから登録完了までの挙動再現
    $t->store_ok();
    # 一覧画面の削除ボタンのリンク確認
    # 一番最後につくったデータを取得
    my $row     = $t->app->teng->single( 'bulletin', +{ deleted => 0 } );
    my $last_id = $row->id;
    my $remove_form
        = "form[name=remove_$last_id][method=post][action=/remove]";
    my $input_id = "input[name=id]";
    my $input_ele = "$remove_form $input_id";
    $t->element_exists($input_ele);
    # 削除リクエスト実行
    my $remove_link_url = $t->tx->res->dom->at($remove_form)->attr('action');
    my $remove_params
        = +{ id => $t->tx->res->dom->at($input_ele)->attr('value'), };
    $t->post_ok( $remove_link_url => form => $remove_params )->status_is(302);

    # 削除成功画面の確認
    my $location_url = $t->tx->res->headers->location;
    $t->get_ok($location_url)->status_is(200);
    $t->content_like(qr{\Q削除しました\E});
};

done_testing();
