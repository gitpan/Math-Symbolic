#!/usr/bin/perl

use strict;
use warnings;
use Math::Symbolic qw/:all/;
use Data::Dumper;

sub ms_to_sub {
	my $tree = shift;
	my $order = shift || [];
	my $count = 0;
	my %order = map {($_, $count++)} @$order;

	no warnings 'recursion';

	
	my $vars = _find_vars($tree);

	my %vars;
	my @not_placed;
	foreach (@$vars) {
		my $pos = $order{$_};
		if (defined $pos) {
			$vars{$_} = $pos;
		}
		else {
			push @not_placed, $_;
		}
	}
	
	$count = 0;
	foreach (sort @not_placed) {
		$vars{$_} = @$vars - @not_placed + $count++;
	}

	$tree = $tree->simplify();
	$tree = $tree->apply_derivatives();
	$tree = $tree->simplify();
	
	my @trees;
	
	my $code = _rec_ms_to_sub($tree, \%vars, \@trees);

	my $sub = _compile_sub('sub {' . $code . '}', @trees);
	return($sub, $code, \@trees);
}

sub _compile_sub {
	my @_TREES;
	@_TREES = @_[1..$#_] if @_>1;
	my $sub = eval $_[0];
	die "$@" if $@;
	return $sub;
}

sub _rec_ms_to_sub {
	my $tree  = shift;
	my $vars  = shift;
	my $trees = shift;

	my $code = '';
	my $ttype = $tree->term_type();
	
	if ($ttype == T_CONSTANT) {
		$code .= $tree->value();
	}
	elsif ($ttype == T_VARIABLE) {
		$code .= '$_[' . $vars->{ $tree->name() } . ']';
	}
	else {
		my $type = $tree->type();
		my $otype = $Math::Symbolic::Operator::Op_Types[$type];
		my $arity = $otype->{arity};
		my $app = $otype->{application};
		if (ref($app) eq 'CODE') {
			my @operands;
			foreach (0..$arity-1) {
				push @$trees, $tree->{operands}[$_];
				push @operands, "\$_TREES[".$#{$trees}."]";
			}
			my $operands = join ', ', @operands;
			$code .= <<HERE
(\$Math::Symbolic::Operator::Op_Types[$type]->{application}->($operands))
HERE
		}
		else {
			my @app = split /\$_\[(\d+)\]/, $app;
			if (@app > 1) {
				for (my $i = 1; $i < @app; $i+=2) {
					$app[$i] =
					'(' .
					_rec_ms_to_sub(
						$tree->{operands}[$app[$i]],
						$vars,
						$trees
					) .
					')';
				}
			}
			$code .= join '', @app;
		}
	}
	return $code;
}


sub _find_vars {
	my $tree = shift;
	my $ttype = $tree->term_type();
	my $vars = [];
	if ($ttype == T_VARIABLE) {
		push @$vars, $tree->name();
	}
	elsif ($ttype == T_OPERATOR) {
		my $type = $tree->type();
		my $otype = $Math::Symbolic::Operator::Op_Types[$type];
		my $arity = $otype->{arity} || die;
		my %v = map {($_, undef)} @$vars;
		foreach (1..$arity) {
			my $v = _find_vars($tree->{operands}[$_-1]);
			foreach (@$v) {
				$v{$_} = undef;
			}
		}
		$vars = [keys %v];
	}
	return $vars;
}

my $v = Math::Symbolic::Variable->new();

my $a = $v->new('a');
my $b = $v->new('b');
my $c = $v->new('c');
my $d = $v->new('d');

my $cn = Math::Symbolic::Constant->new();
my $one = $cn->one();
my $two = $cn->new(2);

my $op = Math::Symbolic::Operator->new();
my $tree = $op->new(
	'*', $a,
	$op->new(
		'+',
		$op->new(
			'-',
			$one,
			$b
		),
		$op->new(
			'*',
			$c,
			$op->new(
				'/',
				$d,
				$op->new(
					'neg',
					$two
				)
			)
		)
	)
);

$tree = $op->new({
	type => U_P_DERIVATIVE,
	operands => [$tree, $a],
});

my $vars = [qw(b a d)];

print "Symbolic: ", $tree,"\n";
print "Vars: @{$vars}\n";

my ($sub, $code, $trees) = ms_to_sub($tree, $vars);
print "Sub code: $code\n";
print "Evaluation of sub with (1,2,1,1): ", $sub->(1,2,1,1),"\n";
print "Required trees:\n";
use Data::Dumper;
print Dumper $trees;
