package Devel::Deprecations::Plugin::OldPerl;

use strict;
use warnings;

use base 'Devel::Deprecations';

sub reason { "Perl too old" }

sub is_deprecated {
    my $minimum_version = $_[-1]->{older_than};
    ...
}

1;
