=head1 NAME

Math::Symbolic - Symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic;
  
  my $tree = Math::Symbolic->new_from_string('2*3^2');

=head1 DESCRIPTION

Math::Symbolic is intended to offer symbolic calculation capabilities
to the Perl programmer without using external (and commercial) libraries
and/or applications.

Unless, however, some interested and knowledgable developers turn up to
participate in the development, the library will be severely limited by
my experience in the area. Symbolic calculations are an active field of
research in CS.

=head2 EXPORT

None by default, but you may choose to have the following constants
exported to your namespace using the standard Exporter semantics.
There are two export tags: :all and :constants. :all will export
all constants and the parse_from_string subroutine.

  Constants for transcendetal numbers:
    EULER (2.7182...)
    PI    (3.14159...)
    
  Constants representing operator types: (First letter indicates arity)
    B_SUM
    B_DIFFERENCE
    B_PRODUCT
    B_DIVISION
    B_LOG
    B_EXP
    U_MINUS
    U_P_DERIVATIVE
    U_T_DERIVATIVE
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

use Math::Symbolic::Base;
use Math::Symbolic::Operator;
use Math::Symbolic::Variable;
use Math::Symbolic::Constant;

use Math::Symbolic::Derivative;

use Math::Symbolic::Parser;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
	all => [
		@{$Math::Symbolic::ExportConstants::EXPORT_TAGS{all}},
		qw{&parse_from_string},
	],
	constants => [
		@{$Math::Symbolic::ExportConstants::EXPORT_TAGS{all}},
	],
);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = '0.101';

=head1 CLASS DATA

The package variable $Parser will contain a Parse::RecDescent
object that is used to parse strings at runtime.

=cut

our $Parser = Math::Symbolic::Parser->new();


=head1 SUBROUTINES

=head2 parse_from_string

This subroutine takes a string as argument and parses it using
a Parse::RecDescent parser. It generates a Math::Symbolic tree
from the string and returns that string.

The parser object used can be found in the $Parser package variable.

=cut

sub parse_from_string {
	my $string = shift;
	die "Missing string argument from parse_from_string() call"
		unless defined $string;
	$string = shift if $string eq __PACKAGE__ and @_;
	$string =~ s/\s+//gs;
	return $Parser->parse($string);
}


1;
__END__

=head1 EXAMPLES

This example demonstrates variable and operator creation using
object prototypes as well as partial derivatives and the various
ways of applying derivatives and simplifying terms.

  use Math::Symbolic qw/:all/;
  
  my $var = Math::Symbolic::Variable->new();
  my $a = $var->new('a' => 2);
  my $b = $var->new('b' => 3);
  my $c = $var->new('c' => 4);
  
  print "Vars: a=" . $a->value() .
             " b=" . $b->value() .
             " c=" . $c->value() .
             " (Values are optional)\n\n";
  
  my $op    = Math::Symbolic::Operator->new();
  my $add1  = $op->new('+', $a, $c);
  my $mult1 = $op->new('*', $a, $b);
  my $div1  = $op->new('/', $add1, $mult1);
  
  print "Expression: (a+c)/(a*b)\n\n";
  
  print "prefix notation and evaluation:\n";
  print $div1->to_string('prefix') . " = " . $div1->value() . "\n\n";
  
  print "Now, we derive this partially to a: (prefix again)\n";
  
  my $n_tree = $op->new( {
    type => U_P_DERIVATIVE,
    operands => [$div1, $a],
  } );
  print $n_tree->to_string('prefix') . " = " . $n_tree->value() . "\n\n";
  	
  print "Now, we apply the derivative to the term: (infix)\n";
  my $derived = $n_tree->apply_derivatives();
  print "$derived = " . $derived->value() . "\n\n";
  
  print "Finally, we simplify the derived term as much as possible:\n";
  my $simplified = $derived->simplify();
  print "$simplified = " . $derived->value() . "\n\n";

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

=head1 SEE ALSO

L<Math::Symbolic::ExportConstants>
L<Math::Symbolic::AuxFunctions>

L<Math::Symbolic::Base>
L<Math::Symbolic::Operator>
L<Math::Symbolic::Constant>
L<Math::Symbolic::Variable>

L<Math::Symbolic::Derivative>

L<Math::Symbolic::Parser>

=cut
