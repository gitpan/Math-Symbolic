
=head1 NAME

Math::Symbolic::Variable - Variable in symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic;

=head1 DESCRIPTION



=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Variable;

use 5.006;
use strict;
use warnings;

use Math::Symbolic::ExportConstants qw/:all/;

use base 'Math::Symbolic::Base';

use overload '""' => sub{ $_[0]->to_string() };

our $VERSION = '0.06';

=head1 METHODS

=head2 Constructor new

First argument is expected to be a hash reference of key-value
pairs which will be used as object attributes.

Special case: First argument is not a hash reference. In this
case, first argument is treated as variable name, second as value.
This special case disallows cloning of objects (when used as
object method).

Returns a Math::Symbolic::Variable.

=cut

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	if (@_ and not ref($_[0]) eq 'HASH') {
		my $name = shift;
		my $value = shift;
		return bless {name=>$name, value=>$value} => $class;
	}
	
	my %args;
	%args = %{+shift} if @_ and defined $_[0] and ref($_[0]) eq 'HASH';

	my $self = {
		value => undef,
		name => undef,
		(ref($proto)?%$proto:()),
		%args,
	};

	bless $self => $class;
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



=head2 Method name

Optional argument: sets the object's name.
Returns the object's name.

=cut

sub name {
	my $self = shift;
	if (@_) {
		$self->{name} = shift;
	}
	return $self->{name};
}



=head2 Method to_string

Returns a string representation of the variable.

=cut

sub to_string {
	my $self = shift;

	return $self->name();
}



=head2 Method term_type

Returns the type of the term. (T_VARIABLE)

=cut

sub term_type {
	return T_VARIABLE;
}



1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

=head1 SEE ALSO

L<perl>.
L<Math::Symbolic>

=cut
