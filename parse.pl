#!/usr/bin/perl
use strict;
use warnings;

use Parse::RecDescent;

my $grammar = <<'HERE';

	main: expr
	    | <error>

	expr: addition

	addition: <leftop:multiplication add_op multiplication>
			{
				@{$item[1]}==1?
				$item[1][0]:
				+{ binary => $item[0],
				operands => $item[1] }
			}

	add_op: '+'
	      | '-'

	multiplication: <leftop:exp mult_op exp>
			{
				@{$item[1]}==1?
				$item[1][0]:
				+{ binary => $item[0],
				operands => $item[1] }
			}
  
	mult_op: '*'
	       | '/'


	exp: <rightop:factor exp_op factor>
			{
				@{$item[1]}==1?
				$item[1][0]:
				+{ binary => $item[0],
				operands => $item[1] }
			}

	exp_op: '^'

	factor: unary
		| function
		| '(' expr ')' { $item[2] }

	function: function_name '(' expr_list ')'
			{
				+{
					function => $item[1],
					operands => $item[3],
				}
			}

	function_name: 'log'

	expr_list: <leftop:expr list_op expr>
			{
				my $i = 1;
				[ grep { $i==1?(--$i,1):(++$i,0) } @{$item[1]} ]
			}

	list_op: ','

	unary: unary_op number	{
					$item[1]?
					+{ unary => $item[1],
					operand => $item[2] } :
					$item[2]
				}
	unary_op: /([+-]?)/	{ $item[1] }
	number: /\d+(\.\d+)?/	{ +{ number => $item[1] } }
HERE

my $parser = new Parse::RecDescent($grammar);

use Data::Dumper;
print Dumper $parser->main($ARGV[0]);


