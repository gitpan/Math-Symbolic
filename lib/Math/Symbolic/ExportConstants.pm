package Math::Symbolic::ExportConstants;

use 5.006;
use strict;
use warnings;

require Exporter;

use constant B_SUM            => 0;
use constant B_DIFFERENCE     => 1;
use constant B_PRODUCT        => 2;
use constant B_DIVISION       => 3;
use constant U_MINUS          => 4;
use constant U_P_DERIVATIVE   => 5;
use constant U_T_DERIVATIVE   => 6;
use constant B_EXP            => 7;
use constant B_LOG            => 8;

use constant T_OPERATOR       => 0;
use constant T_CONSTANT       => 1;
use constant T_VARIABLE       => 2;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(
	B_SUM
	B_DIFFERENCE
	B_PRODUCT
	B_DIVISION
	B_EXP
	B_LOG
	U_MINUS
	U_P_DERIVATIVE
	U_T_DERIVATIVE

	T_OPERATOR
	T_CONSTANT
	T_VARIABLE
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
);
our $VERSION = '0.06';

1;
__END__

=head1 NAME

Math::Symbolic::ExportConstants - Export constants used for Math::Symbolic

=head1 SYNOPSIS

  use Math::Symbolic::ExportConstants qw/:all/;

=head1 DESCRIPTION

This just exports a number of constants on demand.

=head2 EXPORT

None by default. But since exporting symbols is the only functionality
of this module, you'll want to export the :all group of constants.

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

=head1 SEE ALSO

L<perl>.
L<Math::Symbolic>

=cut
