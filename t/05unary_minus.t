use strict;
use warnings;

use Test::More tests => 4;
#use lib 'lib';

use_ok('Math::Symbolic');
use Math::Symbolic::ExportConstants qw/:all/;

my $var = Math::Symbolic::Variable->new();
my $a   = $var->new('a' => 2);

print "Vars: a=" . $a->value() .
           " (Values are optional)\n\n";

my $op    = Math::Symbolic::Operator->new();
my $umi;
undef $@;
eval <<'HERE';
$umi = $op->new({type=>U_MINUS, operands=>[ $a ]});
HERE
ok(!$@, 'Unary minus creation');

print "prefix notation and evaluation:\n";

undef $@;
eval <<'HERE';
print $umi->to_string('prefix') . " = " . $umi->value() . "\n\n";
HERE
ok(!$@, 'Unary minus to prefix');

undef $@;
eval <<'HERE';
print $umi->to_string('infix') . " = " . $umi->value() . "\n\n";
HERE
ok(!$@, 'Unary minus to infix');
