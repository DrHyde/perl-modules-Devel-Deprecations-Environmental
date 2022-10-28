use warnings;
use strict;

use Test::More;
use Test::Exception;

use Devel::Deprecations ();

use lib 't/lib';

dies_ok { Devel::Deprecations->import('Internal::Broken') } 'incomplete plugin dies';
is($@, <<'END',
Devel::Deprecations: plugin Devel::Deprecations::Plugin::Internal::Broken doesn't implement all it needs to
  doesn't inherit from Devel::Deprecations
  doesn't implement 'reason()'
  doesn't implement 'is_deprecated()'
END
    '... with the right message');

done_testing;
