package Catalyst::Engine::Apache2::MP19;

use strict;
use warnings;
use base 'Catalyst::Engine::Apache2';

use Apache2             ();
use Apache::Connection  ();
use Apache::Const       -compile => qw(OK);
use Apache::RequestIO   ();
use Apache::RequestRec  ();
use Apache::RequestUtil ();
use Apache::Response    ();

sub ok_constant { Apache::Const::OK }

1;
__END__

=head1 NAME

Catalyst::Engine::Apache2::MP19 - Catalyst Apache2 mod_perl 1.99x Engine

=head1 SYNOPSIS

    # Set up your Catalyst app as a mod_perl 1.99x application in httpd.conf
    PerlSwitches -I/var/www/MyApp/lib
    
    # Preload your entire application
    PerlModule MyApp
    
    <VirtualHost *>
        ServerName    myapp.hostname.com
        DocumentRoot  /var/www/MyApp/root
        
        <Location />
            SetHandler          modperl
            PerlResponseHandler MyApp
        </Location>
        
        # you can also run your app in any non-root location
        <Location /some/other/path>
            SetHandler          perl-script
            PerlResponseHandler MyApp
        </Location>        
    </VirtualHost>

=head1 DESCRIPTION

This is the Catalyst engine specialized for Apache2 mod_perl version 1.99x.

=head1 ModPerl::Registry

While this method is not recommended, you can also run your Catalyst
application via a ModPerl::Registry script.

httpd.conf:

    PerlModule ModPerl::Registry
    Alias / /var/www/MyApp/script/myapp_registry.pl/
    
    <Directory /var/www/MyApp/script>
        Options +ExecCGI
    </Directory>
    
    <Location />
        SetHandler          perl-script
        PerlResponseHandler ModPerl::Registry
    </Location>
    
script/myapp_registry.pl (you will need to create this):

    #!/usr/bin/perl
    
    use strict;
    use warnings;
    use MyApp;
    
    MyApp->handle_request( Apache::RequestUtil->request );
    
=head1 METHODS

=head2 ok_constant

=head1 SEE ALSO

L<Catalyst>, L<Catalyst::Engine>, L<Catalyst::Engine::Apache2>.

=head1 AUTHORS

Sebastian Riedel, <sri@cpan.org>

Christian Hansen, <ch@ngmedia.com>

Andy Grundman, <andy@hybridized.org>

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
