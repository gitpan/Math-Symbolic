#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib';

use Math::Symbolic qw/:all/;
use Math::Symbolic::MiscAlgebra qw/:all/;

my @matrix = (
	['x*x', 'x*y', 'x*z', 'a*a'],
	['y*x', 'y*y', 'y*z', 'a*a'],
	['z*x', 'z*y', 'z*z', 'a*a'],
	['z*x', 'z*y', 'z*z', 'a*a'],
);

my $det = det @matrix;
print $det->simplify();

