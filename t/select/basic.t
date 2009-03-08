#vim ft:perl
use strict;
use warnings FATAL => 'all';

use Test::More;

plan tests => 1;

use_ok('SQL::Abstract') or BAIL_OUT( "$@" );

my $sqla = SQL::Abstract->create(1);

is(
    $sqla->dispatch( [ -select => 1 ] ),
    'SELECT 1',
    "simplest select statement in mysql"
);

is(
    $sqla->dispatch( [ -select => [ -value => \200 ] ] ),
    'SELECT ?',
    "simplest select statement with placeholder"
);

eq_or_diff(
    [
        SQL::Abstract->generate([
            -ast_version => 1,
            [ -select => [ -value => \200 ] ],
        ]),
    ],
    [ 'SELECT ?', [ 200 ] ],
    'Simplest select statement with placeholder and bind value'
);

is(
    $sqla->dispatch( [ [ -select => '1' ], [ -from => 'dual' ] ] ),
    "SELECT 1 FROM dual",
    "simplest select + from (simplest select in oracle)"
);

is(
    $sqla->dispatch( [ -SELECT => '1' ] ),
    'SELECT 1',
    "verify case of clause name"
);

throws_ok {
    $sqla->dispatch( [ [ -from => 'dual' ], [ -select => 1 ] ] ),
} qr/^'-select' cannot come after '-from'/, "clause ordering error";
