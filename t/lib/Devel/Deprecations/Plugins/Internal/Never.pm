package Devel::Deprecations::Plugin::Internal::Never;

use strict;
use warnings;

use base 'Devel::Deprecations';

sub reason { "never deprecated" }
sub is_deprecated { 0 }

1;
