=head1 NAME

Math::Symbolic::Custom::Default - Default tree tests and transformations

=head1 SYNOPSIS

  use Math::Symbolic;

=head1 DESCRIPTION

This is a class of default tests and transformations for Math::Symbolic trees.
For details on how the custom method delegation model works, please have
a look at the Math::Symbolic::Custom and Math::Symbolic::Custom::Base
classes.

=head2 EXPORT

Please see the docs for Math::Symbolic::Custom::Base for details, but
you should not try to use the standard Exporter semantics with this
class.

=head1 SUBROUTINES

=cut

package Math::Symbolic::Custom::Default;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.111';

use Math::Symbolic::Custom::Base;
BEGIN {*import = \&Math::Symbolic::Custom::Base::aggregate_import}

use Math::Symbolic::ExportConstants qw/:all/;

use Carp;

# Class Data: Special variable required by Math::Symbolic::Custom
# importing/exporting functionality.
# All subroutines that are to be exported to the Math::Symbolic::Custom
# namespace should be listed here.

our $Aggregate_Export = [qw/
	is_sum
	is_constant
	is_integer
	apply_derivatives
/];


=head2 is_integer()

is_integer() returns a boolean.

It returns true (1) if the tree is a constant object representing an
integer value. It does I<not> compute the value of the tree.
(eg. '5*10' is I<not> considered an integer, but '50' is.)

It returns false (0) otherwise.

=cut

sub is_integer {
	my $tree = shift;
	return 0 unless $tree->term_type() == T_CONSTANT;
	my $value = $tree->value();
	return (
		int($value) == $value
	);
}



=head2 is_constant()

is_constant() returns a boolean.

It returns true (1) if the tree consists of only constants and operators or
if it becomes a tree of only constants and operators after application
of derivatives.

It returns false (0) otherwise.

=cut

sub is_constant {
	my $tree = shift;

	my $ttype = $tree->term_type();
	if ($ttype == T_CONSTANT) {
		return 1;
	}
	elsif ($ttype == T_VARIABLE) {
		return 0;
	}
	elsif ($ttype == T_OPERATOR) {
		$tree = $tree->apply_derivatives();
		$ttype = $tree->term_type();
		return 1 if $ttype == T_CONSTANT;
		return 0 if $ttype == T_VARIABLE;
		
		my $type = $tree->type();
		my $arity = $Math::Symbolic::Operator::Op_Types[$type]{arity};
		foreach (1..$arity) {
			return 0 unless is_constant($tree->{operands}[$_-1]);
		}
		return 1;
	}
	else {
		croak "is_constant called on invalid tree type.";
	}
}



=head2 is_sum()

(beta)

is_constant() returns a boolean.

It returns true (1) if the tree contains no variables (because it can then
be evaluated to a single constant which is a sum). It also returns true if
it is a sum or difference of constants and variables. Furthermore, it is
true for products of integers and constants because those products are really
sums of variables.
If none of the above cases match, it applies all derivatives and tries again.

It returns false (0) otherwise.

Please contact the author in case you encounter bugs in the specs or
implementation. The heuristics aren't all that great.

=cut

sub is_sum {
	my $tree = shift;
	my $ttype = $tree->term_type();
	if ($ttype == T_CONSTANT or $ttype == T_VARIABLE) {
		return 1;
	}
	elsif ($ttype == T_OPERATOR) {
		my $type = $tree->type();
		if ($type == B_SUM or $type == B_DIFFERENCE) {
			return(
				is_sum($tree->{operands}[0]) ||
				is_sum($tree->{operands}[1])
			);
		}
		elsif ($type == B_PRODUCT) {
			return(
				$tree->{operands}[0]->is_integer() or
				$tree->{operands}[1]->is_integer()
			);
		}
		elsif ($type == U_MINUS) {
			return is_sum($tree->{operands}[0]);
		}
		elsif ($type == U_P_DERIVATIVE or $type == U_T_DERIVATIVE) {
			my $tree = $tree->apply_derivatives();
			my $ttype = $tree->term_type();
			if ($ttype == T_CONSTANT or $ttype == T_VARIABLE) {
				return 1;
			}
			elsif ($ttype == T_OPERATOR) {
				my $type = $tree->type();
				if (
					($type == U_P_DERIVATIVE ||
					$type == U_T_DERIVATIVE)
				) {
					return 0;
				}
				else {
					return is_sum($tree);
				}
			}
			else {
				die "apply_derivatives screwed the pooch " .
					"in is_sum().";
			}
		}
		elsif (is_constant($tree)) {
			return 1;
		}
		else {
			return 0;
		}
	}
	else {
		croak "is_sum called on invalid tree type.";
	}
}



=head2 apply_derivatives()

Never modifies the tree in-place, but returns a modified copy of the
original tree instead.

Applied to variables and constants, this method just clones.

Applied to operators and if the operator is a derivative, this applies
the derivative to the derivative's first operand.

Regardless what kind of operator this is called on, apply_derivatives
will be applied recursively on its operands.

If the first parameter to this function is an integer, at maximum that
number of derivatives are applied (from top down the tree if possible).

=cut

sub apply_derivatives {
	my $tree = shift;
	my $n = shift || -1;

	my $ttype = $tree->term_type();

	if ($ttype == T_CONSTANT || $ttype == T_VARIABLE) {
		return $tree->new();
	}
	elsif ($ttype == T_OPERATOR) {
		my $max_derivatives = $n;
		$tree = $tree->new();
		my $type = $tree->type();

		while (
			$n &&
			(
				$type == U_P_DERIVATIVE or
				$type == U_T_DERIVATIVE
			)
		) {
			my $op = $Math::Symbolic::Operator::Op_Types[$type];
			my $operands = $tree->{operands};
			my $application = $op->{application};
			
			if (
				$type == U_T_DERIVATIVE and
				$operands->[0]->term_type() == T_VARIABLE
			) {
				my @sig = $operands->[0]->signature();
				my $name = $operands->[1]->name();
				if ((grep {$_ eq $name} @sig) > 0) {
					return $tree;
				}
			}
			$tree = $application->(@$operands);
			return $tree unless $tree->term_type() == T_OPERATOR;
			$type = $tree->type();
			$n--;
		}

		@{$tree->{operands}} =
			map {$_->apply_derivatives($max_derivatives)}
			@{$tree->{operands}};

		return $tree;
	}
	else {
		croak "apply_derivatives called on invalid tree type.";
	}
	die "Sanity check in apply_derivatives() should not be reached.";
}

	
1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic::Custom>
L<Math::Symbolic>

=cut
