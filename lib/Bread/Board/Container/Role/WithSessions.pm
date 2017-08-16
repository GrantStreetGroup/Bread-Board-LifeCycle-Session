package Bread::Board::Container::Role::WithSessions;

our $AUTHORITY = 'cpan:GSG';
our $VERSION   = '0.90';

use Moose::Role;
use namespace::autoclean;
use List::Util 1.33 ('any');

our @LIFECYCLES_TO_FLUSH = qw(
    Session
    Session::WithParameters
    +Bread::Board::LifeCycle::Session
    +Bread::Board::LifeCycle::Session::WithParameters
);

sub flush_session_instances {
    my $self = shift;

    my @containers = ($self);
    my $flush_count = 0;

    # Traverse the sub containers to find any Session services
    while (my $container = shift @containers) {
        push @containers, values %{$container->sub_containers};
        foreach my $service (values %{$container->services}) {
            next unless defined $service->lifecycle;
            next unless any { $service->lifecycle eq $_ } @LIFECYCLES_TO_FLUSH;
            next unless (
                $service->can('has_instance') && $service->has_instance ||
                $service->can('instances')    && values %{$service->instances}
            );

            $service->flush_instance  if $service->can('flush_instance');
            $service->flush_instances if $service->can('flush_instances');
            $flush_count++;
        }
    };

    return $flush_count;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Bread::Board::Container::Role::WithSessions

=head1 VERSION

version 0.90

=head1 DESCRIPTION

This role defines Session helper methods for Containers.

=head1 METHODS

=head2 flush_session_instances

This method clears all Session instances from the container and any sub-containers.  In most cases, this should be called on the root
container, but it can be called on a sub-container, if you want to only clear out services within that container.

If successful, it will return the number of services that were flushed.  Note that this may be zero.

=head1 AUTHOR

Brendan Byrd C<< <BBYRD@CPAN.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Grant Street Group

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
