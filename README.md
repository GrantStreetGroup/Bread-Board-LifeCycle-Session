# NAME

Bread::Board::LifeCycle::Session - A short-lived singleton for Bread::Board

# VERSION

version v0.0.1

# SYNOPSIS

    use Bread::Board;

    my $c = container 'Reports' => as {
        service generic_report => (
            class     => 'Report',
            lifecycle => 'Session',
        );
    };

    sub dispatch {
        # ... dispatch code ...

        my $services_flushed = $c->flush_session_instances;
    }

# DESCRIPTION

This implements a short-term "Session" lifecycle for Bread::Board.  Services with this lifecycle will exist as a singleton until they
are flushed with the [flush\_session\_instances](https://metacpan.org/pod/Bread::Board::Container::Role::WithSessions#flush_session_instances) method.  The idea is
that this method would be called at the end of a web request, but a "session" could be defined as any sort of short-term cycle.

The [Bread::Board::Container::Role::WithSessions](https://metacpan.org/pod/Bread::Board::Container::Role::WithSessions) role is applied to all containers that exist in or around the service.

This module is similar to [Bread::Board::LifeCycle::Request](https://metacpan.org/pod/Bread::Board::LifeCycle::Request), but has no connections to [OX](https://metacpan.org/pod/OX).

# ACKNOWLEDGEMENTS

Thanks to Grant Street Group [http://www.grantstreet.com](http://www.grantstreet.com) for funding development of this code.

Thanks to Steve Grazzini (`<GRAZZ@CPAN.org>`) for discussion of the concept.

# AUTHOR

Grant Street Group &lt;developers@grantstreet.com>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2015 - 2020 by Grant Street Group.

This is free software, licensed under:

    The Artistic License 2.0 (GPL Compatible)
