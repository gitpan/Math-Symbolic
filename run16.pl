#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib';

use Carp;
use Math::Symbolic qw/:all/;
use Math::Symbolic::MiscCalculus qw/:all/;


my $taylor = TaylorPolynomial 'sin(x)', 10, 'x', 'x_0';
$taylor->implement(e => Math::Symbolic::Constant->euler());
print $taylor, "\n\n";

my $t = $taylor->implement(x_0 => 0);
print $taylor->value(x=>$_*PI/4), "\n", sin($_*PI/4), "\n" for 0..10;

my $error = TaylorErrorLagrange 'sin(x)', 100, 'x', 'x_0', 'theta';
$error = $error->simplify();

print $error->value(theta=>1, x_0=>0,x=>$_*PI/4),"\n" for 0..100;
