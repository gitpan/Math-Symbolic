
=head1 NAME

Math::Symbolic::Compiler - Compile Math::Symbolic trees to Perl code

=head1 SYNOPSIS

  use Math::Symbolic::Compiler;
  
  # A tree to compile
  my $tree = Math::Symbolic->parse_from_string('a^2 + b * c * 2');
  
  # The Math::Symbolic::Variable 'a' will be evaluated to $_[1], etc.
  my $vars = [a => 1, b => 0, c => 2];
  
  my ($closure, $code, $trees) =
          Math::Symbolic::Compiler->compile($tree, $vars);
  
  print $closure->(2, 3, 5); # (b, a, c)
  # prints 34 (=2^2 + 3*5*2)
  
  # or:
  ($closure, $trees) =
          Math::Symbolic::Compiler->compile_to_sub($tree, $vars);
  ($code, $trees) = Math::Symbolic::Compiler->compile_to_code($tree, $vars);

=head1 DESCRIPTION

This module allows to compile Math::Symbolic trees to Perl code and/or
anonymous subroutines whose arguments will be positionally mapped to the
variables of the compiled Math::Symbolic tree.

The reason you'd want to do this is that evaluating a Math::Symbolic tree to
its numeric value is extremely slow. So is compiling, but once you've done all
necessary symbolic calculations, you can take advantage of the speed gain
of invoking a closure instead of evaluating a tree.

=head2 UNCOMPILED LEFTOVER TREES

Not all, however, is well in the land of compile Math::Symbolic trees.
There may occasionally be trees that cannot be compiled (such as a derivative)
need to be included as-is into the code. These trees will be returned in a
referenced array by the compile*() methods. The closures will have access to
the required trees as a special variable '@_TREES inside the closure's scope,
so you need not worry about them in that case. But if you plan to use the
generated code itself, you need to supply an array named @_TREES that
contains the trees as returned by the compile*() methods in the scope of
the eval() you evaluate the code with.

Note that you give away all performance benefits compiling the tree might have
if the closure contains uncompiled trees. You can tell there are any by
checking the length of the referenced array that contains the trees. If it's
0, then there are no trees left to worry about.

=head2 AVOIDING LEFTOVER TREES

In most cases, this is pretty simple. Just apply all derivatives in the tree
to make sure that there are none left in the tree. As of version 0.108, there
is no operator except derivatives that cannot be compiled. There may, however,
be some operators you cannot get rid of this easily some time in the future.
If you have problems getting a tree to compile, try using the means of
simplification provided by Math::Symbolic::* to get a simpler tree for
compilation.

=head2 EXPORT

None by default, but you may choose to import the compile(), compile_to_sub(),
and compile_to_code() subroutines to your namespace using the standart
Exporter semantics including the ':all' tag.

=head1 SUBROUTINES

=cut

package Math::Symbolic::Compiler;

use 5.006;
use strict;
use warnings;

use Math::Symbolic::ExportConstants qw/:all/;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	&compile
	&compile_to_sub
	&compile_to_code
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '0.113';


=head2 ($code, $trees) = compile_to_code($tree, $vars)

The compile_to_code() class method takes one mandatory argument which is
the Math::Symbolic tree to be compiled. Second argument is optional
and an array reference to an array of variable mappings.
See L<VARIABLE PASSING STYLES> for details on how this works.

compile_to_code() returns a string and an array reference. The string
contains the compiled Perl code that uses the values stored in @_ as described
in the section on positional variable passing. It also accesses a special
variable @_TREES if there were any sub-trees (inside the tree that has been
compiled) that were impossible to compile. The array reference returned by this
method contains any of the aforementioned trees that failed to compile.

If there are any such trees that did not compile, you may put them into the
@_TREES variable in scope of the eval() that evaluates the compiled code
in the same order that they were returned by this method. If you do that, the
code will run and determine the value of the tree at run-time. Needless to say,
that is slow.

=cut

sub compile_to_code {
	my $tree = shift;
	$tree = shift if $tree eq __PACKAGE__;

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

	# The user is to do that himself.
#	$tree = $tree->simplify();
#	$tree = $tree->apply_derivatives();
#	$tree = $tree->simplify();
	
	my @trees;
	
	my $code = _rec_ms_to_sub($tree, \%vars, \@trees);

	return($code, \@trees);
}



=head2 ($sub, $trees) = compile_to_sub($tree, $vars)

The compile_to_sub() class method takes one mandatory argument which is
the Math::Symbolic tree to be compiled. Second argument is optional
and an array reference to an array of variable mappings.
See L<VARIABLE PASSING STYLES> for details on how this works.

compile_to_sub() returns a list of two elements, the first being the compiled
anonymous subroutine. For details on the second element, please refer to
the docs on the compile_to_code() subroutine.

=cut


sub compile_to_sub {
	my ($code, $trees) = Math::Symbolic::Compiler::compile_to_code(@_);
	my $sub = _compile_sub('sub {' . $code . '}', @$trees);
	return ($sub, $trees);
}



=head2 ($sub, $code, $trees) = compile($tree, $vars)

The compile() class method takes one mandatory argument which is
the Math::Symbolic tree to be compiled. Second argument is optional
and an array reference to an array of variable mappings.
See L<POSITIONAL VARIABLE PASSING> for details on how this works.

compile() returns a list of three elements, the first being the compiled
anonymous subroutine, the second being the compiled code. For details on the
second and third elements, please refer to the docs on the compile_to_code()
subroutine.

=cut

sub compile {
	my ($code, $trees) = Math::Symbolic::Compiler::compile_to_code(@_);
	my $sub = _compile_sub('sub {' . $code . '}', @$trees);
	return ($sub, $code, $trees);
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
		my $app = $otype->{application};
		if (ref($app) eq 'CODE') {
			push @$trees, $tree->new();
			my $arg_str =
				join ', ',
				map {"'$_' => \$_[" . $vars->{$_} . ']'}
				keys %$vars;
			my $index = $#$trees;
			$code .= <<HERE
(\$_TREES[$index]->value($arg_str))
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
		my %v = map {($_, undef)} @$vars;
		foreach (0..@{$tree->{operands}}-1) {
			my $v = _find_vars($tree->{operands}[$_]);
			foreach (@$v) {
				$v{$_} = undef;
			}
		}
		$vars = [keys %v];
	}
	return $vars;
}





1;
__END__

=head2 VARIABLE PASSING STYLES

Currently, the Math::Symbolic compiler only supports compiling to subs with
positional variable passing. At some point, the user should be able to choose
between positional- and named variable passing styles. The difference is
best explained by an example:

  # positional:
  $sub->(4, 5, 1);
  
  # named:
  $sub->(a => 5, b => 4, x => 1);

With positional variable passing, the subroutine statically maps its arguments
to its internal variables. The way the subroutine does that has been fixed
at compile-time. It is determined by the second argument to the various
compile_* functions found in this package. This second argument is expected
to be an array of key/value pairs with the keys being variable names and the
values being their position starting from 0. Example:

  my ($sub) = Math::Symbolic::Compiler->compile_to_sub(
                    $tree, [b => 2, c => 0, a => 1]
              );
    
  # First argument will be mapped to c, second to a, and third to b
  # All others will be ignored.
  $sub->(4, 5, 6, 7);
  
  # Variable mapping: a = 5, b = 6, c = 4

One important note remains: if any (or all) variables in the tree are
unaccounted for, they will be lexicographically sorted and appended to
the variable mapping in that order. That means if you don't map variables
yourself, they will be sorted lexicographically.

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut