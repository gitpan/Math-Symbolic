
=head1 NAME

Math::Symbolic - Symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic;
  
  my $tree = Math::Symbolic->parse_from_string('1/2 * m * v^2');
  # Now do symbolic calculations with $tree.
  # ... like deriving it...
  
  my ($sub) = Math::Symbolic::Compiler->compile_to_sub($tree);

  my $kinetic_energy = $sub->($mass, $velocity);

=head1 DESCRIPTION

Math::Symbolic is intended to offer symbolic calculation capabilities
to the Perl programmer without using external (and commercial) libraries
and/or applications.

Unless, however, some interested and knowledgable developers turn up to
participate in the development, the library will be severely limited by
my experience in the area. Symbolic calculations are an active field of
research in CS.

There are several ways to construct Math::Symbolic trees. There are no
actual Math::Symbolic objects, but rather trees of objects of subclasses of
Math::Symbolic. The most general but unfortunately also the least intuitive
way of constructing trees is to use the constructors of
the Math::Symbolic::Operator, Math::Symbolic::Variable, and
Math::Symbolic::Constant classes to create (nested) objects of the
corresponding types.

Furthermore, you may use the overloaded interface to apply the standard
Perl operators (and functions, see L<OVERLOADED OPERATORS>) to existing
Math::Symbolic trees and standard Perl expressions.

Possibly the most convenient way of constructing Math::Symbolic trees is
using the builtin parser to generate trees from expressions such as '2 * x^5'.
You may use the Math::Symbolic->parse_from_string() class method for this.

Of course, you may combine the overloaded interface with the parser to
generate trees with Perl code such as "$term * 5 * 'sin(omega*t+phi)'" which
will create a tree of the existing tree $term times 5 times the sine of
the vars omega times t plus phi.

There are several modules in the distribution that contain subroutines
related to calculus. These are not loaded by Math::Symbolic by default.
For example, Math::Symbolic::MiscCalculus contains routines to compute
Taylor Polynomials and the associated errors.

Routines related to vector calculus such as grad, div, rot, and Jacobi- and
Hesse matrices are availlable through the Math::Symbolic::VectorCalculus
module. This module is also able to compute Taylor Polynomials of
functions of two variables, directional derivatives, and total differentials.

Some basic support for linear algebra can be found in
Math::Symbolic::MiscAlgebra. This includes a routine to compute
the determinant of a matrix of Math::Symbolic trees.

=head2 EXPORT

None by default, but you may choose to have the following constants
exported to your namespace using the standard Exporter semantics.
There are two export tags: :all and :constants. :all will export
all constants and the parse_from_string subroutine.

  Constants for transcendetal numbers:
    EULER (2.7182...)
    PI    (3.14159...)
    
  Constants representing operator types: (First letter indicates arity)
  (These evaluate to the same numbers that are returned by the type()
   method of Math::Symbolic::Operator objects.)
    B_SUM
    B_DIFFERENCE
    B_PRODUCT
    B_DIVISION
    B_LOG
    B_EXP
    U_MINUS
    U_P_DERIVATIVE (partial derivative)
    U_T_DERIVATIVE (total derivative)
    U_SINE
    U_COSINE
    U_TANGENT
    U_COTANGENT
    U_ARCSINE
    U_ARCCOSINE
    U_ARCTANGENT
    U_ARCCOTANGENT
    U_SINE_H
    U_COSINE_H
    U_AREASINE_H
    U_AREACOSINE_H
    
  Constants representing Math::Symbolic term types:
  (These evaluate to the same numbers that are returned by the term_type()
   methods.)
    T_OPERATOR
    T_CONSTANT
    T_VARIABLE
  
  Subroutines:
    parse_from_string (returns Math::Symbolic tree)

=cut

package Math::Symbolic;

use 5.006;
use strict;
use warnings;

use Carp;

use Math::Symbolic::ExportConstants qw/:all/;
use Math::Symbolic::AuxFunctions;

use Math::Symbolic::Base;
use Math::Symbolic::Operator;
use Math::Symbolic::Variable;
use Math::Symbolic::Constant;

use Math::Symbolic::Derivative;

use Math::Symbolic::Parser;
use Math::Symbolic::Compiler;

use Math::Symbolic::Custom;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
    all => [
        @{ $Math::Symbolic::ExportConstants::EXPORT_TAGS{all} },
        qw{&parse_from_string},
    ],
    constants => [ @{ $Math::Symbolic::ExportConstants::EXPORT_TAGS{all} }, ],
);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT    = qw();

our $VERSION = '0.122';

=head1 CLASS DATA

The package variable $Parser will contain a Parse::RecDescent
object that is used to parse strings at runtime.

=cut

our $Parser;

# Defer until first call!
# = Math::Symbolic::Parser->new();

=head1 SUBROUTINES

=head2 parse_from_string

This subroutine takes a string as argument and parses it using
a Parse::RecDescent parser taken from the package variable
$Math::Symbolic::Parser. It generates a Math::Symbolic tree
from the string and returns that tree.

The string may contain any identifiers matching /[a-zA-Z][a-zA-Z0-9_]*/ which
will be parsed as variables of the corresponding name.

Please refer to L<Math::Symbolic::Parser> for more information.

=cut

sub parse_from_string {
    my $string = shift;
    croak "Missing string argument from parse_from_string() call"
      unless defined $string;
    $string = shift if $string eq __PACKAGE__ and @_;
    $string =~ s/\s+//gs;
    if ( not defined $Parser ) {
        $Parser = Math::Symbolic::Parser->new();
    }
    return $Parser->parse($string);
}

1;
__END__

=head1 EXAMPLES

This example demonstrates variable and operator creation using
object prototypes as well as partial derivatives and the various
ways of applying derivatives and simplifying terms. Furthermore, it
shows how to use the compiler for simple expressions.

  use Math::Symbolic qw/:all/;
  
  my $energy = parse_from_string(<<'HERE');
        kinetic(mass, velocity, time) +
        potential(mass, z, time)
  HERE
  
  $energy->implement(kinetic => '(1/2) * mass * velocity(time)^2');
  $energy->implement(potential => 'mass * g * z(t)');
  
  $energy->set_value(g => 9.81); # permanently
  
  print "Energy is: $energy\n";
  
  # Is how does the energy change with the height?
  my $derived = $energy->new('partial_derivative', $energy, 'z');
  $derived = $derived->apply_derivatives()->simplify();
  
  print "Changes with the heigth as: $derived\n";
  
  # With whatever values you fancy:
  print "Putting in some sample values: ",
        $energy->value(mass => 20, velocity => 10, z => 5),
        "\n";
  
  # Too slow?
  $energy->implement(g => '9.81'); # To get rid of the variable
  
  my ($sub) = Math::Symbolic::Compiler->compile($energy);
  
  print "This was much faster: ",
        $sub->(20, 10, 5),  # vars ordered alphabetically
        "\n";

=head1 OVERLOADED OPERATORS

Since version 0.102, several arithmetic operators have been overloaded.

That means you can do most arithmetic with Math::Symbolic trees just as
if they were plain Perl scalars.

The following operators are currently overloaded to produce valid
Math::Symbolic trees when applied to an expression involving at least one
Math::Symbolic object:

  +, -, *, /, **, sqrt, log, exp, sin, cos

Furthermore, some contexts have been overloaded with particular behaviour:
'""' (stringification context) has been overloaded to produce the string
representation of the object. '0+' (numerical context) has been overloaded
to produce the value of the object. 'bool' (boolean context) has been
overloaded to produce the value of the object.

=head2 EXTENDING THE MODULE

Due to several design decisions, it is probably rather difficult to extend
the Math::Symbolic related modules through subclassing. Instead, we
chose to make the module extendable through delegation.

That means you can introduce your own methods to extend Math::Symbolic's
functionality. How this works in detail can be read in
L<Math::Symbolic::Custom>.

=head1 AUTHOR

Please send feedback, bug reports, and support requests to the Math::Symbolic
support mailing list:
math-symbolic-support at lists dot sourceforge dot net. Please
consider letting us know how you use Math::Symbolic. Thank you.

If you're interested in helping with the development or extending the
module's functionality, please contact the developers' mailing list:
math-symbolic-develop at lists dot sourceforge dot net.

List of contributors:

  Steffen M�ller, symbolic-module at steffen-mueller dot net
  Stray Toaster, mwk at users dot sourceforge dot net

=head1 SEE ALSO

New versions of this module can be found on
http://steffen-mueller.net or CPAN. The module development takes place on
Sourceforge at http://sourceforge.net/projects/math-symbolic/

L<Math::Symbolic::ExportConstants>,
L<Math::Symbolic::AuxFunctions>

L<Math::Symbolic::Base>,
L<Math::Symbolic::Operator>,
L<Math::Symbolic::Constant>,
L<Math::Symbolic::Variable>

L<Math::Symbolic::Custom>,
L<Math::Symbolic::Custom::Base>,
L<Math::Symbolic::Custom::DefaultTests>,
L<Math::Symbolic::Custom::DefaultMods>
L<Math::Symbolic::Custom::DefaultDumpers>

L<Math::Symbolic::Derivative>,
L<Math::Symbolic::MiscCalculus>,
L<Math::Symbolic::VectorCalculus>,
L<Math::Symbolic::MiscAlgebra>

L<Math::Symbolic::Parser>,
L<Math::Symbolic::Compiler>

=cut
