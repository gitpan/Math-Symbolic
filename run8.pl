#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib';
use Math::Symbolic qw/:all/;

my $tree = Math::Symbolic->parse_from_string('2');
print $tree;

