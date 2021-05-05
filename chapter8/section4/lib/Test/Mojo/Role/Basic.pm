package Test::Mojo::Role::Basic;
use Mojo::Base -role;
use Test::More;
use Mojo::File 'curfile';
use Mojo::Util qw{dumper};

sub init {
    my $self = shift;

    # テストコード実行の制限
    die 'not mode testing!' if $self->app->config->{mode} ne 'testing';

    $self->init_db;
    return;
}

sub init_db {
    my $self = shift;

    # データベースの初期化間違いを防止
    die 'not mode testing!' if $self->app->config->{mode} ne 'testing';

    my $db     = $self->app->config->{db_file};
    my $schema = $self->app->config->{schema_file};

    # system コマンドは失敗すると true
    my $cmd = "sqlite3 $db < $schema";
    system $cmd and die "Couldn'n run: $cmd ($!)";
    return;
}

sub store_ok {
    my $t = shift;
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
    return $t;
}

1;
