package Math::Symbolic;

use 5.006;
use strict;
use warnings;

use Math::Symbolic::ExportConstants qw/:all/;

use Math::Symbolic::Base;
use Math::Symbolic::Operator;
use Math::Symbolic::Variable;
use Math::Symbolic::Constant;
use Math::Symbolic::Derivative;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = %Math::Symbolic::ExportConstants::EXPORT_TAGS;
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

our $VERSION = '0.06';



1;
__END__

=head1 NAME

Math::Symbolic - Symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic;

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
exported to your namespace using the standard Exporter semantics
(including the :all tag).

  Constants representing operator types: (First letter indicates arity)
    B_SUM
    B_DIFFERENCE
    B_PRODUCT
    B_DIVISION
    U_MINUS
    U_P_DERIVATIVE
    U_T_DERIVATIVE
  
  Constants representing Math::Symbolic term types:
    T_OPERATOR
    T_CONSTANT
    T_VARIABLE

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

L<perl>.
L<Math::Symbolic::Base>
L<Math::Symbolic::Operator>
L<Math::Symbolic::Derivative>
L<Math::Symbolic::Constant>
L<Math::Symbolic::Variable>


=cut
