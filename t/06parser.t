# BEGIN{$::RD_HINT = 1;}

use strict;
use warnings;

use Test::More tests => 9;
#use lib 'lib';

use_ok('Math::Symbolic');
use Math::Symbolic::ExportConstants qw/:all/;


my $tree;
undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('2');
HERE
ok(
	(!$@ and ref($tree) eq 'Math::Symbolic::Constant'),
	'Parsing constants'
);

my $str;
undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('2*2');
HERE
$str = $tree->to_string();
$str =~ s/\(|\)|\s+//g;
ok(
	(!$@ and $str eq '2*2'),
	'Parsing multiplication'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('(2+2)*2');
HERE
$str = $tree->to_string();
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq '(2+2)*2'),
	'Parsing parens and addition, precedence'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('2-2+2-2');
HERE
$str = $tree->to_string();
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq '((2+2)-2)-2'),
	'Parsing difference, chaining, reordering'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('-2');
HERE
$str = $tree->to_string();
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq '-2'),
	'Parsing unary'
);


undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('5^log(2,4)');
HERE
$str = $tree->to_string('prefix');
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq 'exponentiate(5,log(2,4))'),
	'Parsing exp and log'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('1+2*-5^log(2,4)');
HERE
$str = $tree->to_string('prefix');
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq 'add(1,multiply(2,exponentiate(negate(5),log(2,4))))'),
	'Parsing complicated term'
);

undef $@;
eval <<'HERE';
$tree = Math::Symbolic->parse_from_string('cos(sin(1+2*-5^log(2,4)))');
HERE
$str = $tree->to_string('prefix');
$str =~ s/\s+//g;
ok(
	(!$@ and $str eq 'cos(sin(add(1,multiply(2,exponentiate(negate(5),log(2,4))))))'),
	'Parsing complicated term involving sine and cosine'
);
