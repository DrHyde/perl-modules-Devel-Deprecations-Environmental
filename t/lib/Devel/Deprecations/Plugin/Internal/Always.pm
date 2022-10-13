package Devel::Deprecations::Plugin::Internal::Always;

use strict;
use warnings;

use base 'Devel::Deprecations';

sub reason { "always deprecated" }
sub is_deprecated { 1 }

1;
