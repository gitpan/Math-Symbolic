=head1 NAME

Math::Symbolic::Custom::DefaultMods - Default Math::Symbolic transformations

=head1 SYNOPSIS

  use Math::Symbolic;

=head1 DESCRIPTION

This is a class of default transformations for Math::Symbolic trees. Likewise,
Math::Symbolic::Custom::DefaultTests defines default tree testing
routines.
For details on how the custom method delegation model works, please have
a look at the Math::Symbolic::Custom and Math::Symbolic::Custom::Base
classes.

=head2 EXPORT

Please see the docs for Math::Symbolic::Custom::Base for details, but
you should not try to use the standard Exporter semantics with this
class.

=head1 SUBROUTINES

=cut

package Math::Symbolic::Custom::DefaultMods;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.113';

use Math::Symbolic::Custom::Base;
BEGIN {*import = \&Math::Symbolic::Custom::Base::aggregate_import}

use Math::Symbolic::ExportConstants qw/:all/;

use Carp;

# Class Data: Special variable required by Math::Symbolic::Custom
# importing/exporting functionality.
# All subroutines that are to be exported to the Math::Symbolic::Custom
# namespace should be listed here.

our $Aggregate_Export = [qw/
	apply_derivatives
	apply_constant_fold
/];


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

	return $tree->descend(
		in_place => 0,
		before => sub {
			my $tree = shift;
			my $ttype = $tree->term_type();
			if ($ttype == T_CONSTANT || $ttype == T_VARIABLE) {
				return undef;
			}
			elsif ($ttype == T_OPERATOR) {
				my $max_derivatives = $n;
				my $type = $tree->type();
				
				while (
					$n &&
					(
						$type == U_P_DERIVATIVE or
						$type == U_T_DERIVATIVE
					)
				) {
					my $op =
					$Math::Symbolic::Operator::Op_Types[
						$type
					];

					my $operands = $tree->{operands};
					my $application = $op->{application};
					
					if (
						$type == U_T_DERIVATIVE and
						$operands->[0]->term_type() ==
						T_VARIABLE
					) {
						my @sig =
						$operands->[0]->signature();
						
						my $name =
						$operands->[1]->name();
						
						if (
							(
							grep {$_ eq $name} @sig
							) > 0 and
							not (
							@sig == 1 and
							$sig[0] eq $name
							)
						) {
							return undef;
						}
					}
					$tree->replace(
						$application->(@$operands)
					);
					return undef
						unless $tree->term_type() ==
							T_OPERATOR;

					$type = $tree->type();
					$n--;
				}
				return ();
			}
			else {
				croak "apply_derivatives called on invalid " .
					"tree type.";
			}
			
			die "Sanity check in apply_derivatives() should not " .
				"be reached.";
		},
	);
}



=head2 apply_constant_fold()

Does not modify the tree in-place by default, but returns a modified copy
of the original tree instead. If the first argument is true, the tree will
not be cloned. If it is false or not existant, the tree will be cloned.

Applied to variables and constants, this method just clones.

Applied to operators, all tree segments that contain constants and
operators only will be replaced with Constant objects.

=cut

sub apply_constant_fold {
	my $tree = shift;
	my $in_place = shift;

	return $tree->descend(
		in_place => $in_place,
		before => sub {
			my $tree = shift;
			if ($tree->is_simple_constant()) {
				$tree->replace($tree->apply())
				  unless $tree->term_type() == T_CONSTANT;
				return undef;
			}
			
			return undef if $tree->term_type() == T_VARIABLE;
			return {
				in_place => 1,
				descend_into => [],
			};
		}
	);

	return $tree;
}



1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic::Custom>
L<Math::Symbolic::Custom::DefaultTests>
L<Math::Symbolic>

=cut
