package Bulletin::Model::Bulletin;
use Mojo::Base 'Bulletin::Model::Base';

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

1;
