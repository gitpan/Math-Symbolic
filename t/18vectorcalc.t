use strict;
use warnings;

use Test::More tests => 11;

#use lib 'lib';

use_ok('Math::Symbolic');
use_ok('Math::Symbolic::VectorCalculus');

use Math::Symbolic qw/:all/;
use Math::Symbolic::ExportConstants qw/:all/;
use Math::Symbolic::VectorCalculus qw/:all/;

my $func = 'x+y';
my @grad = grad 'x+y';
ok(
    (
              @grad == 2
          and $grad[0]->is_identical('partial_derivative(x + y, x)')
          and $grad[1]->is_identical('partial_derivative(x + y, y)')
    ),
    'simple grad usage'
);

$func = parse_from_string('2*x+y+3*z');
@grad = grad $func;
ok(
    (
              @grad == 3
          and $grad[0]->is_identical('partial_derivative(((2*x)+y)+(3*z),x)')
          and $grad[1]->is_identical('partial_derivative(((2*x)+y)+(3*z),y)')
          and $grad[2]->is_identical('partial_derivative(((2*x)+y)+(3*z),z)')
    ),
    'more simple grad usage'
);

@grad = grad $func, @{ [qw/y x/] };
ok(
    (
              @grad == 2
          and $grad[0]->is_identical('partial_derivative(((2*x)+y)+(3*z),y)')
          and $grad[1]->is_identical('partial_derivative(((2*x)+y)+(3*z),x)')
    ),
    'more grad usage with custom signature'
);

my @func1 = ( 'x+y', 'x+z', 'z*y^2' );
my @func2 = map { parse_from_string($_) } @func1;

my $div = div @func1;
ok( $div->is_identical(<<'HERE'), 'simple divergence usage' );
((partial_derivative(x + y, x)) +
 (partial_derivative(x + z, y))) +
(partial_derivative(z * (y ^ 2), z))
HERE

$div = div @func2;
ok( $div->is_identical(<<'HERE'), 'more simple divergence usage' );
((partial_derivative(x + y, x)) +
 (partial_derivative(x + z, y))) +
(partial_derivative(z * (y ^ 2), z))
HERE

$div = div @func2, @{ [ 'x', 'z', 'y' ] };
ok( $div->is_identical(<<'HERE'), 'divergence usage with custom signature' );
((partial_derivative(x + y, x)) +
 (partial_derivative(x + z, z))   ) +
(partial_derivative(z * (y ^ 2), y))
HERE

my @rot = rot @func1;
ok(
    (
              @rot == 3
          and $rot[0]->is_identical(<<'ROT0')
(partial_derivative(z * (y ^ 2), y)) - (partial_derivative(x + z, z))
ROT0
          and $rot[1]->is_identical(<<'ROT1'),
(partial_derivative(x + y, z)) - (partial_derivative(z * (y ^ 2), x))
ROT1
          and $rot[2]->is_identical(<<'ROT2'),
(partial_derivative(x + z, x)) - (partial_derivative(x + y, y))
ROT2
    ),
    'basic rot usage'
);

my @expected = (
    'partial_derivative(x + y, x)',
    'partial_derivative(x + y, y)',
    'partial_derivative(x + y, z)',
    'partial_derivative(x + z, x)',
    'partial_derivative(x + z, y)',
    'partial_derivative(x + z, z)',
    'partial_derivative(z * (y ^ 2), x)',
    'partial_derivative(z * (y ^ 2), y)',
    'partial_derivative(z * (y ^ 2), z)',
);
my @matrix = Jacobi @func1;
ok(
    (
        @matrix == 3
          and
          ( grep { $_->is_identical( shift @expected ) } map { (@$_) } @matrix )
          == 9
    ),
    'basic Jacobi usage'
);

@expected = (
    'partial_derivative(partial_derivative((x * y) + z, x), x)',
    'partial_derivative(partial_derivative((x * y) + z, x), y)',
    'partial_derivative(partial_derivative((x * y) + z, x), z)',
    'partial_derivative(partial_derivative((x * y) + z, y), x)',
    'partial_derivative(partial_derivative((x * y) + z, y), y)',
    'partial_derivative(partial_derivative((x * y) + z, y), z)',
    'partial_derivative(partial_derivative((x * y) + z, z), x)',
    'partial_derivative(partial_derivative((x * y) + z, z), y)',
    'partial_derivative(partial_derivative((x * y) + z, z), z)'
);
@matrix = Hesse 'x*y+z';
ok(
    (
        @matrix == 3
          and
          ( grep { $_->is_identical( shift @expected ) } map { (@$_) } @matrix )
          == 9
    ),
    'basic Hesse usage'
);

