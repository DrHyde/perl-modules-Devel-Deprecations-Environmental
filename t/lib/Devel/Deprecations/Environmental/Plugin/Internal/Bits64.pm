package Devel::Deprecations::Environmental::Plugin::Internal::Bits64;

use strict;
use warnings;

use base 'Devel::Deprecations::Environmental';

sub reason { "64 bit integers" }

# BUG! Will break on 128 bit perl :-)
sub is_deprecated { ~0 != 4294967295 }

1;
