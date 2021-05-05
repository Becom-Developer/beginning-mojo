package BeginningMojo;
use Mojo::Base 'Mojolicious';
use Mojo::Util qw(trim);
use BeginningMojo::Model;

sub startup {
    my $self    = shift;
    my $mode    = $self->mode;
    my $moniker = $self->moniker;
    my $home    = $self->home;
    my $common  = $home->child( 'etc', "$moniker.common.conf" )->to_string;
    my $conf    = $home->child( 'etc', "$moniker.$mode.conf" )->to_string;

    # 設定ファイル (読み込む順番に注意)
    $self->plugin( Config => +{ file => $common } );
    $self->plugin( Config => +{ file => $conf } );
    my $config = $self->config;

    $self->helper(
        model => sub { BeginningMojo::Model->new( conf => $config ); } );
    $self->helper(
        teng => sub { BeginningMojo::Model->new( conf => $config )->teng; } );

    my $r = $self->routes;
    $r->get('/')->to('bulletin#index');
    $r->get('/list')->to('bulletin#list');
    $r->get('/create')->to('bulletin#create');
    $r->post('/store')->to('bulletin#store');
    $r->post('/remove')->to('bulletin#remove');
}

1;
