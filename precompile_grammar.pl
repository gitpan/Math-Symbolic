#!/usr/bin/perl
use strict;
use warnings;

use Parse::RecDescent;
use Math::Symbolic;
use File::Temp qw/tempfile/;
use File::Copy qw/move/;

print <<'HERE';
This process will regenerate the precompiled Math::Symbolic parser
from the grammar found in the variable $Math::Symbolic::Parser::Grammar.
This is a development tool not intended for end-users.

IT IS NOT SUGGESTED YOU DO THIS UNLESS YOU KNOW EXACTLY WHY YOU'D WANT TO.

Do you want to continue? Please enter the full word "yes" if you do.

HERE

print '>>> ';

my $answer = <STDIN>;
unless ($answer =~ /^\s*yes\s*$/i) {
	print "Parser regeneration not started.\n";
	exit;
}
else {
	Parse::RecDescent->Precompile($Math::Symbolic::Parser::Grammar,
					"Math::Symbolic::Parser::Precompiled");
	open my $fh, '<', 'Precompiled.pm'
		or die "Could not open generated file Precompiled.pm: $!";
	my ($th, $filename) = tempfile('XXXXXXXX', UNLINK => 1);
	my $line;
	while ($line = <DATA>) {
		print $th $line;
	}
	while ($line = <$fh>) {
		print $th $line;
	}
	close $th or die "Could not write to temporary file: $!";
	close $fh;
	move($filename, 'Precompiled.pm');
	print <<'HERE';
Parser generated as module Math::Symbolic::Parser::Precompiled and stored
in a file named "Precompiled.pm" in the current directory.

A stub documentation has been added. You'd better check it before usage.
HERE
	exit;
}

__DATA__


=head1 NAME

Math::Symbolic::Parser::Precompiled - Precompiled Math::Symbolic Parser

=head1 DESCRIPTION

This module is a precompiled version of the Parse::RecDescent grammar
that can be found in $Math::Symbolic::Parser::Grammar. It is used internally
to improve startup performance. Please use the new() method in the
Math::Symbolic::Parser namespace to generate new parsers.

=head1 AUTHOR

Please send feedback, bug reports, and support requests to the Math::Symbolic
support mailing list:
math-symbolic-support at lists dot sourceforge dot net. Please
consider letting us know how you use Math::Symbolic. Thank you.

If you're interested in helping with the development or extending the
module's functionality, please contact the developers' mailing list:
math-symbolic-develop at lists dot sourceforge dot net.

List of contributors:

  Steffen Müller, symbolic-module at steffen-mueller dot net
  Stray Toaster, mwk at users dot sourceforge dot net
  Oliver Ebenhöh

=head1 SEE ALSO

New versions of this module can be found on
http://steffen-mueller.net or CPAN. The module development takes place on
Sourceforge at http://sourceforge.net/projects/math-symbolic/

L<Math::Symbolic>

L<Math::Symbolic::Parser>

=cut
