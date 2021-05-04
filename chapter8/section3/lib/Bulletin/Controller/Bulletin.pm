package Bulletin::Controller::Bulletin;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(trim);

sub index {
    my $self = shift;
    $self->render( template => 'index' );
}

sub list {
    my $self        = shift;
    my $to_template = $self->model->bulletin->to_template_list;
    $self->stash($to_template);
    $self->render( template => 'list' );
}

sub create {
    my $self = shift;
    $self->render( template => 'create' );
}

sub store {
    my $self   = shift;
    my $params = $self->req->params->to_hash;

    # 値が空の場合は登録しない
    my $comment = $params->{comment};
    my $trimmed = '';
    if ($comment) {
        $trimmed = trim($comment);
    }
    if ( !$trimmed ) {
        $self->flash( msg => "正しく値を入力してください" );
        $self->redirect_to('/create');
        return;
    }

    my $model = $self->model->bulletin->req_params($params);
    $model->store;
    $self->redirect_to('/list');
}

sub remove {
    my $self   = shift;
    my $params = $self->req->params->to_hash;
    my $model  = $self->model->bulletin->req_params($params);
    my $msg    = '';
    if ( my $remove = $model->remove ) {
        $msg = $remove->{msg};
    }
    $self->flash( msg => $msg );
    $self->redirect_to('/list');
}

1;
