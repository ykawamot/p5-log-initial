use inc::Module::Install;
name 'Log-Initial';
all_from 'lib/Log/Initial.pm';

requires 'Data::Dumper';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'IO::Capture::Stdout';

auto_set_repository;
auto_include;
WriteAll;
