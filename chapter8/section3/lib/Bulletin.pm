package Bulletin;
use Mojo::Base 'Mojolicious';
use Mojo::Util qw(trim);
use Bulletin::Model;

sub startup {
    my $self = shift;

    $self->helper( model => sub { Bulletin::Model->new(); } );
    $self->helper( teng  => sub { Bulletin::Model->new()->teng; } );

    my $r = $self->routes;

    $r->get(
        '/' => sub {
            my $c = shift;
            $c->render( template => 'index' );
        }
    );

    $r->get(
        '/list' => sub {
            my $c           = shift;
            my $to_template = $c->model->bulletin->to_template_list;
            $c->stash($to_template);
            $c->render( template => 'list' );
        }
    );

    $r->get(
        '/create' => sub {
            my $c = shift;
            $c->render( template => 'create' );
        }
    );

    $r->post(
        '/store' => sub {
            my $c      = shift;
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
        }
    );

    $r->post(
        '/remove' => sub {
            my $c      = shift;
            my $params = $c->req->params->to_hash;
            my $model  = $c->model->bulletin->req_params($params);
            my $msg    = '';
            if ( my $remove = $model->remove ) {
                $msg = $remove->{msg};
            }
            $c->flash( msg => $msg );
            $c->redirect_to('/list');
        }
    );
}

1;
