use strict;
use warnings;

use Test::More tests => 7;

#use lib 'lib';

use_ok('Math::Symbolic');
use_ok('Math::Symbolic::MiscCalculus');

use Math::Symbolic qw/:all/;
use Math::Symbolic::ExportConstants qw/:all/;
use Math::Symbolic::MiscAlgebra qw/:all/;

my @matrix = ( [ 'x', 'y' ], [ 'z', 'a' ], );

ok( det(@matrix)->is_identical('(x * a) - (z * y)'), '2x2 det' );

@matrix =
  ( [ 'y*x', 'y*y', 'y*z' ], [ 'z*x', 'z*y', 'z*z' ], [ 'z*x', 'z*y', 'z*z' ],
  );

ok( det(@matrix)->is_identical(<<'HERE'), '3x3 det' );
(((((((y * x) * (z * y)) * (z * z)) + (((z * x) * (z * y)) * (y * z))) +
(((z * x) * (y * y)) * (z * z))) - (((y * z) * (z * y)) * (z * x))) -
(((z * z) * (z * y)) * (y * x))) - (((z * z) * (y * y)) * (z * x))
HERE

@matrix = (
    [ 'y*x', 'y*y', 'y*z', 'a' ],
    [ 'z*x', 'z*y', 'z*z', 'b' ],
    [ 'z*x', 'z*y', 'z*z', 'c' ],
    [ 'e*x', 'e*y', 'e*z', 'd' ],
);

ok(bell_polynomial(0)->is_identical('1'), 'bell_polynomial(0)');
ok(bell_polynomial(1)->is_identical('x'), 'bell_polynomial(1)');
ok(bell_polynomial(2)->is_identical('x^2 + x'), 'bell_polynomial(2)');


