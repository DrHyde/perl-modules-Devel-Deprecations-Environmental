package Devel::Deprecations;

use strict;
use warnings;

use DateTime::Format::ISO8601;
use Module::Load ();
use Scalar::Util qw(blessed);

our $VERSION = '1.000';

=head1 NAME

Devel::Deprecations

=head1 DESCRIPTION

A framework for managing deprecations

=head1 SYNOPSIS

This will load the Devel::Deprecations::Plugin::Bits32 plugin and emit a
warning once if running on a 32 bit system:

    use Devel::Deprecations qw(Bits32);

This will start warning about an impending deprecation on the 1st of February
2023, upgrade that to a warning about being unsupported on the 1st of February
2024, and upgrade that to a fatal error on the 1st of February 2025:

    use Devel::Deprecations
        Bits32 => {
            warn_from        => '2023-02-01',
            unsupported_from => '2024-02-01',
            fatal_from       => '2025-02-01',
        };

This will always warn about 32 bit perl or a really old perl:

    use Devel::Deprecations
        OldPerl => { older_than => '5.14.0', },
        'Bits32';

=head1 DEPRECATION ARGUMENTS

Each deprecation has a name, which can be optionally followed by a hash-ref of
arguments. All deprecations should support:

=over

=item warn_from

The time at which to start emitting warnings about an impending deprecation.
Defaults to the moment of creation, C<'1970-01-01'> (any ISO 8601 format is
accepted). You can also provide this as a L<DateTime> object.

This must be before any of C<unsupported_from> or C<fatal_from> which are
specified.

=item unsupported_from

The time at which to start warning harder, when something is no longer
supported. Defaults to C<undef>, meaning "don't do this".

This must be before C<fatal_from> if that is specified.

=item fatal_from

The time after which the code should just C<die>. Defaults to C<undef>,
meaning "don't do this".

=back

Of those three only the most severe will be emitted.

Plugins can support any other arguments they wish.

=head1 CONTENT OF WARNINGS / FATAL ERRORS

The pseudo-variables C<$date>, C<$filename>, C<$line>, and C<$reason> will be
interpolated.

C<$date> will be C<From $unsupported_from: > or C<From $fatal_from: > (using
whichever is earlier) if one of those is configured.

C<$filename> and C<$line> will tell you the file and line on which
C<Devel::Deprecations> is loaded.

C<$reason> is defined in the plugin's C<reason()> method.

=head2 Initial warning

C<Deprecation warning! ${date}In $filename on line $line: $reason>

=head2 "Unsupported" warning

C<Unsupported! In $filename on line $line: $reason>

=head2 Fatal error

C<Unsupported! In $filename on line $line: $reason>

=cut

sub import {
    my $class = shift;
    my @args = @_;
    if($class eq __PACKAGE__) {
        # when loading Devel::Deprecations itself ...
        while(@args) {
            my $plugin = 'Devel::Deprecations::Plugin::'.shift(@args);
            my $plugin_args = ref($args[0]) ? shift(@args) : {};

            Module::Load::load($plugin);
            die(__PACKAGE__.": plugin $plugin doesn't implement all it needs to\n") unless(
                $plugin->isa(__PACKAGE__) &&
                eval {
                    $plugin->reason; $plugin->is_deprecated; 1;
                }
            );
            $plugin->import($plugin_args);
        }
    } else {
        # when called on a subclass ...
        my $args = $args[0];
        $args->{warn_from} ||= '1970-01-01';
        my $_froms = {
            map {
                $_ => blessed($args->{$_}) ? $args->{$_} : DateTime::Format::ISO8601->parse_datetime($args->{$_})
            } grep {
                exists($args->{$_})
            } qw(warn_from unsupported_from fatal_from)
        };
        delete($args->{$_}) foreach(qw(warn_from unsupported_from fatal_from));
        if($class->is_deprecated($args)) {
            my $reason = $class->reason();
            ...
        }
    }
}

=head1 FUNCTIONS

There are no public functions or methods, everything is done when the
module is loaded (specifically, when its C<import()> method is called)
with all specific deprecations handled by plugins.

=head1 WRITING YOUR OWN PLUGINS

The C<Devel::Deprecations::Plugin::*> namespace is yours to play in, except
for the C<Devel::Deprecations::Plugin::Internal::*> namespace.

A plugin should inherit from C<Devel::Deprecation>, and implement the following
methods, which will be called as class methods. Failure to define either of
them will result in fatal errors:

=over

=item reason

Returns a brief string explaining the deprecation. For example "32 bit perl"
or "Perl too old".

=item is_deprecated

This will be passed the arguments hash (with C<warn_from>, C<unsupported_from>,
and C<fatal_from> removed) and should return true or false for whether the
environment matches the deprecation or not.

=back

=head1 FEEDBACK

I welcome feedback about my code, including constructive criticism, bug
reports, documentation improvements, and feature requests. The best bug reports
include files that I can add to the test suite, which fail with the current
code in my git repo and will pass once I've fixed the bug

Feature requests are far more likely to get implemented if you submit a patch
yourself, preferably with tests.

=head1 SOURCE CODE REPOSITORY

L<git://github.com/DrHyde/perl-modules-Devel-Deprecations.git>

=head1 SEE ALSO

L<Devel::Deprecate> - for deprecating parts of your own code as opposed
to parts of the environment your code is running in;

=head1 AUTHOR, LICENCE and COPYRIGHT

Copyright 2022 David Cantrell E<lt>F<david@cantrell.org.uk>E<gt>

This software is free-as-in-speech software, and may be used, distributed, and
modified under the terms of either the GNU General Public Licence version 2 or
the Artistic Licence. It's up to you which one you use. The full text of the
licences can be found in the files GPL2.txt and ARTISTIC.txt, respectively.

=head1 CONSPIRACY

This module is also free-as-in-mason software.

=cut

1;
