use warnings;
use strict;

use Test::More;
use Test::Warnings qw(:all);

use lib 't/lib';

sub _warning_string {
    sprintf("Deprecation warning! In %s on line %d: %s\n", @_);
}

my @warnings;
BEGIN { $SIG{__WARN__} = sub { @warnings = @_ }; }

# line 37 "i-like-weasels"
use Devel::Deprecations 'Internal::Always';
BEGIN {
    is(
        $warnings[0],
        _warning_string("i-like-weasels", 37, "always deprecated"),
        _warning_string("i-like-weasels", 37, "always deprecated"),
    );
    @warnings = ();
}

use Devel::Deprecations 'Internal::Never';
BEGIN {
    is(
        scalar(@warnings),
        0,
        'no deprecation warning emitted'
    );
}

done_testing;
