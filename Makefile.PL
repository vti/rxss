#!/usr/bin/env perl

use strict;
use warnings;

use inc::Module::Install;

name 'RXSS';

version_from 'lib/RXSS.pm';
author 'Viacheslav Tykhanovskyi <vti@cpan.org>';
abstract 'RXSS';
license 'artistic_2';
perl_version '5.008007';

requires 'FindBin';
requires 'Getopt::Long';
requires 'HTML::TreeBuilder';
requires 'HTTP::Tiny';
requires 'Pod::Usage';
requires 'URI';

test_requires 'Test::Class';
test_requires 'Test::Fatal';

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';

no_index directory => 't';

resources
  bugtracker => 'http://github.com/vti/rxss/issues',
  repository => 'http://github.com/vti/rxss/',
  license    => 'http://dev.perl.org/licenses/';

auto_install;

WriteAll;
