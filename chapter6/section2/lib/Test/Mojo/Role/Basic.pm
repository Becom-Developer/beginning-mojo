package Test::Mojo::Role::Basic;
use Mojo::Base -role;
use Test::More;
use Mojo::File 'curfile';
use Mojo::Util qw{dumper};

sub init {
    my $self = shift;

    # テストの時は強制的にモードを変更
    $ENV{MOJO_MODE} = 'testing';

    # web アプリを実行 (.pm ではないので require で読み込み)
    my $app = curfile->dirname->sibling('../../../bulletin.pl');
    require $app;

    $self->init_db;
    return;
}

sub init_db {
    my $self = shift;
    my $db = curfile->dirname->sibling( '../../../db', 'bulletin.testing.db' );
    my $schema = curfile->dirname->sibling( '../../../db', 'bulletin.sql' );

    # system コマンドは失敗すると true
    my $cmd = "sqlite3 $db < $schema";
    system $cmd and die "Couldn'n run: $cmd ($!)";
    return;
}

1;
