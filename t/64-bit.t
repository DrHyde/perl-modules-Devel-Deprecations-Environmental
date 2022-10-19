use warnings;
use strict;

use Test::More;

if(~0 == 4294967295) {
    plan skip_all => 'Test irrelevant on 32 bit machines';
}

use Devel::Deprecations ();

use lib 't/lib';

my @warnings;
$SIG{__WARN__} = sub { @warnings = @_ };

Devel::Deprecations->import('Internal::Bits64');
like(
    $warnings[0],
    qr/64 bit integers/,
    "warned about 64 bit integers"
);

done_testing;
