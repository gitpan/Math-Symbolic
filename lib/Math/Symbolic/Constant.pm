=head1 NAME

Math::Symbolic::Constant - Constants in symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic::Constant;
  my $const = Math::Symbolic::Constant->new(25);
  my $zero  = Math::Symbolic::Constant->zero();
  my $one   = Math::Symbolic::Constant->one();
  my $euler = Math::Symbolic::Constant->euler();
  # e = 2.718281828...

=head1 DESCRIPTION

This module implements numeric constants for Math::Symbolic trees.

=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Constant;

use 5.006;
use strict;
use warnings;

use Math::Symbolic::ExportConstants qw/:all/;

use base 'Math::Symbolic::Base';

our $VERSION = '0.110';

=head1 METHODS

=cut

=head2 Constructor new

Takes hash reference of key-value pairs as argument.
Special case: a value for the constant instead of the hash.
Returns a Math::Symbolic::Constant.

=cut

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	my %args;
	%args = %{+shift} if @_ && ref($_[0]) eq 'HASH';

	my $value = (@_ && !%args ? shift : $args{value});
	$value = $proto->value() if !defined($value) and ref($proto);

	my $self = {
		special => '',
		(ref($proto)?%$proto:()),
		value => $value,
		%args,
	};

	bless $self => $class;
}



=head2 Constructor zero

Arguments are treated as key-value pairs of object attributes.
Returns a Math::Symbolic::Constant with value of 0.

=cut

sub zero {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return $class->new({@_, value => 0, special => 'zero'})
}



=head2 Constructor one

Arguments are treated as key-value pairs of object attributes.
Returns a Math::Symbolic::Constant with value of 1.

=cut

sub one {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return $class->new({@_, value => 1})
}



=head2 Constructor euler

Arguments are treated as key-value pairs of object attributes.
Returns a Math::Symbolic::Constant with value of e, the Euler number.
The object has its 'special' attribute set to 'euler'.

=cut

sub euler {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return $class->new({@_, value => EULER, special => 'euler'})
}



=head2 Method value

value() evaluates the Math::Symbolic tree to its numeric representation.

value() without arguments requires that every variable in the tree contains
a defined value attribute. Please note that this refers to every variable
I<object>, not just every named variable.

value() with one argument sets the object's value.

value() with named arguments (key/value pairs) associates variables in the tree
with the value-arguments if the corresponging key matches the variable name.
(Can one say this any more complicated?)

Example: $tree->value(x => 1, y => 2, z => 3, t => 0) assigns the value 1 to
any occurrances of variables of the name "x", aso.

=cut

sub value {
	my $self = shift;
	if (@_==1) {
		$self->{value} = shift;
	}
	return $self->{value};
}



=head2 Method set_value

set_value() returns nothing and for constants, and sets the constant's value
to its first argument.

Generally, set_value() works like this:

set_value() requires named arguments (key/value pairs) that associate
variable names of variables in the tree with the value-arguments if the
corresponging key matches the variable name.
(Can one say this any more complicated?)

Example: $tree->set_value(x => 1, y => 2, z => 3, t => 0) assigns the value 1
to any occurrances of variables of the name "x", aso.

As opposed to value(), set_value() assigns to the variables I<permanently>
and does not evaluate the tree.

=cut

sub set_value {
	my $self = shift;
	my $value = shift;
	$self->{value} = $value if defined $value;
}



=head2 Method signature

signature() returns a tree's signature. (Which is the empty list in case
of constants.)

In the context of Math::Symbolic, signatures are the list of variables
any given tree depends on. That means the tree "v*t+x" depends on the
variables v, t, and x. Thus, applying signature() on the tree that would
be parsed from above example yields the sorted list ('t', 'v', 'x').

Constants do not depend on any variables and therefore return the empty list.
Obviously, operators' dependencies vary.

Math::Symbolic::Variable objects, however, may have a slightly more
involved signature. By convention, Math::Symbolic variables depend on
themselves. That means their signature contains their own name. But they
can also depend on various other variables because variables themselves
can be viewed as placeholders for more compicated terms. For example
in mechanics, the acceleration of a particle depends on its mass and
the sum of all forces acting on it. So the variable 'acceleration' would
have the signature ('acceleration', 'force1', 'force2',..., 'mass', 'time').

=cut

sub signature {return ();}



=head2 Method implement

A nop for Math::Symbolic::Constant objects.

Takes key/value pairs as arguments. The keys are to be variable names
and the values must be valid Math::Symbolic trees. All occurrances
of the variables will be replaced with their implementation.

=cut

sub implement {
	return();
}



=head2 Method special

Optional argument: sets the object's special attribute.
Returns the object's special attribute.

=cut

sub special {
	my $self = shift;
	if (@_) {
		$self->{special} = shift;
	}
	return $self->{special};
}



=head2 Method to_string

Returns a string representation of the constant.

=cut

sub to_string {
	my $self = shift;

	return $self->value();
}



=head2 Method term_type

Returns the type of the term. (T_CONSTANT)

=cut

sub term_type {
	return T_CONSTANT;
}



1;
__END__


=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut
