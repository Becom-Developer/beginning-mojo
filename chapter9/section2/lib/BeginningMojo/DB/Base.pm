package BeginningMojo::DB::Base;
use Mojo::Base -base;
use Teng;
use Teng::Schema::Loader;
use Time::Piece;

has [qw{conf}];

sub teng {
    my $self    = shift;
    my $dsn_str = 'dbi:SQLite:' . $self->conf->{db_file};
    my $user    = '';
    my $pass    = '';
    my $option  = +{
        RaiseError     => 1,
        PrintError     => 0,
        AutoCommit     => 1,
        sqlite_unicode => 1,
    };

    my $dbh  = DBI->connect( $dsn_str, $user, $pass, $option );
    my $teng = Teng::Schema::Loader->load(
        dbh       => $dbh,
        namespace => 'BeginningMojo::DB::Teng',
    );
    return $teng;
}

# teng fast insert 日付つき
# my $insert_id = $db->teng_fast_insert($table, $params);
sub teng_fast_insert {
    my $self   = shift;
    my $table  = shift;
    my $params = shift;

    my $t    = localtime;
    my $date = $t->date;
    my $time = $t->time;
    $params = +{
        %{$params},
        deleted     => 0,
        created_ts  => "$date $time",
        modified_ts => "$date $time",
    };
    return $self->teng->fast_insert( $table, $params );
}

# teng insert 日付つき (row で返却)
# my $insert_row = $db->teng_insert($table, $params);
sub teng_insert {
    my $self   = shift;
    my $table  = shift;
    my $params = shift;

    my $t    = localtime;
    my $date = $t->date;
    my $time = $t->time;
    $params = +{
        %{$params},
        deleted     => 0,
        created_ts  => "$date $time",
        modified_ts => "$date $time",
    };
    return $self->teng->insert( $table, $params );
}

# teng update 日付つき
# my $update_id = $db->teng_update($table, $params, $cond);
sub teng_update {
    my $self   = shift;
    my $table  = shift;
    my $params = shift;
    my $cond   = shift;

    my $t    = localtime;
    my $date = $t->date;
    my $time = $t->time;

    $params = +{ %{$params}, modified_ts => "$date $time", };
    my $update_count = $self->teng->update( $table, $params, $cond, );
    return $cond->{id} if $update_count;
    return;
}

1;
