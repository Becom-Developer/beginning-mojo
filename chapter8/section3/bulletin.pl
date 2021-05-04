#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use Teng;
use Teng::Schema::Loader;
use Time::Piece;
use Mojo::Util qw(trim);
use lib "./lib";
use Bulletin::Model;

helper model => sub { Bulletin::Model->new(); };
helper teng  => sub { Bulletin::Model->new()->teng };

get '/' => sub ($c) {
    $c->render( template => 'index' );
};

get '/list' => sub ($c) {
    my $to_template = $c->model->bulletin->to_template_list;
    $c->stash($to_template);
    $c->render( template => 'list' );
};

get '/create' => sub ($c) {
    $c->render( template => 'create' );
};

post '/store' => sub ($c) {
    my $params = $c->req->params->to_hash;

    # 値が空の場合は登録しない
    my $comment = $params->{comment};
    my $trimmed = '';
    if ($comment) {
        $trimmed = trim($comment);
    }
    if ( !$trimmed ) {
        $c->flash( msg => "正しく値を入力してください" );
        $c->redirect_to('/create');
        return;
    }
    my $model = $c->model->bulletin->req_params($params);
    $model->store;
    $c->redirect_to('/list');
};

post '/remove' => sub ($c) {
    my $params = $c->req->params->to_hash;
    my $model  = $c->model->bulletin->req_params($params);
    my $msg    = '';
    if ( my $remove = $model->remove ) {
        $msg = $remove->{msg};
    }
    $c->flash( msg => $msg );
    $c->redirect_to('/list');
};

app->start;
__DATA__
