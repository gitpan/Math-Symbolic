
=head1 NAME

Math::Symbolic::VectorCalculus - Symbolically comp. grad, Jacobi matrices etc.

=head1 SYNOPSIS

  use Math::Symbolic qw/:all/;
  use Math::Symbolic::VectorCalculus; # not loaded by Math::Symbolic
  
  @gradient = grad 'x+y*z';
  # or:
  $function = parse_from_string('a*b^c');
  @gradient = grad $function;
  # or:
  @signature = qw(x y z);
  @gradient = grad 'a*x+b*y+c*z', @signature; # Gradient only for x, y, z
  # or:
  @gradient = grad $function, @signature;
  
  # Similar syntax variations as with the gradient:
  $divergence = div @functions;
  $divergence = div @functions, @signature;
  
  # Again, similar DWIM syntax variations as with grad:
  @rotation = rot @functions;
  @rotation = rot @functions, @signature;
  
  # Signatures always inferred from the functions here:
  @matrix = Jacobi @functions;
  # $matrix is now array of array references. These hold
  # Math::Symbolic trees.
  
  # Similar to Jacobi:
  @matrix = Hesse $function;

=head1 DESCRIPTION

This module provides several subroutines related to
vector calculus such as computing gradients, divergence, rotation,
and Jacobi matrices of Math::Symbolic trees.

Please note that the code herein may or may not be refactored into
the OO-interface of the Math::Symbolic module in the future.

=head2 EXPORT

None by default.

You may choose to have any of the following routines exported to the
calling namespace. ':all' tag exports all of the following:

  grad
  div
  rot
  Jacobi

=head1 SUBROUTINES

=cut

package Math::Symbolic::VectorCalculus;

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
          grad
          div
          rot
          Jacobi
          Hesse
          )
    ]
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.119';

=begin comment

_combined_signature returns the combined signature of unique variable names
of all Math::Symbolic trees passed to it.

=end comment

=cut

sub _combined_signature {
    my %seen = map { ( $_, undef ) } map { ( $_->signature() ) } @_;
    return [ sort keys %seen ];
}

=head2 grad

This subroutine computes the gradient of a Math::Symbolic tree representing
a function.

The gradient of a function f(x1, x2, ..., xn) is defined as the vector:

  ( df(x1, x2, ..., xn) / d(x1),
    df(x1, x2, ..., xn) / d(x2),
    ...,
    df(x1, x2, ..., xn) / d(xn) )

(These are all partial derivatives.) Any good book on calculus will have
more details on this.

grad uses prototypes to allow for a variety of usages. In its most basic form,
it accepts only one argument which may either be a Math::Symbolic tree or a
string both of which will be interpreted as the function to compute the
gradient for. Optionally, you may specify a second argument which must
be a (literal) array of Math::Symbolic::Variable objects or valid
Math::Symbolic variable names (strings). These variables will the be used for
the gradient instead of the x1, ..., xn inferred from the function signature.

=cut

sub grad ($;\@) {
    my $original = shift;
    $original = parse_from_string($original)
      unless ref($original) =~ /^Math::Symbolic/;
    my $signature = shift;

    my @funcs;
    my @signature =
      ( defined $signature ? @$signature : $original->signature() );

    foreach (@signature) {
        my $var  = Math::Symbolic::Variable->new($_);
        my $func = Math::Symbolic::Operator->new(
            {
                type     => U_P_DERIVATIVE,
                operands => [ $original->new(), $var ],
            }
        );
        push @funcs, $func;
    }
    return @funcs;
}

=head2 div

This subroutine computes the divergence of a set of Math::Symbolic trees
representing a vectorial function.

The divergence of a vectorial function
F = (f1(x1, ..., xn), ..., fn(x1, ..., xn)) is defined like follows:

  sum_from_i=1_to_n( dfi(x1, ..., xn) / dxi )

That is, the sum of all partial derivatives of the i-th component function
to the i-th coordinate. See your favourite book on calculus for details.
Obviously, it is important to keep in mind that the number of function
components must be equal to the number of variables/coordinates.

Similar to grad, div uses prototypes to offer a comfortable interface.
First argument must be a (literal) array of strings and Math::Symbolic trees
which represent the vectorial function's components. If no second argument
is passed, the variables used for computing the divergence will be
inferred from the functions. That means the function signatures will be
joined to form a signature for the vectorial function.

If the optional second argument is specified, it has to be a (literal)
array of Math::Symbolic::Variable objects and valid variable names (strings).
These will then be interpreted as the list of variables for computing the
divergence.

=cut

sub div (\@;\@) {
    my @originals =
      map { ( ref($_) =~ /^Math::Symbolic/ ) ? $_ : parse_from_string($_) }
      @{ +shift };

    my $signature = shift;
    $signature = _combined_signature(@originals)
      if not defined $signature;

    if ( @$signature != @originals ) {
        die "Variable count does not function count for divergence.";
    }

    my @signature = map { Math::Symbolic::Variable->new($_) } @$signature;

    my $div = Math::Symbolic::Operator->new(
        {
            type     => U_P_DERIVATIVE,
            operands => [ shift(@originals)->new(), shift @signature ],
        }
    );

    foreach (@originals) {
        $div = Math::Symbolic::Operator->new(
            '+', $div,
            Math::Symbolic::Operator->new(
                {
                    type     => U_P_DERIVATIVE,
                    operands => [ $_->new(), shift @signature ],
                }
            )
        );
    }
    return $div;
}

=head2 rot

This subroutine computes the rotation of a set of three Math::Symbolic trees
representing a vectorial function.

The rotation of a vectorial function
F = (f1(x1, x2, x3), f2(x1, x2, x3), f3(x1, x2, x3)) is defined as the
following vector:

  ( ( df3/dx2 - df2/dx3 ),
    ( df1/dx3 - df3/dx1 ),
    ( df2/dx1 - df1/dx2 ) )

Or "nabla x F" for short. Again, I have to refer to the literature for
the details on what rotation is. Please note that there have to be
exactly three function components and three coordinates because the cross
product and hence rotation is only defined in three dimensions.

As with the previously introduced subroutines div and grad, rot
offers a prototyped interface.
First argument must be a (literal) array of strings and Math::Symbolic trees
which represent the vectorial function's components. If no second argument
is passed, the variables used for computing the rotation will be
inferred from the functions. That means the function signatures will be
joined to form a signature for the vectorial function.

If the optional second argument is specified, it has to be a (literal)
array of Math::Symbolic::Variable objects and valid variable names (strings).
These will then be interpreted as the list of variables for computing the
rotation. (And please excuse my copying the last two paragraphs from above.)

=cut

sub rot (\@;\@) {
    my $originals = shift;
    my @originals =
      map { ( ref($_) =~ /^Math::Symbolic/ ) ? $_ : parse_from_string($_) }
      @$originals;

    my $signature = shift;
    $signature = _combined_signature(@originals)
      unless defined $signature;

    if ( @originals != 3 ) {
        die "Rotation only defined for functions of three components.";
    }
    if ( @$signature != 3 ) {
        die "Rotation only defined for three variables.";
    }

    return (
        Math::Symbolic::Operator->new(
            '-',
            Math::Symbolic::Operator->new(
                {
                    type     => U_P_DERIVATIVE,
                    operands => [ $originals[2]->new(), $signature->[1] ],
                }
            ),
            Math::Symbolic::Operator->new(
                {
                    type     => U_P_DERIVATIVE,
                    operands => [ $originals[1]->new(), $signature->[2] ],
                }
            )
        ),
        Math::Symbolic::Operator->new(
            '-',
            Math::Symbolic::Operator->new(
                {
                    type     => U_P_DERIVATIVE,
                    operands => [ $originals[0]->new(), $signature->[2] ],
                }
            ),
            Math::Symbolic::Operator->new(
                {
                    type     => U_P_DERIVATIVE,
                    operands => [ $originals[2]->new(), $signature->[0] ],
                }
            )
        ),
        Math::Symbolic::Operator->new(
            '-',
            Math::Symbolic::Operator->new(
                {
                    type     => U_P_DERIVATIVE,
                    operands => [ $originals[1]->new(), $signature->[0] ],
                }
            ),
            Math::Symbolic::Operator->new(
                {
                    type     => U_P_DERIVATIVE,
                    operands => [ $originals[0]->new(), $signature->[1] ],
                }
            )
        )
    );
}

=head2 Jacobi

Jacobi() returns the Jacobi matrix of a given vectorial function.
It expects any number of arguments (strings and/or Math::Symbolic trees)
which will be interpreted as the vectorial function's components.
Variables used for computing the matrix are inferred from the
combined signature of the components. There is currently no way to
override this behaviour.

The Jacobi matrix is the vector of gradient vectors of the vectorial
function's components.

=cut

sub Jacobi {
    my @funcs =
      map { ( ref($_) =~ /^Math::Symbolic/ ) ? $_ : parse_from_string($_) } @_;

    my @signature = @{ +_combined_signature(@funcs) };

    return map { [ grad $_, @signature ] } @funcs;
}

=head2 Hesse

Hesse() returns the Hesse matrix of a given scalar function. First and
only argument must be a string (to be parsed as a Math::Symbolic tree) or
a Math::Symbolic tree. As with Jacobi(), Hesse() always infers the variables
used for computing the matrix.

The Hesse matrix is the Jacobi matrix of the gradient of a scalar function.

=cut

sub Hesse ($) {
    my $function = shift;
    $function = parse_from_string($function)
      unless ref($function) =~ /^Math::Symbolic/;
    return Jacobi grad $function;
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
