package BeginningMojo::Model::Base;
use Mojo::Base -base;
use BeginningMojo::DB;

has [qw{req_params conf}];

has db => sub {
    BeginningMojo::DB->new( +{ conf => shift->conf } );
};

1;
