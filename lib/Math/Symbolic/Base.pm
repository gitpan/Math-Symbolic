=head1 NAME

Math::Symbolic::Base - Base class for symbols in symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic::Base;

=head1 DESCRIPTION

This is a base class for all Math::Symbolic::* terms such as
Math::Symbolic::Operator, Math::Symbolic::Variable and
Math::Symbolic::Constant objects.

=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Base;

use 5.006;
use strict;
use warnings;

use Carp;

use overload
	"+"    => \&_overload_addition,
	"-"    => \&_overload_subtraction,
	"*"    => \&_overload_multiplication,
	"/"    => \&_overload_division,
	"**"   => \&_overload_exponentiation,
	"sqrt" => \&_overload_sqrt,
	"log"  => \&_overload_log,
	"exp"  => \&_overload_exp,
	"sin"  => \&_overload_sin,
	"cos"  => \&_overload_cos,
	'""'   => sub{ $_[0]->to_string() },
	"0+"   => sub { $_[0]->value() },
	"bool" => sub { $_[0]->value() };

use Math::Symbolic::ExportConstants qw/:all/;

our $VERSION = '0.112';
our $AUTOLOAD;

=head1 METHODS

=cut



=head2 Method to_string

Default method for stringification just returns the object's value.

=cut

sub to_string {
	my $self = shift;
	return $self->value();
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
	croak "This is a method stub from Math::Symbolic::Base. Implement me.";
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
	croak "This is a method stub from Math::Symbolic::Base. Implement me.";
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
	return sort @$sig;
}



=head2 Method set_signature

set_signature expects any number of variable identifiers as arguments.
It sets a variable's signature to this list of identifiers.

=cut

sub set_signature {
	croak
	"Cannot set signature of non-Variable Math::Symbolic tree element.";
}



=head2 Method implement

Takes key/value pairs as arguments. The keys are to be variable names
and the values must be valid Math::Symbolic trees. All occurrances
of the variables will be replaced with their implementation.

=cut

sub implement {
	croak "implement() called on unsupported tree element.";
}

=head2 Method simplify

Minimum method for term simpilification just clones.

=cut

sub simplify {
	my $self = shift;
	return $self->new();
}



=head2 Method term_type

Returns the type of the term. This is a stub to be overridden.

=cut

sub term_type {
	croak "term_type not defined for " . __PACKAGE__;
}


=begin comment

Since version 0.102, there are several overloaded operators. The overloaded
interface is documented below. For more info, please have a look at the
Math::Symbolic man page.

=end comment

=cut

sub _overload_make_object {
	my $operand = shift;
	unless (ref($operand) =~ /^Math::Symbolic/) {
		if ($operand =~ /\D/) {
			$operand = Math::Symbolic::parse_from_string($operand);
		}
		else {
			$operand = Math::Symbolic::Constant->new($operand);
		}
	}
	return $operand;
}


sub _overload_addition {
	my ($obj, $operand, $reverse) = @_;
	$operand = _overload_make_object($operand);
	($obj, $operand) = ($operand, $obj) if $reverse;
	my $n_obj = Math::Symbolic::Operator->new('+', $obj, $operand);
	return $n_obj;
}


sub _overload_subtraction {
	my ($obj, $operand, $reverse) = @_;
	$operand = _overload_make_object($operand);
	($obj, $operand) = ($operand, $obj) if $reverse;
	my $n_obj = Math::Symbolic::Operator->new('-', $obj, $operand);
	return $n_obj;
}


sub _overload_multiplication {
	my ($obj, $operand, $reverse) = @_;
	$operand = _overload_make_object($operand);
	($obj, $operand) = ($operand, $obj) if $reverse;
	my $n_obj = Math::Symbolic::Operator->new('*', $obj, $operand);
	return $n_obj;
}


sub _overload_division {
	my ($obj, $operand, $reverse) = @_;
	$operand = _overload_make_object($operand);
	($obj, $operand) = ($operand, $obj) if $reverse;
	my $n_obj = Math::Symbolic::Operator->new('/', $obj, $operand);
	return $n_obj;
}


sub _overload_exponentiation {
	my ($obj, $operand, $reverse) = @_;
	$operand = _overload_make_object($operand);
	($obj, $operand) = ($operand, $obj) if $reverse;
	my $n_obj = Math::Symbolic::Operator->new('^', $obj, $operand);
	return $n_obj;
}


sub _overload_sqrt {
	my ($obj, undef, $reverse) = @_;
	my $n_obj = Math::Symbolic::Operator->new(
		'^', $obj, Math::Symbolic::Constant->new(0.5),
	);
	return $n_obj;
}


sub _overload_exp {
	my ($obj, undef, $reverse) = @_;
	my $n_obj = Math::Symbolic::Operator->new(
		'^', Math::Symbolic::Constant->euler(), $obj,
	);
	return $n_obj;
}


sub _overload_log {
	my ($obj, undef, $reverse) = @_;
	my $n_obj = Math::Symbolic::Operator->new(
		'log', Math::Symbolic::Constant->euler(), $obj,
	);
	return $n_obj;
}


sub _overload_sin {
	my ($obj, undef, $reverse) = @_;
	my $n_obj = Math::Symbolic::Operator->new('sin', $obj);
	return $n_obj;
}


sub _overload_cos {
	my ($obj, undef, $reverse) = @_;
	my $n_obj = Math::Symbolic::Operator->new('cos', $obj);
	return $n_obj;
}


=begin comment

The following AUTOLOAD mechanism delegates all method calls that aren't found
in the normal Math::Symbolic inheritance tree and that start with
'is_', 'test_', 'apply_', or 'mod_' to the Math::Symbolic::Custom class.

The 'is_' and 'test_' "namespaces" are intended for methods that test a
tree on whether or not it has certain characteristics that define a group.
Eg.: 'is_polynomial'

The 'apply_' and 'mod_' prefixes are intended for modifications to the tree
itself. Eg.: 'apply_derivatives'

=end comment

=cut


sub AUTOLOAD {
	my $call = $AUTOLOAD;
	$call =~ s/.*\:\:(\w+)$/$1/;
	study $call;
	if (
		$call =~ /^(apply_\w+)/ or
		$call =~ /^(mod_\w+)/ or
		$call =~ /^(is_\w+)/ or
		$call =~ /^(test_\w+)/
	) {
		my $method = $1;
		my $ref = Math::Symbolic::Custom->can($method);
		if (defined $ref) {
			goto &$ref;
		}
		else {
			croak "Invalid method called on Math::Symbolic " .
				"tree: '$call'.";
		}
	}
	else {
		croak "Invalid method called on Math::Symbolic tree: '$call'.";
	}
}

# to make AUTOLOAD happy:

sub DESTROY {}

1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut
