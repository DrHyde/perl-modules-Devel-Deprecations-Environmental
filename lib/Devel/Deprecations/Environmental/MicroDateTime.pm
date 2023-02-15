package # hah! take that PAUSE
    Devel::Deprecations::Environmental::MicroDateTime;

use strict;
use warnings;

use overload (
    '<=>'    => '_spaceship',
    bool     => sub { 1 },
    fallback => 1,
);

use POSIX qw(strftime);

our $VERSION = '1.000';

sub _spaceship {
    my($self, $other, $swap) = @_;
    ($other, $self) = ($self, $other) if($swap);
    $self->epoch() <=> $other->epoch();
}

sub from_epoch {
    my($class, %args) = @_;
    return bless({ %args }, $class);
}

sub parse_datetime {
    my($class, $dt_string) = @_;

    if($dt_string =~ /^
        (\d{4}) -
        (\d{2}) -
        (\d{2})
        (?:
            (?:
                T | \x20   # T or literal space
            )
            (\d{2}) :
            (\d{2}) :
            (\d{2})
        )?
    $/x) {
        my($year, $month, $day, $hour, $minute, $second) = ($1, $2, $3, $4, $5, $6);
        $hour   //= 0;
        $minute //= 0;
        $second //= 0;
        return $class->from_epoch(epoch => strftime(
            "%s", $second, $minute, $hour, $day, $month - 1, $year - 1900
        ));
    }
    die("'$dt_string' isn't a valid date/time");
}

sub now { shift->from_epoch(epoch => time); }

sub iso8601 {
    my $self = shift;

    my @time_components = (gmtime($self->{epoch}))[5, 4, 3, 2, 1, 0];
    return sprintf(
        "%04s-%02s-%02sT%02s:%02s:%02s",
        $time_components[0] + 1900,
        $time_components[1] + 1,
        @time_components[2..5]
    );
}

sub epoch { shift->{epoch} }

1;
