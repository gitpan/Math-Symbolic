use strict;
use warnings;

use Test::More tests => 8;

#use lib 'lib';

use_ok('Math::Symbolic');
use Math::Symbolic qw/:all/;
use Math::Symbolic::ExportConstants qw/:all/;

my $term  = parse_from_string('a');
my $latex = $term->to_latex();
ok( defined $latex, 'variable' );

$term  = parse_from_string('2');
$latex = $term->to_latex();
ok( defined $latex, 'constant' );

$term  = parse_from_string('2*a(b,c,d)');
$latex = $term->to_latex();
ok( defined $latex, 'constant, op, var, signature' );

$term = parse_from_string('2*log(2,a)');
$latex = $term->to_latex( implicit_multiplication => 1 );
ok( defined $latex, 'implicit multiplication' );

$term = parse_from_string('2/log(2,a)');
$latex = $term->to_latex( no_fractions => 1 );
ok( defined $latex, 'no fractions' );

$term = parse_from_string('2*log(2,a)');
$latex = $term->to_latex( exclude_signature => 1 );
ok( defined $latex, 'exclude_signature' );

$term = parse_from_string(<<'HERE');
total_derivative(
	partial_derivative(
	  (L+t)*2,
	  partial_derivative(q_a, t)
	), t
) - partial_derivative(
  log(2,L),
  q_a
) + partial_derivative(
  F,
  partial_derivative(q_a, t)
)
HERE
$latex = $term->to_latex();
ok( defined $latex, 'fancier term' );
