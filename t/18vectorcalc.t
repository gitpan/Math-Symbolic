use strict;
use warnings;

use Test::More tests => 19;

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

my $differential = TotalDifferential 'x*y';
ok( $differential->is_identical(<<'HERE'), 'basic TotalDifferential usage' );
partial_derivative(x_0*y_0,x_0)*(x-x_0) +
partial_derivative(x_0*y_0,y_0)*(y-y_0)
HERE

$differential = TotalDifferential 'x*y+z', @{ [qw/z x/] };
ok(
    $differential->is_identical(
        <<'HERE'), 'more basic TotalDifferential usage' );
partial_derivative(x_0*y+z_0,z_0)*(z-z_0) +
partial_derivative(x_0*y+z_0,x_0)*(x-x_0)
HERE

$differential = TotalDifferential 'x*y+z', @{ [qw/z x/] }, @{ [qw/z0 x0/] };
ok(
    $differential->is_identical(
        <<'HERE'), 'yet more basic TotalDifferential usage' );
partial_derivative(x0*y+z0,z0)*(z-z0) +
partial_derivative(x0*y+z0,x0)*(x-x0)
HERE

my $dderiv = DirectionalDerivative 'x*y+z',
  @{ [ 'a', Math::Symbolic::Variable->new('b'), 'c' ] };
ok( $dderiv->is_identical(<<'HERE'), 'basic DirectionalDerivative usage' );
(((partial_derivative((x * y) + z, x)) * (a /
( (((a ^ 2) + (b ^ 2)) + (c ^ 2)) ^ 0.5))) +
((partial_derivative((x * y) + z, y)) * (b /
((((a ^ 2) + (b ^ 2)) + (c ^ 2)) ^ 0.5)))) + ((partial_derivative(
(x * y) + z, z)) * (c / ((((a ^ 2) + (b ^ 2)) + (c ^ 2)) ^ 0.5)))
HERE

$dderiv = DirectionalDerivative 'x*y+z',
  @{ [ 'b', Math::Symbolic::Variable->new('a') ] }, @{ [ 'z', 'x' ] };
ok( $dderiv->is_identical(<<'HERE'), 'basic DirectionalDerivative usage' );
((partial_derivative((x * y) + z, z)) * (b / (((b ^ 2)
+ (a ^ 2)) ^ 0.5))) + ((partial_derivative((x * y) + z, x)
) * (a / (((b^ 2) + (a ^ 2)) ^ 0.5)))
HERE

my $taylor = TaylorPolyTwoDim 'x*y', 'x', 'y', 0;
ok(
    $taylor->is_identical(
        <<'HERE'), 'basic TaylorPolyTwoDim usage (degree 0)' );
x_0 * y_0
HERE

$taylor = TaylorPolyTwoDim 'x*y', 'x', 'y', 1;
ok(
    $taylor->is_identical(
        <<'HERE'), 'basic TaylorPolyTwoDim usage (degree 1)' );
(x_0 * y_0) + ((((x - x_0) * (partial_derivative(x_0 * y_0, x_0))) +
((y - y_0) * (partial_derivative(x_0 * y_0, y_0)))) / 1)
HERE

$taylor = TaylorPolyTwoDim 'x*y', 'x', 'y', 2;
ok(
    $taylor->is_identical(
        <<'HERE'), 'basic TaylorPolyTwoDim usage (degree 2)' );
((x_0 * y_0) + ((((x - x_0) * (partial_derivative(x_0 * y_0, x_0)))
+ ((y - y_0) * (partial_derivative(x_0 * y_0, y_0)))) / 1)) + (((((
partial_derivative(partial_derivative(x_0 * y_0, x_0), x_0)) * ((x
- x_0) ^ 2)) + (2 * ((partial_derivative(partial_derivative(x_0 *
y_0, x_0), y_0)) * (((x - x_0) ^ 1) * ((y - y_0) ^ 1))))) + ((
partial_derivative(partial_derivative(x_0 * y_0, y_0), y_0)) *
((y - y_0) ^ 2))) / (1 * 2))
HERE

