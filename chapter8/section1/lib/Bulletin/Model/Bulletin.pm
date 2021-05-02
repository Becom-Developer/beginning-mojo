package Bulletin::Model::Bulletin;
use Mojo::Base 'Bulletin::Model::Base';
use Time::Piece;

# ロジックメソッドを定義
sub to_template_list {
    my $self        = shift;
    my $to_template = +{
        bulletin_list => [],
        total         => 0,
    };
    my $teng          = $self->teng;
    my @bulletin_rows = $teng->search( 'bulletin', +{ deleted => 0 } );
    my $bulletin_list = [];
    for my $row (@bulletin_rows) {
        push @{$bulletin_list}, $row->get_columns;
    }
    $to_template->{bulletin_list} = $bulletin_list;
    my $total = scalar @{$bulletin_list};
    $to_template->{total} = $total;
    return $to_template;
}

sub store {
    my $self   = shift;
    my $params = $self->req_params;

    my $teng = $self->teng;
    my $t    = localtime;
    my $date = $t->date;
    my $time = $t->time;
    $params = +{
        %{$params},
        deleted     => 0,
        created_ts  => "$date $time",
        modified_ts => "$date $time",
    };
    $teng->fast_insert( 'bulletin', $params );
    return;
}

1;
