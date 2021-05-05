package BeginningMojo::Model::Base;
use Mojo::Base -base;
use Teng;
use Teng::Schema::Loader;

# mojo のhas アクセスメソッド提供、呼び出し元が返却される
has [qw{req_params conf}];

# 全てのモデルで共通して使えるメソッドを定義
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
        namespace => 'DB::Teng',
    );
    return $teng;
}

1;
