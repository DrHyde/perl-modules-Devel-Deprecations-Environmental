package Devel::Deprecations::Plugin::OldPerl;

use strict;
use warnings;

use base 'Devel::Deprecations';

sub reason { "Perl too old" }

sub is_deprecated {
    my $minimum_version = $_[-1]->{older_than} ||
        die(__PACKAGE__.": 'older_than' parameter is mandatory\n");
    my @minimum_version_parts = (split(/\./, "$minimum_version", 3), 0, 0)[0..2];
    die(__PACKAGE__.": $minimum_version isn't a plausible perl version\n")
        if(grep { /\D/a } @minimum_version_parts);

    my @current_version_parts = map { 0 + $_ } ($] =~ /^(\d+)\.(\d{3})(\d{3})$/);

    _parts_to_int(@current_version_parts) < _parts_to_int(@minimum_version_parts);
}

sub _parts_to_int {
    return 1000000 * $_[0] +
              1000 * $_[1] +
                     $_[2]
}

1;
