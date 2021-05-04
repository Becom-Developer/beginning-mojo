package Bulletin;
use Mojo::Base 'Mojolicious';
use Mojo::Util qw(trim);
use Bulletin::Model;

sub startup {
    my $self = shift;

    $self->helper( model => sub { Bulletin::Model->new(); } );
    $self->helper( teng  => sub { Bulletin::Model->new()->teng; } );

    my $r = $self->routes;
    $r->get('/')->to('bulletin#index');
    $r->get('/list')->to('bulletin#list');
    $r->get('/create')->to('bulletin#create');
    $r->post('/store')->to('bulletin#store');
    $r->post('/remove')->to('bulletin#remove');
}

1;
