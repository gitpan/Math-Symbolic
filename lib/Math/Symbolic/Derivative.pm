
=head1 NAME

Math::Symbolic::Derivative - Derive Math::symbolic trees

=head1 SYNOPSIS

  use Math::Symbolic::Derivative qw/:all/;
  $derived = partial_derivative($term, $variable);

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

our $VERSION = '0.108';

=head1  CLASS DATA

The package variable %Partial_Rules contains partial
derivative rules as key-value pairs of names and subroutines.

=cut

# lookup-table for partial derivative rules for various operators.
our %Partial_Rules = (
	'each operand'                      => \&_each_operand,
	'product rule'                      => \&_product_rule,
	'quotient rule'                     => \&_quotient_rule,
	'logarithmic chain rule after ln'   =>
		\&_logarithmic_chain_rule_after_ln,
	'logarithmic chain rule'            => \&_logarithmic_chain_rule,
	'partial derivative commutation'    =>
		\&_partial_derivative_commutation,
	'trigonometric derivatives'         => \&_trigonometric_derivatives,
	'inverse trigonometric derivatives' =>
		\&_inverse_trigonometric_derivatives,
);



=begin comment

The following subroutines are helper subroutines that apply a
specific rule to a tree.

=end comment

=cut

sub _each_operand {
	my ($tree, $var, $cloned) = @_;
	foreach (@{$tree->{operands}}) {
		$_ = partial_derivative($_, $var, 1);
	}
	return $tree;
}



sub _product_rule {
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



sub _quotient_rule {
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



sub _logarithmic_chain_rule_after_ln {
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



sub _logarithmic_chain_rule {
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



sub _partial_derivative_commutation {
	my ($tree, $var, $cloned) = @_;
	$tree->{operands}[0] = partial_derivative(
		$tree->{operands}[0], $var, 0
	);
	return $tree;
}



sub _trigonometric_derivatives {
	my ($tree, $var, $cloned) = @_;
	my $op = Math::Symbolic::Operator->new();
	my $d_inner = partial_derivative($tree->{operands}[0], $var, 0);
	my $trig;
	if ($tree->type() == U_SINE) {
		$trig = $op->new('cos', $tree->{operands}[0]);
	}
	elsif ($tree->type() == U_COSINE) {
		$trig = $op->new('neg', $op->new('sin', $tree->{operands}[0]));
	}
	elsif ($tree->type() == U_SINE_H) {
		$trig = $op->new('cosh', $tree->{operands}[0]);
	}
	elsif ($tree->type() == U_COSINE_H) {
		$trig = $op->new('sinh', $tree->{operands}[0]);
	}
	elsif ($tree->type() == U_TANGENT or $tree->type() == U_COTANGENT) {
		$trig = $op->new(
				'/', Math::Symbolic::Constant->one(),
				$op->new('^',
					$op->new('cos', $tree->op1()),
					Math::Symbolic::Constant->new(2)
				)
			);
		$trig = $op->new('neg', $trig) if $tree->type() == U_COTANGENT;
	}		
	else {
		die "Trigonometric derivative applied to invalid operator.";
	}
	$tree = $op->new('*', $d_inner, $trig);
	
	return $tree;
}



sub _inverse_trigonometric_derivatives {
	my ($tree, $var, $cloned) = @_;
	my $op = Math::Symbolic::Operator->new();
	my $d_inner = partial_derivative($tree->{operands}[0], $var, 0);
	my $trig;
	if ($tree->type() == U_ARCSINE || $tree->type() == U_ARCCOSINE) {
		my $one = Math::Symbolic::Constant->one();
		$trig = $op->new(
				'/', $one,
				$op->new(
					'-', $one,
					$op->new(
						'^', $tree->op1(),
						$one->new(2)
					)
				)
			);
		if ($tree->type() == U_ARCCOSINE) {
			$trig = $op->new('neg', $tree)
		}
	}
	elsif ($tree->type() == U_ARCTANGENT or
	       $tree->type() == U_ARCCOTANGENT) {
		my $one = Math::Symbolic::Constant->one();
		$trig = $op->new(
			'/', $one,
			$op->new(
				'+', $one,
				$op->new(
					'^', $tree->op1(), $one->new(2)
				)
			)
		);
		$trig = $op->new('neg', $trig)
			if $tree->type() == U_ARCCOTANGENT;
	}
	elsif ($tree->type() == U_AREASINE_H or
	       $tree->type() == U_AREACOSINE_H) {
		my $one = Math::Symbolic::Constant->one();
		$trig = $op->new(
			'/', $one,
			$op->new(
				'^',
				$op->new(
					($tree->type()==U_AREASINE_H?'+':'-'),
					$op->new(
						'^', $tree->op1(), $one->new(2)
					),
					$one
				),
				$one->new(0.5)
			)
		);
	}
	else {
		die "Inverse trig. derivative applied to invalid operator.";
	}
	$tree = $op->new('*', $d_inner, $trig);
	
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
		my $rulename = $Math::Symbolic::Operator::Op_Types[
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
		die "Cannot apply partial derivative to anything but a tree.";
	}

	return $tree;
}



=head2 total_derivative

Total derivatives are not yet implemented because there is no need
for total derivatives if there are no variables that represent
algebraic terms themselves. (Which aren't implemented either.)

=cut

sub total_derivative {
	die "Total derivatives not implemented yet. Please use partial\n" .
		"derivatives instead.\n";
}


1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut
