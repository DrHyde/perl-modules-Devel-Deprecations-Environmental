package Devel::Deprecations::Plugin::Bits32;

use strict;
use warnings;

use base 'Devel::Deprecations';

sub reason { "32 bit perl" }
sub is_deprecated { ~0 == 4294967295 }

1;
