use warnings;
use strict;

use Test::More;

# BUG! Will also skip on 128 bit perl :-)
if(~0 != 4294967295) {
    plan skip_all => 'Test irrelevant on 64 bit machines';
}

use Devel::Deprecations ();

use lib 't/lib';

my @warnings;
$SIG{__WARN__} = sub { @warnings = @_ };

Devel::Deprecations->import('Bits32');
like(
    $warnings[0],
    qr/32 bit integers/,
    "warned about 32 bit integers"
);

done_testing;
