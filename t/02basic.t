use strict;
use warnings;

use Test::More tests => 10;
#use lib 'lib';

use_ok('Math::Symbolic');
use Math::Symbolic::ExportConstants qw/:all/;

my $var = Math::Symbolic::Variable->new();
my $a = $var->new('a' => 2);

print "Vars: a=" . $a->value() .
           " (Value is optional)\n\n";

my $const = Math::Symbolic::Constant->new();
ok(
	ref($const) eq 'Math::Symbolic::Constant',
	'Constant prototype'
  );

my $ten   = $const->new(10);
ok(
	ref($ten) eq 'Math::Symbolic::Constant' && $ten->value() == 10 &&
	$ten->special() eq '',
	'constant creation, value(), and special()'
   );

my $euler   = $const->euler();
ok(
	ref($euler) eq 'Math::Symbolic::Constant' && $euler->value() >= 2.7 &&
	$euler->value() <= 2.8 &&
	$euler->special() eq 'euler',
	'euler constant creation, value(), and special()'
   );

my $pi   = $const->pi();
ok(
	ref($pi) eq 'Math::Symbolic::Constant' && $pi->value() >= 3.1 &&
	$pi->value() <= 3.2 &&
	$pi->special() eq 'pi',
	'pi constant creation, value(), and special()'
   );


my $op   = Math::Symbolic::Operator->new();
my $mul1 = $op->new('*', $a, $a);

my $log1 = $op->new('log', $ten, $mul1);
ok(
	ref($log1) eq 'Math::Symbolic::Operator' &&
	$log1->type() == B_LOG,
	'Creation of logarithm'
  );

print "Expression: log_10(a*a)\n\n";

print "prefix notation and evaluation:\n";
print $log1->to_string('prefix') . " = " . $log1->value() . "\n\n";

print "Now, we derive this partially to a: (prefix again)\n";

my $n_tree = $op->new( {
	type => U_P_DERIVATIVE,
	operands => [$log1, $a],
} );
print $n_tree->to_string('prefix') . " = " . $n_tree->value() . "\n\n";

$@ = undef;
my $derived;
eval <<'HERE';
$derived = $n_tree->apply_derivatives();
HERE
ok(!$@, 'apply_derivatives() did not complain');

print "$derived = " . $derived->value() . "\n\n";

print "Finally, we simplify the derived term as much as possible:\n";


$@ = undef;
my $simplified;
eval <<'HERE';
$simplified = $derived->simplify();
HERE
ok(!$@, 'simplify() did not complain');

print "$simplified = " . $derived->value() . "\n\n";

$@ = undef;
eval <<'HERE';
$simplified->value(a=>2);
HERE
ok(!$@, 'value() with arguments did not complain');

$@ = undef;
eval <<'HERE';
$simplified->set_value(a=>2);
HERE
ok(!$@, 'set_value() with arguments did not complain');

