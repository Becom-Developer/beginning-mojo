package BeginningMojo;
use Mojo::Base 'Mojolicious';
use Mojo::Util qw(trim);
use BeginningMojo::Model;

sub startup {
    my $self = shift;

    $self->helper( model => sub { BeginningMojo::Model->new(); } );
    $self->helper( teng  => sub { BeginningMojo::Model->new()->teng; } );

    my $r = $self->routes;
    $r->get('/')->to('bulletin#index');
    $r->get('/list')->to('bulletin#list');
    $r->get('/create')->to('bulletin#create');
    $r->post('/store')->to('bulletin#store');
    $r->post('/remove')->to('bulletin#remove');
}

1;
