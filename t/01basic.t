use strict;
use warnings;

use Test::More tests => 11;

#use lib 'lib';

use_ok('Math::Symbolic');
use_ok('Math::Symbolic::VectorCalculus');
use Math::Symbolic::ExportConstants qw/:all/;

my $var = Math::Symbolic::Variable->new();
ok( ref($var) eq 'Math::Symbolic::Variable', 'Variable prototype' );

my $a = $var->new( 'a' => 2 );
ok(
    ref($a) eq 'Math::Symbolic::Variable'
      && $a->value() == 2
      && $a->name() eq 'a',
    'Variable creation, value(), and name()'
);

my $b = $var->new( 'b' => 3 );
my $c = $var->new( 'c' => 4 );

print "Vars: a="
  . $a->value() . " b="
  . $b->value() . " c="
  . $c->value()
  . " (Values are optional)\n\n";

my $op = Math::Symbolic::Operator->new();
ok( ref($op) eq 'Math::Symbolic::Operator', 'Operator prototype' );

my $add1 = $op->new( '+', $a, $c );
ok( ref($add1) eq 'Math::Symbolic::Operator' && $add1->type() == B_SUM,
    'Operator creation, type()' );

my $mult1 = $op->new( '*', $a,    $b );
my $div1  = $op->new( '/', $add1, $mult1 );

print "Expression: (a+c)/(a*b)\n\n";

print "prefix notation and evaluation:\n";

$@ = undef;
eval <<'HERE';
print $div1->to_string('prefix') . " = " . $div1->value() . "\n\n";
HERE
ok( !$@, 'to_string("prefix") did not complain' );

print "Now, we derive this partially to a: (prefix again)\n";

$@ = undef;
my $n_tree;
eval <<'HERE';
$n_tree = $op->new( {
	type => U_P_DERIVATIVE,
	operands => [$div1, $a],
} );
HERE
ok( !$@, 'long-form partial derivative did not complain' );
ok(
    ref($n_tree) eq 'Math::Symbolic::Operator'
      && $n_tree->type() == U_P_DERIVATIVE,
    ,
    'long-form partial derivative returned derivative'
);

print $n_tree->to_string('prefix') . " = " . $n_tree->value() . "\n\n";

print "Now, we apply the derivative to the term: (infix)\n";

$@ = undef;
my $derived;
eval <<'HERE';
$derived = $n_tree->apply_derivatives();
HERE
ok( !$@, 'apply_derivatives() did not complain' );

print "$derived = " . $derived->value() . "\n\n";

print "Finally, we simplify the derived term as much as possible:\n";

$@ = undef;
my $simplified;
eval <<'HERE';
$simplified = $derived->simplify();
HERE
ok( !$@, 'simplify() did not complain' );

print "$simplified = " . $derived->value() . "\n\n";

