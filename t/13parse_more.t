# BEGIN{$::RD_HINT = 1;}

use strict;
use warnings;

use Test::More tests => 13;
#use lib 'lib';

use_ok('Math::Symbolic');
use Math::Symbolic::ExportConstants qw/:all/;


my $tree;
undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('a');
HERE
ok(
	(!$@ and ref($tree) eq 'Math::Symbolic::Variable'),
	'Parsing variables'
);

my $str;
undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('a*a');
HERE
$str = $tree->to_string();
$str =~ s/\(|\)|\s+//g;
ok(
	(!$@ and $str eq 'a*a'),
	'Parsing multiplication of variables'
);

undef $@;
eval <<'HERE';
$tree = $tree + '(b + a)';
HERE
$str = $tree->to_string();
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq '(a*a)+(b+a)'),
	'Parsing parens and addition, precedence, overloaded ops'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('a-a+a-a');
HERE
$str = $tree->to_string();
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq '((a+a)-a)-a'),
	'Parsing difference, chaining, reordering'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('-BLABLAIdent_1213_ad');
HERE
$str = $tree->to_string();
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq '-BLABLAIdent_1213_ad'),
	'Parsing unary minus and complex identifier'
);


undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('(1+t)^log(t*2,x^2)');
HERE
$str = $tree->to_string('prefix');
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq
	'exponentiate(add(1,t),log(multiply(t,2),exponentiate(x,2)))'),
	'Parsing exp and log'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('a') * 3 + 'b' - (
	Math::Symbolic->parse_from_string('2*c') **
	sin(Math::Symbolic->parse_from_string('x')));
HERE

$str = $tree->to_string('prefix');
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq
	'subtract(add(multiply(a,3),b),exponentiate(multiply(2,c),sin(x)))'),
	'Parsing complicated term'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic::Operator->new('*', 'a', 'b');
HERE

$str = $tree->to_string('prefix');
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq
	'multiply(a,b)'),
	'Autoparsing at operator creation'
);



undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('a(b, c, d)');
HERE

$str = $tree->to_string('prefix');
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq
	'a'),
	'Parsing variable with signature'
);
$str = join '|', $tree->signature();
ok(
	(!$@ and $str eq
	'a|b|c|d'),
	'Checking variable for correct signature'
);


undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('E_pot(r, t) + 1/2 * m(t) * v(t)^2');
HERE

$str = $tree->to_string('prefix');
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq
	'add(E_pot,divide(multiply(multiply(1,m),exponentiate(v,2)),2))'),
	'Parsing term involving variables with signatures'
);

$str = join '|', $tree->signature();
warn $str;
ok(
	(!$@ and $str eq
	'E_pot|m|r|t|v'),
	'Checking term for correct signature'
);

