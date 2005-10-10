package Catalyst::Engine::Apache::MP13;

use strict;
use warnings;
use base 'Catalyst::Engine::Apache';

use Apache            ();
use Apache::Constants ();
use Apache::File      ();

Apache::Constants->import(':common');

sub finalize_headers {
    my ( $self, $c ) = @_;
    
    $self->SUPER::finalize_headers( $c );
    
    $self->apache->send_http_header;
    
    return 0;
}

1;
__END__

=head1 NAME

Catalyst::Engine::Apache::MP13 - Catalyst Apache mod_perl 1.3x Engine

=head1 SYNOPSIS

    # Set up your Catalyst app as a mod_perl 1.3x application in httpd.conf
    <Perl>
        use lib qw( /var/www/MyApp/lib );
    </Perl>
    
    # Preload your entire application
    PerlModule MyApp
    
    <VirtualHost *>
        ServerName   myapp.hostname.com
        DocumentRoot /var/www/MyApp/root
        
        <Location />
            SetHandler       perl-script
            PerlHandler      MyApp
        </Location>
        
        # you can also run your app in any non-root location
        <Location /some/other/path>
            SetHandler      perl-script
            PerlHandler     MyApp
        </Location>
    </VirtualHost>
    
=head1 DESCRIPTION

This is the Catalyst engine specialized for Apache mod_perl version 1.3x.

=head1 Apache::Registry

While this method is not recommended, you can also run your Catalyst
application via an Apache::Registry script.

httpd.conf:

    PerlModule Apache::Registry
    Alias / /var/www/MyApp/script/myapp_registry.pl/
    
    <Directory /var/www/MyApp/script>
        Options +ExecCGI
    </Directory>
    
    <Location />
        SetHandler  perl-script
        PerlHandler Apache::Registry
    </Location>
    
script/myapp_registry.pl (you will need to create this):

    #!/usr/bin/perl
    
    use strict;
    use warnings;
    use MyApp;
    
    MyApp->handle_request( Apache->request );
    
=head1 OVERLOADED METHODS

This class overloads some methods from C<Catalyst::Engine::Apache>.

=over 4

=item $c->engine->finalize_headers

=back

=head1 SEE ALSO

L<Catalyst>, L<Catalyst::Engine>, L<Catalyst::Engine::Apache>.

=head1 AUTHORS

Sebastian Riedel, <sri@cpan.org>

Christian Hansen, <ch@ngmedia.com>

Andy Grundman, <andy@hybridized.org>

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
