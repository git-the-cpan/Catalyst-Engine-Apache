#!perl

# Run all tests against Apache mod_perl
#
# Note, to get this to run properly, you may need to give it the path to your
# httpd.conf:
# 
# perl t/optional/mod_perl.pl -httpd_conf /etc/apache/httpd.conf

use strict;
use warnings;

use Apache::Test;
use Apache::TestRunPerl ();

$ENV{CATALYST_SERVER} = 'http://localhost:8529';

Apache::TestRunPerl->new->run(@ARGV);
