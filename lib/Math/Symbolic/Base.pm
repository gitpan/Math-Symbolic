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

our $VERSION = '0.103';

=head1 METHODS

=cut



=head2 Method to_string

Default method for stringification just returns the object's value.

=cut

sub to_string {
	my $self = shift;
	return $self->value();
}



=head2 Method simplify

Minimum method for term simpilification just clones.

=cut

sub simplify {
	my $self = shift;
	return $self->new();
}



=head2 Method apply_derivatives

Minimum method for application of derivatives just clones.

=cut

sub apply_derivatives {
	my $self = shift;
	return $self->new();
}



=head2 Method term_type

Returns the type of the term. This is a stub to be overridden.

=cut

sub term_type {
	die "term_type not defined for " . __PACKAGE__;
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


1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut
