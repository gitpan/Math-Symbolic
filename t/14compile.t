use strict;
use warnings;
 
use Test::More tests => 6;

#use lib 'lib';

use_ok('Math::Symbolic');
use Math::Symbolic::ExportConstants qw/:all/;

my $var = Math::Symbolic::Variable->new();
my $a   = $var->new( 'x' => 10 );

my ( $first, $second, $third );

$first = $a * 2 + 1;    # x*2 + 1

$@ = undef;
eval <<'HERE';
($second, $third) = Math::Symbolic::Compiler->compile_to_sub($first, [x=>0]);
HERE
ok( !$@, 'compile_to_sub()' );

my $no = $second->(2);
ok( $no == 5, 'Correct result of sub', );

( $second, $third ) = ( undef, undef );

$@ = undef;
eval <<'HERE';
($second, $third) = Math::Symbolic::Compiler->compile_to_code($first);
HERE
ok( !$@, 'compile_to_code()' );

( $second, $third ) = ( undef, undef );
my $fourth;

$@ = undef;
eval <<'HERE';
($second, $third, $fourth) =
Math::Symbolic::Compiler->compile($first, [x=>0]);
HERE
ok( !$@, 'compile()' );

$no = $second->(2);
ok( $no == 5, 'Correct result of sub', );

