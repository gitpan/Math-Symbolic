
=head1 NAME

Math::Symbolic::AuxFunctions - Auxiliary functions for Math::Symbolic hierarchy

=head1 SYNOPSIS

  use Math::Symbolic::AuxFunctions;
  
  Math::Symbolic::AuxFunctions::acos($x);
  # etc

=head1 DESCRIPTION

This module contains implementations of some auxiliary functions that are
used within the Math::Symbolic hierarchy of modules. In particular, this
module holds all trigonometric functions used for numeric evaluation of
trees by Math::Symbolic::Operator.

=head2 EXPORT

None. On purpose. If I wished this module would pollute others' namespaces,
I'd have put the functions right where they're used.

=cut

package Math::Symbolic::AuxFunctions;

use 5.006;
use strict;
use warnings;

use Carp;

use Math::Symbolic::ExportConstants qw/:all/;

our $VERSION = '0.111';


=head1 TRIGONOMETRIC FUNCTIONS

=head2 tan

Computes the tangent sin(x) / cos(x).

=cut

sub tan {
	return sin($_[0]) / cos($_[0]);
}



=head2 cot

Computes the cotangent cos(x) / sin(x).

=cut

sub cot {
	return cos($_[0]) / sin($_[0]);
}



=head2 asin

Computes the arc sine asin(z) = -i log(iz + sqrt(1-z*z)).
Above formula is for complex numbers.

=cut

sub asin { atan2($_[0], sqrt( 1 - $_[0] * $_[0] ) ) }



=head2 acos

Computes the arc cosine acos(z) = -i log(z + sqrt(z*z-1)).
Above formula is for complex numbers.

=cut

sub acos { atan2( sqrt( 1 - $_[0] * $_[0] ), $_[0] ) }



=head2 atan

Computes the arc tangent atan(z) = i/2 log((i+z) / (i-z)).
Above formula is for complex numbers.

=cut

sub atan { atan2($_[0], 1) }



=head2 acot

Computes the arc cotangent ( atan( 1 / x ) ).

=cut

sub acot { atan2(1 / $_[0], 1) }



=head2 asinh

Computes the arc hyperbolic sine asinh(z) = log(z + sqrt(z*z+1))

=cut

sub asinh { log( $_[0] + sqrt( $_[0] * $_[0] + 1 ) ) }



=head2 acosh

Computes the arc hyperbolic cosine acosh(z) = log(z + sqrt(z*z-1)).

=cut

sub acosh { log( $_[0] + sqrt( $_[0] * $_[0] - 1 ) ) }



1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut
