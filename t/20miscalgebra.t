use strict;
use warnings;

use Test::More tests => 6;

#use lib 'lib';

use_ok('Math::Symbolic');
use_ok('Math::Symbolic::MiscCalculus');

use Math::Symbolic qw/:all/;
use Math::Symbolic::ExportConstants qw/:all/;
use Math::Symbolic::MiscAlgebra qw/:all/;

my @matrix = ( [ 'x', 'y' ], [ 'z', 'a' ], );

ok( det(@matrix)->is_identical('(x * a) - (z * y)'), '2x2 det' );

ok(bell_polynomial(0)->is_identical('1'), 'bell_polynomial(0)');
ok(bell_polynomial(1)->is_identical('x'), 'bell_polynomial(1)');
ok(bell_polynomial(2)->is_identical('x^2 + x'), 'bell_polynomial(2)');


