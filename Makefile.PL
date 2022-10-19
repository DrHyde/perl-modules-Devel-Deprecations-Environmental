use ExtUtils::MakeMaker;
WriteMakefile(
    NAME       => 'Devel::Deprecations',
    META_MERGE => {
        license   => 'open_source',
        resources => {
            repository => 'https://github.com/DrHyde/perl-modules-Devel-Deprecations',
            bugtracker => 'https://github.com/DrHyde/perl-modules-Devel-Deprecations/issues',
        }
    },
  VERSION_FROM => 'lib/Devel/Deprecations.pm',
  PREREQ_PM    => {
    'Test::More'                => 0.96, # done_testing and subtests
    'Test::Warnings'            => 0.026,
    'Module::Load'              => 0,
    'DateTime::Format::ISO8601' => 0,
    'Scalar::Util'              => 0,
  },
);
