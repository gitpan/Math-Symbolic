#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib';

use Math::Symbolic qw/:all/;

use Math::Symbolic::VectorCalculus qw/:all/;

print join "\n",
  map { $_->apply_derivatives()->simplify() } grad 'x*y+2*z*x-y^2';

print "\n\n";

my @funcs = ( 'x*y+2*z*x-y^2', 'y+x+z', 'x*y*z' );
my $div = div @funcs;
print $div->apply_derivatives()->simplify();

print "\n\n";

print join "\n", map { $_->apply_derivatives()->simplify() } rot @funcs;

print "\n\n";

my @matrix = Jacobi @funcs;
print "[\n";
foreach my $func (@matrix) {
    print "  [\n";
    foreach my $var (@$func) {
        $var = $var->apply_derivatives()->simplify();
        print "    $var\n";
    }
    print "  ]\n";
}
print "]\n";

