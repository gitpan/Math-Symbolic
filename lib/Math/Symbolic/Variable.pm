
=head1 NAME

Math::Symbolic::Variable - Variable in symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic::Variable;

  my $var1 = Math::Symbolic::Variable->new('name');
  $var1->value(5);
  
  my $var2 = Math::Symbolic::Variable->new('x', 2);

  my $var3 = Math::Symbolic::Variable->new(
     {
       name  => 'variable',
       value => 1,
     }
  );

=head1 DESCRIPTION

This class implements variables for Math::Symbolic trees.
The objects are overloaded in stringification context to
return their names.

=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Variable;

use 5.006;
use strict;
use warnings;

use Math::Symbolic::ExportConstants qw/:all/;

use base 'Math::Symbolic::Base';

our $VERSION = '0.109';

=head1 METHODS

=head2 Constructor new

First argument is expected to be a hash reference of key-value
pairs which will be used as object attributes.

In particular, a variable is required to have a 'name'. Optional
arguments include a 'value', and a 'signature'. The value expected
for the signature key is a reference to an array of identifiers.

Special case: First argument is not a hash reference. In this
case, first argument is treated as variable name, second as value.
This special case disallows cloning of objects (when used as
object method).

Returns a Math::Symbolic::Variable.

=cut

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	if (@_ and not ref($_[0]) eq 'HASH') {
		my $name = shift;
		my $value = shift;
		return bless {name=>$name, value=>$value, signature=>[@_]}
			=> $class;
	}
	
	my %args;
	%args = %{+shift} if @_ and defined $_[0] and ref($_[0]) eq 'HASH';

	my $self = {
		value => undef,
		name => undef,
		signature => [],
		(ref($proto)?%$proto:()),
		%args,
	};

	bless $self => $class;
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
		return $self->{value};
	}
	elsif (@_==0) {
		return $self->{value};
	}
	else {
		my %args = @_;
		if (exists $args{$self->{name}}) {
			return $args{$self->{name}};
		}
		else {
			return $self->{value};
		}
	}
}



=head2 Method set_value

set_value() returns nothing.

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
	my %args = @_;
	if (exists $args{$self->{name}}) {
		$self->{value} = $args{$self->{name}};
	}
}



=head2 Method name

Optional argument: sets the object's name.
Returns the object's name.

=cut

sub name {
	my $self = shift;
	if (@_) {
		$self->{name} = shift;
	}
	return $self->{name};
}



=head2 Method signature

signature() returns a tree's signature.

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

sub signature {
	my $self = shift;
	my $sig = $self->{signature} || [];
	push @$sig, $self->{name};
	return sort keys %{{map {($_, undef)} @$sig}};
}



=head2 Method set_signature

set_signature expects any number of variable identifiers as arguments.
It sets a variable's signature to this list of identifiers.

=cut

sub set_signature {
	my $self = shift;
	@{$self->{signature}} = @_;
	return();
}


=head2 Method to_string

Returns a string representation of the variable.

=cut

sub to_string {
	my $self = shift;

	return $self->name();
}



=head2 Method term_type

Returns the type of the term. (T_VARIABLE)

=cut

sub term_type {
	return T_VARIABLE;
}



1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut
