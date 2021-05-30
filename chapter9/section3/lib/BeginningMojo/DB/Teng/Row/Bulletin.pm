package BeginningMojo::DB::Teng::Row::Bulletin;
use Mojo::Base 'Teng::Row';
use Time::Piece;

sub soft_delete {
    my $self = shift;
    my $opt  = shift || +{};
    my $t    = localtime;
    my $date = $t->date;
    my $time = $t->time;

    my $params = +{
        deleted     => 1,
        modified_ts => "$date $time",
        %{$opt},
    };
    my $txn = $self->handle->txn_scope;

    # 関連情報削除はここに記入

    $self->update($params);
    $txn->commit;
    return;
}

1;
