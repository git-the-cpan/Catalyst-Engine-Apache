use inc::Module::Install 0.65;

name 'Catalyst-Engine-Apache';
all_from 'lib/Catalyst/Engine/Apache.pm';

requires 'Catalyst::Runtime';

tests 't/0*.t';

auto_install;
WriteAll;
