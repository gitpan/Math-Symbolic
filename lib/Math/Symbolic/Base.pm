=head1 NAME

Math::Symbolic::Base - Base class for symbols in symbolic calculations

=head1 SYNOPSIS

  use Math::Symbolic::Base;

=head1 DESCRIPTION



=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Base;

use 5.006;
use strict;
use warnings;

use Math::Symbolic::ExportConstants qw/:all/;

our $VERSION = '0.06';

=head1 METHODS

=cut



=head2 Method to_string

Default method for stringification just returns the object's value.

=cut

sub to_string {
	my $self = shift;
	return $self->value();
}



=head2 Method simplify

Minimum method for term simpilification.

=cut

sub simplify {
	my $self = shift;
	return $self->new();
}



=head2 Method apply_derivatives

Minimum method for application of derivatives.

=cut

sub apply_derivatives {
	my $self = shift;
	return $self->new();
}



=head2 Method term_type

Returns the type of the term.
This is a stub to be overridden.

=cut

sub term_type {
	die "term_type not defined for " . __PACKAGE__;
}

1;
__END__


=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

=head1 SEE ALSO

L<perl>.
L<Math::Symbolic>

=cut
