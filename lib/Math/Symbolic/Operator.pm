
=head1 NAME

Math::Symbolic::Operator - Operators in symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic::Operator;
  
  my $sum = Math::Symbolic::Operator->new('+', $term1, $term2);
  
  my $division = Math::Symbolic::Operator->new(
     {
       type => B_DIVISON,
       operands => [$term1, $term2],
     }
  );
  
  my $derivative = Math::Symbolic::Operator->new(
     {
       type => U_P_DERIVATIVE,
       operands => [$term],
     }
  );

=head1 DESCRIPTION

This module implements all Math::Symbolic::Operator objects.
These objects are overloaded in stringification-context to evaluate
to their term's value.

=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Operator;

use 5.006;
use strict;
use warnings;

use Carp;

use Math::Symbolic::ExportConstants qw/:all/;
use Math::Symbolic::Derivative qw//;

use base 'Math::Symbolic::Base';

use overload '""' => sub{ $_[0]->to_string() };

our $VERSION = '0.101';

our %Op_Symbols = (
	'+'     => B_SUM,
	'-'     => B_DIFFERENCE,
	'*'     => B_PRODUCT,
	'/'     => B_DIVISION,
	'log'   => B_LOG,
	'^'     => B_EXP,
	'neg'   => U_MINUS,
	'partial_derivative' => U_P_DERIVATIVE,
	'total_derivative'   => U_T_DERIVATIVE,
	'sin'   => U_SINE,
	'cos'   => U_COSINE,
	'tan'   => U_TANGENT,
	'cot'   => U_COTANGENT,
	'asin'  => U_ARCSINE,
	'acos'  => U_ARCCOSINE,
	'atan'  => U_ARCTANGENT,
	'acot'  => U_ARCCOTANGENT,
	'sinh'  => U_SINE_H,
	'cosh'  => U_COSINE_H,
	'asinh' => U_AREASINE_H,
	'acosh' => U_AREACOSINE_H,
);

our @Op_Types = (
	# B_SUM
	{
		arity => 2,
		derive => 'each operand',
		infix_string => '+',
		prefix_string => 'add',
		application => '$_[0] + $_[1]',
	},
	# B_DIFFERENCE
	{
		arity => 2,
		derive => 'each operand',
		infix_string => '-',
		prefix_string => 'subtract',
		application => '$_[0] - $_[1]',
	},
	# B_PRODUCT
	{
		arity => 2,
		derive => 'product rule',
		infix_string => '*',
		prefix_string => 'multiply',
		application => '$_[0] * $_[1]',
	},
	# B_DIVISION
	{
		derive => 'quotient rule',
		arity => 2,
		infix_string => '/',
		prefix_string => 'divide',
		application => '$_[0] / $_[1]',
	},
	# U_MINUS
	{
		arity => 1,
		derive => 'each operand',
		infix_string => '-',
		prefix_string => 'negate',
		application => '-$_[0]',
	},
	# U_P_DERIVATIVE
	{
		arity => 2,
		derive => 'partial derivative commutation',
		infix_string => undef,
		prefix_string => 'partial_derivative',
		application => \&Math::Symbolic::Derivative::partial_derivative,
	},
	# U_T_DERIVATIVE
	{
		arity => 2,
		derive => 'defer',
		infix_string => undef,
		prefix_string => 'total_derivative',
		application => \&Math::Symbolic::Derivative::total_derivative,
	},
	# B_EXP
	{
		arity => 2,
		derive => 'logarithmic chain rule after ln',
		infix_string => '^',
		prefix_string => 'exponentiate',
		application => '$_[0] ** $_[1]',
	},
	# B_LOG
	{
		arity => 2,
		derive => 'logarithmic chain rule',
		infix_string => undef,
		prefix_string => 'log',
		application => 'log($_[1]) / log($_[0])',
	},
	# U_SINE
	{
		arity => 1,
		derive => 'trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'sin',
		application => 'sin($_[0])',
	},
	# U_COSINE
	{
		arity => 1,
		derive => 'trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'cos',
		application => 'cos($_[0])',
	},
	# U_TANGENT
	{
		arity => 1,
		derive => 'trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'tan',
		application => 'sin($_[0])/cos($_[0])',
	},
	# U_COTANGENT
	{
		arity => 1,
		derive => 'trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'cot',
		application => 'cos($_[0])/sin($_[0])',
	},
	# U_ARCSINE
	{
		arity => 1,
		derive => 'inverse trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'asin',
		application => 'Math::Symbolic::AuxFunctions::asin($_[0])',
	},
	# U_ARCCOSINE
	{
		arity => 1,
		derive => 'inverse trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'acos',
		application => 'Math::Symbolic::AuxFunctions::acos($_[0])',
	},
	# U_ARCTANGENT
	{
		arity => 1,
		derive => 'inverse trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'atan',
		application => 'Math::Symbolic::AuxFunctions::atan($_[0])',
	},
	# U_ARCCOTANGENT
	{
		arity => 1,
		derive => 'inverse trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'acot',
		application => 'Math::Symbolic::AuxFunctions::acot($_[0])',
	},
	# U_SINE_H
	{
		arity => 1,
		derive => 'trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'sinh',
		application => '0.5*(EULER**$_[0] - EULER**(-$_[0]))',
	},
	# U_COSINE_H
	{
		arity => 1,
		derive => 'trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'cosh',
		application => '0.5*(EULER**$_[0] + EULER**(-$_[0]))',
	},
	# U_AREASINE_H
	{
		arity => 1,
		derive => 'inverse trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'asinh',
		application => 'Math::Symbolic::AuxFunctions::asinh($_[0])',
	},
	# U_AREACOSINE_H
	{
		arity => 1,
		derive => 'inverse trigonometric derivatives',
		infix_string => undef,
		prefix_string => 'acosh',
		application => 'Math::Symbolic::AuxFunctions::acosh($_[0])',
	},
		
);


=head1 METHODS

=head2 Constructor new

Expects a hash reference as first argument. That hash's contents
will be treated as key-value pairs of object attributes.

Special case: if no hash reference was found, first
argument is assumed to be the operator's symbol and the operator
is assumed to be binary. The following 2 arguments will be treated as
operands. This special case will ignore attempts to clone objects.

Returns a Math::Symbolic::Operator.

Supported operator symbols: (number of operands and their
function in parens)

  +                  => sum (2)
  -                  => difference (2)
  *                  => product (2)
  /                  => division (2)
  log                => logarithm (2: base, function)
  ^                  => exponentiation (2: base, exponent)
  neg                => unary minus (1)
  partial_derivative => partial derivative (2: function, var)
  total_derivative   => total derivative (2: function, var)
  sin                => sine (1)
  cos                => cosine (1)
  tan                => tangent (1)
  cot                => cotangent (1)
  asin               => arc sine (1)
  acos               => arc cosine (1)
  atan               => arc tangent (1)
  acot               => arc cotangent (1)
  sinh               => hyperbolic sine (1)
  cosh               => hyperbolic cosine (1)
  asinh              => hyperbolic area sine (1)
  acosh              => hyperbolic area cosine (1)
  
=cut

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	if (@_ and not (ref($_[0]) eq 'HASH')) {
		my $symbol = shift;
		my $type = $Op_Symbols{$symbol};
		defined $type
			or croak "Invalid operator type specified ($symbol).";
		my $operands = [@_[
				0 .. 
				$Op_Types[
					$type
				]{arity} - 1
			]];
		return bless {
			type => $type,
			operands => $operands,
		} => $class;
	}
	
	my %args;
	%args = %{$_[0]} if @_ and ref($_[0]) eq 'HASH';

		
	my $operands = [];
	if (ref $proto) {
		foreach (@{$proto->{operands}}) {
			push @$operands, $_->new();
		}
	}
	
	my $self = {
		type => undef,
		(ref($proto)?%$proto:()),
		operands => $operands,
		%args,
	};

	bless $self => $class;
}



=head2 Method arity

Returns the operator's arity as an integer.

=cut

sub arity {
	my $self = shift;
	return $Op_Types[$self->{type}]{arity};
}



=head2 Method type

Optional integer argument that sets the operator's type.
Returns the operator's type as an integer.

=cut

sub type {
	my $self = shift;
	if (@_) {
		$self->{type} = shift;
	}
	return $self->{type};
}



=head2 Method to_string

Returns a string representation of the operator and its operands.
Optional argument: 'prefix' or 'infix'. Defaults to 'infix'.

=cut

sub to_string {
	my $self = shift;
	my $string_type = shift;
	$string_type = 'infix'
	  unless defined $string_type and $string_type eq 'prefix';
	
	my $string = '';
	if ($string_type eq 'prefix') {
		$string .= $self->_to_string_prefix();
	}
	else {
		$string .= $self->_to_string_infix();
	}
	return $string;
}


sub _to_string_infix {
	my $self = shift;
	my $op = $Op_Types[$self->{type}];

	my $op_str = $op->{infix_string};
	my $string;
	if ($op->{arity} == 2) {
		my $op1 = $self->{operands}[0]->term_type()
			  == T_OPERATOR;
		my $op2 = $self->{operands}[1]->term_type()
			  == T_OPERATOR;
		if (not defined $op_str) {
			$op_str = $op->{prefix_string};
			$string = "$op_str(";
			$string .= join(', ',
					map {
						$_->to_string('infix')
					}
					@{$self->{operands}}
			       	);
			$string .= ')';
		}
		else {
			$string = ($op1?'(':'') .
				  $self->{operands}[0]->to_string('infix') .
				  ($op1?')':'') . " $op_str " . ($op2?'(':'') .
				  $self->{operands}[1]->to_string('infix') .
				  ($op2?')':'');
		}
	}
	elsif ($op->{arity} == 1) {
		my $is_op1 = $self->{operands}[0]->term_type()
			     == T_OPERATOR;
		if (not defined $op_str) {
			$op_str = $op->{prefix_string};
			$string = "$op_str(" .
				  $self->{operands}[0]->to_string('infix') .
				  ")";
		}
		else {
			$string = "$op_str" . ($is_op1?'(':'') .
				  $self->{operands}[0]->to_string('infix') .
				  ($is_op1?')':'');
		}
	}
	else {
		$string = $self->_to_string_prefix();
	}
	return $string;
}



sub _to_string_prefix {
	my $self = shift;
	my $op = $Op_Types[$self->{type}];

	my $op_str = $op->{prefix_string};
	my $string = "$op_str(";
	$string .= join(', ',
			map {$_->to_string('prefix')} @{$self->{operands}}
		       );
	$string .= ')';
	return $string;
}



=head2 Method term_type

Returns the type of the term. ( T_OPERATOR )

=cut

sub term_type {
	return T_OPERATOR;
}



=head2 Method simplify

Term simpilification.

=cut

sub simplify {
	my $self = shift;
	$self = $self->new();

	my $operands = $self->{operands};
	my $op = $Op_Types[$self->type()];

	@$operands = map {$_->simplify()} @$operands;

	if ($self->arity() == 2) {
		my $o1  = $operands->[0];
		my $o2  = $operands->[1];
		my $tt1 = $o1->term_type();
		my $tt2 = $o2->term_type();
		my $type = $self->type();
		
		if ($tt1 == T_CONSTANT and $tt2 == T_CONSTANT) {
			return $self->apply();
		}
		elsif (
			$tt1 == T_VARIABLE and
			$tt2 == T_VARIABLE and
			$o1->name() eq $o2->name()
		) {
			if ($type == B_SUM) {
				my $two = Math::Symbolic::Constant->new(2);
				return $self->new('*', $two, $o1);
			}
			elsif ($type == B_DIFFERENCE) {
				return Math::Symbolic::Constant->zero();
			}
			elsif ($type == B_PRODUCT) {
				my $two = Math::Symbolic::Constant->new(2);
				return $self->new('^', $o1, $two);
			}
			elsif ($type == B_DIVISION) {
				return Math::Symbolic::Constant->one();
			}
		}	
		elsif ($tt1 == T_CONSTANT or $tt2 == T_CONSTANT) {
			my $const = ($tt1==T_CONSTANT?$o1:$o2);
			my $not_c = ($tt1==T_CONSTANT?$o2:$o1);
			my $constant_first = $tt1 == T_CONSTANT;
			
			if ($type == B_SUM) {
				return $not_c if $const->value() == 0;
			}
			elsif ($type == B_DIFFERENCE) {
				return $not_c
				  if !$constant_first and $const->value == 0;
				return Math::Symbolic::Operator->new( {
					type => U_MINUS,
					operands => [$not_c],
				} ) if $constant_first and $const->value == 0;
			}
			elsif ($type == B_PRODUCT) {
				return $not_c if $const->value() == 1;
				return Math::Symbolic::Constant->zero()
				  if $const->value == 0;
				if ($not_c->term_type() == T_OPERATOR and
				    $not_c->type() == B_PRODUCT and
				    $not_c->op1()->term_type() == T_CONSTANT ||
				    $not_c->op2()->term_type() == T_CONSTANT
				   ) {
					my ($c, $nc) = (
						$not_c->op1()->term_type() ==
							T_CONSTANT ?
						($not_c->op1(), $not_c->op2()) :
						($not_c->op2(), $not_c->op1())
					);
					my $c_product = $not_c->new(
						'*', $const, $c
					)->apply();
					return $not_c->new(
						'*',
						$c_product,
						$nc
					);
				}
			}
			elsif ($type == B_DIVISION) {
				return $not_c
				  if !$constant_first and $const->value == 1;
				return Math::Symbolic::Constant->new('#Inf')
				  if !$constant_first and $const->value == 0;
				return Math::Symbolic::Constant->zero()
				  if $const->value == 0;
			}
		}

	}
	elsif ($self->arity() == 1) {
		my $o  = $operands->[0];
		my $tt = $o->term_type();
		my $type = $self->type();
		if ($type == U_MINUS) {
			if ($tt == T_CONSTANT) {
				return Math::Symbolic::Constant->new(
					-$o->value(),
				);
			}
			elsif ($tt == T_OPERATOR) {
				return $o->{operands}[0]
				  if $o->type() == U_MINUS;
			}
		}
	}

	return $self;
}



=head2 Method op1 and op2

Returns first/second operand of the operator if it exists or undef.

=cut

sub op1 {
	return $_[0]{operands}[0] if @{$_[0]{operands}} >= 1;
	return undef;
}

sub op2 {
	return $_[0]{operands}[1] if @{$_[0]{operands}} >= 2;
}


=head2 Method apply

Applies the operation to its operands' value() and returns the result
as a constant (-object).

=cut

sub apply {
	my $self = shift;
	my $op = $Op_Types[$self->type];
	my $operands = $self->{operands};
	my $application = $op->{application};
	
	if (ref($application) ne 'CODE') {
		local @_ = map {$_->value()} @$operands;
		local $@;
		
		my $result = eval $application;
		die "Invalid operator application: $@" if $@;
		die "Undefined result from operator application."
		  if not defined $result;
	
		return Math::Symbolic::Constant->new($result);
	}
	else {
		my $result = $application->(@$operands);
		return $result;
	}
}



=head2 Method value

For operators, value() is just a wrapper around apply().

=cut

sub value {
	my $self = shift;
	return $self->apply()->value();
}



=head2 Method apply_derivatives

If the operator is a derivative, this applies the derivative to its
first operand.
Regardless what kind of operator this is called on, apply_derivatives
will be applied recursively on its operands.

If the first parameter to this function is an integer, at maximum that
number of derivatives are applied (from top down the tree if possible).

=cut

sub apply_derivatives {
	my $self = shift;
	my $n = shift || -1;
	my $max_derivatives = $n;
	$self = $self->new();
	return $self if $self->term_type() == T_CONSTANT;
	my $type = $self->type();

	
	while ($n && ($type == U_P_DERIVATIVE or $type == U_T_DERIVATIVE)) {
		my $op = $Op_Types[$self->type];
		my $operands = $self->{operands};
		my $application = $op->{application};

		$self = $application->(@$operands);
		return $self if $self->term_type() == T_CONSTANT;
		$type = $self->type();
		$n--;
	}

	@{$self->{operands}} =	map {$_->apply_derivatives($max_derivatives)}
				@{$self->{operands}};

	return $self;
}


1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

=head1 SEE ALSO

L<Math::Symbolic>

=cut
