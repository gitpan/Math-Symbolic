
=head1 NAME

Math::Symbolic::MiscAlgebra - Miscellaneous algebra routines like det()

=head1 SYNOPSIS

  use Math::Symbolic qw/:all/;
  use Math::Symbolic::MiscAlgebra qw/:all/; # not loaded by Math::Symbolic
  
  @matrix = (['x*y', 'z*x', 'y*z'],['x', 'z', 'z'],['x', 'x', 'y']);
  $det = det @matrix;

=head1 DESCRIPTION

This module provides several subroutines related to
algebra such as computing the determinant of nxn matrices.

Please note that the code herein may or may not be refactored into
the OO-interface of the Math::Symbolic module in the future.

=head2 EXPORT

None by default.

You may choose to have any of the following routines exported to the
calling namespace. ':all' tag exports all of the following:

  det

=head1 SUBROUTINES

=cut

package Math::Symbolic::MiscAlgebra;

use 5.006;
use strict;
use warnings;

use Carp;

use Math::Symbolic qw/:all/;

require Exporter;
our @ISA         = qw(Exporter);
our %EXPORT_TAGS = (
    'all' => [
        qw(
          det
          )
    ]
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.122';

=head2 det

det() computes the determinant of a matrix of Math::Symbolic trees (or strings
that can be parsed as such). First argument must be a literal array:
"det @matrix", where @matrix is an n x n matrix.

=cut

sub det (\@) {
    my $matrix = shift;
    my $size   = @$matrix;

    foreach (@$matrix) {
        croak "det(Matrix) requires n x n matrix!" if @$_ != $size;
        foreach (@$_) {
            $_ = Math::Symbolic::parse_from_string($_)
              if ref($_) !~ /^Math::Symbolic/;
        }
    }

    return $matrix->[0][0] if $size == 1;
    return $matrix->[0][0] * $matrix->[1][1] - $matrix->[1][0] * $matrix->[0][1]
      if $size == 2;
    return _det_helper( $matrix, $size );
}

sub _det_helper {
    my $matrix = shift;
    my $size   = shift;

    return $matrix->[0][0] * $matrix->[1][1] * $matrix->[2][2] + $matrix->[1][0]
      * $matrix->[2][1] * $matrix->[0][2] + $matrix->[2][0] * $matrix->[0][1] *
      $matrix->[1][2] - $matrix->[0][2] * $matrix->[1][1] * $matrix->[2][0] -
      $matrix->[1][2] * $matrix->[2][1] * $matrix->[0][0] - $matrix->[2][2] *
      $matrix->[0][1] * $matrix->[1][0]
      if $size == 3;

    my $det =
      $matrix->[0][0] *
      _det_helper( _matrix_slice( $matrix, 0, 0 ), $size - 1 );

    foreach ( 1 .. $size - 1 ) {
        if ( $_ % 2 ) {
            $det -=
              $matrix->[0][$_] *
              _det_helper( _matrix_slice( $matrix, 1, $_ ), $size - 1 );
        }
        else {
            $det +=
              $matrix->[0][$_] *
              _det_helper( _matrix_slice( $matrix, 1, $_ ), $size - 1 );
        }
    }
    return $det;
}

sub _matrix_slice {
    my $matrix = shift;
    my $x      = shift;
    my $y      = shift;

    return [ map { [ @{$_}[ 0 .. $y - 1, $y + 1 ... $#$_ ] ] }
          @{$matrix}[ 0 .. $x - 1, $x + 1 .. $#$matrix ] ];
}

1;
__END__

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

=head1 SEE ALSO

New versions of this module can be found on
http://steffen-mueller.net or CPAN. The module development takes place on
Sourceforge at http://sourceforge.net/projects/math-symbolic/

L<Math::Symbolic>

=cut
