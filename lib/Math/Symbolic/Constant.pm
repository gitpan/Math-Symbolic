=head1 NAME

Math::Symbolic::Constant - Constants in symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic::Constant;
  my $const = Math::Symbolic::Constant->new(25);
  my $zero  = Math::Symbolic::Constant->zero();
  my $one   = Math::Symbolic::Constant->one();
  my $euler = Math::Symbolic::Constant->euler();
  # e = 2.718281828...

=head1 DESCRIPTION

This module implements numeric constants for Math::Symbolic trees.

=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Constant;

use 5.006;
use strict;
use warnings;

use Math::Symbolic::ExportConstants qw/:all/;

use base 'Math::Symbolic::Base';

our $VERSION = '0.102';

=head1 METHODS

=cut

=head2 Constructor new

Takes hash reference of key-value pairs as argument.
Special case: a value for the constant instead of the hash.
Returns a Math::Symbolic::Constant.

=cut

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	my %args;
	%args = %{+shift} if @_ && ref($_[0]) eq 'HASH';

	my $value = (@_ && !%args ? shift : $args{value});
	$value = $proto->value() if !defined($value) and ref($proto);

	my $self = {
		special => '',
		(ref($proto)?%$proto:()),
		value => $value,
		%args,
	};

	bless $self => $class;
}



=head2 Constructor zero

Arguments are treated as key-value pairs of object attributes.
Returns a Math::Symbolic::Constant with value of 0.

=cut

sub zero {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return $class->new({@_, value => 0, special => 'zero'})
}



=head2 Constructor one

Arguments are treated as key-value pairs of object attributes.
Returns a Math::Symbolic::Constant with value of 1.

=cut

sub one {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return $class->new({@_, value => 1})
}



=head2 Constructor euler

Arguments are treated as key-value pairs of object attributes.
Returns a Math::Symbolic::Constant with value of e, the Euler number.
The object has its 'special' attribute set to 'euler'.

=cut

sub euler {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	return $class->new({@_, value => EULER, special => 'euler'})
}



=head2 Method value

Optional argument: sets the object's value.
Returns the object's value.

=cut

sub value {
	my $self = shift;
	if (@_) {
		$self->{value} = shift;
	}
	return $self->{value};
}



=head2 Method special

Optional argument: sets the object's special attribute.
Returns the object's special attribute.

=cut

sub special {
	my $self = shift;
	if (@_) {
		$self->{special} = shift;
	}
	return $self->{special};
}



=head2 Method to_string

Returns a string representation of the constant.

=cut

sub to_string {
	my $self = shift;

	return $self->value();
}



=head2 Method term_type

Returns the type of the term. (T_CONSTANT)

=cut

sub term_type {
	return T_CONSTANT;
}



1;
__END__


=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut
