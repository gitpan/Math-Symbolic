
=head1 NAME

Math::Symbolic::Derivative - Derive Math::symbolic trees

=head1 SYNOPSIS

  use Math::Symbolic::Derivative qw/:all/;

=head1 DESCRIPTION

Derivatives for Math::Symbolic.

=head2 EXPORT

None by default. But you may choose to import the total_derivative()
and partial_derivative() functions.

=cut

package Math::Symbolic::Derivative;

use 5.006;
use strict;
use warnings;

use Math::Symbolic::ExportConstants qw/:all/;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	&total_derivative
	&partial_derivative
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '0.06';

# Class data

# lookup-table for partial derivative rules for various operators.
our %Partial_Rules = (
	'each operand'  => \&each_operand,
	'product rule'  => \&product_rule,
	'quotient rule' => \&quotient_rule,
	'logarithmic chain rule after ln' =>
		\&logarithmic_chain_rule_after_ln,
	'logarithmic chain rule' => \&logarithmic_chain_rule,
	'partial derivative commutation' => \&partial_derivative_commutation,
);



=begin comment

The following subroutines are helper subroutines that apply a
specific rule to a tree.

=cut

sub each_operand {
	my ($tree, $var, $cloned) = @_;
	foreach (@{$tree->{operands}}) {
		$_ = partial_derivative($_, $var, 1);
	}
	return $tree;
}



sub product_rule {
	my ($tree, $var, $cloned) = @_;

	my $ops = $tree->{operands};
	my $do1 = partial_derivative($ops->[0], $var, 0);
	my $do2 = partial_derivative($ops->[1], $var, 0);
	my $m1  = Math::Symbolic::Operator->new(
		'*', $ops->[0], $do2,
	);
	my $m2  = Math::Symbolic::Operator->new(
		'*', $ops->[1], $do1,
	);
	$tree = Math::Symbolic::Operator->new(
		'+', $m1, $m2,
	);
	return $tree;
}



sub quotient_rule {
	my ($tree, $var, $cloned) = @_;
	my $ops = $tree->{operands};
	my $do1 = partial_derivative($ops->[0], $var, 0);
	my $do2 = partial_derivative($ops->[1], $var, 0);
	my $m1  = Math::Symbolic::Operator->new(
		'*', $do1, $ops->[1],
	);
	my $m2  = Math::Symbolic::Operator->new(
		'*', $ops->[0], $do2,
	);
	my $m3  = Math::Symbolic::Operator->new(
		'*', $ops->[1], $ops->[1],
	);
	my $a   = Math::Symbolic::Operator->new(
		'+', $m1, $m2,
	);
	$tree = Math::Symbolic::Operator->new(
		'/', $a, $m3,
	);
	return $tree;
}



sub logarithmic_chain_rule_after_ln {
	my ($tree, $var, $cloned) = @_;
	# y(x)=u^v
	# y'(x)=y*(d/dx ln(y))
	# y'(x)=y*(d/dx (v*ln(u)))
	my $ops = $tree->{operands};
	my $e   = Math::Symbolic::Constant->euler();
	my $ln  = Math::Symbolic::Operator->new(
		'log', $e, $ops->[0],
	);
	my $mul1 = $ln->new(
		'*', $ops->[1], $ln,
	);
	my $dmul = partial_derivative($mul1, $var, 0);
	$tree = $ln->new(
		'*', $tree, $dmul,
	);
	return $tree;
}



sub logarithmic_chain_rule {
	my ($tree, $var, $cloned) = @_;
	#log_a(y(x))=>y'(x)/(ln(a)*y(x))
	my $ops = $tree->{operands};
	my $do2 = partial_derivative($ops->[1], $var, 0);
	my $e   = Math::Symbolic::Constant->euler();
	my $ln  = Math::Symbolic::Operator->new(
		'log', $e, $ops->[0],
	);
	my $mul1 = $ln->new(
		'*', $ln, $ops->[1],
	);
	$tree = $ln->new(
		'/', $do2, $mul1,
	);
	return $tree;
}



sub partial_derivative_commutation {
	my ($tree, $var, $cloned) = @_;
	$tree->{operands}[0] = partial_derivative(
		$tree->{operands}[0], $var, 0
	);
	return $tree;
}



=head1 SUBROUTINES

=cut

=head2 partial_derivative

Takes a Math::Symbolic tree and a Math::Symbolic::Variable as argument.
third argument is an optional boolean indicating whether or not the
tree has to be cloned before being derived. If it is true, the
subroutine happily stomps on any code that might rely on any components
of the Math::Symbolic tree that was passed to the sub as first argument.

=cut

sub partial_derivative {
	my $tree   = shift;
	my $var    = shift;
	defined $var or die "Cannot derive using undefined variable.";
	my $cloned = shift;
	
	if (not $cloned) {
		$tree = $tree->new();
		$cloned = 1;
	}
	
	if ($tree->term_type() == T_OPERATOR) {
		my $rulename = $Math::Symbolic::Operator::OP_TYPES[
					$tree->type()
				]->{derive};
		my $subref = $Partial_Rules{$rulename};

		die "Cannot derive using rule '$rulename'."
		   unless defined $subref;
		$tree = $subref->($tree, $var, $cloned);
		
	}
	elsif ($tree->term_type() == T_CONSTANT) {
		$tree = Math::Symbolic::Constant->zero();
	}
	elsif ($tree->term_type() == T_VARIABLE) {
		if ($tree->name() eq $var->name()) {
			$tree = Math::Symbolic::Constant->one;
		}
		else {
			$tree = Math::Symbolic::Constant->zero;
		}
	}
	else {
		die "Not a tree.";
	}

	return $tree;
}



=head2

=cut




sub total_derivative {
	die "Total derivatives not implemented yet. Please use partial\n" .
		"derivatives instead.\n";
}

1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

=head1 SEE ALSO

L<perl>.
L<Math::Symbolic>

=cut
