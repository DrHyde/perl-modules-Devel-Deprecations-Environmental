use warnings;
use strict;

use Test::More;
BEGIN {
    if(~0 != 4294967295) {
        plan skip_all => 'Test irrelevant on 64 (or more!) bit machines';
    }
}

use Test::Warnings qw(:all);

use lib 't/lib';

my @warnings;
BEGIN { $SIG{__WARN__} = sub { @warnings = @_ }; }

use Devel::Deprecations 'Bits32';
BEGIN {
    like(
        $warnings[0],
        qr/32 bit integers/,
        "warned about 43 bit integers"
    );
    @warnings = ();
}

done_testing;
