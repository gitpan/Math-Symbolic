=head1 NAME

Math::Symbolic::Parser - Parse strings into Math::Symbolic trees

=head1 SYNOPSIS

  use Math::Symbolic::Parser;
  my $parser = Math::Symbolic::Parser->new();
  my $tree   = $parser->parse($string);

=head1 DESCRIPTION

This module contains the parsing routines used by Math::Symbolic to
parse strings into Math::Symbolic trees. Usually, you will want
to simply use the Math::Symbolic::parse_from_string subroutine
instead of this module directly. If you do, however, make sure to
remove any whitespace from your input string.

=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Parser;

use 5.006;
use strict;
use warnings;

use Parse::RecDescent;

use Math::Symbolic::ExportConstants qw/:all/;

our $VERSION = '0.08';

our $Grammar = <<'GRAMMAR_END';
	parse: expr
	     | <error>

	expr: addition { $item[1] }

	addition: <leftop:multiplication add_op multiplication>
			{
				Math::Symbolic::Parser::_leftop_list(
					'addition', @item
				)
			}

	add_op: '+'
	      | '-'

	multiplication: <leftop:exp mult_op exp>
			{
				Math::Symbolic::Parser::_leftop_list(
					'multiplication', @item
				)
			}
  
	mult_op: '*'
	       | '/'


	exp: <leftop:factor exp_op factor>
			{
				Math::Symbolic::Parser::_leftop_list(
					'exp', @item
				)
			}

	exp_op: '^'

	factor: unary		{ $item[1] }
		| '(' expr ')'	{ $item[2] }

	unary: unary_op number
		{
			if ($item[1] and $item[1] eq '-') {
				Math::Symbolic::Operator->new({
					type => Math::Symbolic::U_MINUS,
					operands => [$item[2]],
				});
			}
			else {
				$item[2]
			}
		}
	     | unary_op function
		{
			if ($item[1] and $item[1] eq '-') {
				Math::Symbolic::Operator->new({
					type => Math::Symbolic::U_MINUS,
					operands => [$item[2]],
				});
			}
			else {
				$item[2]
			}
		}
		
	unary_op: /([+-]?)/
		{
			$item[1]
		}
		
	number: /\d+(\.\d+)?/
		{
			Math::Symbolic::Constant->new($item[1])
		}

	function: function_name '(' expr_list ')'
			{
				my $function =
				$Math::Symbolic::Operator::OP_B_SYMBOLS{
					$item[1]
				};
				die "Invalid function '$item[1]'!"
					unless defined $function;
					
				Math::Symbolic::Operator->new({
					type => $function,
					operands => $item[3],
				});
			}

	function_name: 'log' | 'partial_derivative'


	expr_list: <leftop:expr list_op expr>
			{
				my $i = 1;
				[
					grep {
						$i==1 ?
						(--$i,1):
						(++$i,0)
					}
					@{$item[1]}
				]
			}

	list_op: ','
GRAMMAR_END


=begin comment

This subroutine (_leftop_list) is used by the parser to generate
Math::Symbolic trees.

=cut

sub _leftop_list {
	my $type = shift;
	my $item = $_[1];
	
	my @ops;
	if (@$item==1) {
		return $item->[0];
	}
	elsif ($type eq 'exp') {
		@ops =(['^', shift @$item]);
	}
	elsif ($type eq 'multiplication') {
		@ops = (['*', shift @$item]);
	}
	elsif ($type eq 'addition') {
		@ops = (['+', shift @$item]);
	}
	else {
		die "Invalid operator!";
	}
	
	while (@$item >= 2) {
		push @ops, [shift @$item, shift @$item];
	}
	my %mapper = (
		'*' => 0,
		'/' => 1,
		'+' => 2,
		'-' => 3,
		'^' => 4
	);
	@ops = sort { $mapper{$a->[0]} <=> $mapper{$b->[0]} } @ops;
	my $tree;
	
	if ($type eq 'exp') {
		$tree = $ops[0][1];
		shift @ops;
	}
	elsif ($type eq 'multiplication' or $type eq 'addition') {
		$tree = $ops[0][1];
		shift @ops;
	}

	
	foreach my $elem (@ops) {
		my $op = $elem->[0];
		my $op_type = $Math::Symbolic::Operator::OP_B_SYMBOLS{
			$op
		};
		die "Invalid operator: '$op'"
			unless defined $op_type;
	
		$tree = Math::Symbolic::Operator->new({
			type     => $op_type,
			operands => [$tree, $elem->[1]],
		});
	}
	return $tree;
}

=head2 Constructor new

This constructor does not expect any arguments and returns a Parse::RecDescent
parser to parse algebraic expressions from a string into Math::Symbolic
trees.

=cut

sub new {
	my $parser = new Parse::RecDescent($Grammar);
	return $parser;
}

1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

=head1 SEE ALSO

L<Math::Symbolic>

=cut
