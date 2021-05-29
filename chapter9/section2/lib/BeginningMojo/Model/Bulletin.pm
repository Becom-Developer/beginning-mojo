package BeginningMojo::Model::Bulletin;
use Mojo::Base 'BeginningMojo::Model::Base';

# ロジックメソッドを定義
sub to_template_list {
    my $self        = shift;
    my $to_template = +{
        bulletin_list => [],
        total         => 0,
    };
    my $teng          = $self->db->teng;
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

    my $db        = $self->db;
    my $table     = 'bulletin';
    my $insert_id = $db->teng_fast_insert( $table, $params );
    return;
}

sub remove {
    my $self   = shift;
    my $remove = +{
        remove_id => undef,
        msg       => '',
    };

    my $params = $self->req_params;
    my $teng   = $self->db->teng;
    my $row    = $teng->single( 'bulletin', $params );
    return if !$row;

    $row->soft_delete();
    $remove->{remove_id} = $row->id;
    $remove->{msg}       = "削除しました";
    return $remove;
}

1;
