use strict;
use warnings;

use Test::More tests => 10;

#use lib 'lib';

use_ok('Math::Symbolic');
use_ok('Math::Symbolic::VectorCalculus');

use Math::Symbolic qw/:all/;
use Math::Symbolic::VectorCalculus qw/:all/;

my $func = 'x+y';
my @grad = grad 'x+y';
@grad = map { $_->apply_derivatives()->simplify() } @grad;
ok( ( @grad == 2 and "$grad[0]" eq '1' and "$grad[1]" eq '1' ),
    'simple grad usage' );

$func = parse_from_string('2*x+y+3*z');
@grad = grad $func;
@grad = map { $_->apply_derivatives()->simplify() } @grad;
ok(
    (
              @grad == 3
          and "$grad[0]" eq '2'
          and "$grad[1]" eq '1'
          and "$grad[2]" eq '3'
    ),
    'more simple grad usage'
);

@grad = grad $func, @{ [qw/y x/] };
@grad = map { $_->apply_derivatives()->simplify() } @grad;
ok( ( @grad == 2 and "$grad[0]" eq '1' and "$grad[1]" eq '2' ),
    'more grad usage with custom signature' );

my @func1 = ( 'x+y', 'x+z', 'z*y^2' );
my @func2 = map { parse_from_string($_) } @func1;

my $div = div @func1;
$div = $div->apply_derivatives()->simplify();
ok( "$div" eq '1 + (y ^ 2)', 'simple divergence usage' );

$div = div @func2;
$div = $div->apply_derivatives()->simplify();
ok( "$div" eq '1 + (y ^ 2)', 'more simple divergence usage' );

$div = div @func2, @{ [ 'x', 'z', 'y' ] };
$div = $div->apply_derivatives()->simplify()->to_string();
$div =~ s/\s|\(|\)//g;
ok( $div eq '2+z*y^2*2*1/y', 'divergence usage with custom signature' );

my @rot = rot @func1;
ok( @rot == 3, 'basic rot usage' );

my @matrix = Jacobi @func1;
ok( @matrix == 3, 'basic Jacobi usage' );

