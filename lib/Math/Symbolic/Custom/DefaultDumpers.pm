
=head1 NAME

Math::Symbolic::Custom::DefaultDumpers - Default Math::Symbolic output routines

=head1 SYNOPSIS

  use Math::Symbolic qw/parse_from_string/;
  $term = parse_from_string(...);
  print $term->to_latex(...);

=head1 DESCRIPTION

This is a class of default output routines for Math::Symbolic trees. Likewise,
Math::Symbolic::Custom::DefaultTests defines default tree testing
routines and Math::Symbolic::Custom::DefaultMods has default tree modification
methods.
For details on how the custom method delegation model works, please have
a look at the Math::Symbolic::Custom and Math::Symbolic::Custom::Base
classes.

=head2 EXPORT

Please see the docs for Math::Symbolic::Custom::Base for details, but
you should not try to use the standard Exporter semantics with this
class.

=head1 SUBROUTINES

=cut

package Math::Symbolic::Custom::DefaultDumpers;

use 5.006;
use strict;
use warnings;
no warnings 'recursion';

our $VERSION = '0.123';

use Math::Symbolic::Custom::Base;
BEGIN { *import = \&Math::Symbolic::Custom::Base::aggregate_import }

use Math::Symbolic::ExportConstants qw/:all/;

use Carp;

# Class Data: Special variable required by Math::Symbolic::Custom
# importing/exporting functionality.
# All subroutines that are to be exported to the Math::Symbolic::Custom
# namespace should be listed here.

our $Aggregate_Export = [
    qw/
      to_latex
      /
];

=head2 to_latex

This method is highly experimental. Use with care.
It returns a LaTeX representation of the Math::Symbolic tree
it is called on. The LaTeX is meant to be included in a LaTeX
source document.

The method uses named parameter passing style. Valid parameters are:

=over 4

=item implicit_multiplication

Used to turn off the 'x' operators for all multiplications.
Defaults to false, that is, the multiplication operators are present.

=item no_fractions

Use '%' division operator instead of fractions.
Defaults to false, that is, use fractions.

=item exclude_signature

By default, the method includes all variables' signatures in parenthesis
if there is one. Set this to true to omit variable signatures.

=item replace_default_greek

By default, all variable names are outputted as LaTeX in a way that
makes them show up exactly as they did in your code. If you set
this option to true, Math::Symbolic will try to replace as many
greek character names with the appropriates symbols as possible.

Valid LaTeX symbols that are matched are:

  Lower case letters:
    alpha, beta, gamma, delta, epsilon, zeta, eta, theta,
    iota, kappa, lambda, mu, nu, xi, pi, rho, sigma,
    tau, upsilon, phi, chi, psi, omega
  
  Variant forms of small letters:
    varepsilon, vartheta, varpi, varrho, varsigma, varphi
  
  Upper case letters:
    Gamma, Delta, Theta, Lambda, Xi, Pi, Sigma, Upsilon, Phi,
    Psi, Omega

=item variable_mappings

Because not all variable names come out as you might want them to,
you may use the 'variable_mappings' option to replace variable names
in the output LaTeX stream with custom LaTeX. For example, the
variable x_i should probably indicate an 'x' with a subscripted i.
The argument to variable_mappings needs to be a hash reference which
contains variable name / LaTeX mapping pairs.

If a variable is replaced in the above fashion, other options that
modify the outcome of the conversion of variable names to LaTeX are
ignored.

=back

=cut

sub to_latex {
    my $self   = shift;
    my %config = @_;
    $config{implicit_multiplication} = 0
      unless defined $config{implicit_multiplication};
    $config{no_fractions}      = 0 unless defined $config{no_fractions};
    $config{exclude_signature} = 0 unless defined $config{exclude_signature};
    $config{replace_default_greek} = 0
      unless defined $config{replace_default_greek};

    $config{variable_mappings} = {}
      if not exists $config{variable_mappings}
      or not ref( $config{variable_mappings} ) eq 'HASH';

    my $default_greek = qr/(?<![a-zA-Z])
         alpha|beta|gamma|delta|epsilon|zeta|eta|theta
         |iota|kappa|lambda|mu|nu|xi|pi|rho|sigma|tau|upsilon
	 |phi|chi|psi|omega
	 |varepsilon|vartheta|varpi|varrho|varsigma|varphi
	 |Gamma|Delta|Theta|Lambda|Xi|Pi|Sigma|Upsilon|Phi|Psi|Omega
	 (?![a-zA-Z])
	/x;
    my $greekify = sub {
        my $s = $_[0];
        $s =~ s/($default_greek)/\\$1/g if $config{replace_default_greek};
        return $s;
    };
    my $precedence = [
        1,     # B_SUM
        1,     # B_DIFFERENCE
        5,     # B_PRODUCT
        5,     # B_DIVISION
        15,    # U_MINUS
        20,    # U_P_DERIVATIVE
        20,    # U_T_DERIVATIVE
        25,    # B_EXP
        50,    # B_LOG
        50,    # U_SINE
        50,    # U_COSINE
        50,    # U_TANGENT
        50,    # U_COTANGENT
        50,    # U_ARCSINE
        50,    # U_ARCCOSINE
        50,    # U_ARCTANGENT
        50,    # U_ARCCOTANGENT
        50,    # U_SINE_H
        50,    # U_COSINE_H
        50,    # U_AREASINE_H
        50,    # U_AREACOSINE_H
    ];

    my $op_to_tex = [

        # B_SUM
        sub { "{$_[0]} + {$_[1]}" },

        # B_DIFFERENCE
        sub { "{$_[0]} - {$_[1]}" },

        # B_PRODUCT
        sub {
            $config{implicit_multiplication}
              ? "{$_[0]\} {$_[1]}"
              : "{$_[0]} \\times {$_[1]}";
        },

        # B_DIVISION
        sub {
            $config{no_fractions}
              ? "{$_[0]} \\div {$_[1]}"
              : "\\frac{$_[0]}{$_[1]}";
        },

        # U_MINUS
        sub { "-{$_[0]}" },

        # U_P_DERIVATIVE
        sub { "\\frac{\\partial {$_[0]}}{\\partial {$_[1]}}" },

        # U_T_DERIVATIVE
        sub { "\\frac{d {$_[0]}}{d {$_[1]}}" },

        # B_EXP
        sub { "$_[0]^{$_[1]}" },

        # B_LOG
        sub { "\\log_{$_[0]}{$_[1]}" },

        # U_SINE
        sub { "\\sin({$_[0]})" },

        # U_COSINE
        sub { "\\cos({$_[0]})" },

        # U_TANGENT
        sub { "\\tan({$_[0]})" },

        # U_COTANGENT
        sub { "\\cot({$_[0]})" },

        # U_ARCSINE
        sub { "\\arcsin({$_[0]})" },

        # U_ARCCOSINE
        sub { "\\arccos({$_[0]})" },

        # U_ARCTANGENT
        sub { "\\arctan({$_[0]})" },

        # U_ARCCOTANGENT
        sub { "\\mathrm{cosec}({$_[0]})" },

        # U_SINE_H
        sub { "\\sinh({$_[0]})" },

        # U_COSINE_H
        sub { "\\cosh({$_[0]})" },

        # U_AREASINE_H
        sub { "\\mathrm{arsinh}({$_[0]})" },

        # U_AREACOSINE_H
        sub { "\\mathrm{arcosh}({$_[0]})" },
    ];

    my $tex = $self->descend(
        operand_finder => sub { $_[0]->descending_operands('all') },
        before         => sub {
            $_[0]->{__precedences} = [
                map {
                    my $ttype = $_->term_type();
                    if ( $ttype == T_OPERATOR ) {
                        $precedence->[ $_->type() ];
                    }
                    elsif ( $ttype == T_VARIABLE ) {
                        100;
                    }
                    elsif ( $ttype == T_CONSTANT ) {
                        100;
                    }
                    else { die; }
                  } @{ $_[0]->{operands} }
            ];
            return ();
        },
        after => sub {
            my $self  = \$_[0];
            my $ttype = $$self->term_type();
            if ( $ttype == T_CONSTANT ) {
                $$self = { text => $$self->value() };
            }
            elsif ( $ttype == T_VARIABLE ) {
                my $name        = $$self->name();
                my $edited_name = $name;
                if ( exists $config{variable_mappings}{$name} ) {
                    $edited_name = $config{variable_mappings}{$name};
                }
                else {
                    $edited_name = $greekify->($name);
                    $edited_name =~ s/_/\\_/g;
                }
                unless ( $config{exclude_signature} ) {
                    my @sig =
                      map {
                        if ( exists $config{variable_mappings}{$_} )
                        {
                            $config{variable_mappings}{$_};
                        }
                        else {
                            s/_/\_/g;
                            $greekify->($_);
                        }
                      }
                      grep { $_ ne $name } $$self->signature();
                    if (@sig) {
                        $$self =
                          {     text => "$edited_name("
                              . join( ', ', @sig )
                              . ')' };
                    }
                    else {
                        $$self = { text => $edited_name };
                    }
                }
                else {
                    $$self = { text => $edited_name };
                }
            }
            elsif ( $ttype == T_OPERATOR ) {
                my $type  = $$self->type();
                my $prec  = $precedence->[$type];
                my $precs = $$self->{__precedences};
                my @ops   = map { $_->{text} } @{ $$self->{operands} };
                for ( my $i = 0 ; $i < @ops ; $i++ ) {
                    $ops[$i] = '(' . $ops[$i] . ')'
                      if $precs->[$i] < $prec
                      or $precs->[$i] == $prec && $prec == 50;
                }
                my $text = $op_to_tex->[$type]->(@ops);
                $$self = { text => $text };
            }
            else {
                die;
            }
        },
    );

    return '$' . $tex->{text} . '$';
}

1;
__END__

=head1 AUTHOR

Please send feedback, bug reports, and support requests to the Math::Symbolic
support mailing list:
math-symbolic-support at lists dot sourceforge dot net. Please
consider letting us know how you use Math::Symbolic. Thank you.

If you're interested in helping with the development or extending the
module's functionality, please contact the developers' mailing list:
math-symbolic-develop at lists dot sourceforge dot net.

List of contributors:

  Steffen Müller, symbolic-module at steffen-mueller dot net
  Stray Toaster, mwk at users dot sourceforge dot net

=head1 SEE ALSO

New versions of this module can be found on
http://steffen-mueller.net or CPAN. The module development takes place on
Sourceforge at http://sourceforge.net/projects/math-symbolic/

L<Math::Symbolic::Custom>
L<Math::Symbolic::Custom::DefaultTests>
L<Math::Symbolic>

=cut
