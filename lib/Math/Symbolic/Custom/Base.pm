=head1 NAME

Math::Symbolic::Custom::Base - Base class for tree tests and transformations

=head1 SYNOPSIS

  # Extending the Math::Symbolic::Custom class:
  package Math::Symbolic::Custom::MyTransformations;
  use Math::Symbolic::Custom::Base;
  BEGIN {*import = \&Math::Symbolic::Custom::Base::aggregate_import}
  
  our $Aggregate_Export = [qw/apply_transformation1 .../];
  sub apply_transformation1 {
     # ...
  }

=head1 DESCRIPTION

This is a base class for your extensions to the Math::Symbolic::Custom
class.

To extend the class, just use the following template for your custom class:

  package Math::Symbolic::Custom::MyTransformations;

  use Math::Symbolic::Custom::Base;
  BEGIN {*import = \&Math::Symbolic::Custom::Base::aggregate_import}
  
  our $Aggregate_Export = [...]; # exported subroutines listed here.
  
  # Now implement the subroutines.
  # Exported subroutine names must start with 'apply_', 'mod_',
  # 'is_', or 'test_'
  
  # ...
  
  1;

=head2 EXPORT

Uses a custom exporter implementation to export certain routines from the
invoking namespace to the Math::Symbolic::Custom namespace.
But... Nevermind.

=cut

package Math::Symbolic::Custom::Base;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.111';
our $AUTOLOAD;

sub aggregate_import {
	my $class = shift;
	no strict 'refs';
	my $subs = ${"${class}::Aggregate_Export"};
	foreach my $sub (@$subs) {
		*{"Math::Symbolic::Custom::$sub"} = \&{"$class\:\:$sub"};
	}
}


1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic>

=cut
