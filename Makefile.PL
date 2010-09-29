use strict;
use warnings;
use inc::Module::Install 0.91;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;

name 'Catalyst-Engine-Apache';
all_from 'lib/Catalyst/Engine/Apache.pm';

requires 'Catalyst::Runtime' => 5.80;

test_requires 'Test::More' => '0.88';

auto_install;
resources repository => 'http://dev.catalyst.perl.org/repos/Catalyst/Catalyst-Engine-Apache/trunk';

author_requires 'Test::NoTabs';
author_tests 't/author';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/Catalyst/Engine/Apache.pm > README")
        and die;
}

WriteAll;
