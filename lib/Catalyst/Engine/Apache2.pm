package Catalyst::Engine::Apache2;

use strict;
use warnings;
use base 'Catalyst::Engine::Apache';

sub finalize_headers {
    my ( $self, $c ) = @_;

    $self->SUPER::finalize_headers( $c );

    # This handles the case where Apache2 will remove the Content-Length
    # header on a HEAD request.
    # http://perl.apache.org/docs/2.0/user/handlers/http.html
    if ( $self->apache->header_only ) {
        $self->apache->rflush;
    }

    return 0;
}

1;
__END__

=head1 NAME

Catalyst::Engine::Apache2 - Base class for Apache 1.99x and 2.x Engines

=head1 SYNOPSIS

See L<Catalyst>.

=head1 DESCRIPTION

This is a base class for Apache 1.99x and 2.x Engines.

=head1 OVERLOADED METHODS

This class overloads some methods from C<Catalyst::Engine>.

=over 4

=item finalize_headers

=back

=head1 SEE ALSO

L<Catalyst> L<Catalyst::Engine>.

=head1 AUTHORS

Sebastian Riedel, <sri@cpan.org>

Christian Hansen, <ch@ngmedia.com>

Andy Grundman, <andy@hybridized.org>

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
