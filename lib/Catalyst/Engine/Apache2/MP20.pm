package Catalyst::Engine::Apache2::MP20;

use strict;
use warnings;
use base 'Catalyst::Engine::Apache2';

use Apache2::Connection  ();
use Apache2::Const       ();
use Apache2::RequestIO   ();
use Apache2::RequestRec  ();
use Apache2::RequestUtil ();
use Apache2::Response    ();

Apache2::Const->import( -compile => ':common' );

1;
__END__

=head1 NAME

Catalyst::Engine::Apache2::MP20 - Catalyst Apache2 mod_perl 2.x Engine

=head1 SYNOPSIS

    # Set up your Catalyst app as a mod_perl 2.x application in httpd.conf
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

This is the Catalyst engine specialized for Apache2 mod_perl version 2.x.

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
    
    MyApp->handle_request( Apache2::RequestUtil->request );

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
