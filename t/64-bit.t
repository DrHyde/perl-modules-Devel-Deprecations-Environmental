use warnings;
use strict;

use Test::More;
BEGIN {
    # BUG! Will break on 128 bit perl :-)
    if(~0 == 4294967295) {
        plan skip_all => 'Test irrelevant on 32 bit machines';
    }
}

use Test::Warnings qw(:all);

use lib 't/lib';

my @warnings;
BEGIN { $SIG{__WARN__} = sub { @warnings = @_ }; }

use Devel::Deprecations 'Internal::Bits64';
BEGIN {
    like(
        $warnings[0],
        qr/64 bit integers/,
        "warned about 64 bit integers"
    );
    @warnings = ();
}

done_testing;
