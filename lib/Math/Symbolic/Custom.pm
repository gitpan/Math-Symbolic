=head1 NAME

Math::Symbolic::Custom - Aggregate class for tree tests and transformations

=head1 SYNOPSIS

  # Extending the class:
  package Math::Symbolic::Custom::MyTransformations;
  use Math::Symbolic::Custom::Base;
  BEGIN {*import = \&Math::Symbolic::Custom::Base::aggregate_import}
  
  our $Aggregate_Export = [qw/apply_transformation1 .../];
  sub apply_transformation1 {
     # ...
  }
  # ...
  
  # Using the custom class:
  use Math::Symbolic;
  use Math::Symbolic::Custom::MyTransformations;

  # later...
  $tree->apply_transformation1();
  $tree->mod_transformation2();
  die unless $tree->is_type1();
  die unless $tree->test_condition1();

=head1 DESCRIPTION

This is an aggregate class for all custom modification, transformation
and testing extensions for Math::Symbolic trees.
Some default transformations and tests are implemented in the
Math::Symbolic::Custom::Default package which is automatically
loaded by the Math::Symbolic::Custom class.

Math::Symbolic::Custom imports all constants from
Math::Symbolic::ExportConstants

=head2 EXPORT

None by default.

=cut

package Math::Symbolic::Custom;

use 5.006;
use strict;
use warnings;

use Carp;

use Math::Symbolic::ExportConstants qw/:all/;

our $VERSION = '0.112';
our $AUTOLOAD;

use Math::Symbolic::Custom::Default;



1;
__END__

=head1 AUTHOR

Steffen Mueller, E<lt>symbolic-module at steffen-mueller dot netE<gt>

New versions of this module can be found on http://steffen-mueller.net or CPAN.

=head1 SEE ALSO

L<Math::Symbolic::Custom::Base>
L<Math::Symbolic::Custom::Default>

L<Math::Symbolic>

=cut
